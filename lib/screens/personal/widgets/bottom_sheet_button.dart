import 'package:flutter/material.dart';

class BottomSheetButton extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final void Function()? onPressed;

  const BottomSheetButton({Key? key,
    required this.icon,
    required this.buttonText,
    required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.surfaceTint)
            ),
            SizedBox(width: 16.0),
            Text(buttonText, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
