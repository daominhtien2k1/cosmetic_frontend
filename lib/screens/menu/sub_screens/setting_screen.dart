import 'package:cosmetic_frontend/screens/menu/sub_screens/menu_subscreens.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Cài đặt'),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.password),
                        SizedBox(width: 16),
                        Text("Thay đổi mật khẩu", style: Theme.of(context).textTheme.titleMedium),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.block),
                        SizedBox(width: 16),
                        Text("Danh sách chặn", style: Theme.of(context).textTheme.titleMedium),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportedPostScreen()));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.compost),
                          SizedBox(width: 16),
                          Text("Bài viết bị báo cáo", style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportedPostScreen()));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.remove_moderator_outlined),
                          SizedBox(width: 16),
                          Text("Bài viết bị xóa", style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportedReviewScreen()));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.reviews_outlined),
                          SizedBox(width: 16),
                          Text("Đánh giá bị báo cáo", style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.playlist_remove_rounded),
                        SizedBox(width: 16),
                        Text("Đánh giá bị xóa", style: Theme.of(context).textTheme.titleMedium),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.bug_report_outlined),
                        SizedBox(width: 16),
                        Text("Báo cáo đã gửi", style: Theme.of(context).textTheme.titleMedium),
                      ],
                    )
                ),

              ],
            ),
          )
      ),
    );
  }
}
