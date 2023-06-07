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
                    child: Row(
                      children: [
                        Icon(Icons.language),
                        SizedBox(width: 16),
                        Text("Thay đổi ngôn ngữ", style: Theme.of(context).textTheme.titleMedium),
                        Spacer(),
                        Text("Tiếng Việt"),
                        Icon(Icons.navigate_next)
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
