import std;

void main()
{
	auto tab = ")]}>".zip(only(3, 57, 1_197, 25_137)).assocArray;
	auto match = "([{<".zip(")]}>").assocArray;
	stdin.byLine.map!((str) {
		alias pop = (ref string str) { scope(success) str.popBack; return str.back; };
		string order;
		return str.filter!(c => "([{<".canFind(c)
				? () { scope(exit) order ~= match[c]; return false; } ()
				: c != pop(order)
		).takeOne.array;
	}).filter!"!a.empty".map!"a.front".map!(c => tab[c]).sum.writeln;
}
