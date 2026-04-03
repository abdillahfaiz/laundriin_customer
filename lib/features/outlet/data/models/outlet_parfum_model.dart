import '../../domain/entities/outlet_parfum.dart';

class OutletParfumModel extends OutletParfum {
  const OutletParfumModel({
    super.id,
    super.nama,
    super.harga,
  });

  factory OutletParfumModel.fromJson(Map<String, dynamic> json) {
    return OutletParfumModel(
      id: json['id'] as String?,
      nama: json['nama'] as String?,
      harga: json['harga'] != null ? int.tryParse(json['harga'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'harga': harga?.toString()};
  }
}
