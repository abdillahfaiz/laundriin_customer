import '../../domain/entities/outlet_coverage.dart';

class OutletCoverageModel extends OutletCoverage {
  const OutletCoverageModel({
    super.isCovered,
    super.distance,
    super.maxRadius,
  });

  factory OutletCoverageModel.fromJson(Map<String, dynamic> json) {
    return OutletCoverageModel(
      isCovered: json['is_covered'] as bool?,
      distance: json['distance'] != null
          ? double.tryParse(json['distance'].toString())
          : null,
      maxRadius: json['max_radius'] != null
          ? double.tryParse(json['max_radius'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_covered': isCovered,
      'distance': distance,
      'max_radius': maxRadius,
    };
  }
}
