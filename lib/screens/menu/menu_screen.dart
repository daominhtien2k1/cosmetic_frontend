import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:cosmetic_frontend/screens/menu/sub_screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/personal_info/personal_info_bloc.dart';
import '../../blocs/personal_info/personal_info_event.dart';
import '../../blocs/personal_info/personal_info_state.dart';

import './widgets/menu_widgets.dart';
import './sub_screens/menu_subscreens.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return Scaffold(
              appBar: AppBar(
                leading: Icon(Icons.menu),
                title: Text("Cá nhân"),
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.chat_outlined))
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 38.0,
                                    backgroundColor: Colors.black12,
                                    child: CircleAvatar(
                                      radius: 36.0,
                                      backgroundColor: Colors.grey[200],
                                      backgroundImage: CachedNetworkImageProvider(userInfo.avatar),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 28),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text("4", style: Theme.of(context).textTheme.titleLarge),
                                        Text("Bài viết", style: Theme.of(context).textTheme.titleMedium)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("5", style: Theme.of(context).textTheme.titleLarge),
                                        Text("Đánh giá", style: Theme.of(context).textTheme.titleMedium)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text("4", style: Theme.of(context).textTheme.titleLarge),
                                        Text("Lượt thích", style: Theme.of(context).textTheme.titleMedium)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ),
                        Text(userInfo.name, style: Theme.of(context).textTheme.bodyMedium),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton.tonal(
                                onPressed: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChangeProfileScreen()));
                                },
                                child: Text("Chỉnh sửa thông tin")
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("Bạn có", style: Theme.of(context).textTheme.titleMedium),
                                  SizedBox(height: 8),
                                  Text("${userInfo.point}", style: Theme.of(context).textTheme.titleLarge),
                                  SizedBox(height: 8),
                                  Text("Điểm khả dụng >", style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Cấp bậc", style: Theme.of(context).textTheme.titleMedium),
                                  SizedBox(height: 8),
                                  Text("Lv. ${userInfo.level}", style: Theme.of(context).textTheme.titleLarge),
                                  SizedBox(height: 8),
                                  Text("Cần 50P để đạt Lv.2", style: Theme.of(context).textTheme.titleMedium),
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.bookmarks_outlined),
                            SizedBox(width: 16),
                            Text("Sản phẩm đánh dấu", style: Theme.of(context).textTheme.titleMedium)
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined),
                            SizedBox(width: 16),
                            Text("Sản phẩm đã xem", style: Theme.of(context).textTheme.titleMedium)
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.favorite_outline),
                            SizedBox(width: 16),
                            Text("Sản phẩm yêu thích", style: Theme.of(context).textTheme.titleMedium)
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.comment_bank_outlined),
                            SizedBox(width: 16),
                            Text("Sản phẩm đã đánh giá", style: Theme.of(context).textTheme.titleMedium)
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.storefront),
                            SizedBox(width: 16),
                            Text("Danh sách cửa hàng", style: Theme.of(context).textTheme.titleMedium)
                          ],
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(Icons.settings_outlined),
                                SizedBox(width: 16),
                                Text("Cài đặt", style: Theme.of(context).textTheme.titleMedium)
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context).add(Logout());
                            // dù câu lệnh ở đằng sau nhưng vì là bất đồng bộ nên vẫn là AuthStatus.authenticated
                            // print("Logout getUser: " + user.toString());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(width: 16),
                                Text("Đăng xuất", style: Theme.of(context).textTheme.titleMedium)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
      }
    );
  }
}
