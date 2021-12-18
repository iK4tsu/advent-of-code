import std;

void main()
{
	alias Point = Tuple!(int, "x", int, "y");

	auto positions = stdin.byLineCopy.until!"a.empty"
		.map!`a.split(',').map!"a.to!int"`
		.map!(a => Point(a.front, a.back)).array;

	auto instructions = stdin.byLineCopy
		.map!"a.split.back.split('=')"
		.map!"tuple(a[0], a[1].to!int)".array;

	positions.recurrence!((state, n) {
		if (n > instructions.length) return state[n - 1];
		const coord = instructions[n - 1][1];

		alias paperFold(alias c) = () {
			return state[n - 1].filter!(a => mixin("a."~c) != coord).map!((a) {
				mixin("a."~c~" = coord - abs(a."~c~" - coord);");
				return a;
			}).array.sort.uniq.array;
		};

		final switch (instructions[n - 1][0])
		{
			case "x": return paperFold!"x"();
			case "y": return paperFold!"y"();
		}
	}).take(2).tail(1).front.length.writeln;
}
