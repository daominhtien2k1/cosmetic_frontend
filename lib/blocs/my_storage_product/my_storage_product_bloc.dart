import 'package:cosmetic_frontend/blocs/my_storage_product/my_storage_product_event.dart';
import 'package:cosmetic_frontend/blocs/my_storage_product/my_storage_product_state.dart';
import 'package:cosmetic_frontend/models/loved_product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';

class StorageProductBloc extends Bloc<StorageProductEvent, StorageProductState> {
  final ProductRepository productRepository;
  StorageProductBloc({required this.productRepository}): super(StorageProductState.initial()) {
    on<LovedProductFetched>(_onLovedProductFetched);
    on<ViewedProductFetched>(_onViewedProductFetched);
    on<LovedProductUnLove>(_onLovedProductUnLove);
  }

  Future<void> _onLovedProductFetched(LovedProductFetched event, Emitter<StorageProductState> emit) async {
    try {
      emit(state.copyWith(storageProductStatus: StorageProductStatus.loading));
      final lovedProducts = await productRepository.fetchLovedProducts();
      emit(state.copyWith(storageProductStatus: StorageProductStatus.success, lovedProducts: lovedProducts));
    } catch (err) {
      emit(state.copyWith(storageProductStatus: StorageProductStatus.failure));
    }
  }

  Future<void> _onViewedProductFetched(ViewedProductFetched event, Emitter<StorageProductState> emit) async {
    try {
      emit(state.copyWith(storageProductStatus: StorageProductStatus.loading));
      final viewedProducts = await productRepository.fetchViewedProducts();
      emit(state.copyWith(storageProductStatus: StorageProductStatus.success, viewedProducts: viewedProducts));
    } catch (err) {
      emit(state.copyWith(storageProductStatus: StorageProductStatus.failure));
    }
  }

  Future<void> _onLovedProductUnLove(LovedProductUnLove event, Emitter<StorageProductState> emit) async{
    try {
      final lovedProduct = event.lovedProduct;
      final lovedProducts = state.lovedProducts;
      if (lovedProducts != null) {
        lovedProducts.remove(lovedProduct);
      }
      emit(state.copyWith(lovedProducts: lovedProducts));
      await productRepository.unloveProduct(productId: lovedProduct.id);
    } catch (err) {

    }
  }
}