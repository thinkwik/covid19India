import 'dart:convert';

import 'package:covid19app/model/StateData.dart';
import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/mainData.dart';
import 'package:covid19app/model/stateDelta.dart';
import 'package:covid19app/model/tableData.dart';
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
        lastupdatedtime: dateInString);

//    DateTime now = DateTime.now();
//    DateTime dateTimeCreatedAt = DateTime.parse(lastupdatedtime);
//    String formattedDate = new DateFormat('dd/MM/yyyy HH:mm:ss').format(now);
//
//    logv("mainkeyValuesData == $lastupdatedtime");
//    logv("formattedDate == $formattedDate");
//    logv("dateTimeCreatedAt == $dateTimeCreatedAt");

    return mainData;
  }

  Future<List<StateData>> getStateDataList() async {
    Response response = await get(_api.getData);
    Map data = jsonDecode(response.body);
    List<StateData> statewise = List();

    data["statewise"].forEach((element) {
      logv(" StateName == ${element["state"]}");
      logv(" StateName Delta == ${element["delta"]}");

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
//      logv("stateNames == $stateName");

      List<DData> dDataList = List();

      Map stateDataMap = Map.from(value["districtData"]);

      stateDataMap.forEach((districtName, value) {
//        logv(
//            "districtName == $districtName || confirmed == ${value["confirmed"]}");
        dDataList.add(
            DData(districtName: districtName, confirmed: value["confirmed"].toString()));
      });

      districtDataList.add(DistrictData(
          stateName: stateName,
          dDataList: dDataList
      ));
    });

    return districtDataList;
  }
}
