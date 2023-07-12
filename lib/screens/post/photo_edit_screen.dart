import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import './edit_image/color_filter_model.dart';
import './edit_image/edit_image_bloc.dart';
import './edit_image/image_edit_state_model.dart';

class PhotoEditScreen extends StatefulWidget {
  final File? file;
  PhotoEditScreen({Key? key, this.file}) : super(key: key);

  @override
  State<PhotoEditScreen> createState() => _PhotoEditScreenState();
}

class _PhotoEditScreenState extends State<PhotoEditScreen> {
  /// Image file picked from previous screen
  File? originalFile;

  Uint8List? tinyScreenshotImage;
  bool showTinyScreenshotImage = false;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  /// Variables used to show or hide bottom widgets

  bool isPenColorVisible = false;
  bool isBrightnessSliderVisible = false;
  bool isContrastSliderVisible = false;
  bool isSaturationSliderVisible = false;
  bool isHueSliderVisible = false;
  bool isBlurVisible = false;
  bool isFilterViewVisible = false;
  bool isBorderSliderVisible = false;

  bool mIsTextstyle = false;
  bool mIsTextColor = false;
  bool mIsTextBgColor = false;
  bool mIsTextSize = false;
  bool mIsMoreConfigWidgetVisible = true;
  bool mIsPenEnabled = false;

  double brightness = 0.0, contrast = 0.0, saturation = 0.0, hue = 0.0;
  bool blurOn = false;
  double blur = 0;
  double blurWidth = 100;
  double blurHeight = 100;

  bool isOuterBorder = true;
  double outerBorderWidth = 0;
  Color outerBorderColor = Colors.black;
  double innerBorderWidth = 0;
  Color innerBorderColor = Colors.black;

  ColorFilterModel? filter;

