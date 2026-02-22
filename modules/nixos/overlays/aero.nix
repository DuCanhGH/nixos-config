{
  waylandEnabled ? false,
}:
final: prev: {
  aero = prev.callPackage ../aero {
    inherit waylandEnabled;
  };
}
