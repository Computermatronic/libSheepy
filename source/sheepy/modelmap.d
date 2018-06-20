module sheepy.modelmap;

struct ModelMap(Model) {
	alias ModelKey = typeof(Model.id);
	Model delegate(ModelKey) missFunc;
	Model[ModelKey] models;

	this(Model delegate(ModelKey) missFunc) {
		this.missFunc = missFunc;
	}

	void insert(Model model) {
		this.models[model.id] = model;
	}

	bool has(ModelKey key) {
		return (key in this.models) !is null;
	}

	Model get(ModelKey key) {
		auto model = key in this.models;
		if (missFunc is null && model is null) return null;
		else if(model is null) return models[key] = missFunc(key);
		return *model;
	}

	Model pick(bool delegate(Model) body ) {
		foreach(k, v; this.models) {
			if (body(v)) return v;
		}
		return null;
	}

	int opApply(int delegate(Model) body) {
		int returnCode;
		foreach(k, v; this.models) {
			if ((returnCode = body(v)) != 0) break;
		}
		return returnCode;
	}
}