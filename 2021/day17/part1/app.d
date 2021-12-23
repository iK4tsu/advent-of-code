import std;

void main()
{
	stdin.byLine.front
		.split(", ").back.drop(2)
		.split("..").front.to!long.iota(0).dropOne.sum.abs.writeln;
}
