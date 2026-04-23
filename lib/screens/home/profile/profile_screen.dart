import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/screens/home/home_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Column(
            children: [

              // ── Blue header ────────────────────────────────
              _ProfileHeader(controller: controller),

              // ── Info cards ────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _InfoCard(label: 'Email',      value: controller.userEmail),
                    const SizedBox(height: 12),
                    _InfoCard(label: 'Department', value: controller.userDepartment),
                    const SizedBox(height: 12),
                    _InfoCard(label: 'Role',       value: controller.userRole),
                    const SizedBox(height: 12),
                    _InfoCard(
                      label: 'Audits Completed',
                      value: controller.completedCount.toString(),
                    ),
                    const SizedBox(height: 32),

                    // ── Sign Out ──────────────────────────────
                    GestureDetector(
                      onTap: () => controller.signOut(),
                      child: AppContainer(
                        width: double.infinity,
                        bgColor: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(14),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout_rounded,
                                color: Color(0xFFDC2626), size: 20),
                            const SizedBox(width: 10),
                            AppTextSemiBold(
                              text: 'Sign Out',
                              color: const Color(0xFFDC2626),
                              fontSize: 15,
                              fontFamily: FontFamily.inter,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
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

// ── Profile Header ────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final HomeController controller;
  const _ProfileHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: navyBlueColor,
        borderRadius: BorderRadius.only(
          bottomLeft:  Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 32,
        left: 24,
        right: 24,
      ),
      child: Column(
        children: [
          AppTextBold(
            text: 'Profile',
            color: whiteColor,
            fontSize: 20,
            fontFamily: FontFamily.inter,
          ),
          const SizedBox(height: 24),
          // Avatar circle
          AppContainer(
            width: 80, height: 80,
            shape: BoxShape.circle,
            bgColor: whiteColor.withValues(alpha: 0.2),
            alignment: Alignment.center,
            child: AppTextBold(
              text: controller.userInitial,
              color: whiteColor,
              fontSize: 28,
              fontFamily: FontFamily.inter,
            ),
          ),
          const SizedBox(height: 14),
          AppTextBold(
            text: controller.userName.isEmpty ? 'Loading...' : controller.userName,
            color: whiteColor,
            fontSize: 18,
            fontFamily: FontFamily.inter,
          ),
          const SizedBox(height: 4),
          AppTextRegular(
            text: controller.userRole,
            color: whiteColor.withValues(alpha: 0.65),
            fontSize: 13,
          ),
          if (controller.userDepartment.isNotEmpty) ...[
            const SizedBox(height: 2),
            AppTextRegular(
              text: controller.userDepartment,
              color: whiteColor.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Info Card ─────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(14),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppTextRegular(
            text: label,
            color: descriptiveColor,
            fontSize: 13,
          ),
          Flexible(
            child: AppTextMedium(
              text: value.isEmpty ? '—' : value,
              color: navyBlueColor,
              fontSize: 14,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}