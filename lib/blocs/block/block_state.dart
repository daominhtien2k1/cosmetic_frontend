import '../../models/models.dart';

enum BlockStatus {initial, loading, success, failure}
class BlockState {
  final BlockStatus status;
  final List<BlockedAccount> blockedAccounts;

  BlockState({required this.status, required this.blockedAccounts});

  BlockState.initial(): status = BlockStatus.initial, blockedAccounts = List<BlockedAccount>.empty(growable: true);

  BlockState copyWith({BlockStatus? status, List<BlockedAccount>? blockedAccounts}) {
    return BlockState(
        status: status ?? this.status,
        blockedAccounts: blockedAccounts ?? this.blockedAccounts
    );
  }
}