import std;

void main()
{
	auto input = stdin.byLine.map!"'9' ~ a ~ '9'";
	auto limit = ['9'.repeat(input.front.length).array];
	auto range = limit.chain(input, limit).array;
	range[1..$-1].map!"a[1..$-1].enumerate".enumerate
		.map!(a => a.value.filter!"a.value != '9'".filter!((c) {
			return only(
				range[a.index][c.index+1], range[a.index+2][c.index+1],
				range[a.index+1][c.index], range[a.index+1][c.index+2],
			).all!(i => c.value < i);
		}).map!"(a.value - '0').to!size_t + 1").join.sum.writeln;
}
