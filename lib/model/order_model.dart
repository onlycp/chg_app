class OrderModel {
  final String orderNo;
  final String chargedTime;
  final String cost;
  final int chargedStatus;
  final String gunCode;
  final String startTime;
  final String stationName;
  final String endTime;
  final String chargedKw;

  OrderModel(
      {this.orderNo,
      this.chargedTime,
      this.cost,
      this.chargedStatus,
      this.gunCode,
      this.startTime,
      this.stationName,
      this.endTime,
      this.chargedKw});

  OrderModel.fromJson(Map<String, dynamic> json)
      : orderNo = json['orderNo'],
        chargedTime = json['chargedTime'],
        cost = json['cost'],
        chargedStatus = json['chargedStatus'],
        gunCode = json['gunCode'],
        startTime = json['startTime'],
        stationName = json['stationName'],
        endTime = json['endTime'],
        chargedKw = json['chargedKw'];
}
