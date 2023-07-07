import 'package:cosmetic_frontend/blocs/block/block_event.dart';
import 'package:cosmetic_frontend/blocs/block/block_state.dart';
import 'package:cosmetic_frontend/models/models.dart';
import 'package:cosmetic_frontend/repositories/block_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockBloc extends Bloc<BlockEvent, BlockState> {
  late final BlockRepository blockRepository;

  BlockBloc(): super(BlockState.initial()) {
    blockRepository = BlockRepository();
    on<BlockedAccountFetched>(_onBlockedAccountFetched);
    on<BlockedAccountRemove>(_onBlockedAccountRemove);
  }

  Future<void> _onBlockedAccountFetched(BlockedAccountFetched event, Emitter<BlockState> emit) async {
    try {
      emit(state.copyWith(status: BlockStatus.loading));
      final blockedAccounts = await blockRepository.fetchBlockedAccounts();
      if (blockedAccounts != null) {
        emit(state.copyWith(status: BlockStatus.success, blockedAccounts: blockedAccounts));
      }
    } catch (e) {
      emit(state.copyWith());
    }
  }

  Future<void> _onBlockedAccountRemove(BlockedAccountRemove event, Emitter<BlockState> emit) async {
    try {
      final BlockedAccount blockedAccount = event.blockedAccount;
      final isDeleted = await blockRepository.removeBlockedAccount(personId: blockedAccount.account);
      if(isDeleted) {
        final blockedAccounts = state.blockedAccounts;
        int index = blockedAccounts.indexOf(blockedAccount);
        blockedAccounts.removeAt(index);
        emit(state.copyWith(blockedAccounts: blockedAccounts));
      }
    } catch (_) {
      emit(state.copyWith());
    }
  }
}