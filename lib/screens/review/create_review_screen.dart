import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../blocs/retrieve_review/retrieve_review_bloc.dart';
import '../../blocs/retrieve_review/retrieve_review_event.dart';
import '../../blocs/product_characteristic/product_characteristic_event.dart';
import '../../blocs/product_detail/product_detail_bloc.dart';
import '../../blocs/product_detail/product_detail_event.dart';
import '../../blocs/product_detail/product_detail_state.dart';
import '../../blocs/review/review_bloc.dart';
import '../../blocs/review/review_event.dart';
import '../../models/models.dart' hide Image;

import 'package:cosmetic_frontend/common/widgets/common_widgets.dart';
import 'package:cosmetic_frontend/constants/assets/placeholder.dart';
import 'package:cosmetic_frontend/routes.dart';


class StandardCreateReviewScreen extends StatefulWidget {
  const StandardCreateReviewScreen({
    super.key,

  });

  @override
  State<StandardCreateReviewScreen> createState() => _StandardCreateReviewScreenState();
}

class _StandardCreateReviewScreenState extends State<StandardCreateReviewScreen> {
  // có controller nên không cần thiết lắm
  late String title;
  late String content;

  String hasRestoredTitleAndContent = "Unknown";

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    print("#Create_review_screen: Rebuild");

    // chỉ có 1 kiểu push từ Quick review và có tham số nên chắc chắn là data!
    final Map<String, dynamic> data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String productId = data["productId"];
    final String productImageUrl = data["productImageUrl"];
    final String productName = data["productName"];
    final int rating = data["rating"];
    final String? oldTitle = data["oldTitle"];
    final String? oldContent = data["oldContent"];

