

class NewsModel {
  String _type;
  String _msid;
  String _subtype;
  String _title;
  String _overridelink;
  String _smalldesc;
  dynamic _emcontent;
  String _imgsize;
  int _timestamp;

  String get type => _type;
  String get msid => _msid;
  String get subtype => _subtype;
  String get title => _title;
  String get overridelink => _overridelink;
  String get smalldesc => _smalldesc;
  dynamic get emcontent => _emcontent;
  String get imgsize => _imgsize;
  int get timestamp => _timestamp;

  NewsModel(this._type, this._msid, this._subtype, this._title, this._overridelink, this._smalldesc, this._emcontent, this._imgsize, this._timestamp);

  NewsModel.map(dynamic obj) {
    this._type = obj["type"];
    this._msid = obj["msid"];
    this._subtype = obj["subtype"];
    this._title = obj["title"];
    this._overridelink = obj["overridelink"];
    this._smalldesc = obj["smalldesc"];
    this._emcontent = obj["emcontent"];
    this._imgsize = obj["imgsize"];
    this._timestamp = obj["timestamp"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["type"] = _type;
    map["msid"] = _msid;
    map["subtype"] = _subtype;
    map["title"] = _title;
    map["overridelink"] = _overridelink;
    map["smalldesc"] = _smalldesc;
    map["emcontent"] = _emcontent;
    map["imgsize"] = _imgsize;
    map["timestamp"] = _timestamp;
    return map;
  }

}