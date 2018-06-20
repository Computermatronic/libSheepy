module sheepy.types.alliance;

import std.meta: AliasSeq, Filter;
import std.algorithm: map;
import std.array: array;
import sheepy.shards.alliance;
import sheepy.utils: isTypeFilter, hasMemberFilter;
import sheepy.client;
import sheepy.types;

class Alliance {
	SheepyClient client;
	uint id;

	AllianceAPIShard allianceShard;
	AlliancesAPIShard alliancesShard;
	AllianceBankAPIShard allianceBankShard;

	alias Shards = AliasSeq!(allianceShard, alliancesShard, allianceBankShard);

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

	@property auto opDispatch(string op)() if(Filter!(hasMemberFilter!op, Shards).length > 0) {
		alias members = Filter!(hasMemberFilter!op, Shards);

		foreach_reverse(i, ref member; members) {
			if (i == 0 && member.id == 0) this.loadShard(client.api.requestAllianceEndpoint(id));
			if (member.id != 0) return mixin("member." ~ op);
		}
		assert(0);
	}

	@property Nation[] leaders() {
		this.opDispatch!"leaderIDs";
		return this.leaderIDs.map!((a) => client.nations.get(a)).array;
	}

	@property Nation[] heirs() {
		return this.heirIDs.map!((a) => client.nations.get(a)).array;
	}

	@property Nation[] officers() {
		return this.officerIDs.map!((a) => client.nations.get(a)).array;
	}

	@property Nation[] members() {
		return this.memberIDs.map!((a) => client.nations.get(a)).array;
	}
}