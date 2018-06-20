module sheepy.shards.tradeprice;

import vibe.data.json;
import sheepy.utils;

struct TradePriceAPIShard {
    alias id = resource;
    
    string resource;
    @JsonName("avgprice") float averagePrice;
    @JsonName("highestbuy") TradePriceAPISaleShard highestBuyOffer;
    @JsonName("lowestbuy") TradePriceAPISaleShard lowestSellOffer;

	this(Json json) {
		this.loadJson(json);
	}
}

struct TradePriceAPISaleShard {
    @JsonName("date") string created;
    @JsonName("nationid") uint nationID;
    uint amount;
    float price;
    @JsonName("totalvalue") float totalValue;
}