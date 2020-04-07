class MainData {
  int confirmed = 0;
  int active = 0;
  int recovered = 0;
  int deceased = 0;

  int confirmedDelta = 0;
  int activeDelta = 0;
  int recoveredDelta = 0;
  int deceasedDelta = 0;

  String lastupdatedtime = "";
  dynamic casesTimeSeries;
  dynamic statewiseAll;

  MainData(
      {this.confirmed,
      this.active,
      this.recovered,
      this.deceased,
      this.confirmedDelta,
      this.activeDelta,
      this.recoveredDelta,
      this.deceasedDelta,
      this.lastupdatedtime,
      this.casesTimeSeries,
      this.statewiseAll});
}
