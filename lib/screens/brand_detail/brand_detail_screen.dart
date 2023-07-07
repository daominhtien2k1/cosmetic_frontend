import 'package:cosmetic_frontend/blocs/brand_detail/brand_detail_bloc.dart';
import 'package:cosmetic_frontend/blocs/brand_detail/brand_detail_event.dart';
import 'package:cosmetic_frontend/blocs/brand_detail/brand_detail_state.dart';
import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandDetailScreen extends StatelessWidget {
  final String brandId;

  BrandDetailScreen({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<BrandDetailBloc>(context).add(BrandDetailFetched(brandId: brandId));
    return Scaffold(
      body: BlocBuilder<BrandDetailBloc, BrandDetailState>(
        builder: (context, state) {
          switch (state.brandDetailStatus) {
            case BrandDetailStatus.initial:
              return Center(child: CircularProgressIndicator());
            case BrandDetailStatus.loading:
              return Center(child: CircularProgressIndicator());
            case BrandDetailStatus.failure:
              return Center(child: Text("Failed"));
            case BrandDetailStatus.success: {
              final brandDetail = state.brandDetail;
              final productList = brandDetail!.productList;
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Text("${brandDetail?.name}"),
                      pinned: true,
                      floating: true,
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 34,
                              backgroundColor: Colors.pink,
                              child: CircleAvatar(
                                radius: 32,
                                // child: Image.network(brandDetail!.image.url), // vẫn là ảnh vuông không khớp với vòng tròn
                                backgroundImage: NetworkImage(brandDetail!.image.url)
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(brandDetail!.name, style: Theme.of(context).textTheme.titleMedium),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: Colors.pink),
                                    Text("${brandDetail?.rating}"),
                                    SizedBox(width: 4),
                                    Text("|"),
                                    SizedBox(width: 4),
                                    Icon(Icons.spatial_tracking, color: Colors.pink),
                                    Text("${brandDetail?.followers}")
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            brandDetail?.isFollowed == true ?
                            OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<BrandDetailBloc>(context).add(BrandFollow(brandId: brandId));
                                },
                                child: Text("Đang theo dõi")
                            )
                                : FilledButton.tonal(
                                onPressed: (){
                                  BlocProvider.of<BrandDetailBloc>(context).add(BrandFollow(brandId: brandId));
                                },
                                child: Text("Theo dõi")
                            )
                          ],
                        )
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverHeaderDelegate(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${brandDetail.products} Sản phẩm"),
                              Wrap(
                                children: [
                                  Text("Bộ lọc"),
                                  SizedBox(width: 8),
                                  Icon(Icons.settings_input_composite_outlined)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList.separated(
                      itemCount: productList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Wrap(
                              spacing: 6,
                              children: [
                                Text('${index+1}', style: Theme.of(context).textTheme.displaySmall),
                                CircleAvatar(
                                    radius: 32.0,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: NetworkImage(productList[index].image.url)
                                ),
                              ],
                            ),
                            title: Text(productList[index].name,
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            subtitle: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                StarList(rating: productList[index].rating),
                                SizedBox(width: 8),
                                Text("${productList[index].rating}", style: Theme.of(context).textTheme.labelLarge),
                                Text("(${productList[index].reviews})")
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider()
                    )
                  ],
                );
            }
          }
        }
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 56.0,
      child: Card(
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        // color: Colors.black12, // dùng thì bị hiệu ứng đè
        color: Colors.white, // dùng thì màu không phải trắng, ảo quá, không dùng color thì là màu hồng
        elevation: 1,
        child: child
      ),
    );
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant _SliverHeaderDelegate oldDelegate) {
    return false;
  }
}