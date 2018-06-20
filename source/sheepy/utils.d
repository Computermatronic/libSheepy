module sheepy.utils;

import std.traits;
import std.datetime : Clock, Duration, SysTime;
import vibe.data.json: Json;

template isTypeFilter(Type) {
	static enum isTypeFilter(alias symbol) = is(typeof(symbol) == Type);
}

template hasMemberFilter(string member) {
	static enum hasMemberFilter(alias symbol) = __traits(hasMember, symbol, member);
}

struct JsonName {
	string name;
}

void loadJson(ShardType)(ref ShardType shard, Json json) {
	foreach(member;  FieldNameTuple!ShardType) {
		static if(member != "load" && member != "isLoaded") {
			static if (hasUDA!(mixin("shard." ~ member), JsonName)) {
				enum jsonName = getUDAs!(mixin("shard." ~ member), JsonName)[0].name;
				if (json[jsonName].type != Json.Type.undefined) {
					mixin("shard." ~ member ~ " = json[jsonName].as!(typeof(shard." ~ member ~ "));");
				}
			} else {
				if (json[member].type != Json.Type.undefined) {
					mixin("shard." ~ member ~ " = json[\"" ~ member ~ "\"].as!(typeof(shard." ~ member ~ "));");
				}
			}
		}
	}
}

Type as(Type)(Json json) {
	import std.range: ElementType;
	import std.algorithm: map;
	import std.array: array;

	static if (isArray!Type && !is(Type == string) && !is(Type == Json[])) {
		return json.byValue.map!((e) => e.to!(ElementType!Type)).array;
	} else static if (is(Type == bool)) {
		return json.to!string == "1" || json.to!string == "Yes" || json.to!string == "true";
	} else static if(is(Type == struct)) {
		Type result;
		loadJson(result, json);
		return result;
	} else {
		return json.to!Type;
	}
}

string cacheFileName(string url) {
	import std.base64: Base64URL;
	size_t hash = url.hashOf;
	return Base64URL.encode((cast(ubyte*)&hash)[0..size_t.sizeof]);
}

Duration fileAge(string file) {
	import std.file : getTimes;

	SysTime modifyTime, accessTime;
	getTimes(file, modifyTime, accessTime);
	return Clock.currTime - modifyTime;
}

string appDataDir(string name) {
	import std.process : environment;

	version(Windows) {
		return environment.get("APPDATA") ~ '/' ~ name;
	} else version(Posix) {
		return environment.get("HOME") ~ (name !is null ? "/." ~ name : "");
	} else {
		static assert(0, "Need platform path stuff");
	}
}