import std;

void main()
{
	auto polymer = stdin.byLineCopy.until!"a.empty".array.front.slide(2).map!"a.to!string".array;
	auto pairs = stdin.byLineCopy
		.map!`a.split(" -> ")`
		.map!"tuple(a.front, a.front.replace(1, 2, a.back~a.front[1..2]))".assocArray;

	auto pairMap = pairs.byKey.map!"tuple(a, size_t(0))".assocArray;
	auto elementMap = polymer.stride(2).map!array.join.sort.group.map!"tuple(a[0], a[1].to!size_t)".assocArray;
	polymer.each!(str => pairMap[str]++);

	generate!(() {
		const newMap = pairMap.dup;
		pairMap.each!((ref value) => value = 0);
		newMap.byPair.each!((tup) { with(tup) {
			elementMap[pairs[key][1]] += value;
			pairs[key].slide(2).each!(str => pairMap[str.to!string] += value);
		}});
		return elementMap;
	}).drop(39).front.byPair
		.map!"a[1]".array.only
		.map!"[a.maxElement, a.minElement]".front
		.fold!"a-b".writeln;
}
