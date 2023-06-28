import '../../models/models.dart';

enum FollowedBrandStatus { initial, loading, success, failure }

class FollowedBrandState {
  FollowedBrandStatus followedBrandStatus;
  List<FollowedBrand> followedBrands;

  FollowedBrandState({required this.followedBrandStatus, required this.followedBrands});

  FollowedBrandState.initial(): followedBrandStatus = FollowedBrandStatus.initial, followedBrands = List<FollowedBrand>.empty(growable: true);

  FollowedBrandState copyWith({
    FollowedBrandStatus? followedBrandStatus,
    List<FollowedBrand>? followedBrands,
  }) {
    return FollowedBrandState(
      followedBrandStatus: followedBrandStatus ?? this.followedBrandStatus,
      followedBrands: followedBrands ?? this.followedBrands,
    );
  }

}