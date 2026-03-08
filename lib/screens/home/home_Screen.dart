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
import 'package:iu_auditor/modal_class/table/table_model.dart';
import 'package:iu_auditor/screens/home/home_Screen_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        children: [
          _SideBar(controller: controller),
          Expanded(
            child: Column(
              children: [
                _TopBar(controller: controller),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    // Single top-level Obx to switch between tabs
                    child: GetBuilder<HomeController>(
                      builder: (ctrl) {
                        if (ctrl.selectedIndex == 0) {
                          return _DashboardBody(controller: ctrl);
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
                ),
              ],
            ),
          ),
        ],
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App brand header
          AppContainer(
            bgColor: const Color(0xFF162032),
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
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

          // Nav label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: AppTextRegular(
              text: "MENU",
              color: whiteColor.withValues(alpha: 0.3),
              fontSize: 10,
            ),
          ),

          // Nav items
          Expanded(
            child: GetBuilder<HomeController>(
              builder: (ctrl) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _items.map((item) {
                  final isSelected = ctrl.selectedIndex == item.index;
                  return GestureDetector(
                    onTap: () => ctrl.selectTab(item.index),
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

          // Sign Out
          GestureDetector(
            onTap: () => controller.signOut(),
            child: AppContainer(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              child: SideBarItem(icon: signOut, name: 'Sign Out'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final HomeController controller;
  const _TopBar({required this.controller});

  static const List<String> _titles = [
    'Dashboard',
    'New Faculties',
    'Senior Lecturers',
    'Audit Questions',
    'Audit Reviews',
    'User Management',
  ];

  @override
  Widget build(BuildContext context) {
    // Single GetBuilder covers all top bar reactive fields
    return GetBuilder<HomeController>(
      builder: (ctrl) => AppContainer(
        bgColor: whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Row(
          children: [
            AppTextBold(
              text: ctrl.selectedIndex < _titles.length
                  ? _titles[ctrl.selectedIndex]
                  : 'Dashboard',
              color: navyBlueColor,
              fontSize: 20,
              fontFamily: FontFamily.inter,
            ),
            const Spacer(),
            AppSvg(assetPath: bell, height: 22, width: 22),
            const SizedBox(width: 24),
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
            AppContainer(
              bgColor: navyBlueColor,
              shape: BoxShape.circle,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
  const _DashboardBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GreetingBanner(controller: controller),
        const SizedBox(height: 24),
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
    // No Obx needed — greeting data is static after login
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
    // GetBuilder rebuilds this row when stats change
    return GetBuilder<HomeController>(
      builder: (ctrl) => Row(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppContainer(
            bgColor: iconBg,
            borderRadius: BorderRadius.circular(10),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          AppTextBold(
            text: '$count',
            color: navyBlueColor,
            fontSize: 28,
            fontFamily: FontFamily.inter,
          ),
          const SizedBox(height: 4),
          AppTextRegular(text: label, color: descriptiveColor, fontSize: 13),
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
            Column(
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
          onPress: () {},
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
                onTap: () {},
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
