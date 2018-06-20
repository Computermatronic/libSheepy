module sheepy.client;

import std.datetime: hours;
import vibe.core.core;
import sheepy.modelmap;
import sheepy.shards;
import sheepy.api;
public import sheepy.types;

class SheepyClient {
	SheepyAPI api;

	ModelMap!Nation nations;
	ModelMap!Alliance alliances;
	ModelMap!War wars;
	ModelMap!City cities;
	ModelMap!TradePrice tradePrices;

	string apiKey, loginEmail, loginPassword;
	uint allianceID;

	this(uint allianceID = 0, string apiKey = null, string loginEmail = null, string loginPassword = null) {
		this.apiKey = apiKey;
		this.loginEmail = loginEmail;
		this.loginPassword = loginPassword;
		this.allianceID = allianceID;

		this.wars = ModelMap!War(&onMissWar);
		this.cities = ModelMap!City(&onMissCity);
		this.tradePrices = ModelMap!TradePrice(&onMissTradePrice);

		this.api = new SheepyAPI(apiKey, loginEmail, loginPassword);

		update();
		setTimer(2.hours, &update, true);
	}

	private War onMissWar(uint id) {
		auto war = new War(id, this);
		war.loadShard(api.requestWarEndpoint(id));
		return war;
	}

	private City onMissCity(uint id) {
		auto city = new City(id, this);
		city.loadShard(api.requestCityEndpoint(id));
		return city;
	}

	private TradePrice onMissTradePrice(string id) {
		auto tradePrice = new TradePrice(id, this);
		tradePrice.loadShard(api.requestTradePriceEndpoint(id));
		return tradePrice;
	}

	void update() {
		foreach(nationShard; api.requestNationsEndpoint()) {
			if (!this.nations.has(nationShard.id)) {
				auto nation = new Nation(nationShard.id, this);
				nation.loadShard(nationShard);
				this.nations.insert(nation);
			} else {
				auto nation = this.nations.get(nationShard.id);
				nation.loadShard(nationShard);
				if (nation.hasShard!NationAPIShard()) nation.loadShard(api.requestNationEndpoint(nationShard.id));
			}
		}

		foreach(allianceShard; api.requestAlliancesEndpoint()) {
			if (!this.alliances.has(allianceShard.id)) {
				auto alliance = new Alliance(allianceShard.id, this);
				alliance.loadShard(allianceShard);
				this.alliances.insert(alliance);
			} else {
				auto alliance = this.alliances.get(allianceShard.id);
				alliance.loadShard(allianceShard);
				if (alliance.hasShard!AllianceAPIShard()) alliance.loadShard(api.requestAllianceEndpoint(allianceShard.id));
			}
		}

		foreach(warShard; api.requestWarsEndpoint()) {
			if (!this.wars.has(warShard.id)) {
				auto war = new War(warShard.id, this);
				war.loadShard(warShard);
				this.wars.insert(war);
			} else {
				auto war = this.wars.get(warShard.id);
				war.loadShard(warShard);
				if (war.hasShard!WarAPIShard()) war.loadShard(api.requestWarEndpoint(warShard.id));
			}
		}

		foreach(city; this.cities) {
			if (city.hasShard!CityAPIShard()) city.loadShard(api.requestCityEndpoint(city.id));
		}

		foreach(tradePrice; this.tradePrices) {
			if (tradePrice.hasShard!TradePriceAPIShard()) tradePrice.loadShard(api.requestTradePriceEndpoint(tradePrice.id));
		}

		if (this.allianceID != 0 && this.apiKey !is null) {
			//this.alliances.get(this.allianceID).loadShard(api.requestAllianceEndpoint(this.allianceID));
			this.alliances.get(this.allianceID).loadShard(api.requestAllianceBankEndpoint(this.allianceID));
			foreach(nationShard; api.requestAllianceMembersEndpoint(this.allianceID)) {
				this.nations.get(nationShard.id).loadShard(nationShard);
				//this.nations.get(nationShard.id).loadShard(api.requestNationEndpoint(nationShard.id));
			}
		}
	}
}