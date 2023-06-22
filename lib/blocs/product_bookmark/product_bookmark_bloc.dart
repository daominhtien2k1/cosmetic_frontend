import 'package:cosmetic_frontend/blocs/product_bookmark/product_bookmark_event.dart';
import 'package:cosmetic_frontend/blocs/product_bookmark/product_bookmark_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ProductBookmarkBloc extends HydratedBloc<ProductBookmarkEvent, ProductBookmarkState> {
  ProductBookmarkBloc(): super(ProductBookmarkState.initial()) {
    on<BookmarkedProductFetched>(_onBookmarkedProductFetched);
    on<ProductBookmarked>(_onProductBookmarked);
    on<ProductUnbookmarked>(_onProductUnbookmarked);
  }

  _onBookmarkedProductFetched(BookmarkedProductFetched event, Emitter<ProductBookmarkState> emit) {

  }


  _onProductBookmarked(ProductBookmarked event, Emitter<ProductBookmarkState> emit) {
    final bookmarkedProduct = event.bookmarkedProduct;
    final bookmarkedProducts = state.bookmarkedProducts;
    final existedBookmarkedProduct = bookmarkedProducts?.indexWhere((element) => element.id == bookmarkedProduct.id);
    if (existedBookmarkedProduct == -1) {
      bookmarkedProducts?.add(bookmarkedProduct);
      print("Add to ${bookmarkedProducts?.length}");
      emit(state.copyWith(bookmarkedProducts: bookmarkedProducts));
    } else {
      print("Không thêm cái mới");
    }
  }

  _onProductUnbookmarked(ProductUnbookmarked event, Emitter<ProductBookmarkState> emit) {
    final productId = event.productId;
    final bookmarkedProducts = state.bookmarkedProducts;
    print("Remove from ${bookmarkedProducts?.length}");

    // bookmarkedProducts?.removeWhere((element) => element.id == productId);
    // emit(state.copyWith(bookmarkedProducts: bookmarkedProducts));

    /*
        final List<int>? arr = null;
        final brr = [...?arr]; // []
     */

    final existedBookmarkedProduct = bookmarkedProducts?.indexWhere((element) => element.id == productId);
    if (existedBookmarkedProduct != -1) {
      bookmarkedProducts?.removeWhere((element) => element.id == productId);
      final newBookmarkedProducts = [...?bookmarkedProducts];

      emit(ProductBookmarkState(
          productBookmarkStatus: ProductBookmarkStatus.success,
          bookmarkedProducts: bookmarkedProducts
      ));
    }

  }



  @override
  ProductBookmarkState? fromJson(Map<String, dynamic> json) {
    return ProductBookmarkState.fromJson(json["value"]);
  }

  @override
  Map<String, dynamic>? toJson(ProductBookmarkState state) {
    /*
      // Cẩn thận:
      final arr = {"x": 3}; // Map<String, int> arr
      final brr = { {"x": 3} }; // Set<Map<String, int>> arr
      final Map<String, dynamic> crr = { "value" : {"x": 3} };
      return state.toJson(); // giống với {"status": "init", "x": [1,2,3]} // cũng đúng nhưng state to cục nhất không có key
    */
    // không cần thiết thêm key, bản thân tên bloc là tên key rồi
    return {"value": state.toJson()};
  }

  @override
  void onChange(Change<ProductBookmarkState> change) {
    print('#BOOKMARK OBSERVER: ${change.currentState.bookmarkedProducts?.length}');
    super.onChange(change);
  }

  @override
  void onEvent(ProductBookmarkEvent event) {
    print('#BOOKMARK OBSERVER: ${event}');
    super.onEvent(event);
  }

}