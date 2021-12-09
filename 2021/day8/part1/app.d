import std;

void main()
{
	stdin.byLine
		.map!`a.retro.until!"a == '|'".array.splitter`.joiner
		.count!"cast(bool)a.length.among(2, 3, 4, 7)".writeln;
}
