import 'package:equatable/equatable.dart';

class OutletLayanan extends Equatable {
  final String? id;
  final String? nama;
  final String? deskripsi;
  final String? tipe;

  const OutletLayanan({
    this.id,
    this.nama,
    this.deskripsi,
    this.tipe,
  });

  @override
  List<Object?> get props => [id, nama, deskripsi, tipe];
}
