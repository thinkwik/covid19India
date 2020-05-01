import 'dart:convert';

import 'package:covid19app/charts/simpleLineChart.dart';
import 'package:covid19app/model/HelplineNumberModel.dart';
import 'package:covid19app/model/StateData.dart';
import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/mainData.dart';
import 'package:covid19app/model/newsModel.dart';
import 'package:covid19app/model/stateDelta.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class API {
  static final String _BASE_URL = "https://covid19.thinkwik.com/api/v1/public";
  static final String _DATA = "data.json";
  static final String _STATE_DISTRICT = "state_district_wise.json";
  static final String _NEWS = "news";
  static final String _CONTACTS = "contact";

  final String getData = "$_BASE_URL/$_DATA";
  final String getStateDistrictWise = "$_BASE_URL/$_STATE_DISTRICT";
  final String getHelplineAPi = "$_BASE_URL/$_CONTACTS";
  final String getNewsApi = "$_BASE_URL/$_NEWS";
  final String getAboutUs = "https://raw.githubusercontent.com/thinkwik/covid19India/master/README.md";
}

class Network {
  API _api = API();

  Future<MainData> getAllData() async {
    Response response = await get(_api.getData);
    Map OrigData = jsonDecode(response.body);
    dynamic data = OrigData["data"];
    dynamic statewiseAll = data["statewise"];
    dynamic statewise = data["statewise"][0];
    dynamic casesTimeSeries = data["cases_time_series"];
    String lastupdatedtime = statewise["lastupdatedtime"];

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
        confirmedDelta: int.parse(statewise["deltaconfirmed"]),
        deceasedDelta: int.parse(statewise["deltadeaths"]),
        recoveredDelta: int.parse(statewise["deltarecovered"]),
        lastupdatedtime: dateInString,
        casesTimeSeries: casesTimeSeries,
        statewiseAll: statewiseAll);

    return mainData;
  }

  Future<List<StateData>> getStateDataList(dynamic statewiseAll) async {
    List<StateData> statewise = List();

    statewiseAll.forEach((element) {

      StateDelta myDelta = StateDelta(
        active: 0,
        confirmed: int.parse(element["deltaconfirmed"]),
        deaths: int.parse(element["deltadeaths"]),
        recovered: int.parse(element["deltarecovered"]),
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
    Map OrigData = jsonDecode(response.body);
    dynamic data = OrigData["data"];

    List<DistrictData> districtDataList = List();

    data.forEach((stateName, value) {
      List<DData> dDataList = List();

      Map stateDataMap = Map.from(value["districtData"]);

      stateDataMap.forEach((districtName, value) {
        dDataList.add(DData(
            districtName: districtName,
            confirmed: value["confirmed"].toString(),
            delta: value["delta"]["confirmed"].toString()));
      });

      districtDataList
          .add(DistrictData(stateName: stateName, dDataList: dDataList));
    });

    return districtDataList;
  }

  Future<ChartDataModel> getChartData(MainData mainData) async {
    DateFormat inputFormat = DateFormat("dd MMMM yyyy");
    List<TimeSeriesData> confirmed = List();
    List<TimeSeriesData> recovered = List();
    List<TimeSeriesData> death = List();

    mainData.casesTimeSeries.forEach((value) {
      String date = value["date"] + "2020";
      String day = DateFormat("dd").format(inputFormat.parse(date));
      String month = DateFormat("MM").format(inputFormat.parse(date));
      String year = "2020";

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

    ChartDataModel chartData = ChartDataModel(
        confirmedData: confirmed, deathData: death, recoveredData: recovered);

    return chartData;
  }

  Future<List<NewsModel>> getNews() async {
    Response response = await get(_api.getNewsApi);
    Map data = jsonDecode(response.body);

    List<NewsModel> newList = List();
    List<dynamic> list = data["data"]["news"];
    list.forEach((element) {newList.add(NewsModel.map(element));});

    return newList;
  }

  Future<List<HelplineNumberModel>> getHelplineNumber() async {

    Response response = await get(_api.getHelplineAPi);
    Map data = jsonDecode(response.body);

    List<HelplineNumberModel> list = List();

    List<dynamic> list1 = data["data"]["contacts"]["regional"];
    list1.forEach((element) {list.add(HelplineNumberModel.map(element));});

    return list;
  }

  Future<String> getAboutUsContent() async {
    Response response = await get(_api.getAboutUs);
    return response.body.toString();
  }


}
