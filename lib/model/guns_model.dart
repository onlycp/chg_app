class GunsModel {
  final String code;
  final int gunType;
  final String stationGunNo;
  final String stationName;
  final String operateTypeName;
  final int status;

  GunsModel(
      {this.stationName,
      this.operateTypeName,
      this.code,
      this.gunType,
      this.stationGunNo,
      this.status});

  GunsModel.fromJson(Map<String, dynamic> json)
      : stationName = json['stationName'],
        operateTypeName = json['operateTypeName'],
        code = json['code'],
        gunType = json['gunType'],
        stationGunNo = json['stationGunNo'],
        status = json['status'];
}
