import 'package:flutter/material.dart';

class FriendTile extends StatelessWidget {
  final String friendName;
  final String imageUrl;

  const FriendTile({Key? key, required this.friendName, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.1,
            blurRadius: 0.1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(imageUrl, width: 84, height: 84)
            ),
          ),
          SizedBox(height: 8),
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(friendName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}
