import 'package:cosmetic_frontend/blocs/followed_brand/followed_brand_event.dart';
import 'package:cosmetic_frontend/blocs/followed_brand/followed_brand_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';

class FollowedBrandBloc extends Bloc<FollowedBrandEvent, FollowedBrandState> {
  late final BrandRepository brandRepository;

  FollowedBrandBloc(): super(FollowedBrandState.initial()) {
    brandRepository = BrandRepository();

    on<FollowedBrandFetch>(_onFollowedBrandFetch);
    on<BrandUnfollowed>(_onBrandUnfollowed);
  }

  Future<void> _onFollowedBrandFetch(FollowedBrandFetch event, Emitter<FollowedBrandState> emit) async {
    try {
      emit(state.copyWith(followedBrandStatus: FollowedBrandStatus.loading));
      final followedBrands = await brandRepository.fetchFollowedBrand();
      emit(state.copyWith(followedBrandStatus: FollowedBrandStatus.success, followedBrands: followedBrands));
    } catch (err) {
      emit(state.copyWith(followedBrandStatus: FollowedBrandStatus.failure));
    }
  }

  Future<void> _onBrandUnfollowed(BrandUnfollowed event, Emitter<FollowedBrandState> emit) async {
    final followedBrand = event.followedBrand;
    final followedBrands = state.followedBrands;
    if (followedBrands != null) {
      followedBrands.remove(followedBrand);
    }
    emit(state.copyWith(followedBrands: followedBrands));
    await brandRepository.unfollowBrand(brandId: followedBrand.id);
  }
}