import 'package:equatable/equatable.dart';

class OutletCoverage extends Equatable {
  final bool? isCovered;
  final double? distance;
  final double? maxRadius;

  const OutletCoverage({
    this.isCovered,
    this.distance,
    this.maxRadius,
  });

  @override
  List<Object?> get props => [isCovered, distance, maxRadius];
}
