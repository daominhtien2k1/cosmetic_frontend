import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Friend extends StatelessWidget {
  final String friendName;
  final String imageUrl;

  const Friend({Key? key, required this.friendName, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  child: Image(
                    image: CachedNetworkImageProvider(imageUrl),
                    fit: BoxFit.cover
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(friendName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold)))
          ],
        ),
      ),
    );
  }
}
