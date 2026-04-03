import 'package:equatable/equatable.dart';

class OutletJenisPerItem extends Equatable {
  final String? id;
  final String? nama;
  final String? deskripsi;

  const OutletJenisPerItem({
    this.id,
    this.nama,
    this.deskripsi,
  });

  @override
  List<Object?> get props => [id, nama, deskripsi];
}
