import '../../models/models.dart';

enum BrandDetailStatus {initial, loading, success, failure }

class BrandDetailState{
  BrandDetailStatus brandDetailStatus;
  BrandDetail? brandDetail;

  BrandDetailState({required this.brandDetailStatus, this.brandDetail});
  BrandDetailState.initial(): brandDetailStatus = BrandDetailStatus.initial, brandDetail = null;

  BrandDetailState copyWith({BrandDetailStatus? brandDetailStatus, BrandDetail? brandDetail}) {
    return BrandDetailState(
        brandDetailStatus: brandDetailStatus ?? this.brandDetailStatus,
        brandDetail: brandDetail ?? this.brandDetail
    );
  }

  @override
  String toString() {
    return {
      'brandDetailStatus': brandDetailStatus.toString(),
      'brandDetail': brandDetail.toString()
    }.toString();
  }
}