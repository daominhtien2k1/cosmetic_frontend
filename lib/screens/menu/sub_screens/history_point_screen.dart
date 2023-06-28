import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/personal_info/personal_info_bloc.dart';
import '../../../blocs/personal_info/personal_info_event.dart';
import '../../../blocs/personal_info/personal_info_state.dart';

class HistoryPointScreen extends StatelessWidget {
  const HistoryPointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
      builder: (context, state) {
        final userInfo = state.userInfo;
        return Scaffold(
          appBar: AppBar(
            title: Text("Lịch sử điểm"),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 32, bottom: 8, left: 48, right: 48),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text("Bạn có", style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(height: 8),
                            Text("${userInfo.point}", style: Theme.of(context).textTheme.titleLarge),
                            SizedBox(height: 8),
                            Text("Điểm khả dụng", style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text("Cấp bậc", style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(height: 8),
                            Text("Lv. ${userInfo.level}", style: Theme.of(context).textTheme.titleLarge),
                            SizedBox(height: 8),
                            Builder(
                                builder: (context) {
                                  const levelThresholds = {
                                    1: 0,
                                    2: 500,
                                    3: 1000,
                                    4: 1500,
                                    5: 2000,
                                    6: 2500,
                                    7: 3000,
                                    8: 3500,
                                    9: 4000,
                                    10: 4500
                                  };
                                  if (userInfo.level < 10) {
                                    final needPoint = levelThresholds[userInfo.level+1]! - userInfo.point;
                                    final nextLevel = userInfo.level +1;
                                    return Text("Cần $needPoint để đạt Lv.$nextLevel", style: Theme.of(context).textTheme.titleMedium);
                                  } else {
                                    return Text("Đạt cấp tối đa", style: Theme.of(context).textTheme.titleMedium);
                                  }
                                }
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            enableDrag: true,
                            isDismissible: true,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return PolicyInfoModalBottomSheet();
                            }
                        );
                      },
                      icon: Icon(Icons.help)
                    ),
                  ),
                  HistoryPointList()
                ],
              ),
            ),
          ),
        );
      }
    );
  }

}

