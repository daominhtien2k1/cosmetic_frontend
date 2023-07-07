import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_frontend/blocs/search/search_event.dart';
import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:cosmetic_frontend/screens/newsfeed/widgets/newsfeed_widgets.dart';
import 'package:cosmetic_frontend/screens/search/widgets/search_review_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/search/search_bloc.dart';
import '../../../blocs/search/search_state.dart';
import '../../../models/search_account_model.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  late String keyword;
  late String searchBy;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final Map<String, dynamic> data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    keyword = data["keyword"];
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SearchResultScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: SearchBar(
            controller: _searchController,
            focusNode: _searchFocusNode,
            hintText: keyword,
            onTap: () {
              Navigator.of(context).pop();
            },
            leading: Icon(Icons.search),
            constraints: BoxConstraints(minWidth: 240.0, maxWidth: 360.0, minHeight: 40.0),
            elevation: MaterialStateProperty.resolveWith<double>((_) => 1),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => Colors.white),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
              return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
            })
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: "Sản phẩm",
              ),
              Tab(
                text: "Thương hiệu",
              ),
              Tab(
                text: "Bài viết",
              ),
              Tab(
                text: "Đánh giá",
              ),
              Tab(
                text: "Người dùng",
              )
            ]
          )
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              ProductSearchResultView(keyword: keyword),
              BrandSearchResultView(keyword: keyword),
              PostSearchResultView(keyword: keyword),
              ReviewSearchResultView(keyword: keyword),
              AccountSearchResultView(keyword: keyword)
            ]
          )
        ),
      ),
    );
  }
}

class ProductSearchResultView extends StatelessWidget {
  final String keyword;
  const ProductSearchResultView({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SearchBloc>(context).add(Search(keyword: keyword, searchBy: "Product"));
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          switch (state.searchStatus) {
            case SearchStatus.initial:
              return Center(child: Text("Không tìm thấy sản phẩm"));
            case SearchStatus.loading:
              return Center(child: CircularProgressIndicator());
            case SearchStatus.failure:
              return Center(child: Text("Không có kết nối mạng"));
            case SearchStatus.success: {
              final searchProductList = state.searchProductList;
              return searchProductList != null && searchProductList.foundedProducts.isNotEmpty
                  ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchProductList.founds ?? 0,
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
                                backgroundImage: NetworkImage(searchProductList.foundedProducts[index].image.url)
                              ),
                            ),
                          ],
                        ),
                        title: Text(searchProductList.foundedProducts[index].name,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                        ),
                        subtitle: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            StarList(rating: searchProductList.foundedProducts[index].rating),
                            SizedBox(width: 8),
                            Text("${searchProductList.foundedProducts[index].rating}", style: Theme.of(context).textTheme.labelLarge),
                            Text("(${searchProductList.foundedProducts[index].reviews})")
                          ],
                        ),
                      );
                    }
                ): Center(child: Text("Không tìm thấy sản phẩm"));
            }
          }
        }
    );
  }
}


class BrandSearchResultView extends StatelessWidget {
  final String keyword;
  const BrandSearchResultView({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SearchBloc>(context).add(Search(keyword: keyword, searchBy: "Brand"));
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          switch (state.searchStatus) {
            case SearchStatus.initial:
              return Center(child: Text("Không tìm thấy thương hiệu"));
            case SearchStatus.loading:
              return Center(child: CircularProgressIndicator());
            case SearchStatus.failure:
              return Center(child: Text("Không có kết nối mạng"));
            case SearchStatus.success: {
              final searchBrandList = state.searchBrandList;
              return searchBrandList != null && searchBrandList.foundedBrands.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchBrandList.foundedBrands.length ?? 0,
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
                                backgroundImage: CachedNetworkImageProvider(searchBrandList.foundedBrands[index].image),
                              ),
                            ),
                          ],
                        ),
                        title: Text(searchBrandList.foundedBrands[index].name, style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium),
                        trailing: searchBrandList.foundedBrands[index].isFollowed ? OutlinedButton(
                          onPressed: () {
                            BlocProvider.of<SearchBloc>(context).add(IsFollowedInSearchBrandUpdated(searchBrand: searchBrandList.foundedBrands[index], newIsFollowed: false));
                          },
                          child: Text("Đang theo dõi"),
                        ) : FilledButton.tonal(
                          onPressed: () {
                            BlocProvider.of<SearchBloc>(context).add(IsFollowedInSearchBrandUpdated(searchBrand: searchBrandList.foundedBrands[index], newIsFollowed: true));
                          },
                          child: Text("Theo dõi"),
                        )

                    );;
                  }
              ) : SizedBox.shrink();
            }
          }
        }
    );
  }
}

class PostSearchResultView extends StatelessWidget {
  final String keyword;
  const PostSearchResultView({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SearchBloc>(context).add(Search(keyword: keyword, searchBy: "Post"));
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          switch (state.searchStatus) {
            case SearchStatus.initial:
              return Center(child: Text("Không có bài viết"));
            case SearchStatus.loading:
              return Center(child: CircularProgressIndicator());
            case SearchStatus.failure:
              return Center(child: Text("Không có kết nối mạng"));
            case SearchStatus.success: {
              final searchPostList = state.searchPostList;
              return searchPostList != null && searchPostList.foundedPosts.isNotEmpty ? ListView.builder(
                itemCount: searchPostList.founds ?? 0,
                itemBuilder: (context, index) {
                  return PostContainer(post: searchPostList.foundedPosts[index]);
                }
              ) : Center(child: Text("Không có bài viết"));
            }
          }
        }
    );
  }
}

