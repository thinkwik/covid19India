import 'dart:convert';

import 'package:covid19app/charts/simpleLineChart.dart';
import 'package:covid19app/model/StateData.dart';
import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/mainData.dart';
import 'package:covid19app/model/stateDelta.dart';
import 'package:covid19app/utils/commons.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class API {
  static final String _BASE_URL = "https://api.covid19india.org";
  static final String _DATA = "data.json";
  static final String _STATE_DISTRICT = "state_district_wise.json";

  final String getData = "$_BASE_URL/$_DATA";
  final String getStateDistrictWise = "$_BASE_URL/$_STATE_DISTRICT";
}

class Network {
  API _api = API();

  Future<MainData> getAllData() async {
    Response response = await get(_api.getData);
    Map data = jsonDecode(response.body);
    dynamic statewise = data["statewise"][0];
    dynamic keyValues = data["key_values"][0];
    dynamic casesTimeSeries = data["cases_time_series"];
    String lastupdatedtime = keyValues["lastupdatedtime"];

    DateFormat inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    DateTime dateTime = inputFormat.parse(lastupdatedtime);
    DateFormat outputFormat = DateFormat("EE d, yyy hh:mm a");
    String dateInString = outputFormat.format(dateTime);

    MainData mainData = MainData(
        active: int.parse(statewise["active"]),
        confirmed: int.parse(statewise["confirmed"]),
        deceased: int.parse(statewise["deaths"]),
        recovered: int.parse(statewise["recovered"]),
        activeDelta: 0,
        confirmedDelta: int.parse(keyValues["confirmeddelta"]),
        deceasedDelta: int.parse(keyValues["deceaseddelta"]),
        recoveredDelta: int.parse(keyValues["recovereddelta"]),
        lastupdatedtime: dateInString,
        casesTimeSeries: casesTimeSeries);

    return mainData;
  }

  Future<List<StateData>> getStateDataList() async {
    Response response = await get(_api.getData);
    Map data = jsonDecode(response.body);
    List<StateData> statewise = List();

    data["statewise"].forEach((element) {
//      logv(" StateName == ${element["state"]}");
//      logv(" StateName Delta == ${element["delta"]}");

      StateDelta myDelta = StateDelta(
        active: element["delta"]["active"],
        confirmed: element["delta"]["confirmed"],
        deaths: element["delta"]["deaths"],
        recovered: element["delta"]["recovered"],
      );

      statewise.add(StateData(
          active: element["active"],
          confirmed: element["confirmed"],
          deaths: element["deaths"],
          lastupdatedtime: element["lastupdatedtime"],
          recovered: element["recovered"],
          state: element["state"],
          delta: myDelta));
    });

    return statewise;
  }

  Future<List<DistrictData>> getStateDetailedData() async {
    Response response = await get(_api.getStateDistrictWise);
    Map data = jsonDecode(response.body);

    List<DistrictData> districtDataList = List();

    data.forEach((stateName, value) {
      List<DData> dDataList = List();

      Map stateDataMap = Map.from(value["districtData"]);

      stateDataMap.forEach((districtName, value) {
        dDataList.add(DData(
            districtName: districtName,
            confirmed: value["confirmed"].toString()));
      });

      districtDataList
          .add(DistrictData(stateName: stateName, dDataList: dDataList));
    });

    return districtDataList;
  }

  Future<ChartData> getChartData(MainData mainData) async {
    DateFormat inputFormat = DateFormat("dd MMMM yyyy");
    List<TimeSeriesData> confirmed = List();
    List<TimeSeriesData> recovered = List();
    List<TimeSeriesData> death = List();

    mainData.casesTimeSeries.forEach((value) {
//      logv("value == $value");
      String date = value["date"] + "2020";
//      logv("date == $date");
      String day = DateFormat("dd").format(inputFormat.parse(date));
      String month = DateFormat("MM").format(inputFormat.parse(date));
      String year = "2020";
//      logv("date STR == $day/$month/$year");

      confirmed.add(TimeSeriesData(
          time: DateTime(int.parse(year), int.parse(month), int.parse(day)),
          count: int.parse(value["totalconfirmed"])));
      recovered.add(TimeSeriesData(
          time: DateTime(int.parse(year), int.parse(month), int.parse(day)),
          count: int.parse(value["totalrecovered"])));
      death.add(TimeSeriesData(
          time: DateTime(int.parse(year), int.parse(month), int.parse(day)),
          count: int.parse(value["totaldeceased"])));
    });

    ChartData chartData = ChartData(
        confirmedData: confirmed, deathData: death, recoveredData: recovered);

    return chartData;
  }
}
