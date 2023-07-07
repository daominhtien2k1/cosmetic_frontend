import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cosmetic_frontend/blocs/brand_detail/brand_detail_event.dart';
import 'package:cosmetic_frontend/blocs/brand_detail/brand_detail_state.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

class BrandDetailBloc extends Bloc<BrandDetailEvent, BrandDetailState>{
  late final BrandRepository brandRepository;
  BrandDetailBloc(): super(BrandDetailState.initial()) {
    brandRepository = BrandRepository();

    on<BrandDetailFetched>(_onBrandDetailFetched);
    on<BrandFollow>(_onBrandFollow);
  }

  Future<void> _onBrandDetailFetched(BrandDetailFetched event, Emitter<BrandDetailState> emit) async {
    try {
      final brandId = event.brandId;
      emit(state.copyWith(brandDetailStatus: BrandDetailStatus.loading));
      final brandDetail = await brandRepository.fetchDetailBrand(brandId: brandId);
      if (brandDetail != null) {
        emit(state.copyWith(brandDetailStatus: BrandDetailStatus.success, brandDetail: brandDetail));
      }
    } catch (err) {
      emit(state.copyWith(brandDetailStatus: BrandDetailStatus.failure));
    }
  }

  Future<void> _onBrandFollow(BrandFollow event, Emitter<BrandDetailState> emit) async {
    try {
      final brandId = event.brandId;
      final brandDetail = state.brandDetail;
      if (brandDetail?.isFollowed == true) {
        brandRepository.unfollowBrand(brandId: brandId);
      } else {
        brandRepository.followBrand(brandId: brandId);
      }
      emit(state.copyWith(brandDetail: brandDetail?.copyWith(isFollowed: !brandDetail.isFollowed)));
    } catch (err) {
      print(err);
    }
  }

}