    if (hasRestoredTitleAndContent == "Unknown") {
      setState(() {
        if (oldTitle != null) _titleController.text = oldTitle;
        if (oldContent != null) _contentController.text = oldContent;
        if (oldTitle != null && oldContent != null) {
          hasRestoredTitleAndContent = "Restore success";
        } else {
          hasRestoredTitleAndContent = "Fail";
        }
      });
    }

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
                              child: Image.network(productImageUrl)
                          )
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: Container(
                          child: Text(productName,
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
                      height: 86,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        controller: _titleController,
                        onSubmitted: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        textInputAction: TextInputAction.done,
                        maxLength: 100,
                        maxLines: 2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tóm tắt ngắn gọn về cảm nhận của bạn',
                          contentPadding: EdgeInsets.only(left: 16, right: 16, top: 4)
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
                        controller: _contentController,
                        onSubmitted: (value) {
                          setState(() {
                            content = value;
                          });
                        },
                        textInputAction: TextInputAction.done,
                        maxLength: 200,
                        maxLines: 6,
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
                Center(
                  child: Container(
                    width: 360,
                    padding: EdgeInsets.only(bottom: 8),
                    child: FilledButton.tonal(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        ),
                        onPressed: () {
                          String titleValue = _titleController.text ?? title;
                          String contentValue = _contentController.text ?? content;
                          BlocProvider.of<ReviewBloc>(context).add(StandardReviewAdd(productId: productId, classification: "Standard", rating: rating, title: titleValue, content: contentValue));
                          Navigator.popUntil(context, ModalRoute.withName(Routes.product_detail_screen));
                        },
                        child: Text("Hoàn thành đánh giá", style: TextStyle(fontSize: 18))
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );

  }
}

class QuickCreateReviewScreen extends StatefulWidget {
  final String productId;
  const QuickCreateReviewScreen({
    super.key,
    required this.productId
  });

  @override
  State<QuickCreateReviewScreen> createState() => _QuickCreateReviewScreenState();
}

class _QuickCreateReviewScreenState extends State<QuickCreateReviewScreen> {
  late int rating;

  // cập nhật lại giá trị 1 lần
  String hasRestoredRating = "Unknown";

  String? oldTitleToTransfer;
  String? oldContentToTransfer;
  List<CharacteristicReviewCriteria>? oldCharacteristicReviewsToTransfer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rating = 0;
  }

  changeRating(int rating) {
    setState(() {
      this.rating = rating;
    });
  }



  @override
  Widget build(BuildContext context) {
    // là ? vì push 2 kiểu từ 2 nơi, nên tham số khác nhau - Bởi vì push từ Fab không có arguments nên là Map?
    final Map<String, dynamic>? data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool? isEditReceive = data?["isEdit"];
    final int? oldRatingReceive = data?["oldRating"];
    final String? oldTitleReceive = data?["oldTitle"];
    final String? oldContentReceive = data?["oldContent"];
    final List<CharacteristicReviewCriteria>? oldCharacteristicReviewsReceive = data?["oldCharacteristicReviews"];

    // Chỉ gán lại một lần - Khôi phục dữ liệu khi ấn vào edit review
    if (isEditReceive == true && hasRestoredRating == "Unknown") {
        setState(() {
          if (oldRatingReceive != null) rating = oldRatingReceive!;
          if (oldTitleReceive != null) oldTitleToTransfer = oldTitleReceive;
          if (oldContentReceive != null) oldContentToTransfer = oldContentReceive;
          if (oldCharacteristicReviewsReceive != null) oldCharacteristicReviewsToTransfer = oldCharacteristicReviewsReceive;
        });


      hasRestoredRating = "Success restore from edit";
    }

    // Chỉ gán lại một lần - Khôi phục dữ liệu đã đánh giá khi ấn Fab
    if (rating == 0 && hasRestoredRating == "Unknown") {
      BlocProvider.of<RetrieveReviewBloc>(context).add(ReviewRetrieved(productId: widget.productId));
      final retrieveReviewState = context.watch<RetrieveReviewBloc>().state;
      final retrieveReview = retrieveReviewState.retrieveReview;
      if (retrieveReview != null) {
        setState(() {
          rating = retrieveReview.rating!;
          oldTitleToTransfer = retrieveReview.title;
          oldContentToTransfer = retrieveReview.content;
          oldCharacteristicReviewsToTransfer = retrieveReview.characteristicReviews;
          hasRestoredRating = "Success restore from FAB";
        });
      }
      // chưa tồn tại dữ liệu, lấy mặc định như lúc đầu, khiến cho không gọi lại Bloc add ReviewRetrieved
      else {
        setState(() {
          hasRestoredRating = "Fail";
        });
      }
    }

    // print("#Create_review_screen: Rebuild");
    // print("#Create_review_screen:  + $rating");
    // print("#Create_review_screen:  + $oldTitleToTransfer");
    // print("#Create_review_screen:  + $oldContentToTransfer");

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text("Viết đánh giá"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, state) {
                switch (state.productDetailStatus) {
                  case ProductDetailStatus.initial:
                    return Center(child: CircularProgressIndicator());
                  case ProductDetailStatus.loading:
                    return Center(child: CircularProgressIndicator());
                  case ProductDetailStatus.failure:
                    return Center(child: Text("Failed"));
                  case ProductDetailStatus.success: {
                    final productDetail = state.productDetail;
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 200,
                              height: 200,
                              // hoặc là bỏ height thì height được tính auto theo tỉ lệ
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Image.network(productDetail?.images[0].url ?? ImagePlaceHolder.imagePlaceHolderOnline)
                              )
                          ),
                          SizedBox(width: 16),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Text("${productDetail?.name}",
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: RatingStars(rating: rating, size: 32, onChangeRating: changeRating),
                          ),
                          Spacer(),
                          Container(
                            width: 360,
                            child: FilledButton.tonal(
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                ),
                                onPressed: rating != 0 ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => StandardCreateReviewScreen(),
                                      settings: RouteSettings(
                                          name: Routes.standard_create_review_screen,
                                          arguments: {
                                            "productId": widget.productId,
                                            "productImageUrl": productDetail?.images[0].url,
                                            "productName": productDetail?.name,
                                            "rating": rating,
                                            if (oldTitleToTransfer != null) "oldTitle": oldTitleToTransfer,
                                            if (oldContentToTransfer != null) "oldContent": oldContentToTransfer
                                          }
                                      ),
                                    ),
                                  );

                                } : null,
                                child: Text("Viết đánh giá tiêu chuẩn", style: TextStyle(fontSize: 18))
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: 360,
                            child: FilledButton.tonal(
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                ),
                                onPressed: rating != 0 ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DetailCreateReviewScreen(),
                                      settings: RouteSettings(
                                          name: Routes.detail_create_review_screen,
                                          arguments: {
                                            "productId": widget.productId,
                                            "productImageUrl": productDetail?.images[0].url,
                                            "productName": productDetail?.name,
                                            "rating": rating,
                                            if (oldTitleToTransfer != null) "oldTitle": oldTitleToTransfer,
                                            if (oldContentToTransfer != null) "oldContent": oldContentToTransfer,
                                            if (oldCharacteristicReviewsToTransfer != null) "oldCharacteristicReviews": oldCharacteristicReviewsToTransfer
                                          }
                                      ),
                                    ),
                                  );

                                } : null,
                                child: Text("Viết chi tiết đánh giá", style: TextStyle(fontSize: 18))
                            ),
                          ),
                          Container(
                            width: 360,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                ),
                                onPressed: rating != 0 ? () {
                                  BlocProvider.of<ReviewBloc>(context).add(QuickReviewAdd(productId: widget.productId, classification: "Quick", rating: rating));
                                  Navigator.popUntil(context, ModalRoute.withName(Routes.product_detail_screen));

                                  // BlocProvider.of<RetrieveReviewBloc>(context).add(ReviewRetrieved(productId: widget.productId));
                                } : null,
                                child: Text("Hoàn thành đánh giá", style: TextStyle(fontSize: 18))
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }
              }
          ),
        )
    );
  }
}

