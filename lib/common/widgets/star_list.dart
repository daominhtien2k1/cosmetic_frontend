import 'package:flutter/material.dart';

class StarList extends StatelessWidget {
  final double rating;
  final Color? color;
  final double? size;

  const StarList({required this.rating, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    final int wholeStars = rating.floor();
    final bool hasHalfStar = rating - wholeStars >= 0.3 && rating - wholeStars <= 0.7;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < wholeStars) {
          // Hiển thị sao đầy
          return Icon(Icons.star, color: color ?? Colors.grey, size: size ?? 16);
        } else if (index == wholeStars && hasHalfStar) {
          // Hiển thị nửa sao
          return Icon(Icons.star_half, color: color ?? Colors.grey, size: size ?? 16);
        } else {
          // Hiển thị sao rỗng
          return Icon(Icons.star_border, color: color ?? Colors.grey, size: size ?? 16);
        }
      }),
    );
  }
}