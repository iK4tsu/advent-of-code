import std;

struct Packet
{
	size_t ver() { return signature[0 .. 3].to!size_t(2); }
	size_t id() { return signature[3 .. 6].to!size_t(2); }
	Nullable!size_t[] subValues() { return subpackets.map!"a.number".array; }

	Packet parse()
	{
		switch (id)
		{
			default: {
				final switch (signature[6..7].to!size_t(2))
				{
					case 0: operator!("packetsLength() < signature[7..offset].to!size_t(2)", 22);   break;
					case 1: operator!("subpackets.length < signature[7..offset].to!size_t(2)", 18); break;
				}
				final switch (id)
				{
					case 0: number = subValues.map!"a.get".sum;                         break;
					case 1: number = subValues.map!"a.get".fold!"a*b";                  break;
					case 2: number = subValues.map!"a.get".minElement;                  break;
					case 3: number = subValues.map!"a.get".maxElement;                  break;
					case 5: number = subValues.map!"a.get".isStrictlyMonotonic!"a > b"; break;
					case 6: number = subValues.map!"a.get".isStrictlyMonotonic!"a < b"; break;
					case 7: number = subValues.map!"a.get".uniq.walkLength == 1;        break;
				}
				return this;
			}
			case 4:
				immutable offset = 6; // ver + id
				auto str = signature[offset..$].chunks(5).until!"a.front == '0'"(OpenRight.no);
				signature = signature[0..str.joiner.walkLength + offset];
				number = str.map!"a.dropOne".joiner.to!size_t(2);
				return this;
		}
	}

	void operator(alias pred, size_t offset)()
	{
		auto packetsLength = () => subpackets.map!"a.signature.length".sum;
		auto packetEnd = () => packetsLength() + offset;
		while (mixin(pred)) subpackets ~= Packet(signature[packetEnd()..$]).parse();
		signature = signature[0..packetEnd()];
	}

	string signature;
	Packet[] subpackets;
	Nullable!size_t number;
}

alias packetOf = (string packet) => packet.chunks(1).map!`a.to!ubyte(16).format!"%04b"`.join.to!Packet.parse;

void main()
{
	stdin.byLineCopy.front.packetOf.number.writeln;
}