class PolicyInfoModalBottomSheet extends StatelessWidget {
  const PolicyInfoModalBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 20,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20)
        ),
        color: Colors.white,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 46,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Chính sách thưởng điểm",
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
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text("Điểm được tính như thế nào?", style: Theme.of(context).textTheme.titleMedium),
                        ),

                        Text("Tài khoản", style: Theme.of(context).textTheme.titleSmall),
                        SizedBox(height: 8),
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FractionColumnWidth(0.4),
                            1: FractionColumnWidth(0.2),
                            2: IntrinsicColumnWidth()
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(child: Text("Đăng kí")),
                                TableCell(child: Text("10 điểm")),
                                TableCell(child: Text("Cho lần đầu tiên"))
                              ]
                            ),
                            TableRow(
                              children: [
                                TableCell(child: Text("Đăng nhập")),
                                TableCell(child: Text("10 điểm")),
                                TableCell(child: Text("Cho lần đầu tiên"))
                              ]
                            ),

                          ],
                        ),

                        SizedBox(height: 24),
                        Text("Thường xuyên vào ứng dụng", style: Theme.of(context).textTheme.titleSmall),
                        SizedBox(height: 8),
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FractionColumnWidth(0.4),
                            1: FractionColumnWidth(0.2),
                            2: IntrinsicColumnWidth()
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(child: Text("Vào ứng dụng hằng ngày")),
                                TableCell(child: Text("10 điểm")),
                                TableCell(child: Text("Tặng điểm 1 lần mỗi ngày"))
                              ]
                            ),
                            TableRow(
                              children: [
                                TableCell(child: Text("Vào ứng dụng liên tục trong 7 hằng ngày")),
                                TableCell(child: Text("500 điểm")),
                                TableCell(child: Text("Tặng điểm 1 lần mỗi tuần"))
                              ]
                            ),
                          ],
                        ),

                        SizedBox(height: 24),
                        Text("Đánh giá sản phẩm", style: Theme.of(context).textTheme.titleSmall),
                        SizedBox(height: 8),
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FractionColumnWidth(0.4),
                            1: FractionColumnWidth(0.2),
                            2: IntrinsicColumnWidth()
                          },
                          children: [
                            TableRow(
                                children: [
                                  TableCell(child: Text("Đánh giá sản phẩm nhanh")),
                                  TableCell(child: Text("10 điểm")),
                                  TableCell(child: Text(""))
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(child: Text("Đánh giá sản phẩm tiêu chuẩn")),
                                  TableCell(child: Text("20 điểm")),
                                  TableCell(child: Text("Nếu xóa/vi phạm sẽ trừ đi số điểm được cộng"))
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(child: Text("Đánh giá sản phẩm chi tiết")),
                                  TableCell(child: Text("30 điểm")),
                                  TableCell(child: Text("Nếu xóa/vi phạm sẽ trừ đi số điểm được cộng"))
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(child: Text("Đánh giá sản phẩm hướng dẫn")),
                                  TableCell(child: Text("30 điểm")),
                                  TableCell(child: Text("Nếu xóa/vi phạm sẽ trừ đi số điểm được cộng"))
                                ]
                            ),
                          ],
                        ),

                        SizedBox(height: 24),
                        Text("Hoạt động trên bảng tin", style: Theme.of(context).textTheme.titleSmall),
                        SizedBox(height: 8),
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FractionColumnWidth(0.4),
                            1: FractionColumnWidth(0.2),
                            2: IntrinsicColumnWidth()
                          },
                          children: [
                            TableRow(
                                children: [
                                  TableCell(child: Text("Tạo bài viết đầu tiên")),
                                  TableCell(child: Text("10 điểm")),
                                  TableCell(child: Text(""))
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(child: Text("Viết bình luận đầu tiên")),
                                  TableCell(child: Text("10 điểm")),
                                  TableCell(child: Text(""))
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(child: Text("Viết bình luận tiếp theo")),
                                  TableCell(child: Text("1 điểm")),
                                  TableCell(child: Text("Tối đa 20 điểm/ngày"))
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(child: Text("Có bài viết trên bảng tin >=100 lượt thích")),
                                  TableCell(child: Text("30 điểm")),
                                  TableCell(child: Text(""))
                                ]
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("Xóa bài viết, bình luận sẽ bị trừ điểm tương ứng với điểm cộng", style: TextStyle(color: Colors.red)),

                        SizedBox(height: 24),
                        Text("Khác", style: Theme.of(context).textTheme.titleSmall),
                        SizedBox(height: 8),
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FractionColumnWidth(0.4),
                            1: FractionColumnWidth(0.2),
                            2: IntrinsicColumnWidth()
                          },
                          children: [
                            TableRow(
                                children: [
                                  TableCell(child: Text("Báo cáo đánh giá")),
                                  TableCell(child: Text("2 điểm")),
                                  TableCell(child: Text(""))
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(child: Text("Báo cáo bài viết")),
                                  TableCell(child: Text("2 điểm")),
                                  TableCell(child: Text(""))
                                ]
                            ),
                            TableRow(
                                children: [
                                  TableCell(child: Text("Viết bình luận tiếp theo")),
                                  TableCell(child: Text("1 điểm")),
                                  TableCell(child: Text("Tối đa 20 điểm/ngày"))
                                ]
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("Cosmetica sẽ kiểm duyệt và xác thực nội dung báo cáo", style: TextStyle(color: Colors.red)),

                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text("Cấp bậc thành viên", style: Theme.of(context).textTheme.titleMedium),
                        ),
                        Text("Sử dụng điểm đã tích lũy để thăng hạng, phân cấp thành viên. Đây là quỹ điểm được tổng hợp từ các hoạt động của thành viên theo lũy tiến thời gian (bao gồm cả điểm cộng và trừ). Khi thành viên đạt được một mốc điểm cụ thể, thứ hạng và phân cấp sẽ có sự thay đổi.", style: TextStyle(color: Colors.red)),
                        DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Cấp bậc',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Expanded(
                                child: Text(
                                  'Mức điểm',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            )
                          ],
                          rows: const <DataRow>[
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 1')),
                                DataCell(Text('<500 điểm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 2')),
                                DataCell(Text('500-1000 điểm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 3')),
                                DataCell(Text('1000-1500 điểm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 4')),
                                DataCell(Text('1500-2000 điểm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 5')),
                                DataCell(Text('2000-2500 điểm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 6')),
                                DataCell(Text('2500-3000 điểm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 7')),
                                DataCell(Text('3000-3500 điểm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 8')),
                                DataCell(Text('3500-4000 điểm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 9')),
                                DataCell(Text('4000-4500 điểm')),
                              ],
                            ),
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text('Cấp 10')),
                                DataCell(Text('4000-4500 điểm')),
                              ],
                            ),
                          ]

                        )



                      ],

                    ),
                  )
                ),
              )
            ],
          ),
        )
    );
  }
}

class HistoryPointList extends StatelessWidget {
  const HistoryPointList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.monitor_weight_outlined),
          title: Text("Lần đầu tiên đăng nhập"),
          subtitle: Text("18.05.2023"),
          trailing: Text("+10"),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(indent: 12, endIndent: 12);
      }
    );
  }
}



