import 'package:cosmetic_frontend/blocs/my_storage_product/my_storage_product_bloc.dart';
import 'package:cosmetic_frontend/blocs/my_storage_product/my_storage_product_event.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:cosmetic_frontend/screens/product_detail/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/my_storage_product/my_storage_product_state.dart';
import '../../common/widgets/star_list.dart';

class ProductLoveScreen extends StatelessWidget {
  ProductLoveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<StorageProductBloc>(context).add(LovedProductFetched());
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Sản phẩm yêu thích'),
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
                  final lovedProducts = state.lovedProducts;
                  return lovedProducts != null && lovedProducts.isNotEmpty
                      ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: lovedProducts.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(productId: lovedProducts[index].id),
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
                                    backgroundImage: NetworkImage(lovedProducts[index].image.url)
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              BlocProvider.of<StorageProductBloc>(context).add(LovedProductUnLove(lovedProduct: lovedProducts[index]));
                            },
                            isSelected: lovedProducts[index].isLoved,
                            selectedIcon: Icon(Icons.favorite, color: Colors.pink),
                            icon: Icon(Icons.favorite_border)
                          ),
                          title: Text(lovedProducts[index].name,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          subtitle: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              StarList(rating: lovedProducts[index].rating),
                              SizedBox(width: 8),
                              Text("${lovedProducts[index].rating}", style: Theme.of(context).textTheme.labelLarge),
                              Text("(${lovedProducts[index].reviews})")
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