  // /// Used to draw on image
  // SignatureController signatureController = SignatureController(penStrokeWidth: 5, penColor: Colors.green);
  // List<Offset> points = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    originalFile = widget.file;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void updateVisibilityToolbar({
    bool isPenColorVisible = false,
    bool isBrightnessSliderVisible = false,
    bool isContrastSliderVisible = false,
    bool isSaturationSliderVisible = false,
    bool isHueSliderVisible = false,
    bool isBlurVisible = false,
    bool isFilterViewVisible = false,
    bool isBorderSliderVisible = false,
  }) {
    setState(() {
      this.isPenColorVisible = isPenColorVisible;
      this.isBrightnessSliderVisible = isBrightnessSliderVisible;
      this.isContrastSliderVisible = isContrastSliderVisible;
      this.isSaturationSliderVisible = isSaturationSliderVisible;
      this.isHueSliderVisible = isHueSliderVisible;
      this.isBlurVisible = isBlurVisible;
      this.isFilterViewVisible = isFilterViewVisible;
      this.isBorderSliderVisible = isBorderSliderVisible;
    });
  }

  void onPenClick() {
    updateVisibilityToolbar(isPenColorVisible: !isPenColorVisible);
  }

  onFilterClick() {
    updateVisibilityToolbar(isFilterViewVisible: !isFilterViewVisible);
  }

  onBrightnessSliderClick() {
    updateVisibilityToolbar(isBrightnessSliderVisible: !isBrightnessSliderVisible);
  }

  onContrastSliderClick() {
    updateVisibilityToolbar(isContrastSliderVisible: !isContrastSliderVisible);
  }

  onSaturationSliderClick() {
    updateVisibilityToolbar(isSaturationSliderVisible: !isSaturationSliderVisible);
  }

  onHueSliderClick() {
    updateVisibilityToolbar(isHueSliderVisible: !isHueSliderVisible);
  }

  onBlurClick() {
    updateVisibilityToolbar(isBlurVisible: !isBlurVisible);
  }

  onBorderSliderClick() {
    updateVisibilityToolbar(isBorderSliderVisible: !isBorderSliderVisible);
  }

  Future<void> captureDownloadAndShare() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String imageDirectoryPath = '${dir.path}/image';
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    // Không có đuôi .png thì thành file byte không đọc được
    // final savedImage = await File('${imageDirectoryPath}/${fileName}').create(recursive: true); // tạo file rỗng 0 byte để ghi dữ liệu
    final savedImage = await File('${imageDirectoryPath}/${fileName}.png').create(recursive: true); // tạo file rỗng 0 byte để ghi dữ liệu

    await screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        final newImageFile = await savedImage.writeAsBytes(image);
        if (newImageFile != null) {
          setState(() {
            tinyScreenshotImage = image;
            showTinyScreenshotImage = true;
          });
          Future.delayed(Duration(seconds: 4), () {
            setState(() {
              showTinyScreenshotImage = false;
            });
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: const Text('Lưu ảnh thành công'),
                backgroundColor: Color(0xFFE97272),
                showCloseIcon: true,
              )
          );
        }
        // Share.shareFiles([savedImage.path]); // deprecated
        /*
          When sharing data created with XFile.fromData, the plugin will write a temporal file inside the cache directory of the app, so it can be shared.
          Although the OS should take care of deleting those files, it is advised, that you clean up this data once in a while (e.g. on app start).
          You can access this directory using path_provider getTemporaryDirectory.
          Alternatively, don't use XFile.fromData and instead write the data down to a File with a path before sharing it, so you control when to delete it.
         */
        Share.shareXFiles([XFile(savedImage.path)], subject: "Ảnh đã chỉnh sửa", text: "Chia sẻ ảnh của bạn");
      }
    });
  }

  Future<void> captureWithoutDownloadAndShare() async {
    await screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        // Share.shareFiles([savedImage.path]); // deprecated
        // không có mimeType thì là dạng file byte, không hiện ảnh
        Share.shareXFiles([XFile.fromData(image, mimeType: 'png')]);
      }
    });
  }

  Future<void> captureWithoutDownload() async {
    final Uint8List? imageFile = await screenshotController.capture();

    Directory dir = await getTemporaryDirectory();
    String imageDirectoryPath = '${dir.path}/image';
    String fileName = "image_temp";
    final savedImage = await File('${imageDirectoryPath}/${fileName}.png').create(recursive: true); // tạo file rỗng 0 byte để ghi dữ liệu

    if(imageFile != null) {
      await savedImage.writeAsBytes(imageFile);
      Navigator.of(context).pop(savedImage);
    }

  }


  Future<void> captureAndDownload() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String imageDirectoryPath = '${dir.path}/image';
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();

    // lưu file dạng Uint8List thì phải, ko mở đc
    // await screenshotController.captureAndSave(imagePath, fileName: fileName).then((value) async {
    //   print(value);
    // });

    final Uint8List? imageFile = await screenshotController.capture();
    if (imageFile != null) {
      setState(() {
        tinyScreenshotImage = imageFile;
        showTinyScreenshotImage = true;
      });
      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          showTinyScreenshotImage = false;
        });
      });

      // Lưu ảnh vào resource của app thì không cần permission
      // If recursive is false, the default, the file is created only if all directories in its path already exist. If recursive is true, any non-existing parent paths are created first.
      // Không có thư mục cha image, mà không có recursive thì bị lỗi
      /*
      Khi bạn sử dụng await File('${imagePath}/${fileName}').create(recursive: true), nếu đường dẫn imagePath không tồn tại, phương thức create sẽ tạo ra thư mục mới để chứa tệp tin.
      Điều này giúp đảm bảo rằng bạn có thể tạo tệp tin trong một đường dẫn cụ thể mà không cần phải tạo thư mục cha trước đó.
       */
      // Cả 2 đều chạy được với chức năng tinyScreenshotImage
      final savedImage = await File('${imageDirectoryPath}/${fileName}.png').create(recursive: true); // tạo file rỗng 0 byte để ghi dữ liệu
      // final savedImage = await File('${imageDirectoryPath}/${fileName}').create(recursive: true); // tạo file rỗng 0 byte để ghi dữ liệu
      print(savedImage.path);
      await savedImage.writeAsBytes(imageFile); // lưu dạng byte, mở bằng desktop không được, mở bằng Flutter code được thì phải bằng Image.memory


      // Lưu ảnh vào gallery (resource hệ thống) thì cần permission
      // final status = await Permission.storage.status; // deprecated and removed
      final status = await Permission.photos.status;
      if (status.isDenied) {
        // We didn't ask for permission yet or the permission has been denied before but not permanently
        await Permission.photos.request();
        if (await Permission.photos.isPermanentlyDenied) {
          // The user opted to never again see the permission request dialog for this
          // app. The only way to change the permission's status now is to let the
          // user manually enable it in the system settings.
          openAppSettings();
        }
      }

      final result = await ImageGallerySaver.saveImage(imageFile);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: const Text('Lưu ảnh thành công'),
              backgroundColor: Color(0xFFE97272),
              showCloseIcon: true,
            )
        );
      }
    }
  }

  // Future<Uint8List> getSnapshotImage() async {
  //   Directory dir = await getApplicationDocumentsDirectory();
  //   String imageDirectoryPath = '${dir.path}/image';
  //   String imagePath = '${imageDirectoryPath}/1689056423977265';
  //   final File imageFile = File(imagePath);
  //   final bytesImage = await imageFile.readAsBytes();
  //   return bytesImage;
  // }

  @override
  Widget build(BuildContext context) {
    final fullScreenHeight = MediaQuery.of(context).size.height;
    final fullScreenWidth = MediaQuery.of(context).size.width;
    final appBarHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top; // 56 + .. = 80
    // Builder(builder: (context) {
    //   final appBarHeight2 = Scaffold.of(context).appBarMaxHeight; // The status bar height + The app bar height + The bottom app bar widget height
    //   print(appBarHeight2);
    //   return SizedBox();
    // }),
    // print(kToolbarHeight); // The app bar height: 56

    // print(kBottomNavigationBarHeight); // 56 ??
    // final bottomNavigationBarHeight = BottomAppBar().height;
    // print(bottomNavigationBarHeight); // null

    final bottomNavigationBarHeight = 80;
    final contentHeight = fullScreenHeight - appBarHeight - bottomNavigationBarHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa ảnh"),
        actions: [
          BlocBuilder<EditImageBloc, ImageEditState>(
              builder: (context, state) {
              final bloc = context.read<EditImageBloc>();
              return IconButton(
                onPressed: bloc.canUndo() ? () {
                  final unChangeListImageEditState = state.listImageEditState;
                  print(unChangeListImageEditState.length);
                  if (unChangeListImageEditState.length > 1) {
                    final lastIndex = unChangeListImageEditState.length-1;
                    final ImageEditStateModel lastImageStateWillAfterChange = unChangeListImageEditState.elementAt(lastIndex-1); // phẩn tử sát cuối
                    print(lastImageStateWillAfterChange.number);
                    if (lastImageStateWillAfterChange.type == 'brightness') {
                      setState(() {
                        brightness = lastImageStateWillAfterChange.number ?? 0;
                      });
                    } else if (lastImageStateWillAfterChange.type == 'contrast') {
                      setState(() {
                        contrast = lastImageStateWillAfterChange.number ?? 0;
                      });
                    } else if (lastImageStateWillAfterChange.type == 'saturation') {
                      setState(() {
                        saturation = lastImageStateWillAfterChange.number ?? 0;
                      });
                    } else if (lastImageStateWillAfterChange.type == 'hue') {
                      setState(() {
                        hue = lastImageStateWillAfterChange.number ?? 0;
                      });
                    }
                  } else { // có mỗi 1 phần tử, pop nốt là rỗng
                    // reset về ban đầu
                    setState(() {
                      brightness = 0;
                      contrast = 0;
                      saturation = 0;
                      hue = 0;

                    });
                  }
                  // change state
                  bloc.add(EditImageUndo());


                } : null,
                icon: Icon(Icons.undo)
              );
            }
          ),
          BlocBuilder<EditImageBloc, ImageEditState>(
              builder: (context, state) {
                final bloc = context.read<EditImageBloc>();
                return IconButton(
                    onPressed: bloc.canRedo() ? () {
                      // change state
                      bloc.add(EditImageRedo());

                      Future.delayed(Duration(milliseconds: 200), () {
                        final restoreListImageEditState = state.listImageEditState;
                        print(restoreListImageEditState.length);
                        final ImageEditStateModel lastImageStateAfterRestore = restoreListImageEditState.last;
                        if (lastImageStateAfterRestore.type == 'brightness') {
                          setState(() {
                            brightness = lastImageStateAfterRestore.number ?? 0;
                          });
                        } else if (lastImageStateAfterRestore.type == 'contrast') {
                          setState(() {
                            contrast = lastImageStateAfterRestore.number ?? 0;
                          });
                        } else if (lastImageStateAfterRestore.type == 'saturation') {
                          setState(() {
                            saturation = lastImageStateAfterRestore.number ?? 0;
                          });
                        } else if (lastImageStateAfterRestore.type == 'hue') {
                          setState(() {
                            hue = lastImageStateAfterRestore.number ?? 0;
                          });
                        }
                      });
                    } : null,
                    icon: Icon(Icons.redo)
                );
              }
          ),

          PopupMenuButton(
              icon: Icon(Icons.save_as),
              tooltip: "",
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Tooltip(
                      message: "Lưu ảnh thay thế",
                      child: IgnorePointer(
                        child: TextButton.icon(
                            onPressed: () {
                            },
                            icon: Icon(Icons.filter),
                            label: Text("Lưu ảnh")
                        ),
                      )
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Tooltip(
                      message: "Lưu ảnh xuống thư mục",
                      child: IgnorePointer(
                        child: TextButton.icon(
                            onPressed: () {
                            },
                            icon: Icon(Icons.save_alt),
                            label: Text("Tải xuống")
                        ),
                      )
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Tooltip(
                        message: "Tải xuống & Chia sẻ",
                        child: IgnorePointer(
                          child: TextButton.icon(
                              onPressed: () {
                              },
                              icon: Icon(Icons.ios_share),
                              label: Text("Tải xuống & Chia sẻ")
                          ),
                        )
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Tooltip(
                        message: "Chia sẻ",
                        child: IgnorePointer(
                          child: TextButton.icon(
                              onPressed: () {
                              },
                              icon: Icon(Icons.share),
                              label: Text("Chia sẻ")
                          ),
                        )
                    ),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  captureWithoutDownload();
                } else if(value == 1){
                  captureAndDownload();
                  updateVisibilityToolbar();
                } else if(value == 2){
                  captureDownloadAndShare();
                  updateVisibilityToolbar();
                } else if(value == 3){
                  captureWithoutDownloadAndShare();
                  updateVisibilityToolbar();
                }
              }
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: contentHeight, // toàn màn hình chỉnh ảnh
              width: fullScreenWidth,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        // height: 400, // chiều cao để scale ảnh nếu cần
                        child: Stack( // Layer 2 : Blur
                          fit: StackFit.loose,
                          children: [
                            // Layer 1: filter
                            // filter với matrix
                            (filter != null && filter!.matrix != null)
                                ? ColorFiltered(
                                    colorFilter: ColorFilter.matrix(filter!.matrix!),
                                    child: ImageFilterWidget(
                                      brightness: brightness,
                                      saturation: saturation,
                                      hue: hue,
                                      contrast: contrast,
                                      child: Image.file(originalFile!),
                                    ),
                                  )
                                :
                                (filter != null && filter!.color != null)
                                  ? ShaderMask(
                                      shaderCallback: (Rect bounds) => LinearGradient(colors: filter!.color!, begin: Alignment.topLeft, end: Alignment.bottomRight).createShader(bounds),
                                      child: ImageFilterWidget(
                                        brightness: brightness,
                                        saturation: saturation,
                                        hue: hue,
                                        contrast: contrast,
                                        child: Image.file(originalFile!)
                                      )
                                    )
                                  :
                                  // Ảnh gốc
                                  ImageFilterWidget(
                                    brightness: brightness,
                                    saturation: saturation,
                                    hue: hue,
                                    contrast: contrast,
                                    child: Image.file(originalFile!, fit: BoxFit.fill)
                                  ),
                            // Kết thúc Layer 1: filter
                            Draggable(
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                                  child: Container(
                                    width: blurWidth,
                                    height: blurHeight,
                                    alignment: Alignment.center, color: Colors.grey.withOpacity(0.1)
                                  ),
                                ),
                              ),
                              feedback: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                                  child: Container(
                                      width: blurWidth,
                                      height: blurHeight,
                                      alignment: Alignment.center, color: Colors.grey.withOpacity(0.1)
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),

                  // Demo lưu lại ảnh thu nhỏ, mở bằng bytes
                  // Container(
                  //   width: 60,
                  //   height: 60,
                  //   child: FutureBuilder<Uint8List>(
                  //     future: getSnapshotImage(),
                  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  //      if (snapshot.hasData) {
                  //         final Uint8List bytesImage = snapshot.data;
                  //         return Image.memory(bytesImage);
                  //      } else {
                  //        return Center(child: CircularProgressIndicator());
                  //      }
                  //     },
                  //   )
                  // ),

                  if (tinyScreenshotImage != null)
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: showTinyScreenshotImage ? 60 : 0,
                        height: showTinyScreenshotImage ? 60 : 0,
                        child: Image.memory(tinyScreenshotImage!),
                        curve: Curves.easeInOut,
                      ),
                    ),

                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Column(
                      children: [
                        // build Tool Edit Image
                        if (isBrightnessSliderVisible)
                          Card(
                            color: Color(0xFFEFAAAA),
                            child: Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Độ sáng ",
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)
                                          ),
                                          TextSpan(
                                              text: brightness == 0 ? "${(brightness*100).toStringAsFixed(0)}" : (brightness < 0 ? "${(brightness*100).toStringAsFixed(0)}" : "+${(brightness*100).toStringAsFixed(0)}"),
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surfaceTint)
                                          ),
                                        ]
                                    ),
                                  ),
                                  Slider(
                                    min: -1.0,
                                    max: 1.0,
                                    onChanged: (value) {
                                      setState(() {
                                        brightness = value;
                                      });
                                    },
                                    value: brightness,
                                    divisions: 100,
                                    label: (brightness*100).toInt().toString(),
                                    onChangeEnd: (value) {
                                      context.read<EditImageBloc>().add(EditImageChange(imageEditStateModel: ImageEditStateModel(type: 'brightness', number: value)));

                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isContrastSliderVisible)
                          Card(
                            color: Color(0xFFEFAAAA),
                            child: Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Độ tương phản ",
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)
                                          ),
                                          TextSpan(
                                              text: contrast == 0 ? "${(contrast*100).toStringAsFixed(0)}" : (contrast < 0 ? "${(contrast*100).toStringAsFixed(0)}" : "+${(contrast*100).toStringAsFixed(0)}"),
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surfaceTint)
                                          ),
                                        ]
                                    ),
                                  ),
                                  Slider(
                                    min: -1.0,
                                    max: 1.0,
                                    onChanged: (value) {
                                      setState(() {
                                        contrast = value;
                                      });
                                    },
                                    value: contrast,
                                    divisions: 100,
                                    label: (contrast*100).toInt().toString(),
                                    onChangeEnd: (value) {
                                      context.read<EditImageBloc>().add(EditImageChange(imageEditStateModel: ImageEditStateModel(type: 'contrast', number: value)));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isSaturationSliderVisible)
                          Card(
                            color: Color(0xFFEFAAAA),
                            child: Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Độ bão hoà ",
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)
                                          ),
                                          TextSpan(
                                              text: saturation == 0 ? "${(saturation*100).toStringAsFixed(0)}" : (saturation < 0 ? "${(saturation*100).toStringAsFixed(0)}" : "+${(saturation*100).toStringAsFixed(0)}"),
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surfaceTint)
                                          ),
                                        ]
                                    ),
                                  ),
                                  Slider(
                                    min: -1.0,
                                    max: 1.0,
                                    onChanged: (value) {
                                      setState(() {
                                        saturation = value;
                                      });
                                    },
                                    value: saturation,
                                    divisions: 100,
                                    label: (saturation*100).toInt().toString(),
                                    onChangeEnd: (value) {
                                      context.read<EditImageBloc>().add(EditImageChange(imageEditStateModel: ImageEditStateModel(type: 'saturation', number: value)));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isHueSliderVisible)
                          Card(
                            color: Color(0xFFEFAAAA),
                            child: Container(
                              padding: EdgeInsets.only(top: 8),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Nhiệt độ ",
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)
                                          ),
                                          TextSpan(
                                              text: hue == 0 ? "${(hue*100).toStringAsFixed(0)}" : (hue < 0 ? "${(hue*100).toStringAsFixed(0)}" : "+${(hue*100).toStringAsFixed(0)}"),
                                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surfaceTint)
                                          ),
                                        ]
                                    ),
                                  ),
                                  Slider(
                                    min: -1.0,
                                    max: 1.0,
                                    onChanged: (value) {
                                      setState(() {
                                        hue = value;
                                      });
                                    },
                                    value: hue,
                                    divisions: 100,
                                    label: (hue*100).toInt().toString(),
                                    onChangeEnd: (value) {
                                      context.read<EditImageBloc>().add(EditImageChange(imageEditStateModel: ImageEditStateModel(type: 'hue', number: value)));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (isBlurVisible)
                          Card(
                            color: Color(0xFFEFAAAA),
                            child: Container(
                              padding: EdgeInsets.only(top: 8, left: 16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Làm mờ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
                                      SizedBox(width: 4),
                                      Switch(
                                        value: blurOn,
                                        onChanged: (bool value) {
                                          setState(() {
                                            blurOn = value;
                                            if (blurOn == false) {
                                              blur = 0;
                                              blurWidth = 0;
                                              blurHeight = 0;
                                            }
                                          });
                                        },
                                      ),
                                      if (blurOn) Slider(
                                        min: 0.0,
                                        max: 10.0,
                                        onChanged: (value) {
                                          setState(() {
                                            blur = value;
                                          });
                                        },
                                        value: blur,
                                        divisions: 100,
                                        label: "${blur.round()}",
                                        onChangeEnd: (value) {
                                          // context.read<EditImageBloc>().add(EditImageChange(imageEditStateModel: ImageEditStateModel(type: 'blur', number: value)));
                                        },
                                      ),
                                    ],
                                  ),
                                  if (blurOn) Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Kích thước", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
                                      Container(
                                        margin: EdgeInsets.only(left: 16),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text("Chiều dài", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
                                                SizedBox(width: 8),
                                                Text("${blurWidth.round()}", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surfaceTint)),
                                                Slider(
                                                  min: 0.0,
                                                  max: 300.0,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      blurWidth = value;
                                                    });
                                                  },
                                                  value: blurWidth,
                                                  divisions: 100,
                                                  label: "${blurWidth.round()}",
                                                  onChangeEnd: (value) {
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Chiều cao", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
                                                SizedBox(width: 8),
                                                Text("${blurHeight.round()}", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surfaceTint)),
                                                Slider(
                                                  min: 0.0,
                                                  max: 300.0,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      blurHeight = value;
                                                    });
                                                  },
                                                  value: blurHeight,
                                                  divisions: 100,
                                                  label: "${blurHeight.round()}",
                                                  onChangeEnd: (value) {
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // tách riêng để cuộn được --> kì lạ
                  if (isFilterViewVisible)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FilterSelectionWidget(
                          image: originalFile,
                          onSelect: (v) {
                            setState(() {
                              filter = v;
                            });
                          }
                      ),
                    ),

                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: SingleChildScrollView(
            // scrollDirection: Axis.vertical, // nhìn cũng đẹp, nhưng trống 1 phần tử ở cuối
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: onPenClick
                ),
                IconButton(
                    icon: Icon(Icons.brightness_4_outlined),
                    onPressed: onBrightnessSliderClick
                ),
                IconButton(
                    icon: Icon(Icons.contrast),
                    onPressed: onContrastSliderClick
                ),
                IconButton(
                    icon: Icon(Icons.water_drop_outlined),
                    onPressed: onSaturationSliderClick
                ),
                IconButton(
                    icon: Icon(Icons.thermostat_outlined),
                    onPressed: onHueSliderClick
                ),
                IconButton(
                    icon: Icon(Icons.blur_on),
                    onPressed: onBlurClick
                ),
                IconButton(
                    icon: Icon(Icons.filter_b_and_w),
                    onPressed: onFilterClick
                ),
                IconButton(
                    icon: Icon(Icons.format_shapes_sharp),
                    onPressed: onBorderSliderClick
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ImageFilterWidget extends StatelessWidget {
  final double? brightness;
  final double? saturation;
  final double? hue;
  final double? contrast;
  final Widget? child;

  ImageFilterWidget({this.brightness, this.saturation, this.hue, this.contrast, this.child});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: brightness != 0.0 ? ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(value: brightness!)) : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
      child: ColorFiltered(
        colorFilter: saturation != 0.0 ? ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(value: saturation!)) : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
        child: ColorFiltered(
          colorFilter: hue != 0.0 ? ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(value: hue!)) : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
          child: ColorFiltered(
            colorFilter: contrast != 0.0 ? ColorFilter.matrix(ColorFilterGenerator.contrastAdjustMatrix(value: contrast!)) : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
            child: child,
          ),
        ),
      ),
    );
  }
}

