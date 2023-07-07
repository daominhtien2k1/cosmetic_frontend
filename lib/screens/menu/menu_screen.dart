import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_frontend/screens/menu/sub_screens/security_screen.dart';
import 'package:cosmetic_frontend/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/personal_info/personal_info_bloc.dart';
import '../../blocs/personal_info/personal_info_event.dart';
import '../../blocs/personal_info/personal_info_state.dart';

import '../../configuration.dart';
import '../../utils/token.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
                  IconButton(onPressed: () {

                  }, icon: Icon(Icons.chat_outlined))
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
                                child: FutureBuilder(
                                    future: statisticOverall(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasData) {
                                      final postCount = snapshot.data["data"]["postCount"];
                                      final reviewCount = snapshot.data["data"]["reviewCount"];
                                      final otherActivityCount = snapshot.data["data"]["otherActivityCount"];
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text("$postCount", style: Theme.of(context).textTheme.titleLarge),
                                              Text("Bài viết", style: Theme.of(context).textTheme.titleMedium)
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("$reviewCount", style: Theme.of(context).textTheme.titleLarge),
                                              Text("Đánh giá", style: Theme.of(context).textTheme.titleMedium)
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text("$otherActivityCount", style: Theme.of(context).textTheme.titleLarge),
                                              Tooltip(
                                                  message: 'Bao gồm comment, reply, ...',
                                                  triggerMode: TooltipTriggerMode.tap,
                                                  child: Text("Hoạt động", style: Theme.of(context).textTheme.titleMedium)
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    }
                                    return Center(child: Text("Error"));
                                  }
                                ),
                              ),
                              SizedBox(width: 8),
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
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryPointScreen()));
                                },
                                child: Column(
                                  children: [
                                    Text("Bạn có", style: Theme.of(context).textTheme.titleMedium),
                                    SizedBox(height: 8),
                                    Text("${userInfo.point}", style: Theme.of(context).textTheme.titleLarge),
                                    SizedBox(height: 8),
                                    Text("Điểm khả dụng >", style: Theme.of(context).textTheme.titleMedium),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryPointScreen()));
                                },
                                child: Column(
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
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductBookmarkScreen()));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.bookmarks_outlined),
                              SizedBox(width: 16),
                              Text("Sản phẩm đánh dấu", style: Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductViewScreen()));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.remove_red_eye_outlined),
                              SizedBox(width: 16),
                              Text("Sản phẩm đã xem", style: Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductLoveScreen()));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.favorite_outline),
                              SizedBox(width: 16),
                              Text("Sản phẩm yêu thích", style: Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
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
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => FollowedBrandScreen()));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.store_mall_directory_outlined),
                              SizedBox(width: 16),
                              Text("Thương hiệu đã theo dõi", style: Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Row(
                        //   children: [
                        //     Icon(Icons.storefront),
                        //     SizedBox(width: 16),
                        //     Text("Danh sách cửa hàng", style: Theme.of(context).textTheme.titleMedium)
                        //   ],
                        // ),
                        // SizedBox(height: 16),
                        Divider(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => SecurityScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(Icons.bug_report_outlined),
                                SizedBox(width: 16),
                                Text("Bảo mật và vi phạm", style: Theme.of(context).textTheme.titleMedium)
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context).add(Logout());
                            // dù câu lệnh ở đằng sau nhưng vì là bất đồng bộ nên vẫn là AuthStatus.authenticated
                            // print("Logout getUser: " + user.toString());
                            HydratedBloc.storage.clear();
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

  Future<Map<String, dynamic>?> statisticOverall() async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/statistic_overall');

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
