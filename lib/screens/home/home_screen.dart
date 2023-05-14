import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cosmetic_frontend/models/models.dart';
import 'package:cosmetic_frontend/screens/home/widgets/home_widgets.dart';

import '../../blocs/product_carousel/product_carousel_bloc.dart';
import '../../blocs/product_carousel/product_carousel_event.dart';
import '../../blocs/product_carousel/product_carousel_state.dart';

import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductCarouselBloc>(context).add(ProductCarouselFetch());
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProductCarouselBloc, ProductCarouselState>(
          builder: (context, state) {
            switch (state.productCarouselStatus) {
              case ProductCarouselStatus.initial:
                return CarouselLoading();
              case ProductCarouselStatus.loading:
                return CarouselLoading();
              case ProductCarouselStatus.failure:
                return Text('Failed to fetch product carousels');
              case ProductCarouselStatus.success: {
                final List<Carousel> carousels = state.carousels ?? <Carousel>[];
                return ProductCarouselSlider(carouselList: carousels);
              }

            }
          }
        )
      )
    );
  }
}
