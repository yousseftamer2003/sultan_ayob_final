import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food2go_app/constants/colors.dart';

class OptionContainerWidget extends StatelessWidget {
  const OptionContainerWidget({super.key, required this.text, required this.icon, required this.onTap, required this.isSelected});
  final String text;
  final String icon;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: isSelected? null : Border.all(color: maincolor),
          color: isSelected ? maincolor.withOpacity(0.3) : Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon,colorFilter: const ColorFilter.mode(maincolor, BlendMode.srcIn),),
              const SizedBox(height: 10),
              Text(text, style: const TextStyle(color: maincolor, fontWeight: FontWeight.w500,fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}