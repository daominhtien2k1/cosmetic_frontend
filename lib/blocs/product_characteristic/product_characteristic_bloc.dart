import 'package:cosmetic_frontend/blocs/product_characteristic/product_characteristic_event.dart';
import 'package:cosmetic_frontend/blocs/product_characteristic/product_characteristic_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';

class ProductCharacteristicBloc extends Bloc<ProductCharacteristicEvent, ProductCharacteristicState> {
  late final ReviewRepository reviewRepository;

  ProductCharacteristicBloc({required this.reviewRepository}): super(ProductCharacteristicState.init()) {
    on<ProductCharacteristicStatistic>(_onProductCharacteristicStatistic);
  }

  Future<void> _onProductCharacteristicStatistic(ProductCharacteristicStatistic event, Emitter<ProductCharacteristicState> emit) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(productCharacteristicStatus: ProductCharacteristicStatus.loading));
      final productCharacteristic = await reviewRepository.statisticProductCharacteristic(productId: productId);
      emit(state.copyWith(productCharacteristicStatus: ProductCharacteristicStatus.success, productCharacteristic: productCharacteristic));
    } catch (err) {
      emit(state.copyWith(productCharacteristicStatus: ProductCharacteristicStatus.failure));
    }
  }

}