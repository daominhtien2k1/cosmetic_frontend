import 'package:cosmetic_frontend/blocs/search/search_event.dart';
import 'package:cosmetic_frontend/models/models.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:cosmetic_frontend/screens/search/sub_screens/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_state.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // late TextEditingController _searchController;
  late SearchController _searchController;

  // late FocusNode _searchFocusNode;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _searchController = TextEditingController();
    _searchController = SearchController();
    // _searchFocusNode = FocusNode();
    BlocProvider.of<SearchBloc>(context).add(SavedSearchFetched());
  }

  @override
  void dispose() {
    _searchController.dispose();
    // _searchFocusNode.dispose();
    super.dispose();
  }

  String removeHtmlTags(String input) {
    RegExp htmlTags = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return input.replaceAll(htmlTags, '');
  }

  Iterable<Widget> getHistoryList(BuildContext context, SearchController controller) {
    print("Rebuild when state changed");
    final List<SavedSearch> savedSearches = BlocProvider.of<SearchBloc>(context).state.savedSearches;

    return savedSearches.map((s) => ListTile(
      leading: const Icon(Icons.history),
      title: Text(s.keyword),
      trailing: IconButton(
          icon: const Icon(Icons.call_missed),
          onPressed: () {
            controller.text = s.keyword;
            // print(controller.selection.baseOffset);

            controller.selection = TextSelection.collapsed(offset: controller.text.length);
            // lạ quá, không tác dụng
            // controller.selection = TextSelection.collapsed(offset: controller.selection.baseOffset);
          }),
      onTap: () {
        // controller.closeView(color.label);
        // handleSelection(color);
      },
    ));
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
    BlocProvider.of<SearchBloc>(context).add(SearchSuggestionsFetched(searchString: input));
    final List<String> searchSuggestions = BlocProvider.of<SearchBloc>(context).state.searchSuggestions;

    return searchSuggestions.map((s) => ListTile(
              leading: const Icon(Icons.pan_tool_alt_outlined),
              title: Html(data: s),
              trailing: IconButton(
                  icon: const Icon(Icons.call_missed),
                  onPressed: () {
                    controller.text = removeHtmlTags(s);
                    controller.selection =
                        TextSelection.collapsed(offset: controller.text.length);

                  }),
              onTap: () {
                // controller.closeView(filteredColor.label);
                // controller.text = filteredColor.label;
                // handleSelection(filteredColor);
              },
            ));
  }

  // void handleSelection(ColorItem color) {
  //   setState(() {
  //     if (searchHistory.length >= 10) {
  //       searchHistory.removeLast();
  //     }
  //     searchHistory.insert(0, color);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: SearchAnchor.bar(
          searchController: _searchController,
          constraints: BoxConstraints(minWidth: 240.0, maxWidth: 360.0, minHeight: 40.0),
          barElevation: MaterialStateProperty.resolveWith<double>((_) => 1),
          barShape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
          }),
          isFullScreen: true,
          barHintText: 'Tìm kiếm sản phẩm, bài viết, đánh giá...',
          viewHintText: "Tìm kiếm sản phẩm, bài viết, đánh giá...",
          viewElevation: 1,
          viewTrailing: [
            IconButton(onPressed: (){
              _searchController.clear();
            }, icon: Icon(Icons.close)),
            IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SearchResultScreen(),
                settings: RouteSettings(
                  name: Routes.search_result_screen,
                  arguments: {
                    "keyword": _searchController.text
                  }
                )
              ));
            }, icon: Icon(Icons.search))

          ],
          suggestionsBuilder: (context, controller) {
            if (controller.text.isEmpty) {
                return getHistoryList(context, controller);
            } else {
              return getSuggestions(controller);
            }

          },
        ),
        // SearchBar(
        //   controller: _searchController,
        //   focusNode: _searchFocusNode,
        //   onTap: () {
        //     // hiện keyboard nếu cần, thực ra không cần cũng được
        //     FocusScope.of(context).requestFocus(_searchFocusNode);
        //   },
        //   leading: Icon(Icons.search),
        //   constraints: BoxConstraints(minWidth: 240.0, maxWidth: 360.0, minHeight: 40.0),
        //   elevation: MaterialStateProperty.resolveWith<double>((_) => 1),
        //   backgroundColor: MaterialStateProperty.resolveWith<Color>(
        //           (states) => Colors.white),
        //   shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
        //     return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
        //   }),
        //   hintText: "Tìm kiếm sản phẩm, bài viết, đánh giá...",
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text("Lịch sử tìm kiếm", style: Theme.of(context).textTheme.titleMedium),
              ),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  switch (state.searchStatus) {
                    case SearchStatus.initial:
                      return Center(child: Text("Hiện chưa có dữ liệu"));
                    case SearchStatus.loading:
                      return Center(child: Text("Đang tải dữ liệu"));
                    case SearchStatus.failure:
                      return Center(child: Text("Internet không khả dụng"));
                    case SearchStatus.success: {
                      final List<SavedSearch> savedSearches = state.savedSearches;
                        return ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(indent: 44);
                            },
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: savedSearches.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 48,
                                child: ListTile(
                                  leading: Icon(Icons.history),
                                  title: Text(savedSearches[index].keyword),
                                  onTap: () {
                                    _searchController.openView();
                                    _searchController.text = savedSearches[index].keyword;
                                  },
                                  // selected: false,
                                  splashColor: Colors.pinkAccent,
                                  // selectedColor: Colors.pink,
                                  // selectedTileColor: Colors.pinkAccent,
                                  // tileColor: Colors.white,
                                  contentPadding: EdgeInsets.only(left: 8),
                                  trailing: IconButton(
                                    onPressed: () {
                                      BlocProvider.of<SearchBloc>(context).add(SavedSearchDelete(searchId: savedSearches[index].id));
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ),
                              );
                            }
                        );
                    }
                  }

                }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text("Tìm kiếm phổ biến", style: Theme.of(context).textTheme.titleMedium),
              ),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton.tonal(
                      onPressed: (){
                        _searchController.openView();
                      },
                      child: Text("halio")
                  ),
                  FilledButton.tonal(
                      onPressed: (){},
                      child: Text("halio")
                  ),
                  FilledButton.tonal(
                      onPressed: (){},
                      child: Text("halio")
                  ),
                  FilledButton.tonal(
                      onPressed: (){},
                      child: Text("halio")
                  ),
                  FilledButton.tonal(
                      onPressed: (){},
                      child: Text("halio")
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
