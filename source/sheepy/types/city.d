module sheepy.types.city;

import std.meta: AliasSeq, Filter;
import sheepy.shards.city;
import sheepy.utils: isTypeFilter, hasMemberFilter;
import sheepy.client;

class City {
	SheepyClient client;
	uint id;

	CityAPIShard cityShard;

	alias Shards = AliasSeq!(cityShard);

	this(uint id, SheepyClient client) {
		this.id = id;
		this.client = client;
	}

	void loadShard(Shard)(Shard shard) {
		shard.id = id;
		Filter!(isTypeFilter!Shard, Shards)[0] = shard;
	}

	bool hasShard(Shard)() {
		return Filter!(isTypeFilter!Shard, Shards)[0].id != 0;
	}

	@property auto opDispatch(string op)() if(Filter!(hasMemberFilter!op, Shards).length > 0){
		alias members = Filter!(hasMemberFilter!op, Shards);

		foreach_reverse(i, ref member; members) {
			if (i == 0 && member.id == 0) this.loadShard(client.api.requestCityEndpoint(id));
			if (member.id != 0) return mixin("member." ~ op);
		}
		assert(0);
	}
}