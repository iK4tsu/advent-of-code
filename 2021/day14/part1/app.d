import std;

void main()
{
	auto polymer = stdin.byLineCopy.until!"a.empty".array.front;
	auto pairs = stdin.byLineCopy
		.map!`a.split(" -> ")`
		.map!"tuple(a.front, a.front.replace(1, 2, a.back~a.front[1..2]))".assocArray;

	polymer.recurrence!((state, n) {
		return state[n - 1].slide(2).map!"a.array.to!string".map!(str => pairs[str]).fold!"a ~ b[1..$]";
	}).drop(10).front.array.sort.group
		.map!"a[1]".array.only
		.map!"[a.maxElement, a.minElement]".front
		.fold!"a-b".writeln;
}