class ColorFilterGenerator {
  static List<double> hueAdjustMatrix({required double value}) {
    value = value * pi;

    if (value == 0)
      return
        [ 1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ];

    double cosVal = cos(value);
    double sinVal = sin(value);
    double lumR = 0.213;
    double lumG = 0.715;
    double lumB = 0.072;

    return List<double>.from(<double>
    [
      (lumR + (cosVal * (1 - lumR))) + (sinVal * (-lumR)),
      (lumG + (cosVal * (-lumG))) + (sinVal * (-lumG)),
      (lumB + (cosVal * (-lumB))) + (sinVal * (1 - lumB)),
      0,
      0,
      (lumR + (cosVal * (-lumR))) + (sinVal * 0.143),
      (lumG + (cosVal * (1 - lumG))) + (sinVal * 0.14),
      (lumB + (cosVal * (-lumB))) + (sinVal * (-0.283)),
      0,
      0,
      (lumR + (cosVal * (-lumR))) + (sinVal * (-(1 - lumR))),
      (lumG + (cosVal * (-lumG))) + (sinVal * lumG),
      (lumB + (cosVal * (1 - lumB))) + (sinVal * lumB),
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]).map((i) => i.toDouble()).toList();
  }

  static List<double> brightnessAdjustMatrix({required double value}) {
    value = value * 100;

    if (value == 0) {
      return
        [ 1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0
        ];
    }

    return List<double>.from(
        <double>[
          1, 0, 0, 0, value,
          0, 1, 0, 0, value,
          0, 0, 1, 0, value,
          0, 0, 0, 1, 0
        ]).map((i) => i.toDouble()).toList();
  }

