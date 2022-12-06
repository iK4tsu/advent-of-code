import std;

enum RPS
{
	A = 1, // rock
	B,     // paper
	C,     // scissors
}

// cycle of the order of RPS hands in descending order
// Rock < Paper < Scissors < Rock
enum rpsOrder = EnumMembers!RPS.only.cycle.takeExactly(4);

void main()
{
	"/dev/stdin".slurp!(string, string)("%s %s")                                             // read input
	            .map!(bind!((c1, c2) => tuple(c1.to!RPS, tr(c2, "XYZ", "036", "s").to!int))) // columns c1 to RPS and XYZ to 036
	            .map!(bind!((c1, c2) => c2 + c2.predSwitch!"a == b"(                         // perform each game's result
	                0, rpsOrder.retro.find(c1).dropOne.front, // loss
	                3, c1,                                    // tie
	                6, rpsOrder.find(c1).dropOne.front,       // win
	            )))
	            .sum                                                                         // sum every result
	            .writeln;

	// Note: given c2 as char, maping XYZ could also be done with (c2 - ('Z' - 'C') - 'A') * 3)
}
