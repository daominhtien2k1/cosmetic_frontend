import 'dart:convert';

import 'package:cosmetic_frontend/blocs/personal_info/personal_info_bloc.dart';
import 'package:cosmetic_frontend/blocs/personal_info/personal_info_event.dart';
import 'package:cosmetic_frontend/blocs/product_bookmark/product_bookmark_bloc.dart';
import 'package:cosmetic_frontend/blocs/product_bookmark/product_bookmark_event.dart';
import 'package:cosmetic_frontend/blocs/product_bookmark/product_bookmark_state.dart';
import 'package:cosmetic_frontend/blocs/product_detail/product_detail_bloc.dart';
import 'package:cosmetic_frontend/blocs/product_detail/product_detail_event.dart';
import 'package:cosmetic_frontend/blocs/product_detail/product_detail_state.dart';
import 'package:cosmetic_frontend/blocs/retrieve_review/retrieve_review_bloc.dart';
import 'package:cosmetic_frontend/blocs/retrieve_review/retrieve_review_event.dart';
import 'package:cosmetic_frontend/blocs/retrieve_review/retrieve_review_state.dart';
import 'package:cosmetic_frontend/blocs/review/review_bloc.dart';
import 'package:cosmetic_frontend/blocs/review/review_event.dart';
import 'package:cosmetic_frontend/blocs/review/review_state.dart';
import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:cosmetic_frontend/constants/assets/placeholder.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:cosmetic_frontend/screens/home/home_screen.dart';
import 'package:cosmetic_frontend/screens/newsfeed/widgets/newsfeed_widgets.dart';
import 'package:cosmetic_frontend/screens/product_detail/widgets/product_detail_image_carousel.dart';
import 'package:cosmetic_frontend/screens/product_detail/widgets/product_detail_widgets.dart';
import 'package:cosmetic_frontend/screens/product_detail/widgets/review_container.dart';
import 'package:cosmetic_frontend/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/models.dart' hide Image;

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductDetailBloc>(context).add(ProductDetailFetched(productId: productId));
    BlocProvider.of<ReviewBloc>(context).add(ReviewsFetched(productId: productId));
    BlocProvider.of<ReviewBloc>(context).add(InstructionReviewsFetched(productId: productId));
    BlocProvider.of<ReviewBloc>(context).add(StatisticStarReviewFetched(productId: productId));
    BlocProvider.of<ProductDetailBloc>(context).add(RelateProductsFetched(productId: productId));
    BlocProvider.of<ProductDetailBloc>(context).add(ProductCharacteristicsFetched(productId: productId));
    BlocProvider.of<RetrieveReviewBloc>(context).add(ReviewRetrieved(productId: productId));
    BlocProvider.of<ProductDetailBloc>(context).add(ProductView(productId: productId));
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          BookmarkProductIconButton(),
          IconButton(onPressed: (){
            // /data/user/0/vn.edu.hust.soict.cosmetic_frontend/app_flutter
            // getApplicationDocumentsDirectory().then((val) {
            //   print(val.path);
            // });
            final bookmarkedProducts = BlocProvider.of<ProductBookmarkBloc>(context).state.bookmarkedProducts;
            print(bookmarkedProducts?.length);
            print(HydratedBloc.storage.read("ProductBookmarkBloc"));
            print(HydratedBloc.storage.read("value")); // null vì tự có key bên ngoài "ProductBookmarkBloc"
            // HydratedBloc.storage.clear(); // khi khởi tạo state là  {value: {productBookmarkStatus: initial, bookmarkedProducts: []} (cho nên trong file hive vẫn đống chữ), sau khi xóa còn null
          }, icon: Icon(Icons.share_outlined)),
        ],
      ),
      body: SafeArea(
        child: ProductDetailContent(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FavouriteAndReviewContainer(),
      ),
      floatingActionButton: FancyFab(productId: productId),
    );
  }
}

// convert to stateful nhưng không có thuộc tính state nào để cập nhật UI button -> đánh đổi là bị rebuild 5-12 lần
class BookmarkProductIconButton extends StatefulWidget {

  @override
  State<BookmarkProductIconButton> createState() => _BookmarkProductIconButtonState();
}