  static List<double> contrastAdjustMatrix({required double value}) {
    value = 1 + value;

    if (value == 0)
      return
        [ 1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0
        ];

    return List<double>.from(<double>
    [
      value, 0, 0, 0, 1,
      0, value, 0, 0, 1,
      0, 0, value, 0, 1,
      0, 0, 0, 1, 0
    ]
    ).map((i) => i.toDouble()).toList();
  }

  static List<double> saturationAdjustMatrix({required double value}) {
    value = value * 100;

    if (value == 0)
      return
        [ 1, 0, 0, 0, 0,
          0, 1, 0, 0, 0,
          0, 0, 1, 0, 0,
          0, 0, 0, 1, 0,
        ];

    double x = ((1 + ((value > 0) ? ((3 * value) / 100) : (value / 100)))).toDouble();
    double lumR = 0.3086;
    double lumG = 0.6094;
    double lumB = 0.082;

    return List<double>.from(<double>
    [
      ( lumR * (1 - x)) + x,      lumG * (1 - x),             lumB * (1 - x),         0,  0,
      lumR * (1 - x),           (lumG * (1 - x)) + x,       lumB * (1 - x),         0,  0,
      lumR * (1 - x),           lumG * (1 - x),             (lumB * (1 - x)) + x,   0,  0,
      0,                        0,                          0,                      1,  0,
    ]
    ).map((i) => i.toDouble()).toList();
  }
}

