import std;

/*
| Length | Numbers |
|   2    | 1       |
|   3    | 7       |
|   4    | 4       |
|   5    | 2 3 5   |
|   6    | 0 6 9   |
|   7    | 8       |

| Digit |      Pattern      | UniqueLen | Order | Uncovers |
|   0   | T TL TR   BL BR B |     N     |   5   |          |
|   1   |      TR      BR   |     Y     |   1   | (TR BR)  |
|   2   | T    TR M BL    B |     N     |   5   |          |
|   3   | T    TR M    BR B |     N     |   4   | TL M BL  | Known comparing with '1' + '4' +'7' + '9'
|   4   |   TL TR M    BR   |     Y     |   4   | (TL M)   | Known comparing with '1'
|   5   | T TL    M    BR B |     N     |   4   | TR BR BL | Known comparing with '4' + '7' + '9'
|   6   | T TL    M BL BR B |     N     |   4   | (BR BL)  | Known comparing with '4' + '7' + '9'
|   7   | T    TR      BR   |     Y     |   2   | T        | Known comparing with '1'
|   8   | T TL TR M BL BR B |     Y     |   1   |          |
|   9   | T TL TR M    BR B |     N     |   3   | B        | Known pos comparing with '4' + '7'
*/

void main()
{
	auto input = stdin.byLineCopy.array;

	alias uncover = (string range) {
		auto output = range.retro.until!"a == '|'".array.reverse.split.to!(string[]);
		auto all = range.splitter('|').joiner.array.split.to!(string[]);

		auto numbers = chain(
			"".only,                            // 0
			all.filter!"a.length == 2".takeOne, // 1
			"".repeat(2),                       // 2, 3
			all.filter!"a.length == 4".takeOne, // 4
			"".repeat(2),                       // 5, 6
			all.filter!"a.length == 3".takeOne, // 7
			all.filter!"a.length == 7".takeOne, // 8
			"".only                             // 9
		).array;

		auto t = numbers[7].filter!(a => !numbers[1].canFind(a)).array.to!string; // top light
		auto lShape = numbers[4].filter!(a => !numbers[1].canFind(a)).array.to!string; // shape of '4' intersect '1'

		numbers[9] = all.filter!"a.length == 6".filter!(str => numbers[4].only(t).joiner.all!(ch => str.canFind(ch))).front;
		auto b = numbers[9].filter!(a => !numbers[4].only(t).joiner.canFind(a)).array.to!string; // bottom light

		numbers[5] = all.filter!"a.length == 5".filter!(str => lShape.only(t, b).joiner.all!(ch => str.canFind(ch))).front;
		auto br = numbers[1].filter!(a => numbers[5].canFind(a)).array.to!string;
		auto tr = numbers[1].filter!(a => !numbers[5].canFind(a)).array.to!string;

		numbers[6] = all.filter!"a.length == 6".filter!(str => lShape.only(t, b, br).joiner.all!(ch => str.canFind(ch)) && !str.canFind(tr)).front;
		auto bl = numbers[6].filter!(a => !lShape.only(t, b, br).joiner.canFind(a)).array.to!string;

		numbers[3] = all.filter!"a.length == 5".filter!(str => t.only(tr, br, b).joiner.all!(ch => str.canFind(ch)) && !str.canFind(bl)).front;
		auto m = numbers[3].filter!(a => lShape.canFind(a)).array.to!string;
		auto tl = lShape.filter!(a => a.to!string != m).array.to!string;

		numbers[0] = t.chain(tl, tr, bl, br, b).array.to!string;
		numbers[2] = t.chain(tr, m, bl, b).array.to!string;

		numbers = numbers.map!"a.to!(dchar[]).sort.array".array.to!(string[]);
		return output
			.map!"a.to!(dchar[]).sort.array"
			.map!(str => numbers.countUntil(str.to!string))
			.map!"a.to!string".join.to!size_t;
	};

	input.map!uncover.sum.writeln;
}