class _BookmarkProductIconButtonState extends State<BookmarkProductIconButton> {
  @override
  Widget build(BuildContext context) {
    print("Rebuild");
    // để ở vị trí này + listen: true thì bị rebuild 4,5 lần. Nhưng khi listen: false thì lại lấy state sản phẩm cũ -> phải ra rồi vào fetch lại lần nữa
    final product = BlocProvider.of<ProductDetailBloc>(context, listen: true).state.productDetail;

    return BlocBuilder<ProductBookmarkBloc, ProductBookmarkState>(
      builder: (context, state) {
        final bookmarkedProducts = state.bookmarkedProducts;
        final isBookmarked = bookmarkedProducts != null ? (bookmarkedProducts.indexWhere((element) => element.id == product?.id) != -1) : false;
        return IconButton(
          isSelected: isBookmarked,
          onPressed: (){
            if (isBookmarked == false) {
              // thêm mới
              final bookmarkedProduct = BookmarkedProduct(
                  id: product!.id,
                  slug: product!.name,
                  name: product!.name,
                  image: ProductImage(url: product!.images[0].url),
                  reviews: product!.reviews,
                  rating: product!.rating,
                  loves: product!.loves,
                  isBookmarked: true);
              BlocProvider.of<ProductBookmarkBloc>(context).add(ProductBookmarked(bookmarkedProduct: bookmarkedProduct));
              // không rebuild lại list khi extends Equatable (hình như vậy)
              // thử tìm hiểu xem BLOC vs final property vs Equatable
              setState(() {
                // setState chỉ nhằm mục đích rerender lại widget gây ra do lỗi trên
                // không biến isBookmarked thành state bởi vì nếu làm thế thì nó sẽ sử dụng lại state cũ của sản phẩm trước
              });
            } else {
              // un bookmark, xóa đi bằng id
              BlocProvider.of<ProductBookmarkBloc>(context).add(ProductUnbookmarked(productId: product!.id));
              setState(() {

              });
            }
          },
          icon: Icon(Icons.bookmark_border_outlined),
          selectedIcon: Icon(Icons.bookmark),
        );
      }
    );
  }
}

class ProductDetailContent extends StatelessWidget {
  const ProductDetailContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        switch (state.productDetailStatus) {
          case ProductDetailStatus.initial:
            return Center(child: CircularProgressIndicator());
          case ProductDetailStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ProductDetailStatus.failure:
            return Center(child: Text("Failed"));
          case ProductDetailStatus.success: {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      ProductImageContainer(),
                      Positioned(
                        bottom: -24,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: BrandAndInfoChip(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ProductInfo(),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CharacteristicContainer(),
                  ),
                  Divider(thickness: 8, color: Colors.black12),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //   child: AvailableInStore(),
                  // ),
                  // Divider(thickness: 8, color: Colors.black12),
                  ProductDetailDescription(),
                  Divider(thickness: 8, color: Colors.black12),
                  // Trong backend model Product có mảng link các sản phẩm liên quan. Lúc render ra UI thì là danh sách sản phẩm liên quan của hãng + sản phẩm liên quan đến tìm kiếm search của mk + sản phẩm liên quan đến tình trạng hiện tại của mình
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: RelateProductList(),
                  ),
                  Divider(thickness: 8, color: Colors.black12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: RelatePostList(),
                  ),
                  Divider(thickness: 8, color: Colors.black12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InstructionReviewList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ProductReviewList(),
                  )
                ],
              ),
            );
          }
        }
      },

    );
  }
}

class FavouriteAndReviewContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final isLoved = state.productDetail?.isLoved ?? false;
          return Container(
            child: Row(
              children: [
                isLoved ?
                IconButton.filledTonal(onPressed: (){
                  BlocProvider.of<ProductDetailBloc>(context).add(ProductLove(productId: state.productDetail!.id));
                }, icon: Icon(Icons.favorite_outlined, color: Colors.pink))
                :
                IconButton.filledTonal(onPressed: (){
                  BlocProvider.of<ProductDetailBloc>(context).add(ProductLove(productId: state.productDetail!.id));

                  final snackBar = SnackBar(
                    content: Text('Bạn được cộng 1 point'),
                    backgroundColor: Colors.pink,
                    // behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Tắt',
                      disabledTextColor: Colors.white,
                      textColor: Colors.yellow,
                      onPressed: () {

                      },
                    ),
                    onVisible: (){
                      BlocProvider.of<PersonalInfoBloc>(context).add(PointIncrease(point: 1));
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                }, icon: Icon(Icons.favorite_border)),
                SizedBox(width: 20),
                BlocBuilder<RetrieveReviewBloc, RetrieveReviewState>(
                    builder: (context, state) {
                      switch (state.retrieveReviewStatus) {
                        case RetrieveReviewStatus.initial: {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Đánh giá ngay", style: Theme.of(context).textTheme.titleMedium),
                              StarList(rating: 0, size: 24)
                            ],
                          );
                        }
                        case RetrieveReviewStatus.loading: {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Đánh giá ngay", style: Theme.of(context).textTheme.titleMedium),
                              StarList(rating: 0, size: 24)
                            ],
                          );
                        }
                        case RetrieveReviewStatus.failure: {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Đánh giá ngay", style: Theme.of(context).textTheme.titleMedium),
                              StarList(rating: 0, size: 24)
                            ],
                          );
                        }
                        case RetrieveReviewStatus.success: {
                          final retrieveReview = state.retrieveReview;
                          final rating = retrieveReview!.rating!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Đánh giá ngay", style: Theme.of(context).textTheme.titleMedium),
                              StarList(rating: rating.toDouble(), size: 24)
                            ],
                          );
                        }
                      }

                  }
                ),
              ],
            ),
          );
      }
    );
  }
}

class ProductImageContainer extends StatelessWidget {
  ProductImageContainer({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // Dù Rebuild liên tục nhưng mà ảnh vẫn là của sản phẩm trước, phải vào lại lần thứ 2 mới load đúng
    print("Rebuild");
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final images = state.productDetail?.images;
          final carousels = images?.map((e) => Carousel(url: e.url)).toList();
          return carousels != null ? ProductDetailImageCarouselSlider(carouselList: carousels) : Placeholder(fallbackHeight: 150);
        }
    );

  }
}

class BrandAndInfoChip extends StatelessWidget {
  const BrandAndInfoChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final product = state.productDetail;
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BrandDetailScreen(brandId: product!.brand.id)));
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          width: 160,
                          height: 48,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black12),
                              borderRadius: BorderRadius.all(Radius.circular(16))
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                product?.brand.image.url ?? ImagePlaceHolder.imagePlaceHolderOnline,
                                width: 32, height: 32),
                              SizedBox(width: 6),
                              Container(
                                width: 80,
                                child: Text(product?.brand.name ?? "Brand", overflow: TextOverflow.ellipsis)
                              ),
                              Spacer(),
                              Icon(Icons.navigate_next_outlined)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(onPressed: () {},
                    icon: Icon(Icons.info_outline),
                    iconSize: 32,
                    color: Colors.black26)
              ]
          );
        }
    );
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        final product = state.productDetail;
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product?.name ?? "",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  StarList(rating: product?.rating ?? 0),
                  SizedBox(width: 8),
                  Text("${product?.rating.toStringAsFixed(2)}"),
                  SizedBox(width: 4),
                  Text("(${product?.reviews} đánh giá)"),
                  SizedBox(width: 8),
                  Text("|"),
                  SizedBox(width: 8),
                  Icon(Icons.favorite, color: Colors.pinkAccent),
                  SizedBox(width: 4),
                  Text("${product?.loves} yêu thích")
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text("${NumberFormat('#,##0').format(product?.lowPrice ?? 0)} đ", style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(width: 16),
                  Text("~", style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(width: 16),
                  Text("${NumberFormat('#,##0').format(product?.highPrice ?? 0)} đ", style: Theme.of(context).textTheme.headlineSmall),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}

class CharacteristicContainer extends StatelessWidget {
  const CharacteristicContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final characteristicCriterias = state.characteristicReviewCriterias as List<CharacteristicReviewCriteria>?;
          final characteristics = characteristicCriterias?.map((cr) => cr.criteria.toString()).toList();
          final productId = state.productDetail?.id;
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.product_characteristic_screen, arguments: productId);
                  },
                  child: Row(
                    children: [
                      Text("Đặc trưng của sản phẩm", style: Theme.of(context).textTheme.titleMedium),
                      Spacer(),
                      Icon(Icons.navigate_next)
                    ],
                  ),
                ),
                SizedBox(height: 8),
                characteristics?.length != 0 ? Container(
                  height: 48,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...?characteristics?.map((c) =>
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Chip(label: Text(c))
                            )
                        ).toList()
                      ],
                    ),
                  ),
                )
                : SizedBox()
              ],
            ),
          );
      }
    );
  }
}