////////////////////////////////// Filter

class FilterSelectionWidget extends StatefulWidget {
  final Function(ColorFilterModel)? onSelect;
  final File? image;

  FilterSelectionWidget({this.onSelect, this.image});

  @override
  FilterSelectionWidgetState createState() => FilterSelectionWidgetState();
}

class FilterSelectionWidgetState extends State<FilterSelectionWidget> {

  List<ColorFilterModel> getFilters() {
    List<double> sepiaMatrix = [0.39, 0.769, 0.189, 0.0, 0.0, 0.349, 0.686, 0.168, 0.0, 0.0, 0.272, 0.534, 0.131, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
    List<double> greyscaleMatrix = [0.2126, 0.7152, 0.0722, 0.0, 0.0, 0.2126, 0.7152, 0.0722, 0.0, 0.0, 0.2126, 0.7152, 0.0722, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
    List<double> vintageMatrix = [0.9, 0.5, 0.1, 0.0, 0.0, 0.3, 0.8, 0.1, 0.0, 0.0, 0.2, 0.3, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
    List<double> sweetMatrix = [1.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
    List<double> milkMatrix = [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.6, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
    List<double> hudsonMatrix = [0.2, 0, 0, 0, 0, 0, 0.78, 0, 0, 0, 0, 0, 0.78, 0, 0, 0, 0, 0, 1, 0];
    List<double> chocolateTeaMatrix = [
      0.4, 0.3, 0.1, 0.0, 0.0,
      0.2, 0.6, 0.2, 0.0, 0.0,
      0.0, 0.2, 0.8, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ];
    
    List<ColorFilterModel> list = [];
    list.add(ColorFilterModel(name: 'Normal'));
    list.add(ColorFilterModel(name: 'Black & White', matrix: greyscaleMatrix));
    list.add(ColorFilterModel(name: 'Sepia', matrix: sepiaMatrix)); // Sepia Tint Sepia là một màu đỏ gạch đậm sang chảnh và trẻ trung với sắc nâu rõ rệt, hợp với mọi tông da.
    list.add(ColorFilterModel(name: 'Vintage', matrix: vintageMatrix)); // Vintage - Tạo hiệu ứng màu cổ điển
    list.add(ColorFilterModel(name: 'Sweet', matrix: sweetMatrix));  // Sweet - Tạo hiệu ứng màu nhẹ nhàng, ngọt ngào.
    list.add(ColorFilterModel(name: 'Milk', matrix: milkMatrix)); // Milk - Tạo hiệu ứng màu nhẹ nhàng, mịn màng.
    list.add(ColorFilterModel(name: 'Hudson', matrix: hudsonMatrix));  // Hudson - Tạo hiệu ứng màu lạnh, nhẹ nhàng.
    list.add(ColorFilterModel(name: 'Chocolate Tea', matrix: chocolateTeaMatrix));

    list.add(ColorFilterModel(name: 'Hudson light', color: [Color(0x8C449BE0), Color(0x8C29C267)]));
    list.add(ColorFilterModel(name: 'Metro', color: [Color(0x8C5388CB), Color(0x8C5B54FA)]));
    list.add(ColorFilterModel(name: 'Paris', color: [Color(0x8C334d50), Color(0x8Ccbcaa5)]));
    list.add(ColorFilterModel(name: 'Oslo', color: [Color(0x8CEFEFBB), Color(0x8Cd4d3dd)]));
    list.add(ColorFilterModel(name: 'Lagos', color: [Color(0x8Cc21500), Color(0x8Cffc500)]));
    list.add(ColorFilterModel(name: 'Melbourne', color: [Color(0x8C1CD8D2), Color(0x8C93EDC7)]));
    list.add(ColorFilterModel(name: 'Jakarta', color: [Color(0x8C00416A), Color(0x8C799F0C), Color(0x8CFFE000)]));
    list.add(ColorFilterModel(name: 'Abu Dhabi', color: [Color(0x8C5F0A87), Color(0x8CA4508B)]));
    list.add(ColorFilterModel(name: 'Faded', color: [Colors.white54, Colors.white54]));
    list.add(ColorFilterModel(name: 'Soft', color: [Color(0x8C868F96), Color(0x8C596164)]));
    list.add(ColorFilterModel(name: 'Cool', color: [Color(0x8CFFECD2), Color(0x8CFCB69F)]));
    list.add(ColorFilterModel(name: 'Warm', color: [Color(0x8CFDFCFB), Color(0x8CE2D1C3)]));
    list.add(ColorFilterModel(name: 'Pale', color: [Color(0x8C42275a), Color(0x8C734b6d)]));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      // width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: getFilters().map((e) {
          return InkWell(
            onTap: () {
              widget.onSelect?.call(e);
            },
            child: Container(
              height: 60,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
              margin: EdgeInsets.all(2),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.file(widget.image!, fit: BoxFit.cover)
                  ),
                  if (e.color != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        gradient: LinearGradient(colors: e.color!),
                      ),
                    ),
                  if (e.matrix != null)
                    ColorFiltered(
                      colorFilter: ColorFilter.matrix(e.matrix!),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.file(widget.image!, fit: BoxFit.cover)
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      e.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

