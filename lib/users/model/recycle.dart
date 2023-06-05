class Recycle{
  int? recycle_id;
  int? user_id;
  String? ibanNo;
  DateTime? dateTime;

  Recycle({
    this.recycle_id,
    this.user_id,
    this.ibanNo,
    this.dateTime,
  });

  factory Recycle.fromJson(Map<String, dynamic> json)=> Recycle(
    recycle_id: int.parse(json["recycle_id"]),
    user_id: int.parse(json["user_id"]),
    ibanNo: json["ibanNo"],
    dateTime: DateTime.parse(json["dateTime"]),
  );

  Map<String, dynamic> toJson(String imageSelectedBase64)=>
      {
        "recycle_id": recycle_id.toString(),
        "user_id": user_id.toString(),
        "ibanNo": ibanNo,
      };
}