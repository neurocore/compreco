module linedef;
import complevel;
import utils;

struct Linedef
{
  short start_vertex;
  short end_vertex;
  LineFlags flags;
  short action;
  short tag;
  short front_sidedef;
  short back_sidedef;
}

enum LineFlags : short
{
  BlockAll      = 0x0001, // Vanilla
  BlockMonsters = 0x0002,
  TwoSided      = 0x0004,
  UpperUnpegged = 0x0008,
  LowerUnpegged = 0x0010,
  SecretOnMap   = 0x0020,
  BlockSound    = 0x0040,
  NeverShow     = 0x0080,
  AlwaysShow    = 0x0100,

  PassThru      = 0x0200, // Boom

  MBF21BlockLandMobs = 0x1000, // MBF21
  MBF21BlockPlayers  = 0x2000,
}

Reason require(Linedef line, Complevel cl)
{
  switch(cl)
  {
    case Complevel.MBF21:
      if (!!(line.flags & 0xFE00)) return Reason.LinedefFlags;

      if (line.action >= 1024
      &&  line.action <= 1026) return Reason.LinedefAction;
      break;

    case Complevel.Boom:
      if (!!(line.flags & 0xFE00)) return Reason.LinedefFlags;
      break;

    default:
      return Reason.NoReason;
  }
  return Reason.NoReason;
}

bool enabled(LineFlags flags)(LineFlags x)
{
  return (x & flags) == flags;
}

