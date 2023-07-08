import 'package:cosmetic_frontend/blocs/my_storage_product/my_storage_product_bloc.dart';
import 'package:cosmetic_frontend/blocs/my_storage_product/my_storage_product_event.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:cosmetic_frontend/screens/product_detail/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/my_storage_product/my_storage_product_state.dart';
import '../../common/widgets/star_list.dart';

class ProductViewScreen extends StatelessWidget {
  ProductViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<StorageProductBloc>(context).add(ViewedProductFetched());
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Sản phẩm đã xem'),
      ),
      body: SafeArea(
        child: BlocBuilder<StorageProductBloc, StorageProductState>(
            builder: (context, state) {
              switch (state.storageProductStatus) {
                case StorageProductStatus.initial:
                  return Center(child: CircularProgressIndicator());
                case StorageProductStatus.loading:
                  return Center(child: CircularProgressIndicator());
                case StorageProductStatus.failure:
                  return Center(child: Text("Failed"));
                case StorageProductStatus.success: {
                  final viewedProducts = state.viewedProducts;
                  return viewedProducts != null && viewedProducts.isNotEmpty
                      ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewedProducts.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(productId: viewedProducts[index].id),
                                settings: RouteSettings(
                                  name: Routes.product_detail_screen,
                                ),
                              ),
                            );
                          },
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 32.0,
                                backgroundColor: Colors.black12,
                                child: CircleAvatar(
                                    radius: 32.0,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: NetworkImage(viewedProducts[index].image.url)
                                ),
                              ),
                            ],
                          ),
                          title: Text(viewedProducts[index].name,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          subtitle: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              StarList(rating: viewedProducts[index].rating),
                              SizedBox(width: 8),
                              Text("${viewedProducts[index].rating}", style: Theme.of(context).textTheme.labelLarge),
                              Text("(${viewedProducts[index].reviews})")
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
