import 'dart:convert';

import 'package:core_dashboard/controllers/config.dart';
import 'package:core_dashboard/controllers/navigation.dart';
import 'package:core_dashboard/pages/dashboard/widgets/theme_tabs.dart';
import 'package:core_dashboard/responsive.dart';
import 'package:core_dashboard/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../constants/defaults.dart';
import '../../constants/ghaps.dart';
import 'customer_info.dart';
import 'menu_tile.dart';


class Sidebar extends StatelessWidget {
  final configController = Get.find<ConfigController>();
  Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.find();
    final appData = configController.appData.value;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDefaults.padding,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/icons/close_filled.svg'),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDefaults.padding,
                    vertical: AppDefaults.padding * 1.5,
                  ),
                  child: Image.memory(base64Decode(appData!.data.logo), height: 150, width: 220,),
                ),
              ],
            ),
            const Divider(),
            gapH16,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                ),
                child: ListView(
                  children: [
                    MenuTile(
                      isActive: navigationController.currentPage.value == 'home' ? true : false,
                      title: "Home",
                      activeIconSrc: "assets/icons/home_filled.svg",
                      inactiveIconSrc: "assets/icons/home_light.svg",
                      onPressed: () {
                        navigationController.changePage("dashboard");
                      },
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.person),
                      title: Text(
                        "Usuários",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Geral",
                          onPressed: () {
                            navigationController.changePage("list-users");
                          },
                        ),
                        MenuTile(
                          isSubmenu: true,
                          title: "Usuários Admin",
                          onPressed: () {
                            navigationController.changePage("list-admin-users");
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.monetization_on),
                      title: Text(
                        "Transações",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Geral",
                          onPressed: () {
                            navigationController.changePage("list-transactions");
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.graphic_eq_outlined),
                      title: Text(
                        "Taxas",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Geral",
                          onPressed: () {
                            navigationController.changePage("list-fees");
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.notification_add_outlined),
                      title: Text(
                        "Eventos",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Geral",
                          onPressed: () {
                            navigationController.changePage("list-events");
                          },
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.shield_moon),
                      title: Text(
                        "Admin",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Lista Consumers",
                          onPressed: () {
                            navigationController.changePage("list-consumers");
                          },
                        ),
                      ]),
                    ExpansionTile(
                      leading: const Icon(Icons.phone_iphone_outlined),
                      title: Text(
                        "Configurações",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Geral",
                          onPressed: () {
                            navigationController.changePage("consumer-detail");
                          },
                        ),
                        MenuTile(
                          isSubmenu: true,
                          title: "Configurações APP",
                          onPressed: () {
                            navigationController.changePage("consumer-config");
                          },
                        ),
                        MenuTile(
                          isSubmenu: true,
                          title: "Telas",
                          onPressed: () {
                            navigationController.changePage("consumer-page");
                          },
                        )
                      ],
                    ),
                    ExpansionTile(
                      leading: const Icon(Icons.support_agent_rounded),
                      title: Text(
                        "Atendimento",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Geral",
                          onPressed: () {
                            navigationController.changePage("list-suport");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: Column(
                children: [
                  if (Responsive.isMobile(context))
                    const CustomerInfo(
                      name: 'Tran Mau Tri Tam',
                      designation: 'Visual Designer',
                      imageSrc:
                          'https://cdn.create.vista.com/api/media/small/339818716/stock-photo-doubtful-hispanic-man-looking-with-disbelief-expression',
                    ),
                  gapH8,
                  const Divider(),
                  gapH8,
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/help_light.svg',
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.textLight,
                          BlendMode.srcIn,
                        ),
                      ),
                      gapW8,
                      Text(
                        'Ajuda & Como utilizar',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Chip(
                        backgroundColor: AppColors.secondaryLavender,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 0.5),
                        label: Text(
                          "0",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  gapH20,
                  const ThemeTabs(),
                  gapH8,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }}