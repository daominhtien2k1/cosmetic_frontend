import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmetic_frontend/blocs/personal_info/personal_info_event.dart';
import 'package:cosmetic_frontend/models/models.dart';
import 'package:cosmetic_frontend/screens/menu/sub_screens/test_baumann_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/personal_info/personal_info_bloc.dart';

class SkinInfoScreen extends StatefulWidget {

  @override
  State<SkinInfoScreen> createState() => _SkinInfoScreenState();
}

class _SkinInfoScreenState extends State<SkinInfoScreen> {
  late String skinType;
  late bool isSensitive;
  late bool hasAcne;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userInfo = BlocProvider.of<PersonalInfoBloc>(context).state.userInfo;
    skinType = userInfo.skin.type;
    isSensitive = userInfo.skin.obstacle.isSensitive;
    hasAcne = userInfo.skin.obstacle.hasAcne;
  }

  void onChangeSkinType(String skinType) {
    setState(() {
      this.skinType = skinType;
    });
  }

  void onChangeIsSensitive(bool isSensitive) {
    setState(() {
      this.isSensitive = isSensitive;
    });
  }


  void onChangeHasAcne(bool hasAcne) {
    setState(() {
      this.hasAcne = hasAcne;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Thông tin loại da'),
        actions: [
          TextButton(onPressed: (){
            final newSkin = Skin(obstacle: Obstacle(isSensitive: isSensitive, hasAcne: hasAcne), type: skinType);
            BlocProvider.of<PersonalInfoBloc>(context).add(SetSkinUser(skin: newSkin));
            BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
            Navigator.of(context).pop();
          }, child: Text("Lưu", style: Theme.of(context).textTheme.titleLarge))
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Row(
                      children: [
                        Text("Da của bạn thuộc loại da gì?", style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    )
                ),
                SkinTypeList(selectedSkinType: skinType, onChangeSkinType: onChangeSkinType),
                SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Container(
                      child: Row(
                        children: [
                          Flexible(child: Text("Bạn có gặp vấn đề da nào dưới đây không?", style: Theme.of(context).textTheme.headlineSmall)),
                        ],
                      ),
                    )
                ),
                SizedBox(height: 8),
                Sensitive(isSensitive: isSensitive, onChangeIsSensitive: onChangeIsSensitive),
                SizedBox(height: 12),
                Acne(hasAcne: hasAcne, onChangeHasAcne: onChangeHasAcne),
                SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 320,
                    child: Text("Nếu bạn chưa biết da mình thuộc loại da nào, hãy cùng Cosmetica làm bài test Baumann để có thể xác định được loại da của bạn nha!"
                        ,style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (builder) => TestBaumannScreen()));
                    },
                    child: Text("Test Baumann",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(decoration: TextDecoration.underline))
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          )
      ),
    );
  }
}

class SkinTypeList extends StatefulWidget {
  final String selectedSkinType;
  void Function(String) onChangeSkinType;

  SkinTypeList({required this.selectedSkinType, required this.onChangeSkinType});

  @override
  _SkinTypeListState createState() => _SkinTypeListState();
}

class _SkinTypeListState extends State<SkinTypeList> {
  String selectedSkinType = '';

  @override
  void initState() {
    selectedSkinType = widget.selectedSkinType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        CosmeticTypeChip(
          label: 'Da thường',
          isSelected: selectedSkinType == 'Da thường',
          onSelected: (isSelected) {
            widget.onChangeSkinType('Da thường');
            setState(() {
              selectedSkinType = isSelected ? 'Da thường' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da dầu',
          isSelected: selectedSkinType == 'Da dầu',
          onSelected: (isSelected) {
            widget.onChangeSkinType('Da dầu');
            setState(() {
              selectedSkinType = isSelected ? 'Da dầu' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da khô',
          isSelected: selectedSkinType == 'Da khô',
          onSelected: (isSelected) {
            widget.onChangeSkinType('Da khô');
            setState(() {
              selectedSkinType = isSelected ? 'Da khô' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da thiên dầu',
          isSelected: selectedSkinType == 'Da thiên dầu',
          onSelected: (isSelected) {
            widget.onChangeSkinType('Da thiên dầu');
            setState(() {
              selectedSkinType = isSelected ? 'Da thiên dầu' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da thiên khô',
          isSelected: selectedSkinType == 'Da thiên khô',
          onSelected: (isSelected) {
            widget.onChangeSkinType('Da thiên khô');
            setState(() {
              selectedSkinType = isSelected ? 'Da thiên khô' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da nhạy cảm',
          isSelected: selectedSkinType == 'Da nhạy cảm',
          onSelected: (isSelected) {
            widget.onChangeSkinType('Da nhạy cảm');
            setState(() {
              selectedSkinType = isSelected ? 'Da nhạy cảm' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da hỗn hợp',
          isSelected: selectedSkinType == 'Da hỗn hợp',
          onSelected: (isSelected) {
            widget.onChangeSkinType('Da hỗn hợp');
            setState(() {
              selectedSkinType = isSelected ? 'Da hỗn hợp' : '';
            });
          },
        ),
      ],
    );
  }
}

class CosmeticTypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CosmeticTypeChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).primaryColor,
      selectedShadowColor: Colors.grey,
      checkmarkColor: Colors.white,
      showCheckmark: true,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.5),
          width: 2.0,
        ),
      ),
    );
  }
}

class Sensitive extends StatefulWidget {
  final bool isSensitive;
  void Function(bool) onChangeIsSensitive;

  Sensitive({required this.isSensitive, required this.onChangeIsSensitive});

  @override
  _SensitiveState createState() => _SensitiveState();
}

class _SensitiveState extends State<Sensitive> {
  bool isSensitive = false;

  @override
  void initState() {
    isSensitive = widget.isSensitive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Nhạy cảm?", style: Theme.of(context).textTheme.titleLarge),
          Wrap(
            spacing: 8.0,
            children: [
              CosmeticTypeChip(
                label: 'Khỏe',
                isSelected: isSensitive == false,
                onSelected: (isSelected) {
                  widget.onChangeIsSensitive(!isSensitive);
                  setState(() {
                    isSensitive = !isSensitive;
                  });
                },
              ),
              CosmeticTypeChip(
                label: 'Nhạy cảm',
                isSelected: isSensitive == true,
                onSelected: (isSelected) {
                  widget.onChangeIsSensitive(!isSensitive);
                  setState(() {
                    isSensitive = !isSensitive;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Acne extends StatefulWidget {
  bool hasAcne;
  void Function(bool) onChangeHasAcne;

  Acne({required this.hasAcne, required this.onChangeHasAcne});

  @override
  _AcneState createState() => _AcneState();
}

class _AcneState extends State<Acne> {
  bool hasAcne = false;

  @override
  void initState() {
    hasAcne = widget.hasAcne;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Có mụn?", style: Theme.of(context).textTheme.titleLarge),
          Wrap(
            spacing: 8.0,
            children: [
              CosmeticTypeChip(
                label: 'Không',
                isSelected: hasAcne == false,
                onSelected: (isSelected) {
                  widget.onChangeHasAcne(!hasAcne);
                  setState(() {
                    hasAcne = !hasAcne;
                  });
                },
              ),
              CosmeticTypeChip(
                label: 'Có',
                isSelected: hasAcne == true,
                onSelected: (isSelected) {
                  widget.onChangeHasAcne(!hasAcne);
                  setState(() {
                    hasAcne = !hasAcne;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}