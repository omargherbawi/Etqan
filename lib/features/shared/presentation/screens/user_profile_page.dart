import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide Trans;
import '../../../../config/asset_paths.dart';
import '../../../../core/core.dart';
import '../../../account/data/models/profile_model.dart';
import '../../data/datasources/shared_remote_datasources.dart';
import '../controllers/current_user_controller.dart';
import '../widgets/user_profile_wdiget.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with TickerProviderStateMixin {
  bool isLoading = true;

  ProfileModel? profile;
  late TabController tabController;

  int currentTab = 0;

  bool isShowAboutButton = true;
  bool isShowMeetingButton = false;

  ScrollController scrollController = ScrollController();
  final sharedRemoteDatasources = Get.find<SharedRemoteDatasources>();

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      int? id = ModalRoute.of(context)!.settings.arguments as int;

      log(
        "USER ID ISUSER ID ISUSER ID ISUSER ID ISUSER ID ISUSER ID ISUSER ID ISUSER ID IS: ${id.toString()}",
      );

      getData(id);
    });

    tabController.addListener(() {
      onChangeTab(tabController.index);
    });
  }

  getData(int id) async {
    setState(() {
      isLoading = true;
    });

    profile = await sharedRemoteDatasources.getUserProfile(id);

    if (profile?.roleName == 'organization') {
      tabController = TabController(length: 5, vsync: this);
    }

    setState(() {
      isLoading = false;
    });
  }

  offAllButton() {
    isShowAboutButton = false;
    isShowMeetingButton = false;
  }

  onChangeTab(int tab) {
    offAllButton();

    if (tab == 0) {
      offAllButton();
      isShowAboutButton = true;
    }

    if (tab == 3) {
      offAllButton();
      isShowMeetingButton = true;
    }

    setState(() {
      currentTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: profile?.fullName ?? ''),
      body:
          isLoading
              ? const Center(child: LoadingAnimation())
              : Stack(
                children: [
                  Positioned.fill(
                    child: NestedScrollView(
                      headerSliverBuilder: (_, __) {
                        return [
                          // image + name + 3 item
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                const Gap(20),

                                // image
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        100.r,
                                      ),
                                      child: CustomImage(
                                        image: profile?.avatar ?? '',
                                        width: 100.w,
                                        height: 100.h,
                                      ),
                                    ),
                                    if (profile?.verified == 1) ...{
                                      PositionedDirectional(
                                        end: 0,
                                        top: 12,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Get.theme.colorScheme.primary
                                                .withValues(alpha: 0.8),
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    },
                                  ],
                                ),

                                const Gap(20),

                                CustomTextWidget(text: profile?.fullName ?? ''),

                                const Gap(6),

                                ratingBar(profile?.rate ?? '0', itemSize: 15),

                                const Gap(24),

                                // classes + students + followers
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(),

                                    // classes
                                    // UserProfileWidget.profileItem(
                                    //   "classes",
                                    //   profile?.webinars?.length.toString() ??
                                    //       '0',
                                    //   AssetPaths.videoSvg,
                                    //   Colors.green,
                                    // ),

                                    // students
                                    UserProfileWidget.profileItem(
                                      "students",
                                      profile?.students?.length.toString() ??
                                          '0',
                                      AssetPaths.profileSvg,
                                      Colors.blue,
                                      width: 25,
                                    ),

                                    // followers
                                    // UserProfileWidget.profileItem(
                                    //   "followers",
                                    //   profile?.followersCount.toString() ?? '0',
                                    //   AssetPaths.provideresSvg,
                                    //   Colors.yellow,
                                    //   width: 25,
                                    // ),
                                    const SizedBox(),
                                  ],
                                ),

                                const Gap(12),
                              ],
                            ),
                          ),

                          // tab
                          SliverAppBar(
                            titleSpacing: 0,
                            pinned: true,
                            automaticallyImplyLeading: false,
                            shadowColor: Colors.grey.withValues(alpha: .12),
                            elevation: 8,
                            centerTitle: true,
                            backgroundColor: Get.theme.scaffoldBackgroundColor,
                            surfaceTintColor: Get.theme.colorScheme.primary,
                            title: SizedBox(
                              width: Get.width,
                              child: tabBar(
                                (i) {
                                  onChangeTab(i);
                                },
                                tabController,
                                [
                                  Tab(
                                    height: 32,
                                    child: Text("about".tr(context: context)),
                                  ),
                                  Tab(
                                    height: 32,
                                    child: Text("classes".tr(context: context)),
                                  ),
                                  Tab(
                                    height: 32,
                                    child: Text("badges".tr(context: context)),
                                  ),
                                  Tab(
                                    height: 32,
                                    child: Text("meeting".tr(context: context)),
                                  ),
                                  if (profile?.roleName == 'organization') ...{
                                    Tab(
                                      height: 32,
                                      child: Text(
                                        "instrcutors".tr(context: context),
                                      ),
                                    ),
                                  },
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        controller: tabController,
                        children: [
                          if (profile == null) ...{
                            const Text("NULLLLLL"),
                          } else ...{
                            // UserProfileWidget.aboutPage(profile!),
                            // UserProfileWidget.classesPage(profile!),
                            // UserProfileWidget.badgesPage(profile!),
                            // UserProfileWidget.meetingPage(profile!),
                            // if (profile?.roleName == 'organization') ...{
                            //   UserProfileWidget.instructorPage(profile!),
                            // },
                          },
                        ],
                      ),
                    ),
                  ),

                  // about button
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    bottom: isShowAboutButton ? 0 : -150,
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          boxShadow(
                            Colors.black.withOpacity(.1),
                            blur: 15,
                            y: -3,
                          ),
                        ],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                if (Get.find<CurrentUserController>().profile !=
                                    null) {
                                  profile?.authUserIsFollower =
                                      !(profile?.authUserIsFollower ?? false);
                                  sharedRemoteDatasources.follow(
                                    profile!.id!,
                                    (profile?.authUserIsFollower ?? false),
                                  );

                                  setState(() {});
                                }
                              },
                              width: Get.width,
                              height: 51,
                              backgroundColor: Colors.white,
                              child: CustomTextWidget(
                                text:
                                    (profile?.authUserIsFollower ?? false)
                                        ? "unFollow"
                                        : "follow",
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          // if (profile?.publicMessage == 1) ...{
                          //   const Gap(20),
                          //   Expanded(
                          //     child: CustomButton(
                          //       onPressed: () {
                          //         UserProfileWidget.showSendMessageDialog(
                          //           profile!.id!,
                          //         );
                          //       },
                          //       width: Get.width,
                          //       height: 51.h,
                          //       text: "sendMessage",
                          //       backgroundColor: Get.theme.colorScheme.primary,
                          //       child: CustomTextWidget(
                          //         text: "sendMessage",
                          //         color: Get.theme.colorScheme.onSurface,
                          //       ),
                          //     ),
                          //   ),
                          // },
                        ],
                      ),
                    ),
                  ),

                  // meeting button
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    bottom: isShowMeetingButton ? 0 : -150,
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          boxShadow(
                            Colors.black.withOpacity(.1),
                            blur: 15,
                            y: -3,
                          ),
                        ],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          // title and price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextWidget(
                                text: "hourlyCharge",
                                color: greyA5,
                              ),
                              // Row(
                              //   children: [
                              //     if (profile?.meeting?.discount != null) ...{
                              //       CustomTextWidget(
                              //         // text: CurrencyUtils.calculator(
                              //         //     profile?.meeting?.price ?? 0),
                              //         text:
                              //             (profile?.meeting?.price ?? 0)
                              //                 .toString(),
                              //         color: greyA5,
                              //         decoration: TextDecoration.lineThrough,
                              //       ),
                              //       const Gap(8),
                              //     },
                              //     // CustomTextWidget(
                              //     //   //  text: CurrencyUtils.calculator(
                              //     //   //       profile?.meeting?.priceWithDiscount ?? 0),
                              //     //   text:
                              //     //       (profile?.meeting?.priceWithDiscount ??
                              //     //               0)
                              //     //           .toString(),
                              //     //   fontWeight: FontWeight.bold,
                              //     //   color: Get.theme.colorScheme.primary,
                              //     // ),
                              //   ],
                              // ),
                            ],
                          ),

                          // const Gap(16),
                          //
                          // CustomButton(
                          //   onPressed: () {
                          //     baseBottomSheet(
                          //       child: SelectDatePage(profile!.id!, profile!),
                          //     );
                          //   },
                          //   width: Get.width,
                          //   height: 51,
                          //   backgroundColor: Get.theme.colorScheme.primary,
                          //   child: CustomTextWidget(
                          //     text: "reserveMeeting",
                          //     color: Get.theme.colorScheme.onSurface,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
