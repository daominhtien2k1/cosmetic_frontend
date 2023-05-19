import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({Key? key}) : super(key: key);

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  // Uint8List? imageData;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   loadAsset("event1.png");
  // }
  //
  // void loadAsset(String name) async {
  //   var data = await rootBundle.load('assets/images/$name');
  //   setState(() => imageData = data.buffer.asUint8List());
  // }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Viết đánh giá"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      // hoặc là bỏ height thì height được tính auto theo tỉ lệ
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.network("https://res.cloudinary.com/dnway4ykc/image/upload/v1684423022/datn/images/fubuztyzaochpcthodyb.jpg",)
                      )
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      child: Container(
                        child: Text("Nước cân bằng da Klairs Suppl Preparation",
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Đặt tiêu đề cho đánh giá này",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tóm tắt ngắn gọn về cảm nhận của bạn',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Cảm nhận của bạn về sản phẩm",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Bạn có thể chia sẻ cảm nhận của bạn về sản phẩm của chúng tôi',
                        hintMaxLines: 2,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Chia sẻ vài bức ảnh cho sản phẩm",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () async {
                  },
                  child: DashedBorderContainer(
                    width: 80,
                    height: 80,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Center(
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

