import 'package:cosmetic_frontend/blocs/product/product_bloc.dart';
import 'package:cosmetic_frontend/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cosmetic_frontend/models/models.dart' hide Image;
import 'package:cosmetic_frontend/screens/home/widgets/home_widgets.dart';

import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';
import '../../blocs/product_carousel/product_carousel_bloc.dart';
import '../../blocs/product_carousel/product_carousel_event.dart';
import '../../blocs/product_carousel/product_carousel_state.dart';

import '../../configuration.dart';
import '../../utils/token.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';

import '../../routes.dart';
import '../product_detail/product_detail_screen.dart';

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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu)
              ),
              title: Text("Cosmetic"),
              actions: [
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                    icon: Icon(Icons.search)
                ),
              ],
            ),
            SliverToBoxAdapter(child: ProductCarousel()),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: BrandList()
              ),
            ),
            AllTypeProductContainer()

          ],

        )
      )
    );
  }
}

class ProductCarousel extends StatelessWidget {
  const ProductCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCarouselBloc, ProductCarouselState>(
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
    );
  }
}

class BrandList extends StatelessWidget {
  const BrandList({Key? key}) : super(key: key);

  Future<List<dynamic>?> fetchListBrands() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/brand/get_list_brands');

    var token = await Token.getToken();

    try {
      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: token,
      });
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List<dynamic>;
        return body;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Nhãn hàng", style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: FutureBuilder(
            future: fetchListBrands(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                final brandListData = snapshot.data;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: brandListData.map<Widget>((brand) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BrandDetailScreen(brandId: brand["_id"])));
                        },
                        child: Container(
                          width: 72,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network("${brand['image']}", width: 48, height: 48),
                              Text("${brand['name']}", textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                );
              } else {
                return Text("Không có kết nối mạng");
              }
            }
          )
        ),
      ],
    );
  }
}

class PopularProductList extends StatelessWidget {
  final List<Product> popularProducts;
  const PopularProductList({Key? key, required this.popularProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Nhiều người quan tâm", style: Theme.of(context).textTheme.titleMedium)
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: popularProducts.length,
          itemBuilder: (BuildContext context, int index) {
            final Product product = popularProducts[index] as Product;
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(productId: product.id),
                    settings: RouteSettings(
                      name: Routes.product_detail_screen,
                    ),
                  ),
                );
              },
              leading: Wrap(
                spacing: 6,
                children: [
                  Text('${index+1}', style: Theme.of(context).textTheme.displaySmall),
                  Image.network(product.image.url, width: 42, height: 52)
                ]
              ),
              title: Text(product.name, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis, maxLines: 2),
              subtitle: StarList(rating: product.rating),
              trailing: Column(
                children: [
                  Icon(Icons.favorite_border),
                  SizedBox(height: 4),
                  Text("${product.loves}")
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

class DiscountProductList extends StatelessWidget {
  final List<Product> discountProducts;
  DiscountProductList({Key? key, required this.discountProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Giảm giá sốc", style: Theme.of(context).textTheme.titleMedium),
            Icon(Icons.navigate_next)
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 232,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 16,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: 144,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.network(
                              "https://media.hasaki.vn/catalog/product/f/a/facebook-dynamic-nuoc-hoa-hong-khong-mui-klairs-danh-cho-da-nhay-cam-180ml-1681723574_img_380x380_64adc6_fit_center.jpg",
                              width: 144,
                              height: 100,
                              fit: BoxFit.fitWidth
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2),
                            Text("Klairs", style: Theme.of(context).textTheme.titleSmall),
                            Text('Nước cân bằng da Klairs supple preparation', style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                StarList(rating: 4.4),
                                SizedBox(width: 8),
                                Text("(3)")
                              ],
                            ),
                            SizedBox(height: 0),
                            Text("200.000 đ", style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class ExclusiveProductList extends StatelessWidget {
  List<Product>? exclusiveProducts;
  ExclusiveProductList({Key? key, required this.exclusiveProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Dành cho bạn", style: Theme.of(context).textTheme.titleMedium),
            Icon(Icons.navigate_next)
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 232,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 16,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: 144,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.network(
                              "https://media.hasaki.vn/catalog/product/f/a/facebook-dynamic-nuoc-hoa-hong-khong-mui-klairs-danh-cho-da-nhay-cam-180ml-1681723574_img_380x380_64adc6_fit_center.jpg",
                              width: 144,
                              height: 100,
                              fit: BoxFit.fitWidth
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2),
                            Text("Klairs", style: Theme.of(context).textTheme.titleSmall),
                            Text('Nước cân bằng da Klairs supple preparation', style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                StarList(rating: 4.4),
                                SizedBox(width: 8),
                                Text("(3)")
                              ],
                            ),
                            SizedBox(height: 0),
                            Text("200.000 đ", style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class UpcomingProductList extends StatelessWidget {
  List<Product>? upcomingProducts;
  UpcomingProductList({Key? key, required this.upcomingProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sắp ra mắt", style: Theme.of(context).textTheme.titleMedium),
            Icon(Icons.navigate_next)
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 232,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 16,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: 144,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.network(
                              "https://media.hasaki.vn/catalog/product/f/a/facebook-dynamic-nuoc-hoa-hong-khong-mui-klairs-danh-cho-da-nhay-cam-180ml-1681723574_img_380x380_64adc6_fit_center.jpg",
                              width: 144,
                              height: 100,
                              fit: BoxFit.fitWidth
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2),
                            Text("Klairs", style: Theme.of(context).textTheme.titleSmall),
                            Text('Nước cân bằng da Klairs supple preparation', style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                StarList(rating: 4.4),
                                SizedBox(width: 8),
                                Text("(3)")
                              ],
                            ),
                            SizedBox(height: 0),
                            Text("200.000 đ", style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class NewProductList extends StatelessWidget {
  List<Product>? newProducts;
  NewProductList({Key? key, required this.newProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Mới ra mắt", style: Theme.of(context).textTheme.titleMedium),
            Icon(Icons.navigate_next)
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 232,
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              width: 16,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.all(0),
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  width: 144,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.network(
                              "https://media.hasaki.vn/catalog/product/f/a/facebook-dynamic-nuoc-hoa-hong-khong-mui-klairs-danh-cho-da-nhay-cam-180ml-1681723574_img_380x380_64adc6_fit_center.jpg",
                              width: 144,
                              height: 100,
                              fit: BoxFit.fitWidth
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2),
                            Text("Klairs", style: Theme.of(context).textTheme.titleSmall),
                            Text('Nước cân bằng da Klairs supple preparation', style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                StarList(rating: 4.4),
                                SizedBox(width: 8),
                                Text("(3)")
                              ],
                            ),
                            SizedBox(height: 0),
                            Text("200.000 đ", style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}


class AllTypeProductContainer extends StatelessWidget {
  const AllTypeProductContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductBloc>(context).add(HomeAllTypeProductFetched());

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        switch (state.productStatus) {
          case ProductStatus.initial:
            return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
          case ProductStatus.loading:
            return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
          case ProductStatus.failure:
            return const SliverToBoxAdapter(child: Center(child: Text('Failed to fetch')));
          case ProductStatus.success: {
            final List<Product> popularProducts = state.popularProducts!;
            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: PopularProductList(popularProducts: popularProducts),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),                        child: DiscountProductList(discountProducts: []),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ExclusiveProductList(exclusiveProducts: []),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: UpcomingProductList(upcomingProducts: []),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: NewProductList(newProducts: []),
                      ),
                    ],
                  )
              ),
            );

          }
        }
      }
    );
  }
}
