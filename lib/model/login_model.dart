class LoginModel {
  LoginModel({
    required this.logindata,
    required this.Message,
  });
  late final List<Logindata> logindata;
  late final String Message;

  LoginModel.fromJson(Map<String, dynamic> json) {
    logindata = json['logindata'] != null
        ? List.from(json['logindata'])
            .map((e) => Logindata.fromJson(e))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['logindata'] = logindata.map((e) => e.toJson()).toList();
    _data['Message'] = Message;
    return _data;
  }
}

class Logindata {
  Logindata({
    required this.id,
    required this.mobile,
    required this.otp,
    required this.role,
    required this.count,
    required this.verify,
    required this.otpSentTime,
    required this.isAvalable,
    required this.dt,
  });
  late final int id;
  late final int mobile;
  late final int otp;
  late final String role;
  late final int count;
  late final String verify;
  late final String otpSentTime;
  late final String isAvalable;
  late final String dt;

  Logindata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    otp = json['otp'];
    role = json['role'];
    count = json['count'];
    verify = json['verify'];
    otpSentTime = json['otpSentTime'];
    isAvalable = json['isAvalable'];
    dt = json['dt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['mobile'] = mobile;
    _data['otp'] = otp;
    _data['role'] = role;
    _data['count'] = count;
    _data['verify'] = verify;
    _data['otpSentTime'] = otpSentTime;
    _data['isAvalable'] = isAvalable;
    _data['dt'] = dt;
    return _data;
  }
}
