import 'dart:convert';

import 'package:covid19app/charts/simpleLineChart.dart';
import 'package:covid19app/model/StateData.dart';
import 'package:covid19app/model/districtData.dart';
import 'package:covid19app/model/mainData.dart';
import 'package:covid19app/model/newsModel.dart';
import 'package:covid19app/model/stateDelta.dart';
import 'package:covid19app/utils/commons.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

class API {
  static final String _BASE_URL = "https://api.covid19india.org";
  static final String _DATA = "data.json";
  static final String _STATE_DISTRICT = "state_district_wise.json";

  final String getData = "$_BASE_URL/$_DATA";
  final String getStateDistrictWise = "$_BASE_URL/$_STATE_DISTRICT";
  final String getGNewsApi =
      "https://news.google.com/rss/search?q=covid19&hl=en-IN&gl=IN&ceid=IN:en";
  final String getNewsApi =
      "https://toibnews.timesofindia.indiatimes.com/cricket/node/";
}

class Network {
  API _api = API();

  Future<MainData> getAllData() async {
    Response response = await get(_api.getData);
    Map data = jsonDecode(response.body);
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
//    Map data = jsonDecode(response.body);
    List<StateData> statewise = List();

    statewiseAll.forEach((element) {
//      logv(" StateName == $element");

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
    Map data = jsonDecode(response.body);

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

    ChartDataModel chartData = ChartDataModel(
        confirmedData: confirmed, deathData: death, recoveredData: recovered);

    return chartData;
  }

  Future<List<NewsModel>> getNews() async {
    Response response1 = await get(_api.getNewsApi + "75074630-1.json");
    Response response2 = await get(_api.getNewsApi + "75074630-2.json");
    Response response3 = await get(_api.getNewsApi + "75074630-3.json");
    Map data1 = jsonDecode(response1.body);
    Map data2 = jsonDecode(response2.body);
    Map data3 = jsonDecode(response3.body);

    List<NewsModel> newList = List();

    List<dynamic> list1 = data1["data"]["contents"];
    List<dynamic> list2 = data2["data"]["contents"];
    List<dynamic> list3 = data3["data"]["contents"];
    list1.forEach((element) {newList.add(NewsModel.map(element));});
    list2.forEach((element) {newList.add(NewsModel.map(element));});
    list3.forEach((element) {newList.add(NewsModel.map(element));});

    return newList;
  }
}
