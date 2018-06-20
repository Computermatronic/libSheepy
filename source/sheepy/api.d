module sheepy.api;

import std.array : Appender;
import std.format : formattedWrite;
import std.regex : ctRegex, matchAll;
import std.string : replace;
import std.format: format;
import std.datetime: Duration, hours;
import std.algorithm: canFind, map;
import std.array: array;
import std.exception: enforce;

import vibe.http.common : HTTPMethod, enforceHTTP;
import vibe.http.client : HTTPClientRequest, HTTPClientResponse, requestHTTP;
import vibe.http.status : HTTPStatus, isSuccessCode;
import vibe.data.json : Json, parseJsonString;
import vibe.stream.operations : readAllUTF8;

import sheepy.shards;
import sheepy.utils: appDataDir, cacheFileName, fileAge;

class SheepyAPI {
	string[string] cookies;
	string[string] headers;

	string apiKey, loginEmail, loginPassword;

	this(string apiKey = null, string loginEmail = null, string loginPassword = null) {
		this.apiKey = apiKey;
		this.loginEmail = loginEmail;
		this.loginPassword = loginPassword;
	}

	NationAPIShard requestNationEndpoint(uint id) {
		return NationAPIShard(this.requestEndpoint(`http://politicsandwar.com/api/nation/id=%s`, id));
	}

	NationsAPIShard[] requestNationsEndpoint() {
		return this.requestEndpoint(`http://politicsandwar.com/api/nations/`)["nations"].byValue.map!((e) => NationsAPIShard(e)).array;
	}

	AllianceMembersAPIShard[] requestAllianceMembersEndpoint(uint id) {
		return this.requestEndpoint(`http://politicsandwar.com/api/alliance-members/?allianceid=%s&key=%s`, id, apiKey)
			["nations"].byValue.map!((e) => AllianceMembersAPIShard(e)).array;
	}

	AllianceAPIShard requestAllianceEndpoint(uint id) {
		return AllianceAPIShard(this.requestEndpoint(`http://politicsandwar.com/api/alliance/id=%s`, id));
	}

	AlliancesAPIShard[] requestAlliancesEndpoint() {
		return this.requestEndpoint(`http://politicsandwar.com/api/alliances/`)["alliances"].byValue.map!((e) => AlliancesAPIShard(e)).array;
	}

	AllianceBankAPIShard requestAllianceBankEndpoint(uint id) {
		return AllianceBankAPIShard(this.requestEndpoint(`http://politicsandwar.com/api/alliance-bank/?allianceid=%s&key=%s`, id, apiKey)["alliance_bank_contents"][0]);
	}

	WarAPIShard requestWarEndpoint(uint id) {
		return WarAPIShard(this.requestEndpoint(`http://politicsandwar.com/api/war/%s`, id)["war"][0]);
	}

	WarsAPIShard[] requestWarsEndpoint() {
		return this.requestEndpoint(`http://politicsandwar.com/api/wars/`)["wars"].byValue.map!((e) => WarsAPIShard(e)).array;
	}

	CityAPIShard requestCityEndpoint(uint id) {
		return CityAPIShard(this.requestEndpoint(`http://politicsandwar.com/api/city/id=%s`, id));
	}

	TradePriceAPIShard requestTradePriceEndpoint(string resource) {
		return TradePriceAPIShard(this.requestEndpoint(`http://politicsandwar.com/api/tradeprice/resource=`, resource));
	}

	void sendMessage(string to, string cc, string subject, string message) {
		this.requestHTMLEndpointPost(`http://politicsandwar.com/inbox/message/`, [
			"newconversation": "true", 
			"receiver" : to, 
			"carboncopy" : cc, 
			"subject" : subject, 
			"body" : message, 
			"sndmsg" : "Send Message"
		], [
			`Referer`: `http://politicsandwar.com/inbox/message/`
		]);
	}

	Json requestEndpoint(Args...)(string fmt, Args args) {
		static if (args.length > 0) string url = format(fmt, args);
		else string url = fmt;
		auto responseBody = this.request(url, HTTPMethod.GET).parseJsonString(url);
		enforce(responseBody[`success`].to!bool, responseBody[`general_message`].to!string);
		return responseBody;
	}

	string requestHTMLEndpointPost(string url, string[string] form, string[string] headers = null) {
		if (`User-Agent` !in headers) {
			headers[`User-Agent`] = `Mozilla/5.0 (Windows NT x.y; rv:10.0) Gecko/20100101 Firefox/10.0`;
		}
		auto responseBody = this.request(url, HTTPMethod.POST, form, headers);

		if (responseBody.canFind(`<meta http-equiv="REFRESH" content="0;url=https://politicsandwar.com/login/">`)) {
			requestHTMLLoginPost();
			return this.request(url, HTTPMethod.POST, form, headers);
		}
		return responseBody;
	}

	void requestHTMLLoginPost() {
		this.request(`https://politicsandwar.com/login`, HTTPMethod.POST, [
			`email`: loginEmail,
			`password`: loginPassword,
			`rememberme`: `1`,
			`loginform`: `Login`
		], [
			`User-Agent`: `Mozilla/5.0 (Windows NT x.y; rv:10.0) Gecko/20100101 Firefox/10.0`,
			`Referer`: `https://politicsandwar.com/login`
		]);
	}

	string request(T...)(string url, HTTPMethod method, T args) 
	if ((T.length > 1 && (is(T[0] == string) || is(T[0] == Json) || is(T[0] == string[string]))) || T.length == 0) {
		string responseBody;
		void onRequest(scope HTTPClientRequest request) {
			request.method = method;

			foreach(name, value; headers) {
				request.headers[name] = value;
			}

			static if (args.length > 2) {
				foreach(name, value; args[1]) {
					request.headers[name] = value;
				}
			}

			Appender!string cookies;
			foreach(name, value; this.cookies) {
				cookies.formattedWrite("%s=%s; ", name, value);
			}
			request.headers["Cookie"] = cookies.data;

			static if (T.length > 1 && is(T[0] == Json)) {
				request.writeJsonBody(args[0]);
			} else static if (T.length > 1 && is(T[0] == string[string])) {
				request.writeFormBody(args[0]);
			} else static if (T.length > 1 && is(T[0] == string)) {
				request.writeBody(args[0]);
			}
		}
		void onResponse(scope HTTPClientResponse response) {
			enforceHTTP((cast(HTTPStatus)response.statusCode).isSuccessCode(), cast(HTTPStatus)response.statusCode, response.statusPhrase);
			//foreach(name, cookie; response.cookies) {
			//	cookies[name] = cookie.value;
			//}
			cookies.copyCookies(response);
			responseBody = response.bodyReader.readAllUTF8().replace(",,", ",");
		}

		requestHTTP(url, &onRequest, &onResponse);
		return responseBody;
	}
}

void copyCookies(ref string[string] buffer, scope HTTPClientResponse res) {
	import std.regex;
	enum cookieRegex = ctRegex!`(?P<cookie_name>[a-zA-Z0-9_]+)=(?P<cookie_value>[a-zA-Z0-9_]+);.+\n?`;

	foreach(name, cookieHeader; res.headers) {
		if (name == "Set-Cookie") {
			foreach(cookie; cookieHeader.matchAll(cookieRegex)) {
				buffer[cookie["cookie_name"]] = cookie["cookie_value"];
			}
		}
	}
}