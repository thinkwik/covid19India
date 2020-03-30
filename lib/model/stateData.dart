import 'package:covid19app/model/stateDelta.dart';

class StateData {
  String active;
  String confirmed;
  String deaths;
  String lastupdatedtime;
  String recovered;
  String state;
  StateDelta delta;

  StateData({this.active, this.confirmed, this.deaths, this.lastupdatedtime,
      this.recovered, this.state, this.delta});


}
