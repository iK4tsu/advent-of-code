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
	            .map!(bind!((c1, c2) => tuple(c1.to!RPS, tr(c2, "XYZ", "ABC", "s").to!RPS))) // columns to RPS
	            .map!(bind!((c1, c2) => c2 + c1.predSwitch!"a == b"(                         // perform each game's result
	                rpsOrder.find(c2).dropOne.front, 0,       // loss
	                c2, 3,                                    // tie
	                rpsOrder.retro.find(c2).dropOne.front, 6, // win
	            )))
	            .sum                                                                         // sum every result
	            .writeln;

	// Note: give c2 as char, maping XYZ could also be done with [(c2 - ('Z' - 'C')).to!char].to!RPS
}
