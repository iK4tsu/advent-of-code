import std.algorithm : fold, group, joiner, map, sort, sum;
import std.array : array, front;
import std.conv : to;
import std.range : dropOne, chain, only, iota, repeat;
import std.stdio : stdin, writeln;

void main()
{
	80.iota.fold!((state, _) {
		auto fish = state.front;
		state[7] += fish;
		return state.dropOne.chain(fish.only).array;
	})(
		stdin.byLine
			.map!"a.splitter(',')".joiner
			.map!"a.to!size_t".array.sort.group
			.fold!((arr, tup) { arr[tup[0]] = tup[1]; return arr; })(0.repeat!size_t(9).array)
	).sum.writeln;
}
