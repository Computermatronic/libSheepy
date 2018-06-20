module sheepy.types.nation;

import std.meta: AliasSeq, Filter;
import sheepy.shards.nation;
import sheepy.utils: isTypeFilter, hasMemberFilter;
import sheepy.client;

class Nation {
	SheepyClient client;
	uint id;

	NationAPIShard nationShard;
	NationsAPIShard nationsShard;
	AllianceMembersAPIShard allianceMembersShard;

	alias Shards = AliasSeq!(nationShard, nationsShard, allianceMembersShard);

	this(uint id, SheepyClient client) {
		this.id = id;
		this.client = client;
	}

	void loadShard(Shard)(Shard shard) {
		shard.id = id;
		Filter!(isTypeFilter!Shard, Shards)[0] = shard;
	}

	void reload() {
		this.loadShard(client.api.requestNationEndpoint(id));
	}

	bool hasShard(Shard)() if (Filter!(isTypeFilter!Shard, Shards).length == 1){
		return Filter!(isTypeFilter!Shard, Shards)[0].id != 0;
	}

	@property auto opDispatch(string op)() if(Filter!(hasMemberFilter!op, Shards).length > 0) {
		alias members = Filter!(hasMemberFilter!op, Shards);

		foreach_reverse(i, ref member; members) {
			if (i == 0 && member.id == 0) this.loadShard(client.api.requestNationEndpoint(id));
			if (member.id != 0) return mixin("member." ~ op);
		}
		assert(0);
	}

	void sendMessage(string subject, string message, string cc = null) {
		client.api.sendMessage(this.opDispatch!"leader", cc, subject, message);
	}
}