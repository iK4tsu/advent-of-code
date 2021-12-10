import std;

/*
Based on a coworker's solution: immarianaas

 aaaa
b    c
b    c
 dddd
e    f
e    f
 gggg

A more clever solution is to search for a unique signature for each light. By
counting how many times all lights that form the unique signature of each digit
are on in all digits we achieve a unique result for each.

 aaaa              aaaa     aaaa              aaaa     aaaa   aaaa     aaaa     aaaa
b    c        c        c        c   b    c   b        b           c   b    c   b    c
b    c        c        c        c   b    c   b        b           c   b    c   b    c
                   dddd     dddd     dddd     dddd     dddd            dddd     dddd
e    f        f   e             f        f        f   e    f      f   e    f        f
e    f        f   e             f        f        f   e    f      f   e    f        f
 gggg              gggg     gggg              gggg     gggg            gggg     gggg


| Digit | Signature | Total |
|   0   | abcefg    |  42   |
|   1   | cf        |  17   |
|   2   | acdeg     |  34   |
|   3   | acdfg     |  39   |
|   4   | bcdf      |  30   |
|   5   | abdfg     |  37   |
|   6   | abdefg    |  41   |
|   7   | acf       |  25   |
|   8   | abcdefg   |  49   |
|   9   | abcdfg    |  45   |
*/

void main()
{
	auto table = only(42, 17, 34, 39, 30, 37, 41, 25, 49, 45).zip("0123456789").assocArray;
	stdin.byLine
		.map!"a.split('|').map!split".map!"tuple(a.front.join.array.sort.group.assocArray, a.back)"
		.map!(a => a[1].map!(str => table[str.fold!((r, c) => r + a[0][c])(0)]).array.to!size_t)
		.sum.writeln;
}
