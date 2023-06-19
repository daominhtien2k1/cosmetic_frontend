import 'package:equatable/equatable.dart';

abstract class BrandDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BrandDetailFetched extends BrandDetailEvent {
  final String brandId;

  BrandDetailFetched({required this.brandId});
}