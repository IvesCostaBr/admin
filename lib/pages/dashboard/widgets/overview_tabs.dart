import 'package:flutter/material.dart';

import '../../../shared/constants/defaults.dart';
import '../../../shared/constants/ghaps.dart';
import '../../../shared/widgets/tabs/tab_with_growth.dart';
import '../../../theme/app_colors.dart';

class OverviewTabs extends StatefulWidget {
  const OverviewTabs({
    super.key,
  });

  @override
  State<OverviewTabs> createState() => _OverviewTabsState();
}

class _OverviewTabsState extends State<OverviewTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _selectedIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.bgLight,
            borderRadius:
                BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
          ),
          child: TabBar(
            controller: _tabController,
            dividerHeight: 0,
            padding: const EdgeInsets.symmetric(
                horizontal: 0, vertical: AppDefaults.padding),
            indicator: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(AppDefaults.borderRadius),
              ),
              color: AppColors.bgSecondayLight,
            ),
            tabs: const [
              TabWithGrowth(
                title: "Usuários",
                amount: "4",
                growthPercentage: "20%",
              ),
              TabWithGrowth(
                title: "Movimentado",
                iconSrc: "assets/icons/activity_light.svg",
                iconBgColor: AppColors.secondaryLavender,
                amount: "R\$ 4.965,43",
                growthPercentage: "40.7%",
                isPositiveGrowth: true,
              ),
            ],
          ),
        ),
        gapH24,
      ],
    );
  }
}
