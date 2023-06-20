import 'package:cosmetic_frontend/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class StorageProductEvent {
  @override
  List<Object> get props => [];
}

class LovedProductFetched extends StorageProductEvent {

}

class ViewedProductFetched extends StorageProductEvent {

}

class BookmarkedProductFetched extends StorageProductEvent {

}

class LovedProductUnLove extends StorageProductEvent {
  final LovedProduct lovedProduct;

  LovedProductUnLove({required this.lovedProduct});
}
