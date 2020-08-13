class Staff {
  int id;
  String name;
  String rfid;

  Staff({
    this.id,
    this.name,
    this.rfid,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id ?? 0,
      "name": name ?? "",
      "rfid": rfid ?? "",
    };
  }

  static Staff fromMap(Map<String, dynamic> map) {
    return Staff(
      id: int.parse(map["id"].toString()) ?? 0,
      name: map["name"].toString() ?? "",
      rfid: map["rfid"].toString() ?? "",
    );
  }
}
