import 'package:cosmetic_frontend/models/models.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../configuration.dart';
import '../../../routes.dart';
import '../../../utils/token.dart';

class DeletedBannedPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bài viết bị xóa'),
        ),
        body: FutureBuilder(
            future: getListDeletedBannedPosts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                final List<DeletedBannedPost> deletedBannedPosts = List<DeletedBannedPost>.from(snapshot.data["data"].map((x) => DeletedBannedPost.fromJson(x)));
                return deletedBannedPosts.length!= 0 ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: deletedBannedPosts.length,
                    itemBuilder: (context, index) {
                      final post = deletedBannedPosts[index];
                      return Card(
                        child: ListTile(
                          titleAlignment: ListTileTitleAlignment.top,
                          isThreeLine: true,
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Chip(
                                  padding: EdgeInsets.all(8.0),
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                  label: Text("${post.subject}"),
                                  labelStyle: TextStyle(color:  Theme.of(context).colorScheme.onInverseSurface),
                                )
                              ],
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: RichText(
                                  text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Bạn đã chia sẻ một bài viết\n",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .titleMedium),
                                        TextSpan(
                                            text: "${post.postDescribed}",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                              overflow: TextOverflow.clip,)
                                        )
                                      ]
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (String? value) {
                                  switch (value) {
                                    case 'go-post': {
                                      // Thành màn hình loading
                                      Navigator.pushNamed(context, Routes.post_detail_screen, arguments: post.postId);
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'go-post',
                                    child: Text('Đi đến bài viết'),
                                  ),

                                ],
                              )
                            ],
                          ),
                          // Không sử dụng Builder sẽ bị lỗi ==== Exception caught by gesture ===== The following _TypeError was thrown while handling a gesture: type 'RenderSliverList' is not a subtype of type 'RenderBox' in type cast
                          // trailing: Builder(
                          //   builder: (context) {
                          //     return InkWell(
                          //         // onTap: () {
                          //         //   //call your onpressed function here
                          //         //   print('Button Pressed');
                          //         // },
                          //         onTapDown: (TapDownDetails details) {
                          //           final RenderBox referenceBox = context.findRenderObject() as RenderBox;
                          //           // xem lại code mẫu, như vậy chạy sai
                          //           // final tapPosition = referenceBox.globalToLocal(details.globalPosition);
                          //           // print(tapPosition);
                          //           // _showContextMenu(context, tapPosition);
                          //           print(details.globalPosition);
                          //           _showContextMenu(context, details.globalPosition);
                          //         },
                          //       child: Icon(Icons.more_vert)
                          //     );
                          //   }
                          // ),
                        ),
                      );
                    },
                  ),
                ): Center(child: Text("Không có bài viết nào bị báo cáo"));
              }
              return Center(child: Text("Error"));
            }
        )
    );
  }

  void _showContextMenu(BuildContext context, Offset tapPosition) async {
    final RenderObject? overlay = Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        context: context,

        // Show the context menu at the tap location
        position: RelativeRect.fromRect(
            Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),

        // set a list of choices for the context menu
        items: [
          const PopupMenuItem(
            value: 'detail-report',
            child: Text('Xem chi tiết báo cáo'),
          ),
          const PopupMenuItem(
            value: 'go-post',
            child: Text('Đi đến bài viết'),
          )
        ]);

    // Implement the logic for each choice here
    switch (result) {
      case 'detail-report': {

      }
      break;
      case 'go-post': {

      }


    }
  }

  Future<Map<String, dynamic>?> getListDeletedBannedPosts() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/post/get_deleted_banned_post');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      return body;
    } else {
      return null;
    }
  }
}




