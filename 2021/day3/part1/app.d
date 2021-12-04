import std.algorithm : clamp, each, fold, map;
import std.array : array, back, front;
import std.conv : to;
import std.range : enumerate, iota, repeat, retro;
import std.stdio : stdin, writeln;

void main()
{
	auto lines = stdin.byLine;
	lines.fold!((res, char[] str) {
			res.each!((i, ref val) => val += (-1)^^(str[i] == '0'));
			return res;
		})(1.repeat(lines.front.length).array)
		.map!(n => n.clamp(0, 1)).retro.enumerate!int
		.fold!((res, digit) {
			immutable base = 2^^digit.index;
			return [res.front + digit.value * base, res.back + (!digit.value) * base];
		})([0, 0]).fold!"a * b".writeln;
}
