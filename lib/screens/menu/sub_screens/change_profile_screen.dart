import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_frontend/screens/menu/sub_screens/skin_info_screen.dart';
import 'package:flutter/material.dart';

class ChangeProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Chỉnh sửa hồ sơ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 48.0,
                          backgroundColor: Colors.black12,
                          child: CircleAvatar(
                            radius: 46.0,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: const CachedNetworkImageProvider(
                                "https://banner2.cleanpng.com/20180612/hv/kisspng-computer-icons-designer-avatar-5b207ebb279901.8233901115288562511622.jpg"),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -8,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black38,
                                width: 1,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.camera_alt_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Text("Họ và tên", style: Theme.of(context).textTheme.titleMedium),
                      Spacer(),
                      Text("Đào Minh Tiến"),
                      Icon(Icons.navigate_next)
                    ],
                  )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Text("Giới tính", style: Theme.of(context).textTheme.titleMedium),
                        Spacer(),
                        Text("Nam"),
                        Icon(Icons.navigate_next)
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mô tả", style: Theme.of(context).textTheme.titleMedium),
                        Spacer(),
                        Container(
                            constraints: BoxConstraints(
                              maxWidth: 200,
                              maxHeight: 40
                            ),
                            child: Text("Một đoạn văn bản rất dài Một đoạn văn bản rất dài Một đoạn văn bản rất dài",
                              maxLines: 2, overflow: TextOverflow.ellipsis)
                        ),
                        Icon(Icons.navigate_next)
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Text("Thành phố", style: Theme.of(context).textTheme.titleMedium),
                        Spacer(),
                        Text("Hà Nội"),
                        Icon(Icons.navigate_next)
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Text("Quốc gia", style: Theme.of(context).textTheme.titleMedium),
                        Spacer(),
                        Text("Việt Nam"),
                        Icon(Icons.navigate_next)
                      ],
                    )
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SkinInfoScreen()));
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Text("Thông tin loại da", style: Theme.of(context).textTheme.titleMedium),
                          Spacer(),
                          Text("Da khô"),
                          Icon(Icons.navigate_next)
                        ],
                      )
                  ),
                ),
              ],
            ),
        )
      ),
    );
  }
}
