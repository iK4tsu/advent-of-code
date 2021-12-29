import std;

struct Snailfish
{
	this(char[] input)
	{
		this(input.to!string);
	}

	this(string input)
	{
		size_t paren;
		foreach(i, c; input[1..$]) switch (c)
		{
			case '[': paren++; break;
			case ']': paren--; break;
			case ',': break;
			default: numbers ~= Number((c - '0').to!size_t, paren);
		}
	}

	alias Number = Tuple!(size_t, "value", size_t, "depth");
	Number[] numbers;

	Snailfish opBinary(string op, R)(const R rhs) const
		if (op == "+")
	{
		Snailfish ret;
		ret.numbers = numbers.chain(rhs.numbers).map!(a => Number(a.value, a.depth+1)).array;

		// explode
		Lexplode: with (ret) for (size_t i; i < numbers.length; i++)
		if (numbers[i].depth > 3) // filter pairs with depth 4 or higher
		{
			if (i) numbers[i-1].value += numbers[i].value; // update value to the left
			if (i+2 < numbers.length) numbers[i+2].value += numbers[i+1].value; // update value to the right
			numbers[i] = Number(0, numbers[i].depth-1);
			numbers = numbers.remove(i+1); // transform pair in a 0
		}

		// split
		with (ret) for (size_t i; i < numbers.length; i++)
		if (numbers[i].value > 9) // filter numbers with value 10 or higher
		{
			const half = numbers[i].value / 2.0;
			const depth = numbers[i].depth + 1;
			numbers[i] = Number(half.floor.to!size_t, depth); // left value
			numbers = numbers[0..i+1]~Number(half.ceil.to!size_t, depth)~numbers[i+1..$]; // right value
			if (depth > 3) goto Lexplode; // explosions always come first
			i--; // evaluate left value after split
		}

		return ret;
	}

	size_t magnitude()
	{
		auto ret = numbers.dup;
		Lshrink: for (size_t i; i < ret.length-1; i++)
		if (ret[i].depth == ret[i+1].depth)
		{
			ret[i] = Number(3*ret[i].value + 2*ret[i+1].value, ret[i].depth-1);
			ret = ret.remove(i+1);
			goto Lshrink; // must restart from the begining
		}
		return ret.front.value;
	}
}

void main()
{
	auto input = stdin.byLine.map!(to!Snailfish).array;
	input.cartesianProduct(input).filter!"a[0] != a[1]".map!`a.fold!"a+b".magnitude`.maxElement.writeln;
}
