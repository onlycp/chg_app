class TradeModel {
  final String title;
  final String tradeTime;
  final String cost;
  final int tradeType;

  TradeModel({this.title, this.tradeTime, this.cost, this.tradeType});

  TradeModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        tradeTime = json['tradeTime'],
        cost = json['cost'],
        tradeType = json['tradeType'];
}
