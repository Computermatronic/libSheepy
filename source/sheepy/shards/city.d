module sheepy.shards.city;

import vibe.data.json;
import sheepy.utils;

struct CityAPIShard {
	@JsonName("cityid") uint id;
	@JsonName("nationid") uint nationID;
	@JsonName("founded") string created;
	@JsonName("age") uint daysOld;
	bool powered;
	float infrastructure;
	@JsonName("land") float landArea;
	uint population;
	@JsonName("popdensity") float populationDensity;
	@JsonName("crime") float crimeRate;
	@JsonName("disease") float diseaseRate;
	@JsonName("commerce") float commerceRate;
	@JsonName("avgincome") float averageIncome;
	uint pollution;
	@JsonName("nuclearpollution") uint nuclearPollution;
	@JsonName("basepop") uint basePopulation;
	@JsonName("basepopdensity") float basePopulationDensity;
	@JsonName("minimumwage") float minimumWage;
	@JsonName("poplostdisease") uint diseaseDeaths;
	@JsonName("poplostcrime") uint crimeDeaths;
	@JsonName("imp_coalpower") uint coalPower;
	@JsonName("imp_oilpower") uint oilPowerPlants;
	@JsonName("imp_nuclearpower") uint nuclearPowerPlants;
	@JsonName("imp_windpower") uint windPowerPlants;
	@JsonName("imp_coalmine") uint coalMines;
	@JsonName("imp_oilwell") uint oilWells;
	@JsonName("imp_ironmine") uint ironMines;
	@JsonName("imp_bauxitemine") uint bauxiteMines;
	@JsonName("imp_leadmine") uint leadMines;
	@JsonName("imp_uramine") uint uraniumMines;
	@JsonName("imp_farm") uint farms;
	@JsonName("imp_gasrefinery") uint gasolineRefineries;
	@JsonName("imp_steelmill") uint steelRefineries;
	@JsonName("imp_aluminumrefinery") uint aluminumRefineries;
	@JsonName("imp_munitionsfactory") uint munitionsFactories;
    @JsonName("imp_policestation") uint policeStations;
    @JsonName("imp_hospital") uint hospitals;
    @JsonName("imp_recyclingcenter") uint recyclingCenters;
    @JsonName("imp_subway") uint subways;
    @JsonName("imp_supermarket") uint superMarkets;
    @JsonName("imp_bank") uint banks;
    @JsonName("imp_mall") uint malls;
    @JsonName("imp_stadium") uint stadiums;
    @JsonName("imp_barracks") uint barrackses;
    @JsonName("imp_factory") uint factories;
    @JsonName("imp_hangar") uint hangars;
    @JsonName("imp_drydock") uint drydocks;

	this(Json json) {
		this.loadJson(json);
	}
}