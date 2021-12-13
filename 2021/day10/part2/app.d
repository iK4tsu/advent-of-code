import std;

void main()
{
	auto tab = ")]}>".zip(only(1L, 2L, 3L, 4L)).assocArray;
	auto match = "([{<".zip(")]}>").assocArray;
	stdin.byLine.map!((str) {
		alias pop = (ref string str) { scope(success) str.popBack; return str.back; };
		string order;
		return str.filter!(c => "([{<".canFind(c)
				? () { scope(exit) order ~= match[c]; return false; } ()
				: c != pop(order)
		).takeOne.array.empty ? order.retro.array : "";
	}).filter!"!a.empty".map!(str => str.fold!((a, c) => a * 5 + tab[c])(0L))
		.array.sort.radial.front.writeln;
}
