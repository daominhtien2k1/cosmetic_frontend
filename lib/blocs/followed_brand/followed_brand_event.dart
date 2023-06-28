import 'package:cosmetic_frontend/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class FollowedBrandEvent {
  @override
  List<Object> get props => [];
}

class FollowedBrandFetch extends FollowedBrandEvent {

}

class BrandUnfollowed extends FollowedBrandEvent {
  final FollowedBrand followedBrand;

  BrandUnfollowed({required this.followedBrand});
}