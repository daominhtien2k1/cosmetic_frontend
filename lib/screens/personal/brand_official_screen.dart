import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/brand/brand_detail_bloc.dart';
import '../../blocs/brand/brand_detail_event.dart';
import '../../blocs/brand/brand_detail_state.dart';
import '../../blocs/friend/friend_bloc.dart';
import '../../blocs/friend/friend_event.dart';
import '../../blocs/friend/friend_state.dart';
import '../../blocs/personal_info/personal_info_bloc.dart';
import '../../blocs/personal_info/personal_info_event.dart';
import '../../blocs/personal_info/personal_info_state.dart';
import '../../blocs/personal_post/personal_post_bloc.dart';
import '../../blocs/personal_post/personal_post_state.dart';
import '../../common/widgets/star_list.dart';
import '../../models/models.dart' hide Image, Friend;
import '../newsfeed/widgets/post_container.dart';
import './widgets/personal_widgets.dart';

class BrandOfficialScreen extends StatefulWidget {
  final String? accountId;
  BrandOfficialScreen({this.accountId});

  @override
  State<BrandOfficialScreen> createState() => _BrandOfficialScreenState();
}

class _BrandOfficialScreenState extends State<BrandOfficialScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.accountId != null) {
      // null? toString() ảo ma
      context.read<PersonalInfoBloc>().add(PersonalInfoOfAnotherUserFetched(id: widget.accountId.toString()));
      context.read<FriendBloc>().add(FriendsOfAnotherUserFetched(id: widget.accountId.toString()));
    }

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 160.0,
              flexibleSpace: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
                builder: (context, state) {
                  final userInfo = state.userInfo;
                  return FlexibleSpaceBar(
                    title: Row(
                      children: [
                        Text(userInfo.name, style: TextStyle(color: Colors.teal)),
                      ],
                    ),
                    background: Image.network(
                      userInfo.coverImage,
                      fit: BoxFit.cover,
                    )
                  );
                }
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: BrandOfficialHeaderContainer()
              ),
            ),
            SliverToBoxAdapter(
              child: Divider()
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Icon(Icons.cases_sharp),
                    const SizedBox(width: 10.0),
                    _LocationText()
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider()
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: const [
                    Expanded(
                        child: Text(
                          "Bạn bè",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        )),
                    Text("Xem thêm>>"),
                  ],
                )
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _NumberOfFriend()
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 150.0,
                  child: _ListFriendCompact()
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(height: 1, color: Colors.pinkAccent.withOpacity(0.2), thickness: 1)
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: "Sản phẩm"
                    ),
                    Tab(
                      text: "Bài viết"
                    ),
                  ],
                ),
              ),
              pinned: true,
            ),
            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //         (BuildContext context, int index) {
            //       return Container(
            //         color: index.isOdd ? Colors.white : Colors.black12,
            //         height: 100.0,
            //         child: Center(
            //           child: Text('$index', textScaleFactor: 5),
            //         ),
            //       );
            //     },
            //     childCount: 20,
            //   ),
            // ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _BrandProductList(),
                  _BrandPersonalPostList()
                ],
              )
            )
          ],
        )
      ),
    );
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class BrandOfficialHeaderContainer extends StatelessWidget {
  const BrandOfficialHeaderContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          if (userInfo.brandId != null) {
            BlocProvider.of<BrandDetailBloc>(context).add(BrandDetailFetched(brandId: userInfo.brandId!));
          }
          return BlocBuilder<BrandDetailBloc, BrandDetailState>(
            builder: (context, state) {
              final brandDetail = state.brandDetail;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.pink,
                    child: CircleAvatar(
                        radius: 32,
                        // child: Image.network(brandDetail!.image.url), // vẫn là ảnh vuông không khớp với vòng tròn
                        backgroundImage: NetworkImage(userInfo.avatar)
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Text(userInfo.name, style: Theme.of(context).textTheme.titleMedium),
                          Icon(Icons.verified, color: Colors.pink)
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.pink),
                          Text("${brandDetail?.rating.toStringAsFixed(2)}"),
                          SizedBox(width: 4),
                          Text("|"),
                          SizedBox(width: 4),
                          Icon(Icons.spatial_tracking, color: Colors.pink),
                          Text("${brandDetail?.reviews}")
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  brandDetail?.isFollowed == true ?
                  OutlinedButton(
                    onPressed: () {
                      BlocProvider.of<BrandDetailBloc>(context).add(BrandFollow(brandId: brandDetail!.id));
                    },
                    child: Text("Đang theo dõi")
                  )
                  : FilledButton.tonal(
                    onPressed: (){
                      BlocProvider.of<BrandDetailBloc>(context).add(BrandFollow(brandId: brandDetail!.id));
                    },
                    child: Text("Theo dõi")
                  )
                ],
              );
            }
          );
        }
    );
  }
}

class _LocationText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          var location = "${userInfo.city}, ${userInfo.country}";
          return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Sống và làm việc tại ",
                    style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  TextSpan(
                    text: location,
                    style: const TextStyle(
                        fontSize: 17.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)
                    )
                ]
              ));
        });
  }
}

class _NumberOfFriend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(
        builder: (context, state) {
          final friendList = state.friendList;
          return Text("${friendList.friends.length.toString()} người bạn",
              style: TextStyle(fontSize: 17.0, color: Colors.grey[700]));
        }
    );
  }
}

class _ListFriendCompact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendBloc, FriendState>(builder: (context, state) {
      final friendList = state.friendList;
      return GridView.builder(
        itemCount: 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.5)),
        itemBuilder: (context, index) {
          return index >= friendList.friends.length
              ? SizedBox()
              : GridTile(
            child: Friend(
              friendName: friendList.friends[index].name,
              imageUrl: friendList.friends[index].avatar,
            ),
          );
        },
      );
    });
  }
}

class _BrandPersonalPostList extends StatefulWidget {
  _BrandPersonalPostList({
    Key? key,
  }) : super(key: key);

  @override
  State<_BrandPersonalPostList> createState() => _BrandPersonalPostListState();
}

class _BrandPersonalPostListState extends State<_BrandPersonalPostList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalPostBloc, PersonalPostState>(
        builder: (context, state) {
          // switch case hết giá trị thì BlocBuilder sẽ tự hiểu không bao giờ rơi vào trường hợp null ---> Siêu ghê
          switch (state.status) {
            case PersonalPostStatus.initial:
              return Center(child: CircularProgressIndicator());
            case PersonalPostStatus.loading:
              return Center(child: CircularProgressIndicator());
            case PersonalPostStatus.failure:
              return Center(child: Text('Failed to fetch posts'));
            case PersonalPostStatus.success:
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.postList.posts.length,
                  itemBuilder: (context, index) {
                    return index >= state.postList.posts.length
                        ? const CircularProgressIndicator()
                        : PostContainer(post: state.postList.posts[index] as Post);
                  });
          // return const Center(child: Text('Successed to fetch posts'));
          }
        });
  }
}

class _BrandProductList  extends StatelessWidget {
  const _BrandProductList ({super.key});

  @override
  Widget build(BuildContext context) {
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
                return ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
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
                );
              }
            }
          }
        )
    );
  }
}

