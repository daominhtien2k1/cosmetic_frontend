import 'package:cosmetic_frontend/blocs/personal_info/personal_info_bloc.dart';
import 'package:cosmetic_frontend/blocs/personal_info/personal_info_event.dart';
import 'package:cosmetic_frontend/blocs/personal_info/personal_info_state.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostInfo extends StatelessWidget {
  final String? status;
  final void Function(String) onHandleSetClassification;
  PostInfo({Key? key, this.status, required this.onHandleSetClassification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("#Post_info: $status");
    BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
    return BlocBuilder<PersonalInfoBloc, PersonalInfoState>(
        builder: (context, state) {
        final userInfo = state.userInfo;
        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(text: '${userInfo.name}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            if(status != null) TextSpan(text: ' hiện đang cảm thấy ',  style: TextStyle(color: Colors.black, fontSize: 16)),
                            if(status != null) TextSpan(text: '$status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis
                      ),
                      SizedBox(height: 8),
                      ClassificationButton(onHandleSetClassification: onHandleSetClassification)
                    ],
                  ),
                ),
              )
            ]
          )
        );
      }
    );
  }


}

class ClassificationButton extends StatefulWidget {
  final void Function(String) onHandleSetClassification;

  const ClassificationButton({
    super.key,
    required this.onHandleSetClassification
  });

  @override
  State<ClassificationButton> createState() => _ClassificationButtonState();
}

class _ClassificationButtonState extends State<ClassificationButton> {
  final List<String> list = <String>['Chung', 'Góc hỏi đáp', 'Chia sẻ kinh nghiệm'];
  String dropdownValue = 'Chung';

  @override
  Widget build(BuildContext context) {
    // return TextButton(
    //     style: OutlinedButton.styleFrom(
    //       side: const BorderSide(color: Colors.black45),
    //       foregroundColor: Colors.black45,
    //       splashFactory: NoSplash.splashFactory,
    //       padding: EdgeInsets.all(12)
    //     ),
    //     onPressed: () {},
    //     child: Text('Góc hỏi đáp')
    // );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(30)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          elevation: 1,
          style: TextStyle(color: Theme.of(context).colorScheme.surfaceTint),
          // underline: Container(
          //   height: 2,
          //   color: Colors.deepPurpleAccent,
          // ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
            widget.onHandleSetClassification(value!);
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
