import std.algorithm : clamp, each, filter, fold, map;
import std.array : array, back, front;
import std.conv : to;
import std.range : iota, only, repeat, transversal;
import std.stdio : stdin, writeln;

void main()
{
	auto rating = stdin.byLineCopy.array.repeat(2).array;
	rating.front.front.length.iota.each!((i) {
		auto left = rating.front.transversal(i).fold!((res, bit) => res + (-1)^^(bit == '0'))(1);
		auto right = rating.back.transversal(i).fold!((res, bit) => res + (-1)^^(bit == '0'))(1);
		auto arr = only(left, right).map!(n => n.clamp(0, 1)).array;
		rating = [
			rating.front.length == 1 ? rating.front : rating.front.filter!(line => line[i].to!string == arr.front.to!string).array,
			rating.back.length == 1 ? rating.back : rating.back.filter!(line => line[i].to!string == (!arr.back).to!int.to!string).array,
		];
	});
	rating.map!(str => str.front.to!int(2)).fold!"a * b".writeln;
}
