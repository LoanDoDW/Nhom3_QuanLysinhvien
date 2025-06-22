class MajorModel {
  final int id;
  final String maNganh;
  final String tenNganh;
  final List<int> subjectIds;

  MajorModel({
    required this.id,
    required this.maNganh,
    required this.tenNganh,
    required this.subjectIds,
  });

  factory MajorModel.fromJson(Map<String, dynamic> json) {
    return MajorModel(
      id: int.parse(json['id'].toString()),
      maNganh: json['ma_nganh'],
      tenNganh: json['ten_nganh'],
      subjectIds: List<int>.from(json['subject_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ma_nganh': maNganh,
      'ten_nganh': tenNganh,
      'subject_ids': subjectIds,
    };
  }
}