class DistrictData {
  String stateName;
  List<DData> dDataList;

  DistrictData({this.stateName, this.dDataList});
}

class DData {
  String districtName;
  String confirmed;

  DData({this.districtName, this.confirmed});
}
