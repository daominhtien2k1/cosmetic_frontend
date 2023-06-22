import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_frontend/blocs/product_bookmark/product_bookmark_bloc.dart';
import 'package:cosmetic_frontend/blocs/product_bookmark/product_bookmark_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/widgets/star_list.dart';


class ProductBookmarkScreen extends StatelessWidget {
  ProductBookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Sản phẩm đánh dấu'),
      ),
      body: SafeArea(
        child: BlocBuilder<ProductBookmarkBloc, ProductBookmarkState>(
            builder: (context, state) {
              switch (state.productBookmarkStatus) {
                case ProductBookmarkStatus.initial:
                  return Center(child: Text("Không tìm thấy sản phẩm"));
                case ProductBookmarkStatus.loading:
                  return Center(child: CircularProgressIndicator());
                case ProductBookmarkStatus.failure:
                  return Center(child: Text("Failed"));
                case ProductBookmarkStatus.success: {
                  final bookmarkedProducts = state.bookmarkedProducts;
                  return bookmarkedProducts != null && bookmarkedProducts.isNotEmpty
                      ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: bookmarkedProducts.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 32.0,
                                backgroundColor: Colors.black12,
                                child: CircleAvatar(
                                    radius: 32.0,
                                    backgroundColor: Colors.grey[200],
                                    // backgroundImage: NetworkImage(bookmarkedProducts[index].image.url)
                                    child: CachedNetworkImage(imageUrl: bookmarkedProducts[index].image.url),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                              onPressed: () {
                              },
                              isSelected: bookmarkedProducts[index].isBookmarked,
                              selectedIcon: Icon(Icons.bookmark, color: Colors.pink),
                              icon: Icon(Icons.bookmark_add_outlined)
                          ),
                          title: Text(bookmarkedProducts[index].name,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          subtitle: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              StarList(rating: bookmarkedProducts[index].rating),
                              SizedBox(width: 8),
                              Text("${bookmarkedProducts[index].rating}", style: Theme.of(context).textTheme.labelLarge),
                              Text("(${bookmarkedProducts[index].reviews})")
                            ],
                          ),
                        );
                      }
                  ): Center(child: Text("Không tìm thấy sản phẩm"));
                }
              }
            }
        ),
      ),
    );
  }
}
