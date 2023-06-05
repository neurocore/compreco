module wad;
import std.conv;
import std.file;
import std.array;
import std.string;
import std.range;
import std.algorithm;
import map;
import utils;
import linedef;
import sector;
import complevel;
import settings;

class Wad
{
  struct Header
  {
    char[4] identification;
    uint num_lumps;
    uint directory_offset;
  }

  struct Lump
  {
    uint file_offset;
    uint size;
    char[8] name;
  }

  enum Scope { Global, Map, Walls, Flats, Sprites }

  Settings settings;
  ubyte[] data;
  Lump[] lumps;
  Header head;
  Map[int] maps;

  this(Settings settings)
  {
    this.settings = settings;
  }

  private void clear()
  {
    data = [];
    lumps = [];
    head = Header.init;
  }

  private void read_data(string file)
  {
    data = cast(ubyte[]) read(file);
    head = *cast(Header*) data.ptr;
    auto dir = data[head.directory_offset .. $];

    for (size_t i = 0; i < head.num_lumps; i++)
    {
      auto offset = i * Lump.sizeof;
      lumps ~= *cast(Lump*)(dir.ptr + offset);
    }
  }

  private void parse_data(bool verbose = false)
  {
    import std.uni, std.conv, std.string;
    import std.stdio;

    uint map_n = 0;
    foreach (lump; lumps)
    {
      string name = cast(string) lump.name;
      name = name.toLower.strip("\0 ");

      if (name.startsWith("map")) // map marker
      {
        map_n = name[3..$].try_parse!uint;
        maps[map_n] = new Map;
        if (verbose) writeln("map #", map_n);
      }
      else if (name.is_map_lump) // lump that belongs to map
      {
        auto chunk = get_lumps_data(lump);

        switch(name)
        {
          case "linedefs":
            maps[map_n].lines = read_items!Linedef(chunk);
            break;

          case "sectors":
            maps[map_n].sectors = read_items!Sector(chunk);
            break;

          default: break;
        }
        if (verbose) writeln("map lump - ", name);
      }
      else // other lump
      {
        map_n = 0;
        if (verbose) writeln("other    - ", name);
      }
    }
  }

  public bool init(string file)
  {
    import std.file;
    if (!exists(file)) return false;

    clear();
    read_data(file);
    parse_data();
    return true;
  }

  override string toString()
  {
    string str;
    foreach (lump; lumps)
      str ~= lump.name ~ "\n";
    return str;
  }

  private ubyte[] get_lumps_data(Lump lump)
  {
    uint from = lump.file_offset;
    uint to = lump.file_offset + lump.size;
    return data[from .. to];
  }

  public ubyte[] get_lump(string name)
  {
    foreach (lump; lumps)
      if (lump.name == name)
        return get_lumps_data(lump);

    return [];
  }

  public Complevel complevel()
  {
    import std.conv, std.traits;
    import std.stdio;

    bool found = false;
    foreach_reverse (cl; EnumMembers!Complevel)
    {
      if (cl == Complevel.size) continue;

      int[] keys = maps.keys; // ascending
      sort!((a, b) { return a < b; })(keys);

      foreach (i; keys)
      {
        auto map = maps[i];
        auto reason = map.require(cl, settings);
        if (reason > 0)
        {
          writeln(" reason: map #", i, " - ", reason);
          if (!settings.explain) return cl;
          found = true;
        }
      }

      if (found) return cl; 
    }
    return Complevel.Doom_II;
  }
}
