module sector;
import complevel;
import utils;

struct Sector
{
  short floor_height;
  short ceiling_height;
  char[8] floor_tex;
  char[8] ceiling_tex;
  short brightness;
  Specials special;
  short tag;
}

enum Specials : short
{
  Normal,
  BlinkRandom, BlinkHalf, BlinkSecond,
  Damage20Blink, Damage10, _Reserved1, Damage5,
  LightGlow,
  Secret,
  CloseDoor30Sec, Damage20Exit,
  BlinkSyncSec, BlinkSyncHalf,
  CloseDoor300Sec, _Reserved2,
  Damage20,
  LightFlickers,

  // boom features then
  BoomDamage5  = 32,
  BoomDamage10 = 64,
  BoomDamage20 = 96, // 5 & 6 bits enabled!
  BoomSecret   = 128,
  BoomFriction = 256,
  BoomPushPull = 512,

  // MBF21 features
  MBF21AlternateDamage  = 4096,
  MBF21KillGroundedMobs = 8192,
}

Reason require(Sector sector, Complevel cl)
{
  switch(cl)
  {
    case Complevel.MBF21:
      if (!!(sector.special & 0xF000))
        return Reason.SectorSpecials;
      break;

    case Complevel.Boom:
      if (!!(sector.special & 0xFFE0))
        return Reason.SectorSpecials;
      break;

    default:
      return Reason.NoReason;
  }
  return Reason.NoReason;
}

bool enabled(Specials specs)(Specials x)
{
  return (x & specs) == specs;
}
