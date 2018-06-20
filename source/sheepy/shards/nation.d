module sheepy.shards.nation;

import vibe.data.json;
import sheepy.utils;

struct NationAPIShard {
	@JsonName("nationid") uint id;
	@JsonName("cityids") uint[] cityIDs;
	string name;
	@JsonName("prename") string preTitle;
	string continent;
	@JsonName("socialpolicy") string socialPolicy;
	string color;
	@JsonName("minutessinceactive") uint minutesSinceActive;
	@JsonName("uniqueid") string uniqueID;
	string government;
	@JsonName("domestic_policy") string domesticPolicy;
	@JsonName("war_policy") string warPolicy;
	@JsonName("founded") string created;
	@JsonName("daysold") uint daysOld;
	@JsonName("alliance") string allianceName;
	@JsonName("allianceid") uint allianceID;
	@JsonName("allianceposition") uint allianceRank;
	@JsonName("flagurl") string flagURL;
	@JsonName("leadername") string leader;
	@JsonName("title") string leaderTitle;
	@JsonName("ecopolicy") string economicPolicy;
	@JsonName("approvalrating") float approvalRating;
	@JsonName("nationrank") uint rank;
	@JsonName("cities") uint cityCount;
	float longitude;
	float latitude;
	float score;
	uint population;
	float gdp;
	@JsonName("totalinfrastructure") float infrastructure;
	@JsonName("infdesttot") float infrastructureKilled;
	@JsonName("landarea") float landArea;
	uint soldiers;
	uint tanks;
	uint aircraft;
	uint ships;
	@JsonName("soldierskilled") uint soldiersKilled;
	@JsonName("tankskilled") uint tanksKilled;
	@JsonName("aircraftkilled") uint aircraftKilled;
	@JsonName("shipskilled") uint shipsKilled;
	@JsonName("soldierscasualties") uint soldiersLost;
	@JsonName("tankscasualties") uint tanksLost;
	@JsonName("aircraftcasualties") uint aircraftLost;
	@JsonName("shipscasualties") uint shipsLost;
	uint missiles;
	uint nukes;
	@JsonName("missilelaunched") uint missilesLaunched;
	@JsonName("nukeslaunched") uint nukesLaunched;
	@JsonName("missileseaten") uint missileEaten;
	@JsonName("nukeseaten") uint nukesEaten;
	@JsonName("ironworks") uint ironworksProjects;
	@JsonName("bauxiteworks") uint bauxiteworksProjects;
	@JsonName("armsstockpile") uint armsStockpileProjects;
	@JsonName("emgasreserve") uint gasolineReserveProjects;
	@JsonName("massirrigation") uint massIrrigationProjects;
	@JsonName("inttradecenter") uint internationalTradeCenterProjects;
	@JsonName("missilelpad") uint missilelPadProjects;
	@JsonName("nuclearresfac") uint nuclearResearchfacilitiyProjects;
	@JsonName("irondome") uint ironDomeProjects;
	@JsonName("vitaldefsys") uint vitalDefenseSystemProjects;
	@JsonName("intagncy") uint intelligenceAgencyProjects;
	@JsonName("uraniumenrich") uint uraniumEnrichmentProjects;
	@JsonName("propbureau") uint propagandaBureauProjects;
	@JsonName("cenciveng") uint civicEngineeringProjects;
	@JsonName("vmode") uint vacationModeTurnsLeft;
	@JsonName("offensivewars") uint offensiveWarCount;
	@JsonName("defensivewars") uint defensiveWarCount;
	@JsonName("defensivewar_ids") uint[] defensiveWarIDs;
	@JsonName("offensivewar_ids") uint[] offensiveWarIDs;
	@JsonName("beige_turns_left") uint beigeTurnsLeft;
	@JsonName("radiation_index") float radiationIndex;
	string season;

	this(Json json) {
		this.loadJson(json);
	}
}

struct NationsAPIShard {
	@JsonName("nationid") uint id;
	@JsonName("nation") string name;
	string leader;
	string continent;
	@JsonName("war_policy") string warPolicy;
	string color;
	@JsonName("alliance") string allianceName;
	@JsonName("allianceid") uint allianceID;
	@JsonName("allianceposition") uint allianceRank;
	@JsonName("cities") uint cityCount;
	@JsonName("offensivewars") uint offensiveWarCount;
	@JsonName("defensivewars") uint defensiveWarCount;
	float score;
	uint rank;
	@JsonName("vacmode") uint vacationModeTurnsLeft;
	@JsonName("minutessinceactive") uint minutesSinceActive;

	this(Json json) {
		this.loadJson(json);
	}
}

struct AllianceMembersAPIShard {
	@JsonName("nationid") uint id;
	string leader;
	@JsonName("war_policy") string warPolicy;
	string color;
	@JsonName("alliance") string allianceName;
	@JsonName("allianceid") uint allianceID;
	@JsonName("allianceposition") uint allianceRank;
	@JsonName("cities") uint cityCount;
	@JsonName("offensivewars") uint offensiveWarCount;
	@JsonName("defensivewars") uint defensiveWarCount;
	float score;
	uint rank;
	@JsonName("vacmode") uint vacationModeTurnsLeft;
	@JsonName("minutessinceactive") uint minutesSinceActive;
	float infrastructure;
	@JsonName("cityprojecttimerturns") uint projectTurnsLeft;
	@JsonName("ironworks") uint ironworksProjects;
	@JsonName("bauxiteworks") uint bauxiteworksProjects;
	@JsonName("armsstockpile") uint armsStockpileProjects;
	@JsonName("emgasreserve") uint gasolineReserveProjects;
	@JsonName("massirrigation") uint massIrrigationProjects;
	@JsonName("inttradecenter") uint internationalTradeCenterProjects;
	@JsonName("missilelpad") uint missilelPadProjects;
	@JsonName("nuclearresfac") uint nuclearResearchfacilitiyProjects;
	@JsonName("irondome") uint ironDomeProjects;
	@JsonName("vitaldefsys") uint vitalDefenseSystemProjects;
	@JsonName("intagncy") uint intelligenceAgencyProjects;
	@JsonName("uraniumenrich") uint uraniumEnrichmentProjects;
	@JsonName("propbureau") uint propagandaBureauProjects;
	@JsonName("cenciveng") uint civicEngineeringProjects;
	float money;
	float food;
	float coal;
	float oil;
	float uranium;
	float iron;
	float bauxite;
	float lead;
	float gasoline;
	float munitions;
	float steel;
	@JsonName("aluminum") float aluminium;
	uint credits;
	uint soldiers;
	uint tanks;
	uint aircraft;
	uint ships;
	uint missiles;
	uint nukes;
	uint spies;

	this(Json json) {
		this.loadJson(json);
	}
}