class InstructionCreateReviewScreen extends StatefulWidget {
  final String productId;

  const InstructionCreateReviewScreen({
    super.key,
    required this.productId
  });

  @override
  State<InstructionCreateReviewScreen> createState() => _InstructionCreateReviewScreenState();
}

class _InstructionCreateReviewScreenState extends State<InstructionCreateReviewScreen> {
  late String title;
  late TextEditingController _titleController;
  final QuillEditorController controller = QuillEditorController();

  String hasRestoredTitleAndContent = "Unknown";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    // là ? vì push 2 kiểu từ 2 nơi, nên tham số khác nhau
    final Map<String, dynamic>? data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool? isEditReceive = data?["isEdit"];
    final String? reviewIdReceive = data?["reviewId"];
    final String? oldTitleReceive = data?["oldTitle"];
    final String? oldContentReceive = data?["oldContent"];


    // Chỉ gán lại một lần - Khôi phục dữ liệu khi ấn vào edit review
    if (isEditReceive == true && hasRestoredTitleAndContent == "Unknown") {
      setState(() {
        if (oldTitleReceive != null) _titleController.text = oldTitleReceive;
        if (oldContentReceive != null) {
          // không được, không hiểu tại sao
          // print(oldContentReceive);
          // controller.setText(oldContentReceive);
          // controller.getText().then((value) => print("CCCC: + $value"));
        };

        if (oldTitleReceive != null && oldContentReceive != null && reviewIdReceive != null) {
          hasRestoredTitleAndContent = "Success restore from edit";
        } else {
          hasRestoredTitleAndContent = "Fail";
        }
      });
    }


    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text("Hướng dẫn và chia sẻ cảm nhận"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, state) {
                switch (state.productDetailStatus) {
                  case ProductDetailStatus.initial:
                    return Center(child: CircularProgressIndicator());
                  case ProductDetailStatus.loading:
                    return Center(child: CircularProgressIndicator());
                  case ProductDetailStatus.failure:
                    return Center(child: Text("Failed"));
                  case ProductDetailStatus.success: {
                      final productDetail = state.productDetail;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
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
                                          child: Image.network(productDetail?.images[0].url ?? ImagePlaceHolder.imagePlaceHolderOnline)
                                      )
                                  ),
                                  SizedBox(width: 16),
                                  Flexible(
                                    child: Container(
                                      child: Text("${productDetail?.name}",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .titleLarge,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Tiêu đề",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(16),
                                child: Container(
                                  height: 86,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: TextField(
                                    controller: _titleController,
                                    onSubmitted: (value) {
                                      setState(() {
                                        title = value;
                                      });
                                    },
                                    textInputAction: TextInputAction.done,
                                    maxLength: 100,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Tóm tắt ngắn gọn về cảm nhận của bạn',
                                        contentPadding: EdgeInsets.only(
                                            left: 16, right: 16, top: 8)
                                    ),
                                  ),
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("Nội dung",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: ContentHtmlEditor(controller: controller, oldContent: oldContentReceive)
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 360,
                                padding: EdgeInsets.only(bottom: 20, top: 20),
                                child: FilledButton.tonal(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    ),
                                    onPressed: () async {
                                      String content = await controller.getText();
                                      // print(content);
                                      if (isEditReceive == null) { // nếu là tạo mới
                                        BlocProvider.of<ReviewBloc>(context).add(InstructionReviewAdd(productId: widget.productId, classification: "Instruction", title: title, content: content));
                                      }
                                    else if (isEditReceive == true && reviewIdReceive != null){ // nếu là edit
                                        BlocProvider.of<ReviewBloc>(context).add(InstructionReviewEdit(reviewId: reviewIdReceive, title: title, content: content));
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Text("Hoàn thành", style: TextStyle(fontSize: 18))
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                }
              }
          ),
        )
    );

  }
}

class ContentHtmlEditor extends StatefulWidget {
  final QuillEditorController controller;
  final String? oldContent;
  ContentHtmlEditor({Key? key, required this.controller, this.oldContent}) : super(key: key);

