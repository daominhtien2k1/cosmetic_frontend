import 'package:cosmetic_frontend/blocs/product/product_event.dart';
import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductDetailFetched extends ProductDetailEvent {
  final String productId;

  ProductDetailFetched({required this.productId});
}

class RelateProductsFetched extends ProductDetailEvent {
  final String productId;

  RelateProductsFetched({required this.productId});
}

class ProductDetailLove extends ProductDetailEvent {
  final String productId;
  ProductDetailLove({required this.productId});
}

class ProductCharacteristicsFetched extends ProductDetailEvent {
  final String productId;

  ProductCharacteristicsFetched({required this.productId});
}

class ProductLove extends ProductDetailEvent {
  final String productId;

  ProductLove({required this.productId});
}

class ProductView extends ProductDetailEvent {
  final String productId;

  ProductView({required this.productId});
}
