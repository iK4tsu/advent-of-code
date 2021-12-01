import std.algorithm : count, map;
import std.array : array;
import std.conv : to;
import std.stdio : stdin, writeln;
import std.range : iota;

void main()
{
	auto arr = stdin.byLine.map!(to!size_t).array;
	iota(3, arr.length).count!(i => arr[i] > arr[i - 3]).writeln;
}
