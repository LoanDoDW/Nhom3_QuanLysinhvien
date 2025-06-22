class SubjectModel {
  final int id;
  final String maMon;
  final String tenMon;
  final int soTinChi;

  SubjectModel({
    required this.id,
    required this.maMon,
    required this.tenMon,
    required this.soTinChi,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      maMon: json['ma_mon'],
      tenMon: json['ten_mon'],
      soTinChi: int.tryParse(json['so_tin_chi'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ma_mon': maMon,
      'ten_mon': tenMon,
      'so_tin_chi': soTinChi,
    };
  }
}
