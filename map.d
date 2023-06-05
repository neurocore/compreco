module map;
import defs;
import linedef;
import sector;
import utils;
import complevel;
import settings;

class Map
{
  string name;
  Linedef[] lines;
  Sector[] sectors;

  // not implemented
  Thing[] things;
  Sidedef[] sides;
  Vertice[] points;
  Seg[] segs;
  SubSector[] ssectors;
  Reject reject;
  BlockMap blockmap;

  this(string name = string.init)
  {
    this.name = name;
  }

  Reason require(Complevel cl, Settings settings)
  {
    Reason full_reason = Reason.NoReason;

    foreach (line; lines)
    {
      auto reason = line.require(cl);
      if (reason > 0)
      {
        if (!settings.explain) return reason;
        full_reason |= reason;
      }
    }

    foreach (sector; sectors)
    {
      auto reason = sector.require(cl);
      if (reason > 0)
      {
        if (!settings.explain) return reason;
        full_reason |= reason;
      }
    }

    return full_reason;
  }
}