  @override
  State<ContentHtmlEditor> createState() => _ContentHtmlEditorState();
}

class _ContentHtmlEditorState extends State<ContentHtmlEditor> {
  late QuillEditorController controller;

  final customToolBarList = [
    ToolBarStyle.undo,
    ToolBarStyle.redo,
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.underline,
    ToolBarStyle.size,
    ToolBarStyle.align,
    ToolBarStyle.image,
    ToolBarStyle.video,
    ToolBarStyle.link,

    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
  ];

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.grey.shade100;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = TextStyle(
      fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal);
  final _hintTextStyle = TextStyle(
      fontSize: 14, color: Colors.black87, fontWeight: FontWeight.normal);

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    // controller.onTextChanged((text) {
    //   // print('listening to $text');
    // });
  }

  // không được, init state cũng không được
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   if (mounted) {
  //     if (widget.oldContent != null) {
  //       controller.setText(widget.oldContent!);
  //     }
  //   }
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Widget textButton({required String text, required VoidCallback onPressed}) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: MaterialButton(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //         color: _toolbarIconColor,
  //         onPressed: onPressed,
  //         child: Text(
  //           text,
  //           style: TextStyle(color: _toolbarColor),
  //         )),
  //   );
  // }
  //
  // void getHtmlText() async {
  //   String? htmlText = await controller.getText();
  // }
  //
  // void setHtmlText(String text) async {
  //   await controller.setText(text);
  // }
  //
  // void insertNetworkImage(String url) async {
  //   await controller.embedImage(url);
  // }
  //
  // void insertVideoURL(String url) async {
  //   await controller.embedVideo(url);
  // }
  //
  //
  // void insertHtmlText(String text, {int? index}) async {
  //   await controller.insertText(text, index: index);
  // }
  //
  // void clearEditor() => controller.clear();
  //
  // void enableEditor(bool enable) => controller.enableEditor(enable);
  //
  // void unFocusEditor() => controller.unFocus();

  @override
  Widget build(BuildContext context) {
    // controller.setText("Không cần sử dụng await nên không thêm async vào method chứa nó");
    // controller.getText().then((value) => print(value));

    // print("Rebuild");
    
    return Container(
      height: 400,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ToolBar.scroll(
              toolBarColor: _toolbarColor,
              padding: const EdgeInsets.all(8),
              iconSize: 25,
              iconColor: _toolbarIconColor,
              activeIconColor: Colors.pinkAccent,
              controller: controller,
              // crossAxisAlignment: WrapCrossAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              direction: Axis.horizontal,
              // toolBarConfig: customToolBarList,
              customButtons: [
                // InkWell(
                //     onTap: () => unFocusEditor(),
                //     child: const Icon(
                //       Icons.favorite,
                //       color: Colors.black,
                //     )),
                // InkWell(
                //     onTap: () async {
                //       var selectedText = await controller.getSelectedText();
                //       // print('selectedText: $selectedText');
                //       var selectedHtmlText = await controller.getSelectedHtmlText();
                //       // print('selectedHtmlText: $selectedHtmlText');
                //     },
                //     child: const Icon(
                //       Icons.add_circle,
                //       color: Colors.black,
                //     )),
                InkWell(
                    onTap: () {
                      controller.setText(widget.oldContent!);
                    },
                    child: const Icon(
                      Icons.start,
                      color: Colors.black,
                    )),
              ],
            ),
            Flexible(
              fit: FlexFit.tight,
              child: QuillHtmlEditor(
                text: widget.oldContent != null ? widget.oldContent : null,
                hintText: '', // có chữ sẽ bị lỗi khi nhập xong
                controller: controller,
                isEnabled: true,
                minHeight: 500,
                textStyle: _editorTextStyle,
                hintTextStyle: _hintTextStyle,
                hintTextAlign: TextAlign.start,
                padding: const EdgeInsets.only(left: 10, top: 10),
                hintTextPadding: const EdgeInsets.only(left: 20),
                backgroundColor: _backgroundColor,
                // onFocusChanged: (hasFocus) {
                //   // print('has focus $hasFocus');
                // },
                // onTextChanged: (text) {
                //
                // },
                // onEditorCreated: () {
                //
                // },
                // onEditorResized: (height) {
                //   // print('Editor resized $height');
                // },
                // onSelectionChanged: (sel) {
                //   // print('index ${sel.index}, range ${sel.length}'),
                // }

              ),
            ),
          ]
      ),
    );
  }
}

