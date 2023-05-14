import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../blocs/post/post_bloc.dart';
import '../../blocs/post/post_event.dart';
import '../../routes.dart';

import '../../constants/localdata/local_data.dart';
import './widgets/post_widgets.dart';

class CreatePostScreen extends StatefulWidget  {

  CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // In any case, when you are using a TextEditingController (or maintaining any mutable state), then you should use a StatefulWidget and keep the state in the State class.
  final TextEditingController textEditingController = TextEditingController();
  String? status;

  //isMinimizeDraggableScrollableSheet
  bool isMinimizeDSS = false;

  // chức năng ảnh/video
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList; // luồng vẫn hơi củ chuối
  dynamic _pickImageError;
  late VideoPlayerController _controller; // tính năng video chưa được
  bool isVideo = false;

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = (value == null ? null : <XFile>[value]);
  }

  Future<void> _playVideo(XFile? file) async {
    if (file != null) {
      _controller.dispose();
      if (kIsWeb) {
        _controller = VideoPlayerController.network(file.path);
      } else {
        _controller = VideoPlayerController.file(File(file.path));
      }
      const double volume = kIsWeb ? 0.0 : 1.0;
      await _controller.setVolume(volume);
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();
    }
  }

  Widget _previewVideo() {
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: VideoPlayer(_controller),
    );
  }

  Widget _previewImages() {
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        // child: ListView.builder(
        //   primary: false,
        //   shrinkWrap: true,
        //   key: UniqueKey(),
        //   itemBuilder: (BuildContext context, int index) {
        //     // Why network for web?
        //     // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        //     return Semantics(
        //       label: 'image_picker_example_picked_image',
        //       child: kIsWeb
        //           ? Image.network(_imageFileList![index].path)
        //           : Image.file(File(_imageFileList![index].path)),
        //     );
        //   },
        //   itemCount: _imageFileList!.length,
        // ),
          child: GridView.builder(
            primary: false,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 4,
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2),
            ),
            itemCount: _imageFileList!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {

                },
                child: GridTile(
                    child: Semantics(
                        label: 'image_picker_example_picked_image',
                        child: kIsWeb
                            ? Image.network(_imageFileList![index].path)
                            : Image.file(File(_imageFileList![index].path)),
                      )
                ),
              );
            },
          )
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Bạn chưa chọn ảnh nào',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    if (isVideo) {
      return _previewVideo();
    } else {
      return _previewImages();
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source, {BuildContext? context, bool isMultiImage = false, required bool isVideo}) async {
    if (isVideo) {
      setState(() {
        this.isVideo = true;
      });
      final XFile? file = await _picker.pickVideo(source: source, maxDuration: const Duration(seconds: 10));
      await _playVideo(file);
    } else if (isMultiImage) {
      try {
        final List<XFile> pickedFileList = await _picker.pickMultiImage();
        setState(() {
          _imageFileList = pickedFileList;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    } else {
      try {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();

  }

  handleCreatePost() {
    final described = textEditingController.text;
    // print(_imageFileList?[0]);
    context.read<PostBloc>().add(PostAdd(described: described, status: status, imageFileList: _imageFileList));
  }

  @override
  Widget build(BuildContext context) {
    // print("#Create_post_screen: Rebuild");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PostAppbar(
        title: 'Tạo bài viết',
        action: 'Đăng',
        textEditingController: textEditingController,
        onHandleCreatePost: handleCreatePost,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: PostInfo(avtUrl: currentUser.imageUrl, name: currentUser.name, status: status),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration.collapsed(
                              hintText: 'Đăng bài viết của bạn'),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ),
                    ),
                    Container(
                        child: _imageFileList != null ? _handlePreview() : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
          ),
          Positioned.fill(
              child: NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  // print("${notification.extent}");
                  if (notification.extent <= 0.25) {
                    // setState(() {
                    //   isMinimizeDSS = true;
                    // });
                  } else {
                    // setState(() {
                    //   isMinimizeDSS = false;
                    // });
                  }
                  return true;
                },
                child: DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  maxChildSize: 0.6,
                  minChildSize: 0.1,
                  builder: (_, controller) {
                    // if (!isMinimizeDSS)
                      return Material(
                        elevation: 20,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20)
                        ),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                width: 40,
                                color: Colors.grey[400],
                                height: 2,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: controller,
                                itemCount: 7,
                                itemBuilder: (context, index) {
                                  switch (index) {
                                    case 0:
                                      return ListTile(
                                        onTap: () {
                                          _onImageButtonPressed(ImageSource.gallery, context: context, isVideo: false);
                                        },
                                        leading: Icon(Icons.photo, color: Colors.green),
                                        title: Text('Ảnh từ gallery')
                                      );
                                    case 1:
                                      return ListTile(
                                          onTap: () {
                                            _onImageButtonPressed(ImageSource.gallery, context: context, isMultiImage: true, isVideo: false);
                                          },
                                          leading: Icon(Icons.photo_library, color: Colors.green),
                                          title: Text('Nhiều ảnh từ gallery')
                                      );
                                    case 2:
                                      return ListTile(
                                          onTap: () {
                                            _onImageButtonPressed(ImageSource.camera, context: context, isVideo: false);
                                          },
                                          leading: Icon(Icons.camera, color: Colors.red),
                                          title: Text('Chụp ảnh')
                                      );
                                    case 3:
                                      return ListTile(
                                          onTap: () {
                                            _onImageButtonPressed(ImageSource.gallery, context: context, isVideo: true);
                                          },
                                          leading: Icon(Icons.video_library, color: Colors.red),
                                          title: Text('Video từ gallery')
                                      );
                                    case 4:
                                      return ListTile(
                                          onTap: () {
                                            _onImageButtonPressed(ImageSource.camera, context: context, isVideo: true);
                                          },
                                          leading: Icon(Icons.videocam, color: Colors.red),
                                          title: Text('Quay video')
                                      );
                                    case 5:
                                      return ListTile(
                                          onTap: () async {
                                            final statusGetBack = await Navigator.of(context).pushNamed(Routes.emotion_screen, arguments: status) as String?;
                                            // print("#Create_post_screen: $statusGetBack");
                                            setState(() {
                                              this.status = statusGetBack;
                                            });
                                            },
                                          leading: Icon(Icons.emoji_emotions_outlined, color: Colors.orange),
                                          title: Text('Cảm xúc')
                                      );
                                    case 6:
                                      return ListTile(
                                          onTap: () {},
                                          leading: Icon(Icons.text_format, color: Colors.blue, size: 28),
                                          title: Text('Màu nền')
                                      );
                                    default:
                                      return ListTile(
                                          onTap: () {},
                                          leading: Icon(Icons.photo_library, color: Colors.green),
                                          title: Text('Ảnh/video')
                                      );
                                  }
                                }),
                            ),
                          ],
                        ),
                      );
                      // bị rebuild liên tục nên lag lắm
                    // else
                    //   return Material(
                    //     elevation: 20,
                    //     borderRadius: BorderRadius.vertical(
                    //       top: Radius.circular(20)
                    //     ),
                    //     color: Colors.white,
                    //     child: Column(
                    //       children: [
                    //         Center(
                    //           child: Container(
                    //             margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    //             width: 40,
                    //             color: Colors.grey[400],
                    //             height: 2,
                    //           ),
                    //         ),
                    //         SingleChildScrollView(
                    //           controller: controller,
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //             children: [
                    //               Icon(Icons.photo, color: Colors.green),
                    //               Icon(Icons.photo_library, color: Colors.green),
                    //               Icon(Icons.camera, color: Colors.red),
                    //               Icon(Icons.video_library, color: Colors.red),
                    //               Icon(Icons.camera, color: Colors.red),
                    //               Icon(Icons.emoji_emotions_outlined, color: Colors.orange),
                    //               Icon(Icons.text_format, color: Colors.blue, size: 28),
                    //             ],
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   );
                  }
                ),
              )
          )
      ]),
    );
  }
}





