import 'package:core_dashboard/shared/constants/defaults.dart';
import 'package:core_dashboard/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ThemeIconTile extends StatefulWidget {
  const ThemeIconTile({super.key, this.isDark = false, this.onPressed});

  final bool isDark;
  final Function()? onPressed;

  @override
  State<ThemeIconTile> createState() => _ThemeIconTileState();
}

class _ThemeIconTileState extends State<ThemeIconTile> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color:
            _isHover ? Colors.white : AppColors.highlightLight.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(AppDefaults.padding * 0.25),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) {
          setState(() {
            _isHover = value;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
              )
            ],
          ),
          child: Center(
            child: Icon(widget.isDark ? Icons.dark_mode_outlined :Icons.light_mode),
          ),
        ),
      ),
    );
  }
}