class AvailableInStore extends StatelessWidget {
  const AvailableInStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Icon(Icons.storefront),
          SizedBox(width: 8),
          Text("Có sẵn tại cửa hàng"),
          Spacer(),
          Icon(Icons.navigate_next)
        ],
      ),
    );
  }
}

class ProductDetailDescription extends StatelessWidget {
  const ProductDetailDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final product = state.productDetail;
        return Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Thông tin sản phẩm", style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 16),
                  Text(product?.description ?? "",
                     maxLines: 4,
                   overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  BrandInfoContainer()
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2), // Đặt màu nền là màu trắng
                boxShadow: [
                  BoxShadow(
                    color: Colors.white, // Đặt màu shadow
                    offset: Offset(0, -4), // Đặt hướng shadow (0,-4) để đổ ngược lên trên
                    blurRadius: 16, // Đặt bán kính blur cho shadow
                    spreadRadius: 8, // Đặt bán kính mở rộng của shadow
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    enableDrag: true,
                    isDismissible: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Material(
                          elevation: 20,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20)
                          ),
                          color: Colors.white,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 46,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Center(
                                          child: Text("Thông tin sản phẩm", style: Theme.of(context).textTheme.titleMedium)
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icon(Icons.close)
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Html(
                                        data: product?.description
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                      );
                    }
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Xem tất cả", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.pinkAccent)),
                    Icon(Icons.navigate_next)
                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }
}

class BrandInfoContainer extends StatelessWidget {
  const BrandInfoContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final product = state.productDetail;
        return Container(
          child: Row(
            children: [
              Image.network(product?.brand.image.url ?? ImagePlaceHolder.imagePlaceHolderOnline,
                  width: 72, height: 72),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Thương hiệu:"),
                      SizedBox(width: 16),
                      Text(product?.brand.name ?? "")
                    ],
                  ),
                  Row(
                    children: [
                      Text("Sản xuất tại:"),
                      SizedBox(width: 16),
                      Text(product?.brand.origin ?? "")
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mô tả:"),
                      SizedBox(width: 16),
                      SizedBox(
                          width: 232,
                          child: Text(product?.brand.description ?? "",
                              overflow: TextOverflow.clip, maxLines: 2)
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }
}

class ProductReviewList extends StatelessWidget {
  const ProductReviewList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        switch (state.reviewStatus) {
          case ReviewStatus.initial:
            return Center(child: CircularProgressIndicator());
          case ReviewStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ReviewStatus.failure:
            return Center(child: Text("Failed"));
          case ReviewStatus.success: {
            final reviews = state.reviews;
              return Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text("Người dùng đánh giá", style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                        Spacer(),
                        Text("Xem thêm"),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                  ),
                  StatisticStar(),
                  if(reviews!= null) ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reviews?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Review review = reviews![index];
                        return ReviewContainer(review: review);
                      }
                  ),
                ],
              );
            }
        }
      }
    );
  }
}

class RelateProductList extends StatelessWidget {
  RelateProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final List<RelateProduct>? relateProducts = state.relateProducts;
          if (relateProducts != null && relateProducts.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Có thể bạn sẽ thích", style: Theme.of(context).textTheme.titleMedium),
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
                    itemCount: relateProducts?.length ?? 0,
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
                                      relateProducts?[index].image.url ?? ImagePlaceHolder.imagePlaceHolderOnline,
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
                                    Text("${relateProducts?[index].brandName}", style: Theme.of(context).textTheme.titleSmall),
                                    Text('${relateProducts?[index].name}', style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        StarList(rating: relateProducts?[index].rating ?? 0),
                                        SizedBox(width: 8),
                                        Text("${relateProducts?[index].reviews}")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.favorite_outlined, color: Colors.pinkAccent.shade200),
                                        SizedBox(width: 4),
                                        Text("${relateProducts?[index].loves} yêu thích"),
                                      ],
                                    ),
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
          } else {
            return SizedBox();
          }

      }
    );
  }
}

