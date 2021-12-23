import std;

void main()
{
	alias Slice = Tuple!(long, "from", long, "to");
	auto input = stdin.byLine.front.splitter(',')
		.map!`a.find('=').dropOne.splitter("..").map!"a.to!long"`
		.map!(arr => Slice(arr.front, arr.dropOne.front+1));

	auto xs = input.front;
	auto ys = input.back;

	long xMinStep = 0.recurrence!"a[n-1]+n".until!(i => xs.from < i).walkLength;
	long yMaxStep = ys.from.iota(0).dropOne.sum.abs;

	auto velocitiesOf(R)(R range, Slice slice) {
		with(slice) return range
			.filter!(arr => arr.any!(i => from <= i && i < to))
			.map!array
			.map!(arr => 0.iota(arr.count!(a => a >= from && a < to)).map!(i => arr[0..$-i]))
			.joiner.array.sort!"a.length < b.length";
	}

	auto xrange = velocitiesOf(xMinStep.iota(xs.to)
		.map!`a.iota(0, -1).cumulativeFold!"a+b"`
		.map!(arr => arr.until!(i => i >= xs.to)), xs);
	auto yrange = velocitiesOf(ys.from.iota(yMaxStep+1)
		.map!`a.recurrence!"a[n-1]-1".cumulativeFold!"a+b"`
		.map!(arr => arr.until!(i => i < ys.from)), ys);

	// I could try and make all of this lazy, but I just want to finish this
	xrange.map!(x => yrange
		.filter!(y => y.length == x.length || (y.length >= xrange.back.length && x.front == x.length))
		.map!(y => [x.front, y.front])
	).joiner.array.sort.uniq.walkLength.writeln;
}
