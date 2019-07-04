class RechargeModel {
  String stationName;
  String gunCode;
  double soc;
  String chargedKw;
  String chargedTime;
  int chargedStatus;
  String currentVol;
  String currentA;
  String cost;

  RechargeModel(
      {this.stationName,
      this.gunCode,
      this.soc,
      this.chargedKw,
      this.chargedTime,
      this.chargedStatus,
      this.currentVol,
      this.currentA,
      this.cost});

  RechargeModel.fromJson(Map<String, dynamic> json)
      : stationName = json['stationName'],
        gunCode = json['gunCode'],
        chargedKw = json['chargedKw'],
        chargedTime = json['chargedTime'],
        currentVol = json['currentVol'],
        currentA = json['currentA'],
        cost = json['cost'],
        soc = json['soc'],
        chargedStatus = json['chargedStatus'];
}
