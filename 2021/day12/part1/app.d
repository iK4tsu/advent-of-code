import std;
import std.ascii : isLower;

void main()
{
	(string path, string[][string] world) {
		alias self = __traits(parent, (){});
		if (path.all!isLower) world.each!((ref a) { a = a.remove!(p => p == path); });
		if (path == "end") return [[path]];
		else return world[path].map!((p) {
			return self(p, world.byPair.map!"tuple(a.key, a.value.dup)".assocArray).map!(p => path ~ p).array;
		}).array.join;
	} ("start", stdin.byLine.map!"a.to!string.split('-')"
		.map!"[tuple(a.front, a.back), tuple(a.back, a.front)]"
		.joiner.filter!`a[1] != "start" && a[0] != "end"`
		.fold!((aa, tup) { aa[tup[0]] ~= tup[1]; return aa; })(string[][string].init)
	).walkLength.writeln;
}