class DetailCreateReviewScreen extends StatefulWidget {

  const DetailCreateReviewScreen({
    super.key,
  });

  @override
  State<DetailCreateReviewScreen> createState() => _DetailCreateReviewScreenState();
}

class _DetailCreateReviewScreenState extends State<DetailCreateReviewScreen> {
  late String title;
  late String content;

  String hasRestoredTitleAndContent = "Unknown";

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String productId = data["productId"];
    final String productImageUrl = data["productImageUrl"];
    final String productName = data["productName"];
    final int rating = data["rating"];
    final String? oldTitle = data["oldTitle"];
    final String? oldContent = data["oldContent"];
    final List<CharacteristicReviewCriteria>? oldCharacteristicReviews = data["oldCharacteristicReviews"];

    if (hasRestoredTitleAndContent == "Unknown") {
      setState(() {
        if (oldTitle != null) _titleController.text = oldTitle;
        if (oldContent != null) _contentController.text = oldContent;
        if (oldTitle != null && oldContent != null) {
          hasRestoredTitleAndContent = "Restore success";
        } else {
          hasRestoredTitleAndContent = "Fail";
        }
      });
    }

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
                              child: Image.network(productImageUrl)
                          )
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: Container(
                          child: Text(productName,
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
                      height: 86,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        controller: _titleController,
                        onSubmitted: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        textInputAction: TextInputAction.done,
                        maxLength: 100,
                        maxLines: 2,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Tóm tắt ngắn gọn về cảm nhận của bạn',
                            contentPadding: EdgeInsets.only(left: 16, right: 16, top: 4)
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
                        controller: _contentController,
                        onSubmitted: (value) {
                          setState(() {
                            content = value;
                          });
                        },
                        textInputAction: TextInputAction.done,
                        maxLength: 200,
                        maxLines: 6,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Quay lại", style: TextStyle(fontSize: 18))
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: FilledButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            ),
                            onPressed: () {
                              String titleValue = _titleController.text ?? title;
                              String contentValue = _contentController.text ?? content;
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CharacteristicReviewScreen(),
                                  settings: RouteSettings(
                                    name: Routes.characteristic_review_screen,
                                    arguments: {
                                      "productId": productId,
                                      "rating": rating,
                                      "title": titleValue,
                                      "content": contentValue,
                                      if (oldCharacteristicReviews != null) "oldCharacteristicReviews": oldCharacteristicReviews
                                    }
                                  ),
                                ),
                              );
                            },
                            child: Text("Tiếp", style: TextStyle(fontSize: 18))
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        )
    );

  }
}

// chưa làm phần đánh giá chi tiết đặc trưng, gây ra lỗi diện rộng, nó biến thành review product của cái khác
class CharacteristicReviewScreen extends StatelessWidget {
  CharacteristicReviewScreen({Key? key}) : super(key: key);

  // có thể sản phẩm không có tiêu chí nào --> trong code admin là mỗi khi tạo 1 sản phẩm thì nên có 4 tiêu chí mặc định
  List<CharacteristicReviewCriteria>? characteristicReviewCriterias = [];

  initOrRestoreScoredCharacteristicReviews(BuildContext context, {List<CharacteristicReviewCriteria>? oldCharacteristicReviews}) {
    if (oldCharacteristicReviews != null) {
      print("Được chuyển data retrieve từ Quick sang");
      print(oldCharacteristicReviews);
      // logic là retrieve, nhưng không cần gọi lại, vì retrieve từ quick rồi và chuyển đến đây. Cần thiết gọi lại cũng được nếu setState xảy ra vấn đề
      characteristicReviewCriterias = oldCharacteristicReviews;
    } else {
      print("Khởi tạo giá trị nếu như không có data retrieve");
      // nên gọi get_list_characteristics ở đây để khởi tạo danh sách thuộc tính
      final productDetailState = BlocProvider.of<ProductDetailBloc>(context).state;
      final characteristicCriterias = productDetailState.characteristicReviewCriterias as List<CharacteristicReviewCriteria>?;
      print(characteristicCriterias);

      characteristicReviewCriterias = characteristicCriterias?.map((cc) {
        return CharacteristicReviewCriteria(
          characteristic_id: cc.characteristic_id,
          criteria: cc.criteria,
          point: 1
        );
      }).toList();

      print(characteristicReviewCriterias?.first.criteria);
      print(characteristicReviewCriterias?.first.point);
    }
    // print(List<dynamic>.from(characteristicReviewCriterias.map((c) => c.toJson())));

  }

