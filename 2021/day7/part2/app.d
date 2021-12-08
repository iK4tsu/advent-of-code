import std;

void main()
{
	auto range = stdin.byLine.front.to!string.splitter(',').map!"a.to!int".array;
	auto avg = range.sum / range.length.to!double;
	range.map!(a => [abs(a - avg.floor), abs(a - avg.ceil)])
		.map!`a.map!"(a.pow(2) + a) / 2.0"`
		.fold!((arr, n) => [arr.front + n.front, arr.back + n.back])([0., 0.])
		.minElement.to!size_t.writeln;
}
