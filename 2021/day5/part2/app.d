import std.algorithm : any, each, filter, fold, minElement, map, sort, uniq;
import std.array : array, back, byPair, front;
import std.range : cycle, enumerate, iota, take, transposed, walkLength, zip;
import std.stdio : stdin, writeln;
import std.typecons : No, Tuple, Yes;

void main()
{
	alias Point = Tuple!(size_t, "x", size_t, "y");
	stdin.byLine
		.map!`a.to!string.splitter(" -> ").map!"a.splitter(',')"`
		.map!`a.map!"a.map!(to!int)".map!array`.map!array
		.fold!((rate, pts) {
			alias pred = (step) { with(step) return pts.front[index].iota(pts.back[index] + value, value).array; };
			auto seq = pts.dup.transposed
				.map!array.map!"a.back < a.front ? -1 : 1".enumerate
				.map!pred.array;
			immutable shortest = seq.enumerate.minElement!"a.value.walkLength".index;
			zip(
				shortest == 0 ? seq.front.cycle.take(seq.back.length).array : seq.front,
				shortest == 1 ? seq.back.cycle.take(seq.front.length).array : seq.back
			).each!((x, y) => rate[Point(x, y)]++);
			return rate;
		})(size_t[Point].init).byPair.filter!"a.value > 1".walkLength.writeln;
}
