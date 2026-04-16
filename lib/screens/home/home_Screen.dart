import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_svg.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/home_components/screen_table/screen_table.dart';
import 'package:iu_auditor/components/home_components/side_bar_item.dart';
import 'package:iu_auditor/const/assets.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/core/app_responsive.dart';
import 'package:iu_auditor/modal_class/table/table_model.dart';
import 'package:iu_auditor/screens/home/home_controller.dart';
import 'package:iu_auditor/screens/home/audits/audits_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Static key so the drawer can be opened from the top bar
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final r = AppResponsive(constraints.maxWidth);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: bgColor,
          // On mobile the sidebar lives in a drawer
          drawer: r.isMobile ? _SideBar(controller: controller) : null,
          body: Row(
            children: [
              // Persistent sidebar on tablet + desktop
              if (!r.isMobile) _SideBar(controller: controller),
              Expanded(
                child: Column(
                  children: [
                    _TopBar(controller: controller, responsive: r),
                    Expanded(
                      child: GetBuilder<HomeController>(
                        builder: (ctrl) {
                          if (ctrl.selectedIndex == 0) {
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(28),
                              child: _DashboardBody(
                                controller: ctrl,
                                responsive: r,
                              ),
                            );
                          }
                          if (ctrl.selectedIndex == 1) {
                            return const AuditsScreen();
                          }
                          return Center(
                            child: AppTextMedium(
                              text: "Coming Soon",
                              color: descriptiveColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// SIDEBAR
// ─────────────────────────────────────────
class _SideBarNavItem {
  final String icon;
  final String name;
  final int index;
  const _SideBarNavItem({
    required this.icon,
    required this.name,
    required this.index,
  });
}

class _SideBar extends StatelessWidget {
  final HomeController controller;
  const _SideBar({required this.controller});

  static final List<_SideBarNavItem> _items = [
    _SideBarNavItem(icon: dashboard, name: 'Home', index: 0),
    _SideBarNavItem(icon: auditReviews, name: 'Audits', index: 1),
    _SideBarNavItem(icon: user, name: 'Profile', index: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: 220,
      bgColor: navyBlueColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand header
            AppContainer(
              bgColor: const Color(0xFF162032),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppContainer(
                    bgColor: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    padding: const EdgeInsets.all(8),
                    child: AppSvg(
                      assetPath: dashboard,
                      color: whiteColor,
                      height: 20,
                      width: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppTextBold(
                    text: "IU Auditor",
                    color: whiteColor,
                    fontSize: 16,
                    fontFamily: FontFamily.inter,
                  ),
                  AppTextRegular(
                    text: "Admin Portal",
                    color: whiteColor.withValues(alpha: 0.45),
                    fontSize: 11,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: AppTextRegular(
                text: "MENU",
                color: whiteColor.withValues(alpha: 0.3),
                fontSize: 10,
              ),
            ),

            Expanded(
              child: GetBuilder<HomeController>(
                builder: (ctrl) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _items.map((item) {
                    final isSelected = ctrl.selectedIndex == item.index;
                    return GestureDetector(
                      onTap: () {
                        ctrl.selectTab(item.index);
                        // Close drawer on mobile after selecting a tab
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: AppContainer(
                        width: double.infinity,
                        bgColor: isSelected ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 13,
                        ),
                        child: SideBarItem(
                          icon: item.icon,
                          name: item.name,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const Divider(color: Colors.white12, height: 1),

            GestureDetector(
              onTap: () => controller.signOut(),
              child: AppContainer(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 20,
                ),
                child: SideBarItem(icon: signOut, name: 'Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final HomeController controller;
  final AppResponsive responsive;
  const _TopBar({required this.controller, required this.responsive});

  static const List<String> _titles = ['Home', 'Audits', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) => AppContainer(
        bgColor: whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Hamburger on mobile
            if (responsive.isMobile)
              GestureDetector(
                onTap: () => HomeScreen._scaffoldKey.currentState?.openDrawer(),
                child: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.menu_rounded, color: navyBlueColor),
                ),
              ),

            AppTextBold(
              text: ctrl.selectedIndex < _titles.length
                  ? _titles[ctrl.selectedIndex]
                  : 'Home',
              color: navyBlueColor,
              fontSize: responsive.isMobile ? 16 : 20,
              fontFamily: FontFamily.inter,
            ),

            const Spacer(),

            AppSvg(assetPath: bell, height: 22, width: 22),
            const SizedBox(width: 16),

            // Hide name/role on mobile — too cramped
            if (!responsive.isMobile) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextMedium(
                    text: ctrl.userName,
                    color: navyBlueColor,
                    fontSize: 14,
                  ),
                  AppTextRegular(
                    text: ctrl.userRole,
                    color: descriptiveColor,
                    fontSize: 12,
                  ),
                ],
              ),
              const SizedBox(width: 12),
            ],

            AppContainer(
              bgColor: navyBlueColor,
              shape: BoxShape.circle,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: AppTextRegular(
                text: ctrl.userInitial,
                color: whiteColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// DASHBOARD BODY
// ─────────────────────────────────────────
class _DashboardBody extends StatelessWidget {
  final HomeController controller;
  final AppResponsive responsive;
  const _DashboardBody({required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    // On desktop: side-by-side rows
    // On tablet/mobile: everything stacks vertically
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GreetingBanner(controller: controller),
        const SizedBox(height: 24),

        if (responsive.isDesktop) ...[
          // Desktop: stats (flex 3) + quick actions (flex 2) side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _StatsRow(controller: controller)),
              const SizedBox(width: 20),
              const Expanded(flex: 2, child: _StartAuditBanner()),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _UpcomingAudits(controller: controller)),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: _RecentActivity(controller: controller)),
            ],
          ),
        ] else ...[
          // Tablet / Mobile: everything stacked
          _StatsRow(controller: controller),
          const SizedBox(height: 20),
          const _StartAuditBanner(),
          const SizedBox(height: 20),
          _UpcomingAudits(controller: controller),
          const SizedBox(height: 20),
          _RecentActivity(controller: controller),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────
// GREETING BANNER
// ─────────────────────────────────────────
class _GreetingBanner extends StatelessWidget {
  final HomeController controller;
  const _GreetingBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: primaryColor,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(28),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextRegular(
                  text: controller.greeting,
                  color: whiteColor.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
                const SizedBox(height: 4),
                AppTextBold(
                  text: controller.userName,
                  color: whiteColor,
                  fontSize: 24,
                  fontFamily: FontFamily.inter,
                ),
                const SizedBox(height: 8),
                AppTextRegular(
                  text: "Here's your audit overview for today.",
                  color: whiteColor.withValues(alpha: 0.75),
                  fontSize: 13,
                ),
              ],
            ),
          ),
          AppSvg(
            assetPath: auditReviews,
            color: whiteColor.withValues(alpha: 0.2),
            height: 80,
            width: 80,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// STATS ROW
// ─────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final HomeController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) => LayoutBuilder(
        builder: (context, constraints) {
          final r = AppResponsive(constraints.maxWidth);

          // On very narrow widths wrap cards in a column instead of a row
          // so they never overflow
          if (r.isMobile) {
            return Column(
              children: [
                _StatCard(
                  label: 'Pending',
                  count: ctrl.pendingCount,
                  icon: Icons.hourglass_empty_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFEF3C7),
                ),
                const SizedBox(height: 12),
                _StatCard(
                  label: 'In Progress',
                  count: ctrl.inProgressCount,
                  icon: Icons.edit_note_rounded,
                  iconColor: primaryColor,
                  iconBg: const Color(0xFFDBEAFE),
                ),
                const SizedBox(height: 12),
                _StatCard(
                  label: 'Completed',
                  count: ctrl.completedCount,
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: const Color(0xFF10B981),
                  iconBg: const Color(0xFFD1FAE5),
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Pending',
                  count: ctrl.pendingCount,
                  icon: Icons.hourglass_empty_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFEF3C7),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  label: 'In Progress',
                  count: ctrl.inProgressCount,
                  icon: Icons.edit_note_rounded,
                  iconColor: primaryColor,
                  iconBg: const Color(0xFFDBEAFE),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  label: 'Completed',
                  count: ctrl.completedCount,
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: const Color(0xFF10B981),
                  iconBg: const Color(0xFFD1FAE5),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          AppContainer(
            bgColor: iconBg,
            borderRadius: BorderRadius.circular(10),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextBold(
                text: '$count',
                color: navyBlueColor,
                fontSize: 24,
                fontFamily: FontFamily.inter,
              ),
              AppTextRegular(
                text: label,
                color: descriptiveColor,
                fontSize: 13,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// START NEW AUDIT BANNER
// ─────────────────────────────────────────
class _StartAuditBanner extends StatelessWidget {
  const _StartAuditBanner();

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextSemiBold(
            text: "Quick Actions",
            color: navyBlueColor,
            fontSize: 15,
            fontFamily: FontFamily.inter,
          ),
          const SizedBox(height: 16),
          AppButton(
            txt: "  Start New Audit  →",
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            icon: const Icon(
              Icons.edit_note_rounded,
              color: whiteColor,
              size: 20,
            ),
            spacing: 6,
            borderRadius: BorderRadius.circular(10),
            onPress: () => Get.find<HomeController>().startNewAudit(),
          ),
          const SizedBox(height: 10),
          AppButton(
            txt: "  View All Audits  →",
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            bgColor: bgColor,
            txtColor: navyBlueColor,
            icon: const Icon(
              Icons.list_alt_rounded,
              color: navyBlueColor,
              size: 20,
            ),
            spacing: 6,
            borderRadius: BorderRadius.circular(10),
            onPress: () => Get.find<HomeController>().viewAllAudits(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// UPCOMING AUDITS TABLE
// ─────────────────────────────────────────
class _UpcomingAudits extends StatelessWidget {
  final HomeController controller;
  const _UpcomingAudits({required this.controller});

  @override
  Widget build(BuildContext context) {
    final columns = [
      TableColumnModel(
        title: 'Faculty',
        cellBuilder: (row) => Row(
          children: [
            AppContainer(
              bgColor: bgColor,
              borderRadius: BorderRadius.circular(8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: AppTextSemiBold(
                text: row['initials'],
                color: primaryColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextSemiBold(
                    text: row['name'],
                    color: navyBlueColor,
                    fontSize: 14,
                  ),
                  AppTextRegular(
                    text: row['department'],
                    color: descriptiveColor,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      TableColumnModel(
        title: 'Due Date',
        cellBuilder: (row) {
          final isHigh = row['urgency'] == 'high';
          final isMed = row['urgency'] == 'medium';
          final color = isHigh
              ? redColor
              : isMed
              ? const Color(0xFFF59E0B)
              : const Color(0xFF10B981);
          final bg = isHigh
              ? const Color(0xFFFEE2E2)
              : isMed
              ? const Color(0xFFFEF3C7)
              : const Color(0xFFD1FAE5);
          return AppContainer(
            bgColor: bg,
            borderRadius: BorderRadius.circular(20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: AppTextRegular(text: row['due'], color: color, fontSize: 12),
          );
        },
      ),
      TableColumnModel(
        title: 'Action',
        cellBuilder: (row) => AppButton(
          txt: "Start",
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          borderRadius: BorderRadius.circular(8),
          onPress: () => Get.find<HomeController>().startNewAudit(),
        ),
      ),
    ];

    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextSemiBold(
                text: "Upcoming Audits",
                color: navyBlueColor,
                fontSize: 15,
                fontFamily: FontFamily.inter,
              ),
              GestureDetector(
                onTap: () => controller.viewAllAudits(),
                child: AppTextRegular(
                  text: "View All",
                  color: primaryColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ScreenTable(
            columns: columns,
            data: controller.upcomingAudits,
            controller: controller.upcomingAuditsTableController,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// RECENT ACTIVITY
// ─────────────────────────────────────────
class _RecentActivity extends StatelessWidget {
  final HomeController controller;
  const _RecentActivity({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextSemiBold(
            text: "Recent Activity",
            color: navyBlueColor,
            fontSize: 15,
            fontFamily: FontFamily.inter,
          ),
          const SizedBox(height: 16),
          ...controller.recentActivity.map(
            (activity) => _ActivityItem(activity: activity),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final Map<String, dynamic> activity;
  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    final isComplete = activity['icon'] == 'complete';
    final isStart = activity['icon'] == 'start';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            bgColor: isComplete
                ? const Color(0xFFD1FAE5)
                : isStart
                ? const Color(0xFFDBEAFE)
                : bgColor,
            shape: BoxShape.circle,
            padding: const EdgeInsets.all(8),
            child: Icon(
              isComplete
                  ? Icons.check_circle_outline_rounded
                  : isStart
                  ? Icons.play_circle_outline_rounded
                  : Icons.upload_outlined,
              color: isComplete
                  ? const Color(0xFF10B981)
                  : isStart
                  ? primaryColor
                  : descriptiveColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'inter',
                      color: descriptiveColor,
                    ),
                    children: [
                      TextSpan(text: '${activity['action']} '),
                      TextSpan(
                        text: activity['target'],
                        style: const TextStyle(
                          color: navyBlueColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                AppTextRegular(
                  text: activity['time'],
                  color: iconColor,
                  fontSize: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
