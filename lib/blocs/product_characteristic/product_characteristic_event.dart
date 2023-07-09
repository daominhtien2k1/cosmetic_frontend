import 'package:equatable/equatable.dart';

abstract class ProductCharacteristicEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductCharacteristicStatistic extends ProductCharacteristicEvent {
  final String productId;

  ProductCharacteristicStatistic({required this.productId});
}