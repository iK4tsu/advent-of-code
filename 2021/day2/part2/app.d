import std.algorithm : fold, map;
import std.array : array, back, front, split;
import std.conv : to;
import std.range : only, take;
import std.stdio : stdin, writeln;
import std.typecons : Tuple;

void main()
{
	alias Submarine = Tuple!(size_t, "pos", size_t, "depth", size_t, "aim");
	stdin.byLine.map!(to!string).map!split
		.fold!((Submarine res, line) {
			with(res) final switch(line.front)
			{
				case "forward": return Submarine(pos + line.back.to!size_t, depth + line.back.to!size_t * aim, aim);
				case "down":    return Submarine(pos, depth, aim + line.back.to!size_t);
				case "up":      return Submarine(pos, depth, aim - line.back.to!size_t);
			}
		})(Submarine.init).expand.only.take(2).fold!"a * b".writeln;
}
