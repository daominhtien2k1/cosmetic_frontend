import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_frontend/screens/menu/sub_screens/menu_subscreens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/personal_info/personal_info_bloc.dart';
import '../../../blocs/personal_info/personal_info_event.dart';
import '../../../blocs/personal_info/personal_info_state.dart';

class ChangeProfileScreen extends StatelessWidget {
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

  setGender(BuildContext context, {required String gender}) {
    showDialog(
        context: context,
        builder: (context) {
          return GenderChoiceDialog(gender: gender);
    }).then((newGender) { // trước đây là chuyển từ tiếng việt sang tiếng anh
      if (newGender != null) {
        final String newGenderText;
        switch (newGender) {
          case "Bí mật":
            newGenderText = "Bí mật";
            break;
          case "Nam":
            newGenderText = "Nam";
            break;
          case "Nữ":
            newGenderText = "Nữ";
            break;
          default:
            newGenderText = "Bí mật";
            break;
        }
        BlocProvider.of<PersonalInfoBloc>(context).add(SetGenderUser(gender: newGenderText));
        BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
      }
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
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
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
                                  backgroundImage: CachedNetworkImageProvider(userInfo.avatar),
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
                        child: InkWell(
                          onTap: () {
                            setName(context);
                          },
                          child: Row(
                            children: [
                              Text("Họ và tên", style: Theme.of(context).textTheme.titleMedium),
                              Spacer(),
                              Text(userInfo.name),
                              Icon(Icons.navigate_next)
                            ],
                          ),
                        )
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: InkWell(
                            onTap: () {
                              setGender(context, gender: userInfo.gender);
                            },
                            child: Row(
                              children: [
                                Text("Giới tính", style: Theme.of(context).textTheme.titleMedium),
                                Spacer(),
                                Text(userInfo.gender),
                                Icon(Icons.navigate_next)
                              ],
                            ),
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: InkWell(
                            onTap: () {
                              setDescription(context);
                            },
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
                                    child: Text(userInfo.description,
                                      maxLines: 2, overflow: TextOverflow.ellipsis)
                                ),
                                Icon(Icons.navigate_next)
                              ],
                            ),
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: InkWell(
                            onTap: () {
                              setCity(context);
                            },
                            child: Row(
                              children: [
                                Text("Thành phố", style: Theme.of(context).textTheme.titleMedium),
                                Spacer(),
                                Text(userInfo.city),
                                Icon(Icons.navigate_next)
                              ],
                            ),
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: InkWell(
                            onTap: () {
                              setCity(context);
                            },
                            child: Row(
                              children: [
                                Text("Quốc gia", style: Theme.of(context).textTheme.titleMedium),
                                Spacer(),
                                Text(userInfo.country),
                                Icon(Icons.navigate_next)
                              ],
                            ),
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
                                Text(userInfo.skin.type),
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
    );
  }
}


class GenderChoiceDialog extends StatefulWidget {
  final String gender;

  GenderChoiceDialog({Key? key, required this.gender}) : super(key: key);

  @override
  GenderChoiceDialogState createState() => GenderChoiceDialogState();
}

class GenderChoiceDialogState extends State<GenderChoiceDialog>{
  String selectedGender = "Bí mật";
  List<String> gender = [
    "Bí mật", "Nam", "Nữ"
  ];

  @override
  void initState() {
    selectedGender = widget.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    return AlertDialog(
      //title: TextStyleExample(name : 'Phone Ringtone',style : textTheme.titleMedium!.copyWith(color: MyColors.black, fontWeight: FontWeight.bold)),
      title: Text('Giới tính'),
      content: Wrap(
        children: gender.map((g) => RadioListTile(
          title: Text(g),
          groupValue: selectedGender,
          selected: g == selectedGender,
          value: g,
          onChanged: (dynamic val) {
            setState(() {
              selectedGender = val;
            });
          },
        )).toList(),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context, selectedGender);
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
  }
}