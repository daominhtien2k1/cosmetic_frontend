import 'dart:convert';

import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:cosmetic_frontend/screens/home/home_screen.dart';
import 'package:cosmetic_frontend/screens/newsfeed/widgets/newsfeed_widgets.dart';
import 'package:cosmetic_frontend/screens/product_detail/widgets/product_detail_image_carousel.dart';
import 'package:cosmetic_frontend/screens/product_detail/widgets/product_detail_widgets.dart';
import 'package:cosmetic_frontend/screens/product_detail/widgets/review_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/models.dart' hide Image;

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_border_outlined)),
          IconButton(onPressed: (){}, icon: Icon(Icons.share_outlined)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  ProductImage(),
                  Positioned(
                    bottom: -24,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: BrandAndInfo(),
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
                child: AvailableInStore(),
              ),
              Divider(thickness: 8, color: Colors.black12),
              ProductDetailDescription(),
              Divider(thickness: 8, color: Colors.black12),
              // Trong backend model Product có mảng link các sản phẩm liên quan. Lúc render ra UI thì là danh sách sản phẩm liên quan của hãng + sản phẩm liên quan đến tìm kiếm search của mk + sản phẩm liên quan đến tình trạng hiện tại của mình
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: RelateProduct(),
              ),
              Divider(thickness: 8, color: Colors.black12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: RelatePostList(),
              ),
              Divider(thickness: 8, color: Colors.black12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ProductReviewList(),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FavouriteAndReviewContainer(isLoved: false),
      ),
      floatingActionButton: FancyFab(),
    );
  }
}

class FavouriteAndReviewContainer extends StatefulWidget {
  final bool isLoved;

  FavouriteAndReviewContainer({
    super.key,
    required this.isLoved
  });

  @override
  State<FavouriteAndReviewContainer> createState() => _FavouriteAndReviewContainerState();
}

class _FavouriteAndReviewContainerState extends State<FavouriteAndReviewContainer> {
  late bool isLoved;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoved = widget.isLoved;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Row(
        children: [
          isLoved ?
          IconButton.filledTonal(onPressed: (){
            setState(() {
              isLoved = false;
            });
            print(isLoved);
          }, icon: Icon(Icons.favorite_outlined))
          :
          IconButton.filledTonal(onPressed: (){
            setState(() {
              isLoved = true;
            });
            print(isLoved);

          }, icon: Icon(Icons.favorite_border)),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Đánh giá ngay", style: Theme.of(context).textTheme.titleMedium),
              StarList(rating: 0, size: 24)
            ],

          ),
        ],
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  ProductImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Carousel> carousels = [
      Carousel(url: "https://encrypted-tbn1.gstatic.com/shopping?q=tbn:ANd9GcT3OuIQxdI2ustrh-aekGmKfkTVE3ewuPQYCgLWt_kEpgP5a46eH3TEtGxX7lpNMxVyHxRtzvpQviCQP_aHuiZ25wkhLNarrdv7-kqZ7A3ffTwDnW3jdwn3eMqmDOgHWoS2Njo&usqp=CAc"),
      Carousel(url: "https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcTIwL4xUx-Ek5W8eeVkYgX7Na0DpaAZObJDxsHZQwAPe_T4TYA-UStoMWRzd7NYPUXqt1wZo0E5ONyk9Toi0uGDsf0SOTnu629-VUaOXjlVy7GJ_iATVVR5ov7MwzEkYloiC6s&usqp=CAc"),
      Carousel(url: "https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcS0lxE3eUOzeSXuy0mBYUlSirTz9Empm5TeZ5Jwta78aOMWft-qJibo3wLwKjctPgcUoFczneiyd4iVgmcuUfJioraVqrttEOdqJufKaWHNw3Pa-IAlE2vKyXWOkFY-njpUhw&usqp=CAc")
    ];

    return ProductDetailImageCarouselSlider(carouselList: carousels);
  }
}

class BrandAndInfo extends StatelessWidget {
  const BrandAndInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Container(
                width: 124,
                height: 48,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                child: Row(
                  children: [
                    Image.network("https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcS0lxE3eUOzeSXuy0mBYUlSirTz9Empm5TeZ5Jwta78aOMWft-qJibo3wLwKjctPgcUoFczneiyd4iVgmcuUfJioraVqrttEOdqJufKaWHNw3Pa-IAlE2vKyXWOkFY-njpUhw&usqp=CAc",
                        width: 32, height: 32),
                    SizedBox(width: 6),
                    Text("Kiehl"),
                    Spacer(),
                    Icon(Icons.navigate_next_outlined)
                  ],
                ),
              )
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.info_outline), iconSize: 32, color: Colors.black26)
      ]
    );
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mặt nạ dưỡng trắng da chiết xuất quả thanh yên Yuzu Nhật Bản Bio-essense (20ml)",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                StarList(rating: 4.4),
                SizedBox(width: 8),
                Text("4.42"),
                SizedBox(width: 4),
                Text("(130 đánh giá)"),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text("Đã bán 938"),
                SizedBox(width: 8),
                Text("|"),
                SizedBox(width: 8),
                Icon(Icons.favorite),
                SizedBox(width: 4),
                Text("24 yêu thích")
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text("28.000 đ", style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(width: 16),
                Text(
                  '29.500 đ',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    decoration: TextDecoration.lineThrough,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                )
              ],
            )
          ],
        ),
      ),
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
              Text("Tóc xoăn phồng mượt gấp 18 lần chất liệu gồm phủ Tourr kết hợp 4 cồng phát "
                  "ion âm giúp sản xuất ra hàng triệu ion âm giúp tóc trở nên bóng mượt, óng ả hơn gấp 18"
                  " lần. Chất liệu đặc biệt này còn hỗ trợ tỏa nhiệt đều, giúp tạo kiểu nhanh chóng",
                 maxLines: 4,
               overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              BrandInfo()
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Xem tất cả", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blueAccent)),
              Icon(Icons.navigate_next)
            ],
          ),
        )
      ],
    );
  }
}

class BrandInfo extends StatelessWidget {
  const BrandInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.network("https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcS0lxE3eUOzeSXuy0mBYUlSirTz9Empm5TeZ5Jwta78aOMWft-qJibo3wLwKjctPgcUoFczneiyd4iVgmcuUfJioraVqrttEOdqJufKaWHNw3Pa-IAlE2vKyXWOkFY-njpUhw&usqp=CAc",
              width: 72, height: 72),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Thương hiệu:"),
                  SizedBox(width: 16),
                  Text("Halio")
                ],
              ),
              Row(
                children: [
                  Text("Sản xuất tại:"),
                  SizedBox(width: 16),
                  Text("Hàn Quốc")
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mô tả:"),
                  SizedBox(width: 16),
                  SizedBox(
                      width: 232,
                      child: Text("Halio là thương hiệu chăm sóc da và nha khoa đến từ Hàn Quốc",
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
}

class ProductReviewList extends StatelessWidget {
  const ProductReviewList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Text("Người dùng đánh giá", style: Theme.of(context).textTheme.titleMedium),
                Spacer(),
                Text("Xem thêm"),
                Icon(Icons.navigate_next)
              ],
            ),
          ),
          StatisticStar(),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  const jsonString = '''
                  {
                "id": "6465eaca7372cc1938755da1",
                "rating": 2,
                "title": "Tệ",
                "content": "Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.",
                "createdAt": "2023-05-18T12:18:21.617Z",
                "updatedAt": "2023-05-18T12:18:21.617Z",
                "usefuls": 7,
                "replies": 0,
                "author": {
                    "id": "63bbff18fc13ae6493000831",
                    "name": "Saul Wibrow",
                    "avatar": "http://dummyimage.com/100x100.png/ff4444/ffffff"
                },
                "is_setted_useful": true,
                "is_blocked": false,
                "can_edit": false,
                "banned": false,
                "can_reply": false,
                "images": [
                    {
                        "url": "http://dummyimage.com/273x271.png/2016da/ffffff",
                        "publicId": ""
                    }
                ]
            }
                  ''';
                  Map<String, dynamic> data = jsonDecode(jsonString);
                  final Review review = Review.fromJson(data);
                  return ReviewContainer(review: review);
                }
            ),
          ),
        ],
      ),
    );
  }
}

class RelateProduct extends StatelessWidget {
  const RelateProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ở màn home thì chỉ dựa trên tìm kiếm và tình trạng da của mình thôi, ko có dựa trên sản phẩm gốc
    return RelateProductList(relateProducts: []);
  }
}

class RelateProductList extends StatelessWidget {
  List<Product>? relateProducts;
  RelateProductList({Key? key, required this.relateProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      '{ "id": "63ddd33e5fa9cf5634bb2820",  "described": "The rough duck calmly ran because some teacher humbly rolled below a dumb hamster which, became a vibrating, lazy hamster.",  "createdAt": "2023-02-04T03:38:38.608Z", "updatedAt": "2023-02-04T03:38:38.608Z", "likes": 0, "comments": 5, "author": {  "id": "63bbff18fc13ae649300082b", "name": "Gussi Waterhouse",  "avatar": "http://dummyimage.com/100x100.png/cc0000/ffffff" }, "is_liked": false, "status": "trống vắng", "is_blocked": false, "can_edit": false, "banned": false,  "can_comment": false }';
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
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 40, bottom: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text("4.15", style: Theme.of(context).textTheme.displaySmall),
              StarList(rating: 4.15)
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  StarList(rating: 5),
                  SizedBox(width: 24),
                  Text("87 đánh giá")
                ],
              ),
              Row(
                children: [
                  StarList(rating: 4),
                  SizedBox(width: 24),
                  Text("87 đánh giá")
                ],
              ),
              Row(
                children: [
                  StarList(rating: 3),
                  SizedBox(width: 24),
                  Text("87 đánh giá")
                ],
              ),
              Row(
                children: [
                  StarList(rating: 2),
                  SizedBox(width: 24),
                  Text("87 đánh giá")
                ],
              ),
              Row(
                children: [
                  StarList(rating: 1),
                  SizedBox(width: 24),
                  Text("87 đánh giá")
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}