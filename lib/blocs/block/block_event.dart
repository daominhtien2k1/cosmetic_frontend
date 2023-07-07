import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class BlockEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BlockedAccountFetched extends BlockEvent {}

class BlockedAccountRemove extends BlockEvent {
  final BlockedAccount blockedAccount;

  BlockedAccountRemove({required this.blockedAccount});
}