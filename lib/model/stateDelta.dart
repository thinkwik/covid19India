class StateDelta {
  int active = 0;
  int confirmed = 0;
  int deaths = 0;
  int recovered = 0;

  StateDelta({this.active, this.confirmed, this.deaths, this.recovered});
}
