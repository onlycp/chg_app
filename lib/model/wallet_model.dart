class WalletModel {
  final String freeCost;
  final String freezeCost;

  WalletModel({this.freeCost, this.freezeCost});

  WalletModel.fromJson(Map<String, dynamic> json)
      : freeCost = json['freeCost'],
        freezeCost = json['freezeCost'];
}
