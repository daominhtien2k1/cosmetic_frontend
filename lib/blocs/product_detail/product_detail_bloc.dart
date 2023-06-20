import 'package:cosmetic_frontend/blocs/product_detail/product_detail_event.dart';
import 'package:cosmetic_frontend/blocs/product_detail/product_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  late final ProductRepository productRepository;
  ProductDetailBloc({required this.productRepository}): super(ProductDetailState.init()) {

    on<ProductDetailFetched>(_onProductDetailFetched);
    on<RelateProductsFetched>(_onRelateProductsFetched);
    on<ProductCharacteristicsFetched>(_onProductCharacteristicsFetched);
    on<ProductLove>(_onProductLove);
    on<ProductView>(_onProductView);
  }

  Future<void> _onProductDetailFetched(ProductDetailFetched event, Emitter<ProductDetailState> emit) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(productDetailStatus: ProductDetailStatus.loading));
      final productDetail = await productRepository.fetchDetailProduct(productId: productId);
      if (productDetail != null) {
        emit(state.copyWith(productDetailStatus: ProductDetailStatus.success, productDetail: productDetail));
      }
      print(productDetail);
    } catch(error) {
      print(error);
      emit(state.copyWith(productDetailStatus: ProductDetailStatus.failure));
    }
  }

  Future<void> _onRelateProductsFetched(RelateProductsFetched event, Emitter<ProductDetailState> emit) async {
    final productId = event.productId;
    try {
      final relateProducts = await productRepository.fetchRelateProducts(
          productId: productId);
      if (relateProducts != null) {
        emit(state.copyWith(productDetailStatus: ProductDetailStatus.success,
            relateProducts: relateProducts));
      }
    } catch(error) {
      emit(state.copyWith(productDetailStatus: ProductDetailStatus.failure));
    }
  }

  Future<void> _onProductCharacteristicsFetched(ProductCharacteristicsFetched event, Emitter<ProductDetailState> emit) async {
    final productId = event.productId;
    try {
      final characteristicCriterias = await productRepository.fetchCharacteristics(productId: productId);
      // characteristics?.retainWhere((c) => ((c!="Chất liệu") && (c!="Giá cả") && (c!="Hiệu quả") && (c!="An toàn")));
      if (characteristicCriterias != null) {
        emit(state.copyWith(productDetailStatus: ProductDetailStatus.success,
            characteristicReviewCriterias: characteristicCriterias));
      }
    } catch(error) {
      emit(state.copyWith(productDetailStatus: ProductDetailStatus.failure));
    }
  }

  Future<void> _onProductLove(ProductLove event, Emitter<ProductDetailState> emit) async {
    try {
      final productId = event.productId;
      final productDetail = state.productDetail;
      if (productDetail?.isLoved == true) {
        productRepository.unloveProduct(productId: productId);
      } else {
        productRepository.loveProduct(productId: productId);
      }
      emit(state.copyWith(productDetail: productDetail?.copyWith(isLoved: !productDetail.isLoved)));
    } catch (err) {
      print(err);
    }
  }

  _onProductView(ProductView event, Emitter<ProductDetailState> emit) {
    try {
      final productId = event.productId;
      productRepository.viewProduct(productId: productId);
    } catch (err) {
      print(err);
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    // print('#PRODUCT DETAIL OBSERVER: $error');
  }

  @override
  void onTransition(Transition<ProductDetailEvent, ProductDetailState> transition) {
    super.onTransition(transition);
    // print('#PRODUCT DETAIL OBSERVER: {stateCurrent: ${transition.event}, productDetailCurrent: ${transition.currentState.productDetail} ,relateProductsCurrent: ${transition.currentState.relateProducts} }');
    // print('#PRODUCT DETAIL OBSERVER: {stateNext: ${transition.event}, productDetailNext: ${transition.nextState.productDetail} ,relateProductsNext: ${transition.nextState.relateProducts} }');

  }

  @override
  void onEvent(ProductDetailEvent event) {
    super.onEvent(event);
    // print('#PRODUCT DETAIL OBSERVER: $event');
  }

}