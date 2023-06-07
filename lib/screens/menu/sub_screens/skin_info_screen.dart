import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    skinType = "Da dầu";
    isSensitive = false;
    hasAcne = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Thông tin loại da'),
        actions: [
          TextButton(onPressed: (){}, child: Text("Lưu", style: Theme.of(context).textTheme.titleLarge))
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
                SkinTypeList(),
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
                Sensitive(),
                SizedBox(height: 12),
                Acne(),
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
                  child: Text("Test Baumann", style: Theme.of(context).textTheme.titleLarge?.copyWith(decoration: TextDecoration.underline) ),
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
  @override
  _SkinTypeListState createState() => _SkinTypeListState();
}

class _SkinTypeListState extends State<SkinTypeList> {
  String selectedSkinType = '';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        CosmeticTypeChip(
          label: 'Da thường',
          isSelected: selectedSkinType == 'Da thường',
          onSelected: (isSelected) {
            setState(() {
              selectedSkinType = isSelected ? 'Da thường' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da dầu',
          isSelected: selectedSkinType == 'Da dầu',
          onSelected: (isSelected) {
            setState(() {
              selectedSkinType = isSelected ? 'Da dầu' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da khô',
          isSelected: selectedSkinType == 'Da khô',
          onSelected: (isSelected) {
            setState(() {
              selectedSkinType = isSelected ? 'Da khô' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da thiên dầu',
          isSelected: selectedSkinType == 'Da thiên dầu',
          onSelected: (isSelected) {
            setState(() {
              selectedSkinType = isSelected ? 'Da thiên dầu' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da thiên khô',
          isSelected: selectedSkinType == 'Da thiên khô',
          onSelected: (isSelected) {
            setState(() {
              selectedSkinType = isSelected ? 'Da thiên khô' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da nhạy cảm',
          isSelected: selectedSkinType == 'Da nhạy cảm',
          onSelected: (isSelected) {
            setState(() {
              selectedSkinType = isSelected ? 'Da nhạy cảm' : '';
            });
          },
        ),
        CosmeticTypeChip(
          label: 'Da hỗn hợp',
          isSelected: selectedSkinType == 'Da hỗn hợp',
          onSelected: (isSelected) {
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
  @override
  _SensitiveState createState() => _SensitiveState();
}

class _SensitiveState extends State<Sensitive> {
  String selectedSensitiveType = '';

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
                isSelected: selectedSensitiveType == 'Khỏe',
                onSelected: (isSelected) {
                  setState(() {
                    selectedSensitiveType = isSelected ? 'Khỏe' : '';
                  });
                },
              ),
              CosmeticTypeChip(
                label: 'Nhạy cảm',
                isSelected: selectedSensitiveType == 'Nhạy cảm',
                onSelected: (isSelected) {
                  setState(() {
                    selectedSensitiveType = isSelected ? 'Nhạy cảm' : '';
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
  @override
  _AcneState createState() => _AcneState();
}

class _AcneState extends State<Acne> {
  String selectedAcneType = '';

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
                isSelected: selectedAcneType == 'Không',
                onSelected: (isSelected) {
                  setState(() {
                    selectedAcneType = isSelected ? 'Không' : '';
                  });
                },
              ),
              CosmeticTypeChip(
                label: 'Có',
                isSelected: selectedAcneType == 'Có',
                onSelected: (isSelected) {
                  setState(() {
                    selectedAcneType = isSelected ? 'Có' : '';
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