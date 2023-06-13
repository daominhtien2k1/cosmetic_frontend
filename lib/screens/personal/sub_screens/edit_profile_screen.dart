import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/personal_widgets.dart';
import '../../../blocs/personal_info/personal_info_bloc.dart';
import '../../../blocs/personal_info/personal_info_event.dart';
import '../../../blocs/personal_info/personal_info_state.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  void setName(BuildContext context)  {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập tên'),
            content: TextField(
              onChanged: (value) {

              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Tên"),
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  BlocProvider.of<PersonalInfoBloc>(context).add(SetNameUser(name: _textFieldController.value.text));
                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                  Navigator.pop(context);
                },
                child: Text('Xác nhận',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }
  void setDescription(BuildContext context)  {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập mô tả'),
            content: TextField(
              onChanged: (value) {
                // name =
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Mô tả"),
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  BlocProvider.of<PersonalInfoBloc>(context).add(SetDescriptionUser(description: _textFieldController.value.text));
                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                  Navigator.pop(context);
                },
                child: Text('Xác nhận'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }
  void setCity(BuildContext context)  {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập thành phố'),
            content: TextField(
              onChanged: (value) {

              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Tên"),
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  BlocProvider.of<PersonalInfoBloc>(context).add(SetCityUser(city: _textFieldController.value.text));
                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                  Navigator.pop(context);
                },
                child: Text('Xác nhận'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }
  void setCountry(BuildContext context)  {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập quốc gia'),
            content: TextField(
              onChanged: (value) {
                // name =
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Tên"),
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  BlocProvider.of<PersonalInfoBloc>(context).add(SetCountryUser(country: _textFieldController.value.text));
                  BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                  Navigator.pop(context);
                },
                child: Text('Xác nhận'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Chỉnh sửa trang cá nhân'),
      ),
      body: BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
          builder: (context, state) {
            final userInfo = state.userInfo;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Ảnh đại diện", style: Theme.of(context).textTheme.titleLarge),
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AvatarBottomSheet());
                              },
                              child: Text("Chỉnh sửa"),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 80.0,
                          backgroundImage: CachedNetworkImageProvider(userInfo.avatar),
                        )
                      ],
                    ),
                )),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 8,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Ảnh bìa", style: Theme.of(context).textTheme.titleLarge),
                              TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => CoverBottomSheet());
                                },
                                child: Text("Chỉnh sửa"),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            height: 220.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(userInfo.coverImage),
                                  fit: BoxFit.cover,
                                )),
                          )
                        ],
                      ),
                    )),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 8,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mô tả", style: Theme.of(context).textTheme.titleLarge),
                            TextButton(
                                onPressed: () {
                                  setDescription(context);
                                },
                                child: Text("Chỉnh sửa")
                            )
                          ],
                        ),
                        Text(userInfo.description)
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 8,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tên hiển thị", style: Theme.of(context).textTheme.titleLarge),
                            TextButton(
                                onPressed: () {
                                  setName(context);
                                },
                                child: Text("Chỉnh sửa")
                            ),
                          ],
                        ),
                        Text(userInfo.name, style: Theme.of(context).textTheme.titleLarge)
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 8,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Thành phố", style: Theme.of(context).textTheme.titleLarge),
                            TextButton(
                                onPressed: () {
                                  setCity(context);
                                },
                                child: Text("Chỉnh sửa")
                            )
                          ],
                        ),
                        Text(userInfo.city, style: Theme.of(context).textTheme.titleLarge)
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(
                    height: 8,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Quốc gia", style: Theme.of(context).textTheme.titleLarge),
                            TextButton(
                                onPressed: () {
                                  setCountry(context);
                                },
                                child: Text("Chỉnh sửa")
                            )
                          ],
                        ),
                        Text(userInfo.country, style: Theme.of(context).textTheme.titleLarge)
                      ],
                    ),
                  ),
                )
              ],
            );
        }
      ),
    );
  }
}




