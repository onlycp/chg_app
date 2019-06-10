class RechargeModel {
  final String stationName;
  final String gunCode;
  final int soc;
  final String chargedKw;
  final String chargedTime;
  final int chargedStatus;
  final String currentVol;
  final String currentA;
  final String cost;

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
