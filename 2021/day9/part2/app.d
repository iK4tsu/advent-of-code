import std;

void main()
{
	alias Basin = size_t;
	Basin*[] basins;

	auto input = stdin.byLine;
	NullableRef!Basin[] candidates = new NullableRef!Basin[input.front.length + 1];
	basins.reserve(input.front.length * 2);

	input.each!(arr => arr.each!((i, v)
	{
		if (v == '9') candidates[i+1].nullify; // it's a limit
		else if (candidates[i].isNull && candidates[i+1].isNull)
		{
			// "solo" value --> MAYBE it represents a new basin
			basins ~= new Basin(1);
			candidates[i+1].bind(basins[$-1]);
		}
		else if (!candidates[i].isNull)
		{
			// this value belongs to the previous basin
			candidates[i].get()++;
			if (!candidates[i+1].isNull && (&candidates[i].get() !is &candidates[i+1].get()))
			{
				// HEY there are conflicts!!!
				// The "new" basin already exists!
				// merge both basins in one
				candidates[i].get += candidates[i+1].get;
				basins = basins.remove!(a => a is &candidates[i+1].get());
				candidates[i+1 .. $].retro
					.filter!"!a.isNull".filter!((ref a) => &a.get() is &candidates[i+1].get())
					.each!((ref a) => a.bind(&candidates[i].get()));
			}
			else candidates[i+1] = candidates[i]; // extend the previous basin
		}
		else
		{
			candidates[i+1].get()++; // add to the existent basin
		}
	}));

	basins.map!"*a".array.sort.tail(3).fold!"a*b".writeln;
}
