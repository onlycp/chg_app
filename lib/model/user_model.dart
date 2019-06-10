class UserModel {
  final String mobile;
  final String photoUrl;
  final String realName;
  final String idCard;
  final int isRealAuthed;

  UserModel(
      {this.mobile,
      this.photoUrl,
      this.realName,
      this.idCard,
      this.isRealAuthed});

  UserModel.fromJson(Map<String, dynamic> json)
      : mobile = json['mobile'],
        photoUrl = json['photoUrl'],
        realName = json['realName'],
        idCard = json['idCard'],
        isRealAuthed = json['isRealAuthed'];
}
