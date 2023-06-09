import '../../models/models.dart';

enum StorageProductStatus {initial, loading, success, failure}

class StorageProductState {
  StorageProductStatus storageProductStatus;
  final List<LovedProduct>? lovedProducts;
  final List<ViewedProduct>? viewedProducts;


  StorageProductState({
    required this.storageProductStatus,
    required this.lovedProducts,
    required this.viewedProducts
  });

  StorageProductState.initial():
    storageProductStatus = StorageProductStatus.initial,
    lovedProducts = List<LovedProduct>.empty(growable: true),
    viewedProducts = List<ViewedProduct>.empty(growable: true);

  StorageProductState copyWith({
    StorageProductStatus? storageProductStatus,
    List<LovedProduct>? lovedProducts,
    List<ViewedProduct>? viewedProducts
  }) {
    return StorageProductState(
      storageProductStatus: storageProductStatus ?? this.storageProductStatus,
      lovedProducts: lovedProducts ?? this.lovedProducts,
      viewedProducts: viewedProducts ?? this.viewedProducts
    );
  }
}