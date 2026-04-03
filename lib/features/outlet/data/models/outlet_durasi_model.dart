import '../../domain/entities/outlet_durasi.dart';

class OutletDurasiModel extends OutletDurasi {
  const OutletDurasiModel({
    super.id,
    super.nama,
    super.estimasiJam,
    super.harga,
  });

  factory OutletDurasiModel.fromJson(Map<String, dynamic> json) {
    return OutletDurasiModel(
      id: json['id'] as String?,
      nama: json['nama'] as String?,
      estimasiJam: json['estimasi_jam'] as int?,
      harga: json['harga'] != null ? int.tryParse(json['harga'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'estimasi_jam': estimasiJam,
      'harga': harga?.toString(),
    };
  }
}
