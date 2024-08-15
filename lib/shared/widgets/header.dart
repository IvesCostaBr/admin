import 'dart:convert';

import 'package:core_dashboard/providers/user.dart';
import 'package:core_dashboard/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../constants/defaults.dart';
import '../constants/ghaps.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.drawerKey});

  final GlobalKey<ScaffoldState> drawerKey;

  @override
  Widget build(BuildContext context) {
    final userProvider = Get.find<UserProvider>();
    final userData = userProvider.userData;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.padding, vertical: AppDefaults.padding),
      color: AppColors.bgSecondayLight,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (Responsive.isMobile(context))
              IconButton(
                onPressed: () {
                  drawerKey.currentState!.openDrawer();
                },
                icon: Badge(
                  isLabelVisible: false,
                  child: SvgPicture.asset(
                    "assets/icons/menu_light.svg",
                  ),
                ),
              ),
            if (Responsive.isMobile(context))
              IconButton(
                onPressed: () {},
                icon: Badge(
                  isLabelVisible: false,
                  child: SvgPicture.asset("assets/icons/search_filled.svg"),
                ),
              ),
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 1,
                child: TextFormField(
                  // style: Theme.of(context).textTheme.labelLarge,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: AppDefaults.padding,
                          right: AppDefaults.padding / 2),
                      child: SvgPicture.asset("assets/icons/search_light.svg"),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    border: AppDefaults.outlineInputBorder,
                    focusedBorder: AppDefaults.focusedOutlineInputBorder,
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!Responsive.isMobile(context))
                    IconButton(
                      onPressed: () {},
                      icon: Badge(
                        isLabelVisible: true,
                        child:
                            SvgPicture.asset("assets/icons/message_light.svg"),
                      ),
                    ),
                  if (!Responsive.isMobile(context)) gapW16,
                  if (!Responsive.isMobile(context))
                    IconButton(
                      onPressed: () {},
                      icon: Badge(
                        isLabelVisible: true,
                        child: SvgPicture.asset(
                            "assets/icons/notification_light.svg"),
                      ),
                    ),
                  if (!Responsive.isMobile(context)) gapW16,
                  if (!Responsive.isMobile(context))
                    IconButton(
                      onPressed: () {},
                      icon: CircleAvatar(
                        backgroundImage: userData!["avatar"] != null ? MemoryImage(base64Decode(userData["avatar"])) : null
                      )
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
