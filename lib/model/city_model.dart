class CityModel {
  final String id;
  final String name;
  final String region;

  CityModel({this.id, this.name, this.region});

  CityModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        region = json['regionCode'];
}
