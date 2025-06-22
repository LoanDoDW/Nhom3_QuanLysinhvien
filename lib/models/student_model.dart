class Student {
  final int id;
  final String maSv;
  final String hoTen;
  final String gioiTinh;
  final String ngaySinh;
  final int nganhId;
  final String tenNganh;

  Student({
    required this.id,
    required this.maSv,
    required this.hoTen,
    required this.gioiTinh,
    required this.ngaySinh,
    required this.nganhId,
    this.tenNganh = '',
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: int.tryParse(json['id'].toString()) ?? 0,
      maSv: json['ma_sv'],
      hoTen: json['ho_ten'], // 👉 sửa đúng tên field theo DB
      gioiTinh: json['gioi_tinh'],
      ngaySinh: json['ngay_sinh'],
      nganhId: int.tryParse(json['nganh_id'].toString()) ?? 0,
      tenNganh: json['ten_nganh'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ma_sv': maSv,
      'ho_ten': hoTen,
      'gioi_tinh': gioiTinh,
      'ngay_sinh': ngaySinh,
      'nganh_id': nganhId,
    };
  }
}
