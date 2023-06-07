import 'package:cosmetic_frontend/models/models.dart';

enum ProductDetailStatus {initial, loading, success, failure }

class ProductDetailState {
  ProductDetailStatus productDetailStatus;
  ProductDetail? productDetail;
  List<RelateProduct>? relateProducts;
  List<CharacteristicReviewCriteria>? characteristicCriterias;

  ProductDetailState({required this.productDetailStatus, this.productDetail, this.relateProducts, this.characteristicCriterias});

  ProductDetailState.init(): productDetailStatus = ProductDetailStatus.initial, productDetail = null, relateProducts = null, characteristicCriterias = null;

  ProductDetailState copyWith({ProductDetailStatus? productDetailStatus, ProductDetail? productDetail, List<RelateProduct>? relateProducts, List<CharacteristicReviewCriteria>? characteristicCriterias}) {
    return ProductDetailState(
      productDetailStatus: productDetailStatus ?? this.productDetailStatus,
      productDetail: productDetail ?? this.productDetail,
      relateProducts: relateProducts ?? this.relateProducts,
      characteristicCriterias: characteristicCriterias ?? this.characteristicCriterias
    );
  }

}