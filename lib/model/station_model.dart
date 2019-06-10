class StationModel {
//  final String cityName;
//  final String keyword;
//  final double lat;
//  final double lng;
//  final int page;
//  final int pageSize;
//
//  StationModel(
//      {this.cityName,
//      this.keyword,
//      this.lat,
//      this.lng,
//      this.page,
//      this.pageSize});
//
//  StationModel.fromJson(Map<String, dynamic> json)
//      : cityName = json['cityName'],
//        keyword = json['keyword'],
//        lat = json['lat'],
//        lng = json['lng'],
//        page = json['page'],
//        pageSize = json['pageSize'];

  final String id;
  final String name;
  final String lng;
  final String lat;
  final double distance;
  final String address;
  final String images;
  final String operTime;
  final int operateType;
  final String operateTypeName;
  final int fastPoleCount;
  final int fastPoleIdleCount;
  final int slowPoleCount;
  final int slowPoleIdleCount;

  StationModel(
      this.id,
      this.name,
      this.lng,
      this.lat,
      this.distance,
      this.address,
      this.images,
      this.operTime,
      this.operateType,
      this.operateTypeName,
      this.fastPoleCount,
      this.fastPoleIdleCount,
      this.slowPoleCount,
      this.slowPoleIdleCount);

  StationModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        lat = json['lat'],
        lng = json['lng'],
        distance = json['distance'],
        address = json['address'],
        images = json['images'],
        operTime = json['operTime'],
        operateType = json['operateType'],
        operateTypeName = json['operateTypeName'],
        fastPoleCount = json['fastPoleCount'],
        fastPoleIdleCount = json['fastPoleIdleCount'],
        slowPoleCount = json['slowPoleCount'],
        slowPoleIdleCount = json['slowPoleIdleCount'];
}
