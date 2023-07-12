import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import './image_edit_state_model.dart';

// Event
abstract class EditImageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EditImageChange extends EditImageEvent {
  ImageEditStateModel imageEditStateModel;

  EditImageChange({required this.imageEditStateModel});
}

class EditImageUndo extends EditImageEvent {}

class EditImageRedo extends EditImageEvent {}

// State
class ImageEditState {
  List<ImageEditStateModel> listImageEditState;
  List<ImageEditStateModel> listRedoImageEditState;

  ImageEditState({required this.listImageEditState, required this.listRedoImageEditState});

  ImageEditState.initial(): listImageEditState = List<ImageEditStateModel>.empty(growable: true), listRedoImageEditState = List<ImageEditStateModel>.empty(growable: true);

  ImageEditState copyWith({List<ImageEditStateModel>? listImageEditState, List<ImageEditStateModel>? listRedoImageEditState}) {
    return ImageEditState(
        listImageEditState: listImageEditState ?? this.listImageEditState,
        listRedoImageEditState: listRedoImageEditState ?? this.listRedoImageEditState
    );
  }

}

// Bloc
class EditImageBloc extends Bloc<EditImageEvent, ImageEditState> {

  /// {@macro replay_counter_bloc}
  EditImageBloc() : super(ImageEditState.initial()) {
    on<EditImageChange>(_onEditImageChange);
    on<EditImageUndo>(_onEditImageUndo);
    on<EditImageRedo>(_onEditImageRedo);
  }

  _onEditImageChange(EditImageChange event, Emitter<ImageEditState> emit) {
    final imageEditStateModel = event.imageEditStateModel;
    final listImageEditState = state.listImageEditState;
    final listRedoImageEditState = state.listRedoImageEditState;

    listImageEditState.add(imageEditStateModel);
    // Clear redo list when a new edit action is made
    listRedoImageEditState.clear();

    emit(state.copyWith(listImageEditState: listImageEditState, listRedoImageEditState: listRedoImageEditState));
  }

  _onEditImageUndo(EditImageUndo event, Emitter<ImageEditState> emit) {
    final listImageEditState = state.listImageEditState;
    final listRedoImageEditState = state.listRedoImageEditState;

    if (listImageEditState.isEmpty) {
      return;
    }

    final undoneImageState = listImageEditState.last;
    final updatedImageEditState = listImageEditState.removeLast();

    listRedoImageEditState.add(undoneImageState);

    emit(state.copyWith(
      listImageEditState: listImageEditState,
      listRedoImageEditState: listRedoImageEditState,
    ));
  }

  void _onEditImageRedo(EditImageRedo event, Emitter<ImageEditState> emit) {
    final listImageEditState = state.listImageEditState;
    final listRedoImageEditState = state.listRedoImageEditState;

    if (listRedoImageEditState.isEmpty) {
      return;
    }

    final redoneImageState = listRedoImageEditState.removeLast();

    listImageEditState.add(redoneImageState);

    emit(state.copyWith(
      listImageEditState: listImageEditState,
      listRedoImageEditState: listRedoImageEditState,
    ));
  }

  bool canUndo() {
    return state.listImageEditState.isNotEmpty;
  }

  bool canRedo() {
    return state.listRedoImageEditState.isNotEmpty;
  }

}