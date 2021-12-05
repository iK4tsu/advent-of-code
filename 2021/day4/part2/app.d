import std.algorithm.iteration : filter, fold, joiner, map, splitter, sum;
import std.algorithm.mutation : remove;
import std.algorithm.searching : all, any, until;
import std.array : array, assocArray, byPair, front;
import std.conv : to;
import std.range : enumerate, chunks, only, takeOne, retro, transposed;
import std.stdio : stdin, writeln;
import std.typecons : tuple;

void main()
{
	auto moves = stdin.byLineCopy.map!(to!string).takeOne.front.splitter(',').array;
	auto keys = stdin.byLineCopy.filter!"!a.empty".map!splitter.joiner.array.chunks(25).map!"a.chunks(5).array".array;
	auto boards = keys.map!joiner.map!`a.map!"tuple(a, false)"`.map!assocArray.array;

	auto marked(R)(R range, size_t i) { return range.any!(all!(key => boards[i][key])); }
	auto bingo(R)(R range) { return marked(range.value, range.index) || marked(range.value.array.transposed, range.index); }

	moves.fold!((res, move) {
		size_t[] complete;
		foreach (i, board; boards) if (move in board)
		{
			board[move] = true;
			if (keys[i].only.enumerate(i).any!(a => bingo(a)))
			{
				res[1] = move.to!int;
				res[0] = board;
				complete ~= i;
			}
		}
		foreach (i; complete.retro) {
			boards = boards.remove(i);
			keys = keys.remove(i);
		}
		return res;
	})(tuple(boards.front, 0)).only
		.map!`tuple(a[0].byPair.filter!"!a.value", a[1])`
		.map!`tuple(a[0].map!"a.key.to!int".sum, a[1])`
		.front.fold!"a * b".writeln;
}