  updateCharacteristicReviews(String criteria, int newScore) {
    print("Update $criteria thành $newScore");
    int index = characteristicReviewCriterias!.indexWhere((c) => c.criteria == criteria);
    final String characteristic_id_temp = characteristicReviewCriterias!.elementAt(index).characteristic_id;
    characteristicReviewCriterias!
      ..removeAt(index)
      ..insert(index, CharacteristicReviewCriteria(
          characteristic_id: characteristic_id_temp,
          criteria: criteria,
          point: newScore
      ));
  }


  @override
  Widget build(BuildContext context) {
    // push từ 1 nơi chắc chắn có argument nên Map là không có ?
    final Map<String, dynamic> data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String productId = data["productId"];
    final int rating = data['rating'];
    final String title = data["title"];
    final String content = data["content"];
    final List<CharacteristicReviewCriteria>? oldCharacteristicReviews = data["oldCharacteristicReviews"];

    initOrRestoreScoredCharacteristicReviews(context, oldCharacteristicReviews: oldCharacteristicReviews);

    print("Rebuild");

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Viết đánh giá"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                        "Vui lòng xếp hạng những tiêu chí sau:", style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge),
                  ),
                  characteristicReviewCriterias != null && characteristicReviewCriterias?.length != 0
                  ? ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (ctx, index) {
                        return SizedBox(height: 12);
                      },
                      shrinkWrap: true,
                      itemCount: characteristicReviewCriterias?.length ?? 0,
                      itemBuilder: (ctx, index) {
                        return CharacteristicProductTile(
                          characteristicReviewCriteria: characteristicReviewCriterias![index],
                          onScoringCriteria: updateCharacteristicReviews
                        );
                      }
                  ) : Center(child: Text("Hiện chưa có tiêu chí nào")),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Quay lại", style: TextStyle(fontSize: 18))
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: FilledButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              ),
                              onPressed: () {
                                BlocProvider.of<ReviewBloc>(context).add(DetailReviewAdd(productId: productId, classification: "Detail", rating: rating, title: title, content: content, characteristicReviews: characteristicReviewCriterias));
                                Navigator.popUntil(context, ModalRoute.withName(Routes.product_detail_screen));
                              },
                              child: Text("Hoàn thành", style: TextStyle(fontSize: 18))
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

              ],
            ),
          ),
        ),
      )
    );
  }
}

class CharacteristicProductTile extends StatefulWidget {
  final CharacteristicReviewCriteria characteristicReviewCriteria;
  final Function(String, int) onScoringCriteria;

  const CharacteristicProductTile({
    super.key,
    required this.characteristicReviewCriteria,
    required this.onScoringCriteria
  });

  @override
  State<CharacteristicProductTile> createState() => _CharacteristicProductTileState();
}

class _CharacteristicProductTileState extends State<CharacteristicProductTile> {
  late int point;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    point = widget.characteristicReviewCriteria.point ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black12),
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.characteristicReviewCriteria.criteria, style: Theme.of(context).textTheme.titleLarge),
          Slider(
              value: point.toDouble(),
              max: 5,
              min: 1,
              divisions: 4,
              label: point.toString(),
              onChanged: (value) {
                setState(() {
                  this.point = value.toInt();
                });
                widget.onScoringCriteria(widget.characteristicReviewCriteria.criteria, point);
              }
          )
        ],
      ),
    );
  }
}

class RatingStars extends StatefulWidget {
  final int rating;
  final Color? color;
  final double? size;
  final Function(int)? onChangeRating;

  const RatingStars({required this.rating, this.color, this.size, this.onChangeRating});

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late int rating;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () {
            setState(() {
              rating = index + 1;
              widget.onChangeRating?.call(rating);
            });
          },
          isSelected: index + 1 <= rating,
          selectedIcon: Icon(Icons.star),
          icon: Icon(Icons.star_border),
          iconSize: widget.size ?? 16
        );
      }),
    );
  }
}
