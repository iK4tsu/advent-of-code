import std.algorithm : fold, map;
import std.array : array, back, front, split;
import std.conv : to;
import std.stdio : stdin, writeln;
import std.typecons : Tuple;

void main()
{
	alias Submarine = Tuple!(size_t, "pos", size_t, "depth");
	stdin.byLine.map!(to!string).map!split
		.fold!((Submarine res, line) {
			with(res) final switch(line.front)
			{
				case "forward": return Submarine(pos + line.back.to!size_t, depth);
				case "down":    return Submarine(pos, depth + line.back.to!size_t);
				case "up":      return Submarine(pos, depth - line.back.to!size_t);
			}
		})(Submarine.init).fold!"a * b".writeln;
}
