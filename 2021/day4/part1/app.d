import std.algorithm : all, any, filter, fold, joiner, map, splitter, until;
import std.array : array, assocArray, back, byPair, empty, front;
import std.conv : to;
import std.range : enumerate, chunks, only, takeOne, transposed;
import std.stdio : stdin, writeln;
import std.typecons : No;

void main()
{
	auto moves = stdin.byLineCopy.map!(to!string).takeOne.front.splitter(',').array;
	auto keys = stdin.byLineCopy.filter!"!a.empty".map!splitter.joiner.array.chunks(25).map!"a.chunks(5).array".array;
	auto boards = keys.map!joiner.map!`a.map!"tuple(a, false)"`.map!assocArray.array;

	auto marked(R)(R range, size_t i) { return range.any!(all!(key => boards[i][key])); }
	auto bingo(R)(R range) { return marked(range.value, range.index) || marked(range.value.array.transposed, range.index); }

	auto move = moves.until!((move) {
		foreach (board; boards) if (move in board) board[move] = true;
		return keys.enumerate.any!(a => bingo(a));
	})(No.openRight).array.back.to!int;

	boards[keys.enumerate.until!(a => bingo(a))(No.openRight).array.back.index]
		.byPair.filter!"!a.value"
		.fold!"a + b.key.to!int"(0).only
		.fold!"a * b"(move).writeln;
}