// lỗi ngay nếu sửa trực tiếp ở đây
class ReviewSearchResultView extends StatelessWidget {
  final String keyword;
  const ReviewSearchResultView({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SearchBloc>(context).add(Search(keyword: keyword, searchBy: "Review"));
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          switch (state.searchStatus) {
            case SearchStatus.initial:
              return Center(child: Text("Không có bài đánh giá"));
            case SearchStatus.loading:
              return Center(child: CircularProgressIndicator());
            case SearchStatus.failure:
              return Center(child: Text("Không có kết nối mạng"));
            case SearchStatus.success: {
              final searchReviewList = state.searchReviewList;
              return searchReviewList != null && searchReviewList.foundedReviews.isNotEmpty ? ListView.builder(
                  itemCount: searchReviewList.founds ?? 0,
                  itemBuilder: (context, index) {
                    return SearchReviewContainer(review: searchReviewList.foundedReviews[index]);
                  }
              ) : Center(child: Text("Không có bài đánh giá"));
            }
          }
        }
    );
  }
}

class AccountSearchResultView extends StatelessWidget {
  final String keyword;
  const AccountSearchResultView({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SearchBloc>(context).add(Search(keyword: keyword, searchBy: "Account"));
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          switch (state.searchStatus) {
            case SearchStatus.initial:
              return Center(child: Text("Không tìm thấy tài khoản"));
            case SearchStatus.loading:
              return Center(child: CircularProgressIndicator());
            case SearchStatus.failure:
              return Center(child: Text("Không có kết nối mạng"));
            case SearchStatus.success: {
              final searchAccountList = state.searchAccountList;
                return searchAccountList != null && searchAccountList.foundedAccounts.isNotEmpty ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchAccountList.foundedAccounts.length ?? 0,
                    itemBuilder: (context, index) {
                      return AccountSearchListTile(searchAccount: searchAccountList.foundedAccounts[index]);
                    }
                ) : Center(child: Text("Không tìm thấy tài khoản"));
            }
          }
        }
    );
  }
}

class AccountSearchListTile extends StatelessWidget {
  final SearchAccount searchAccount;

  AccountSearchListTile({required this.searchAccount});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.personal_screen, arguments: searchAccount.id);
      },
      leading: Stack(
        children: [
          CircleAvatar(
              radius: 32.0,
              backgroundColor: Colors.black12,
              child: CircleAvatar(
                  radius: 32.0,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: CachedNetworkImageProvider(searchAccount.avatar)
              )
          ),
        ],
      ),
      title: Text(searchAccount.name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text("Level ${searchAccount.level}"),
      trailing: buildStatusFriendButton(context)
    );
  }

  // Ở đây không có chặn
  Widget buildStatusFriendButton(BuildContext context) {
    if (searchAccount.statusFriend == "Me" || searchAccount.statusFriend == "Block") {
      return SizedBox();
    } else if (searchAccount.statusFriend == "Unknown") {
      return OutlinedButton(
        onPressed: () {
          // setState(() {
          //   statusFriend = "Sent friend request";
          // });
          BlocProvider.of<SearchBloc>(context).add(StatusFriendInSearchAccountUpdated(searchAccount: searchAccount, newStatusFriend: "Sent friend request"));
        },
        child: Text("Thêm bạn bè"),
      );
    } else if (searchAccount.statusFriend == "Sent friend request") {
      return FilledButton.tonal(
        style: FilledButton.styleFrom(backgroundColor: Colors.amber),
        onPressed: () {
          // setState(() {
          //   statusFriend = "Unknown";
          // });
          BlocProvider.of<SearchBloc>(context).add(StatusFriendInSearchAccountUpdated(searchAccount: searchAccount, newStatusFriend: "Unknown"));
        },
        child: Text("Hủy lời mời"),
      );
    } else if (searchAccount.statusFriend == "Received friend request") {
      return FilledButton.tonal(
        style: FilledButton.styleFrom(backgroundColor: Colors.amber),
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Phản hồi lời mời đã nhận?'),
              content: const Text('Thao tác này không thể hoàn tác'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Xóa'),
                  child: const Text('Xóa'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Chấp nhận'),
                  child: const Text('Chấp nhận'),
                ),
              ],
            ),
          ).then((value) {
            if (value == "Xóa") {
              // setState(() {
              //   statusFriend = "Unknown";
              // });
              BlocProvider.of<SearchBloc>(context).add(StatusFriendInSearchAccountUpdated(searchAccount: searchAccount, newStatusFriend: "Unknown"));
            } else if (value == "Chấp nhận") {
              // setState(() {
              //   statusFriend = "Friend";
              // });
              BlocProvider.of<SearchBloc>(context).add(StatusFriendInSearchAccountUpdated(searchAccount: searchAccount, newStatusFriend: "Friend"));
            }
          });
        },
        child: Text("Có lời mời"),
      );
    } else if(searchAccount.statusFriend == "Friend") {
      return FilledButton.tonal(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Xác nhận hủy kết bạn?'),
              content: const Text('Thao tác này không thể hoàn tác'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Hủy'),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Xác nhận'),
                  child: const Text('Xác nhận'),
                ),
              ],
            ),
          ).then((value) {
            if (value == "Hủy") {

            } else if (value == "Xác nhận") {
              // setState(() {
              //   statusFriend = "Unknown";
              // });
              BlocProvider.of<SearchBloc>(context).add(StatusFriendInSearchAccountUpdated(searchAccount: searchAccount, newStatusFriend: "Unknown"));
            }
          });

        },
        child: Text("Bạn bè"),
      );
    } else {
      return SizedBox();
    }
  }
}



