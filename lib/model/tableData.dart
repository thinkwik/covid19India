import 'package:covid19app/model/stateDelta.dart';

class TableData {
  String stateName;
  String confirmed;
  String active;
  String recovered;
  String deceases;
  StateDelta stateDelta =
      StateDelta(active: 0, recovered: 0, confirmed: 0, deaths: 0);

  TableData(
      {this.stateName,
      this.confirmed,
      this.active,
      this.recovered,
      this.deceases,
      this.stateDelta});
}
