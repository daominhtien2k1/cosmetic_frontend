import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/followed_brand/followed_brand_bloc.dart';
import '../../../blocs/followed_brand/followed_brand_event.dart';
import '../../../blocs/followed_brand/followed_brand_state.dart';

class FollowedBrandScreen extends StatelessWidget {
  const FollowedBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FollowedBrandBloc>(context).add(FollowedBrandFetch());
    return Scaffold(
      appBar: AppBar(
        title: Text("Thương hiệu theo dõi"),
      ),
      body: SafeArea(
        child: BlocBuilder<FollowedBrandBloc, FollowedBrandState>(
          builder: (context, state) {
            switch (state.followedBrandStatus) {
              case FollowedBrandStatus.initial:
                return Center(child: Text("Không tìm thấy thương hiệu"));
              case FollowedBrandStatus.loading:
                return Center(child: CircularProgressIndicator());
              case FollowedBrandStatus.failure:
                return Center(child: Text("Không có kết nối mạng"));
              case FollowedBrandStatus.success: {
                final followedBrands = state.followedBrands;
                return followedBrands != null && followedBrands.isNotEmpty ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: followedBrands.length ?? 0,
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
                                  backgroundImage: CachedNetworkImageProvider(followedBrands[index].image),
                                ),
                              ),
                            ],
                          ),
                          title: Text(followedBrands[index].name, style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium),
                          trailing: followedBrands[index].isFollowed ? OutlinedButton(
                            onPressed: () {
                              BlocProvider.of<FollowedBrandBloc>(context).add(BrandUnfollowed(followedBrand: followedBrands[index]));
                            },
                            child: Text("Đang theo dõi"),
                          ) : FilledButton.tonal(
                            onPressed: () {
                            },
                            child: Text("Theo dõi"),
                          )

                      );;
                    }
                ) : Center(child: Text("Không có thương hiệu nào"));

              }
            }
          }
        ) ,
      ),
    );
  }
}
