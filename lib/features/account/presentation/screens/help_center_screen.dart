import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/core.dart';
import '../../../../core/widgets/custom_tabbar_widget.dart';

import '../widgets/contact_us_help_center.dart';
import '../widgets/faqs_help_center.dart';

class HelpCenterSearch extends StatefulWidget {
  const HelpCenterSearch({super.key});

  @override
  State<HelpCenterSearch> createState() => _HelpCenterSearchState();
}

class _HelpCenterSearchState extends State<HelpCenterSearch>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "helpCenter", isLocalize: true),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: UIConstants.mobileBodyPadding,
          child: Column(
            children: [
              CustomTabbarWidget(
                controller: _tabController,
                allowPadding: false,
                tabs: ['faq'.tr, 'contactUs'.tr],
              ),
              Gap(10.h),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: _tabController,
                  children: const [
                    FaqsHelpCenterBuild(),
                    ContactUsHelpCenterBuild(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
