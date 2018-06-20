module sheepy.shards.war;

import vibe.data.json;
import sheepy.utils;

struct WarAPIShard {
	uint id;
	@JsonName("war_ended") bool hasEnded;
	@JsonName("date") string created;
	@JsonName("aggressor_id") uint attackerID;
	@JsonName("defender_id") uint defenderID;
	@JsonName("aggressor_alliance_name") string attackerAllianceName;
	@JsonName("aggressor_is_applicant") bool attackerIsApplicant;
	@JsonName("defender_alliance_name") string defenderAllianceName;
	@JsonName("defender_is_applicant") bool defenderIsApplicant;
	@JsonName("aggressor_offering_peace") bool aattackerIsOfferingPeace;
	@JsonName("war_reason") string reason;
	@JsonName("aggressor_military_action_points") uint attackerMAPs;
	@JsonName("defender_military_action_points") uint defenderMAPs;
	@JsonName("aggressor_resistance") uint attackerResistance;
	@JsonName("defender_resistance") uint defenderResistance;
	@JsonName("aggressor_is_fortified") bool attackerIsFortified;
	@JsonName("defender_is_fortified") bool defenderIsFortified;
	@JsonName("turns_left") uint turnsLeft;

	this(Json json) {
		this.loadJson(json);
	}
}

struct WarsAPIShard {
	@JsonName("warID") uint id;
	uint attackerID;
	uint defenderID;
	string attackerAA;
	string defenderAA;
	@JsonName("war_type") string warType;
	string status;
	@JsonName("date") string created;

	this(Json json) {
		this.loadJson(json);
	}
}