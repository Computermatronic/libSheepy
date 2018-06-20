module sheepy.shards.alliance;

import vibe.data.json;
import sheepy.utils;

struct AllianceAPIShard {
	@JsonName("leaderids") uint[] leaderIDs;
	@JsonName("allianceid") uint id;
	string name;
	string acronym;
	float score;
	string color;
	@JsonName("members") uint memberCount;
	@JsonName("member_id_list") uint[] memberIDs;
	@JsonName("vmodemembers") uint vacationModeMemberCount;
	@JsonName("accepting members") bool isAcceptingMembers;
	@JsonName("applicants") uint applicantCount;
	@JsonName("flagurl") string flagURL;
	@JsonName("irc") string discordURL;
	float gdp;
	@JsonName("cities") uint cityCount;
	uint soldiers;
	uint tanks;
	uint aircraft;
	uint ships;
	uint missiles;
	uint nukes;
	uint treasures;

	this(Json json) {
		this.loadJson(json);
	}
}

struct AlliancesAPIShard {
	uint id;
	@JsonName("founddate") string created;
	string name;
	string acronym;
	string color;
	string continent;
	uint rank;
	//@JsonName("members") uint memberCount;
	//float score;
	@JsonName("leaderids") uint[] leaderIDs;
	@JsonName("heirids") uint[] heirIDs;
	@JsonName("officerids") uint[] officerIDs;
	@JsonName("avgscore") float averageScore;
	@JsonName("flagurl") string flagURL;
	@JsonName("forumurl") string forumURL;
	@JsonName("ircchan") string discordURL;

	this(Json json) {
		this.loadJson(json);
	}
}

struct AllianceBankAPIShard {
	@JsonName("alliance_id") uint id;
	string name;
	@JsonName("taxrate") float moneyTax;
	@JsonName("resource_taxrate") float resourceTax;
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
	float aluminum;

	this(Json json) {
		this.loadJson(json);
	}
}