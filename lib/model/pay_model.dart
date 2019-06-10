class PayModel {
  final String payInfo;
  final int type;

  PayModel({this.payInfo, this.type});

  PayModel.fromJson(Map<String, dynamic> json)
      : payInfo = json['payInfo'],
        type = json['type'];
}
