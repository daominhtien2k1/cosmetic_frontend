import 'package:cosmetic_frontend/models/models.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../configuration.dart';
import '../../../routes.dart';
import '../../../utils/token.dart';

class ReportedReviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Đánh giá bị báo cáo'),
        ),
        body: FutureBuilder(
            future: getListReportedReviews(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                final List<ReportedReview> reportedReviews = List<ReportedReview>.from(snapshot.data["data"].map((x) => ReportedReview.fromJson(x)));
                return reportedReviews.length!= 0 ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: reportedReviews.length,
                    itemBuilder: (context, index) {
                      final review = reportedReviews[index];
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
                                    backgroundColor: Theme
                                        .of(context)
                                        .colorScheme
                                        .errorContainer,
                                    label: Text("${review.subject}")
                                ),
                                SizedBox(width: 8),
                                ActionChip(
                                  onPressed: null,
                                  avatar: Icon(Icons.pending),
                                  label: Text("${review.status}"),
                                  disabledColor: Colors.amber,
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
                                            text: "${review.reviewContent}",
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
                                    case 'detail-report': {
                                      print("AAA");
                                      showModalBottomSheet(
                                          enableDrag: true,
                                          isDismissible: true,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return _ReportDetailModalBottomSheet(reportedReview: review);
                                          }
                                      );
                                    }
                                    break;
                                    case 'go-review': {
                                      Navigator.pushNamed(context, Routes.review_detail_screen, arguments: review.reviewId);
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'detail-report',
                                    child: Text('Xem chi tiết báo cáo'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'go-review',
                                    child: Text('Đi đến bài đánh giá'),
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

  Future<Map<String, dynamic>?> getListReportedReviews() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/report/get_list_reported_reviews');

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

class _ReportDetailModalBottomSheet extends StatelessWidget {
  final ReportedReview reportedReview;

  _ReportDetailModalBottomSheet({required this.reportedReview});

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 20,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)
        ),
        color: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 46,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Chi tiết báo cáo",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                ),
                Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Text("Lí do:", style: Theme.of(context).textTheme.titleMedium),
                                SizedBox(width: 16),
                                Chip(
                                    padding: EdgeInsets.all(8.0),
                                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                                    label: Text("${reportedReview.subject}")
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Chi tiết nội dung:", style: Theme.of(context).textTheme.titleMedium),
                                SizedBox(width: 16),
                                Text("${reportedReview.details}",)
                              ],
                            ),
                            Row(
                              children: [
                                Text("Trạng thái:", style: Theme.of(context).textTheme.titleMedium),
                                SizedBox(width: 16),
                                ActionChip(
                                  onPressed: null,
                                  avatar: Icon(Icons.pending),
                                  label: Text("${reportedReview.status}"),
                                  disabledColor: Colors.amber,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                )
              ]
          ),
        )
    );
  }
}




