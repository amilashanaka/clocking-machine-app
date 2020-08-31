import 'package:ClockIN/data/staff/staff_in_out.dart';

class Staff {
  int id;
  String name;
  String rfid;
  String pinCode;
  StaffInOut staffInOut;

  Staff({
    this.id,
    this.name,
    this.rfid,
    this.pinCode,
    this.staffInOut,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id ?? 0,
      "name": name ?? "",
      "rfid": rfid ?? "",
      "pinCode": pinCode ?? ""
    };
  }

  static Staff fromMap(Map<String, dynamic> map) {
    return Staff(
      id: int.parse(map["id"].toString()) ?? 0,
      name: map["name"].toString() ?? "",
      rfid: map["rfid"].toString() ?? "",
      pinCode: map["pinCode"].toString() ?? "",
      staffInOut: map["lastInOut"] != null
          ? StaffInOut.fromMap(map["lastInOut"]) ?? null
          : null,
    );
  }
}
