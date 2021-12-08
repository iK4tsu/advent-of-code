import std;

void main()
{
	auto range = stdin.byLine.front.to!string.splitter(',').map!"a.to!int".array;
	auto median = range.sort.radial.front;
	range.fold!((a, b) => a + abs(b - median))(0).writeln;
}
