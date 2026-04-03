import 'package:equatable/equatable.dart';

class OutletDurasi extends Equatable {
  final String? id;
  final String? nama;
  final int? estimasiJam;
  final int? harga;

  const OutletDurasi({
    this.id,
    this.nama,
    this.estimasiJam,
    this.harga,
  });

  @override
  List<Object?> get props => [id, nama, estimasiJam, harga];
}
