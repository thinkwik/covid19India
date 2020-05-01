/// loc : "Andhra Pradesh"
/// number : "+91-866-2410978"

class HelplineNumberModel {
  String _loc;
  String _number;

  String get loc => _loc;
  String get number => _number;

  HelplineNumberModel(this._loc, this._number);

  HelplineNumberModel.map(dynamic obj) {
    this._loc = obj["loc"];
    this._number = obj["number"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["loc"] = _loc;
    map["number"] = _number;
    return map;
  }

}