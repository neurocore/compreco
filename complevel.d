module complevel;

enum Complevel
{
  Doom_II = 2,
  Ultimate = 3,
  FinalDoom = 4,
  Boom = 9,
  MBF = 11,
  MBF21 = 21,
  size,
}

immutable Complevel[] complevels =
[
  Complevel.Doom_II,
  Complevel.Ultimate,
  Complevel.FinalDoom,
  Complevel.Boom,
  Complevel.MBF,
  Complevel.MBF21
];
