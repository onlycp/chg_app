class VersionModel {
  final String version;
  final String intVersion;
  final String url;
  final String note;

  VersionModel({this.version, this.intVersion, this.url, this.note});

  VersionModel.fromJson(Map<String, dynamic> json)
      : version = json['version'],
        intVersion = json['intVersion'],
        url = json['url'],
        note = json['note'];
}
