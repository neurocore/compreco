module utils;

T try_parse(T)(string s, T def = T.init)
{
  import std.conv, std.typecons;

  T n;
  try { n = parse!uint(s); }
  catch(ConvException ex) { n = def; }

  return n;
}

enum MapLump
{
  Things, Linedefs, Sidedefs, Vertexes, Segs,
  SSectors, Nodes, Sectors, Reject, Blockmap
}

bool is_map_lump(string name)
{
  import std.uni, std.conv, std.traits;

  string str = name.toLower;
  foreach (map_lump; EnumMembers!MapLump)
    if (str == map_lump.to!string.toLower)
      return true;
  return false;
}

T[] read_items(T)(ubyte[] data)
{
  T[] arr;
  for (size_t i = 0; i < data.length / T.sizeof; i++)
    arr ~= *cast(T*)(data.ptr + i * T.sizeof);
  return arr;
}

enum Reason : uint
{
  NoReason,
  LinedefFlags   = 1 << 0,
  LinedefAction  = 1 << 1,
  SectorSpecials = 1 << 2,
}
