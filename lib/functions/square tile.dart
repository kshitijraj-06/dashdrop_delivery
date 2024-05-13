import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget{
  final String ImagePath;
  final Function()? onTap;
  const SquareTile({super.key, required this.ImagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white
        ),
        child: Image.network(ImagePath,
        height: 40,),
      ),
    );
  }
}