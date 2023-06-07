import 'package:cosmetic_frontend/models/models.dart';

enum ProductDetailStatus {initial, loading, success, failure }

class ProductDetailState {
  ProductDetailStatus productDetailStatus;
  ProductDetail? productDetail;
  List<RelateProduct>? relateProducts;
  List<CharacteristicReviewCriteria>? characteristicReviewCriterias;

  ProductDetailState({required this.productDetailStatus, this.productDetail, this.relateProducts, this.characteristicReviewCriterias});

  ProductDetailState.init(): productDetailStatus = ProductDetailStatus.initial, productDetail = null, relateProducts = null, characteristicReviewCriterias = null;

  ProductDetailState copyWith({ProductDetailStatus? productDetailStatus, ProductDetail? productDetail, List<RelateProduct>? relateProducts, List<CharacteristicReviewCriteria>? characteristicReviewCriterias}) {
    return ProductDetailState(
      productDetailStatus: productDetailStatus ?? this.productDetailStatus,
      productDetail: productDetail ?? this.productDetail,
      relateProducts: relateProducts ?? this.relateProducts,
      characteristicReviewCriterias: characteristicReviewCriterias ?? this.characteristicReviewCriterias
    );
  }

}