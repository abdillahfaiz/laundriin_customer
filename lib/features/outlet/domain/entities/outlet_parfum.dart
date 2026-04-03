import 'package:equatable/equatable.dart';

class OutletParfum extends Equatable {
  final String? id;
  final String? nama;
  final int? harga;

  const OutletParfum({
    this.id,
    this.nama,
    this.harga,
  });

  @override
  List<Object?> get props => [id, nama, harga];
}
