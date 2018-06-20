module sheepy.types.war;

import std.meta: AliasSeq, Filter;
import sheepy.shards.war;
import sheepy.utils: isTypeFilter, hasMemberFilter;
import sheepy.client;
import sheepy.types;

class War {
	SheepyClient client;
	uint id;

	WarAPIShard warShard;
	WarsAPIShard warsShard;

	alias Shards = AliasSeq!(warShard, warsShard);

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
			if (i == 0 && member.id == 0) this.loadShard(client.api.requestWarEndpoint(id));
			if (member.id != 0) return mixin("member." ~ op);
		}
		assert(0);
	}

	@property Nation attacker() {
		return new Nation(this.attackerID, client);
	}

	@property Nation defender() {
		return new Nation(this.defenderID, client);
	}
}