class RelatePostList extends StatelessWidget {
  const RelatePostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Text("675 Bài viết liên quan", style: Theme.of(context).textTheme.titleMedium),
                Spacer(),
                Text("Xem thêm"),
                Icon(Icons.navigate_next)
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  const jsonString =
                      '{ "id": "63ddd33e5fa9cf5634bb2820",  "described": "The rough duck calmly ran because some teacher humbly rolled below a dumb hamster which, became a vibrating, lazy hamster.",  "createdAt": "2023-02-04T03:38:38.608Z", "updatedAt": "2023-02-04T03:38:38.608Z", "likes": 0, "comments": 5, "author": {  "id": "63bbff18fc13ae649300082b", "name": "Gussi Waterhouse",  "avatar": "http://dummyimage.com/100x100.png/cc0000/ffffff" }, "is_liked": false, "status": "trống vắng", "is_blocked": false, "can_edit": false, "banned": false,  "can_comment": false, "classification": "General" }';
                  Map<String, dynamic> data = jsonDecode(jsonString);
                  final Post post = Post.fromJson(data);
                  return PostContainer(post: post);
                }
            ),
          ),
        ],
      ),
    );
  }
}

class StatisticStar extends StatelessWidget {
  const StatisticStar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        switch (state.reviewStatus) {
          case ReviewStatus.initial:
            return Center(child: CircularProgressIndicator());
          case ReviewStatus.loading:
            return Center(child: CircularProgressIndicator());
          case ReviewStatus.failure:
            return Center(child: Text("Failed"));
          case ReviewStatus.success: {
            final statisticStar = state.statisticStar;
            return Container(
              padding: const EdgeInsets.only(
                  left: 24, right: 40, bottom: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("${statisticStar?.rating}", style: Theme
                          .of(context)
                          .textTheme
                          .displaySmall),
                      StarList(rating: statisticStar?.rating ?? 0)
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          StarList(rating: 5),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the5StarRatings} đánh giá")
                        ],
                      ),
                      Row(
                        children: [
                          StarList(rating: 4),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the4StarRatings} đánh giá")
                        ],
                      ),
                      Row(
                        children: [
                          StarList(rating: 3),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the3StarRatings} đánh giá")
                        ],
                      ),
                      Row(
                        children: [
                          StarList(rating: 2),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the2StarRatings} đánh giá")
                        ],
                      ),
                      Row(
                        children: [
                          StarList(rating: 1),
                          SizedBox(width: 24),
                          Text("${statisticStar?.the1StarRatings} đánh giá")
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
        }

      }
    );
  }
}

class InstructionReviewList extends StatelessWidget {
  const InstructionReviewList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40,
        maxHeight: 440, // Set the maximum height here
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Row(
              children: [
                Text("Hướng dẫn và chia sẻ cảm nhận", style: Theme.of(context).textTheme.titleMedium),
                Spacer(),
                Text("Xem thêm"),
                Icon(Icons.navigate_next)
              ],
            ),
          ),
          BlocBuilder<ReviewBloc, ReviewState>(builder: (context, state) {
            switch (state.reviewStatus) {
              case ReviewStatus.initial:
                return Center(child: CircularProgressIndicator());
              case ReviewStatus.loading:
                return Center(child: CircularProgressIndicator());
              case ReviewStatus.failure:
                return Center(child: Text("Failed"));
              case ReviewStatus.success: {
                  final instructionReviews = state.instructionReviews!;
                  return instructionReviews.isNotEmpty ? Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: instructionReviews!.length,
                        itemBuilder: (context, index) {
                          final instructionReview = instructionReviews![index];
                          return ReviewContainer(review: instructionReview);
                        }
                    ),
                  ) : SizedBox();
                }
            }
          })
        ],
      ),
    );
  }
}