import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:cosmetic_frontend/models/models.dart' hide Image;
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../configuration.dart';
import '../../../routes.dart';
import '../../../utils/token.dart';

class DeletedBannedReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bài viết bị xóa'),
        ),
        body: FutureBuilder(
            future: getListDeletedBannedReviews(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                final List<DeletedBannedReview> deletedBannedReviews = List<DeletedBannedReview>.from(snapshot.data["data"].map((x) => DeletedBannedReview.fromJson(x)));
                return deletedBannedReviews.length!= 0 ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: deletedBannedReviews.length,
                    itemBuilder: (context, index) {
                      final review = deletedBannedReviews[index];
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
                                  label: Text("${review.subject}"),
                                  labelStyle: TextStyle(color:  Theme.of(context).colorScheme.onInverseSurface),
                                )
                              ],
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Bạn đã đánh giá một sản phẩm",
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .titleMedium),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text("Phân loại:"),
                                        SizedBox(width: 8),
                                        Chip(
                                          avatar: Icon(Icons.ac_unit),
                                          label: Text("${review.classification}"),
                                          backgroundColor: Colors.greenAccent
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                            width: 60,
                                            height: 60,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: Image.network(review.productImage),
                                            )
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(review.productName,
                                            style: Theme.of(context).textTheme.titleMedium,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 8,
                                      children: [
                                        if (review.rating != null) StarList(rating: review.rating?.toDouble() ?? 0, color: Colors.orangeAccent),
                                        if(review.title != null) Text(
                                            "${review.title}",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .titleMedium),
                                      ],
                                    ),
                                    if(review.content!= null) Text(
                                        "${review.content}",
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              ),
                              // Nguy hiểm vì không call API dẫn đến lấy state cũ của người khác
                              // PopupMenuButton<String>(
                              //   onSelected: (String? value) {
                              //     switch (value) {
                              //       case 'go-review': {
                              //         // Thành màn hình loading
                              //         Navigator.pushNamed(context, Routes.review_detail_screen, arguments: review.reviewId);
                              //       }
                              //     }
                              //   },
                              //   itemBuilder: (BuildContext context) =>
                              //   <PopupMenuEntry<String>>[
                              //     const PopupMenuItem<String>(
                              //       value: 'go-review',
                              //       child: Text('Đi đến bài viết'),
                              //     ),
                              //
                              //   ],
                              // )
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
            value: 'go-review',
            child: Text('Đi đến bài viết'),
          )
        ]);

    // Implement the logic for each choice here
    switch (result) {
      case 'detail-report': {

      }
      break;
      case 'go-review': {

      }


    }
  }

  Future<Map<String, dynamic>?> getListDeletedBannedReviews() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/review/get_list_deleted_banned_reviews');

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




