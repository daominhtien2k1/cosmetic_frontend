import 'package:cosmetic_frontend/blocs/search/search_event.dart';
import 'package:cosmetic_frontend/screens/newsfeed/widgets/newsfeed_widgets.dart';
import 'package:cosmetic_frontend/screens/search/widgets/search_review_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/search/search_bloc.dart';
import '../../../blocs/search/search_state.dart';

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
      initialIndex: 2,
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
              Center(
                child: Text("It's cloudy here"),
              ),
              Center(
                child: Text("It's cloudy here"),
              ),
              ProductSearchResultView(keyword: keyword),
              ReviewSearchResultView(keyword: keyword),
              Center(
                child: Text("It's cloudy here"),
              ),
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
