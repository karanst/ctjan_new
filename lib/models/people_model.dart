/// response_code : "1"
/// message : "Get Group Data"
/// status : "success"
/// data : [{"f_name":"RajBairagi ","profile_pic":"1680786170image_picker1167548528729956270.png","l_name":"","about_us":""},{"f_name":"Ankit bairagi bairagi bairagi bairagi ","profile_pic":"1680846815scaled_8b7d9dc7-d74f-4d7a-9613-4e769290659e3269784665455632141.jpg","l_name":"bairagi ","about_us":""},{"f_name":"","profile_pic":"1680848102image_picker5091129868175507326.png","l_name":"bairagi ","about_us":""},{"f_name":"","profile_pic":"","l_name":"pandit","about_us":""},{"f_name":"","profile_pic":"1680849807scaled_a5fdb899-ee53-492f-854e-1b0b8f3bc25d8307066435848207888.jpg","l_name":"Bairagii","about_us":""},{"f_name":"Karan","profile_pic":"1680851576scaled_1c1cac88-00b8-4a94-9350-1c8303410ba07407790350758738345.jpg","l_name":"sir","about_us":"I'm good player "}]

class PeopleModel {
  PeopleModel({
      String? responseCode, 
      String? message, 
      String? status, 
      List<Data>? data,}){
    _responseCode = responseCode;
    _message = message;
    _status = status;
    _data = data;
}

  PeopleModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _message = json['message'];
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _responseCode;
  String? _message;
  String? _status;
  List<Data>? _data;
PeopleModel copyWith({  String? responseCode,
  String? message,
  String? status,
  List<Data>? data,
}) => PeopleModel(  responseCode: responseCode ?? _responseCode,
  message: message ?? _message,
  status: status ?? _status,
  data: data ?? _data,
);
  String? get responseCode => _responseCode;
  String? get message => _message;
  String? get status => _status;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['message'] = _message;
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// f_name : "RajBairagi "
/// profile_pic : "1680786170image_picker1167548528729956270.png"
/// l_name : ""
/// about_us : ""

class Data {
  Data({
      String? fName, 
      String? profilePic, 
      String? lName, 
      String? aboutUs,}){
    _fName = fName;
    _profilePic = profilePic;
    _lName = lName;
    _aboutUs = aboutUs;
}

  Data.fromJson(dynamic json) {
    _fName = json['f_name'];
    _profilePic = json['profile_pic'];
    _lName = json['l_name'];
    _aboutUs = json['about_us'];
  }
  String? _fName;
  String? _profilePic;
  String? _lName;
  String? _aboutUs;
Data copyWith({  String? fName,
  String? profilePic,
  String? lName,
  String? aboutUs,
}) => Data(  fName: fName ?? _fName,
  profilePic: profilePic ?? _profilePic,
  lName: lName ?? _lName,
  aboutUs: aboutUs ?? _aboutUs,
);
  String? get fName => _fName;
  String? get profilePic => _profilePic;
  String? get lName => _lName;
  String? get aboutUs => _aboutUs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['f_name'] = _fName;
    map['profile_pic'] = _profilePic;
    map['l_name'] = _lName;
    map['about_us'] = _aboutUs;
    return map;
  }

}