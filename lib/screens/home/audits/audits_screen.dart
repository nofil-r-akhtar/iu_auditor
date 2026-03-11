import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/app_theme/colors.dart';
import 'package:iu_auditor/components/app_button.dart';
import 'package:iu_auditor/components/app_container.dart';
import 'package:iu_auditor/components/app_text.dart';
import 'package:iu_auditor/components/app_text_field.dart';
import 'package:iu_auditor/const/enums.dart';
import 'package:iu_auditor/core/app_responsive.dart';
import 'package:iu_auditor/screens/home/audits/audits_controller.dart';
import 'package:iu_auditor/screens/home/audits/audit_form/audit_form_controller.dart';
import 'package:iu_auditor/screens/home/audits/audit_form/audit_form_screen.dart';

class AuditsScreen extends StatelessWidget {
  const AuditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuditsController controller = Get.put(AuditsController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final r = AppResponsive(constraints.maxWidth);

        return Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              _Header(controller: controller, responsive: r),

              const SizedBox(height: 20),

              // ── Filter tabs ──
              _FilterTabs(controller: controller),

              const SizedBox(height: 20),

              // ── Table header (tablet/desktop only) ──
              if (r.useTableView) ...[
                _TableHeader(),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
              ],

              // ── Content list ──
              Expanded(
                child: GetBuilder<AuditsController>(
                  builder: (ctrl) {
                    final teachers = ctrl.filtered;

                    if (teachers.isEmpty) {
                      return AppContainer(
                        bgColor: whiteColor,
                        borderRadius: r.useTableView
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              )
                            : BorderRadius.circular(12),
                        child: Center(
                          child: AppTextRegular(
                            text: "No teachers found",
                            color: descriptiveColor,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    if (r.useTableView) {
                      // ── TABLE VIEW (tablet + desktop) ──
                      return AppContainer(
                        bgColor: whiteColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: teachers.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            color: Color(0xFFE2E8F0),
                          ),
                          itemBuilder: (context, index) =>
                              _TeacherRow(teacher: teachers[index]),
                        ),
                      );
                    } else {
                      // ── CARD VIEW (mobile) ──
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: teachers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            _TeacherCard(teacher: teachers[index]),
                      );
                    }
                  },
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
// HEADER
// ─────────────────────────────────────────
class _Header extends StatelessWidget {
  final AuditsController controller;
  final AppResponsive responsive;
  const _Header({required this.controller, required this.responsive});

  @override
  Widget build(BuildContext context) {
    // On mobile the search goes below the title to avoid cramping
    if (responsive.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextBold(
            text: "Teachers to Audit",
            color: navyBlueColor,
            fontSize: 20,
            fontFamily: FontFamily.inter,
          ),
          const SizedBox(height: 4),
          GetBuilder<AuditsController>(
            builder: (ctrl) => AppTextRegular(
              text: "${ctrl.allTeachers.length} teachers assigned",
              color: descriptiveColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          AppTextField(
            textController: controller.searchController,
            placeholder: "Search teachers...",
            placeholderColor: iconColor,
            prefixIcon: const Icon(Icons.search, color: iconColor, size: 18),
            backgroundColor: whiteColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
            onChanged: controller.onSearch,
          ),
        ],
      );
    }

    // Tablet / Desktop: title left, search right
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextBold(
                text: "Teachers to Audit",
                color: navyBlueColor,
                fontSize: 22,
                fontFamily: FontFamily.inter,
              ),
              const SizedBox(height: 4),
              GetBuilder<AuditsController>(
                builder: (ctrl) => AppTextRegular(
                  text: "${ctrl.allTeachers.length} teachers assigned",
                  color: descriptiveColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 280,
          child: AppTextField(
            textController: controller.searchController,
            placeholder: "Search teachers...",
            placeholderColor: iconColor,
            prefixIcon: const Icon(Icons.search, color: iconColor, size: 18),
            backgroundColor: whiteColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
            onChanged: controller.onSearch,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// FILTER TABS
// ─────────────────────────────────────────
class _FilterTabs extends StatelessWidget {
  final AuditsController controller;
  const _FilterTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuditsController>(
      builder: (ctrl) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterTab(
              label: "All",
              count: ctrl.allTeachers.length,
              isSelected: ctrl.selectedFilter == 0,
              onTap: () => ctrl.setFilter(0),
            ),
            const SizedBox(width: 8),
            _FilterTab(
              label: "Pending",
              count: ctrl.countByStatus(AuditStatus.pending),
              isSelected: ctrl.selectedFilter == 1,
              onTap: () => ctrl.setFilter(1),
            ),
            const SizedBox(width: 8),
            _FilterTab(
              label: "In Progress",
              count: ctrl.countByStatus(AuditStatus.inProgress),
              isSelected: ctrl.selectedFilter == 2,
              onTap: () => ctrl.setFilter(2),
            ),
            const SizedBox(width: 8),
            _FilterTab(
              label: "Completed",
              count: ctrl.countByStatus(AuditStatus.completed),
              isSelected: ctrl.selectedFilter == 3,
              onTap: () => ctrl.setFilter(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppContainer(
        bgColor: isSelected ? navyBlueColor : whiteColor,
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextMedium(
              text: label,
              color: isSelected ? whiteColor : descriptiveColor,
              fontSize: 13,
            ),
            const SizedBox(width: 6),
            AppContainer(
              bgColor: isSelected ? whiteColor.withValues(alpha: 0.2) : bgColor,
              borderRadius: BorderRadius.circular(10),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              child: AppTextRegular(
                text: '$count',
                color: isSelected ? whiteColor : descriptiveColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// TABLE HEADER (tablet/desktop only)
// ─────────────────────────────────────────
class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const SizedBox(width: 50),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: AppTextSemiBold(
              text: "Teacher",
              color: navyBlueColor,
              fontSize: 13,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppTextSemiBold(
              text: "Department",
              color: navyBlueColor,
              fontSize: 13,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppTextSemiBold(
              text: "Specialization",
              color: navyBlueColor,
              fontSize: 13,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppTextSemiBold(
              text: "Due Date",
              color: navyBlueColor,
              fontSize: 13,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppTextSemiBold(
              text: "Status",
              color: navyBlueColor,
              fontSize: 13,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppTextSemiBold(
              text: "Action",
              color: navyBlueColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// TABLE ROW (tablet/desktop)
// ─────────────────────────────────────────
class _TeacherRow extends StatelessWidget {
  final AuditTeacher teacher;
  const _TeacherRow({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          AppContainer(
            width: 50,
            height: 50,
            bgColor: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(10),
            alignment: Alignment.center,
            child: AppTextSemiBold(
              text: teacher.initials,
              color: primaryColor,
              fontSize: 12,
              fontFamily: FontFamily.inter,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: AppTextSemiBold(
              text: teacher.name,
              color: navyBlueColor,
              fontSize: 14,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppTextRegular(
              text: teacher.department,
              color: descriptiveColor,
              fontSize: 13,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppTextRegular(
              text: "• ${teacher.specialization}",
              color: descriptiveColor,
              fontSize: 13,
            ),
          ),
          Expanded(
            flex: 2,
            child: AppTextRegular(
              text: "Due: ${teacher.dueDate}",
              color: descriptiveColor,
              fontSize: 13,
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusBadge(status: teacher.status),
                if (teacher.status == AuditStatus.inProgress &&
                    teacher.progressPercent != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: teacher.progressPercent! / 100,
                            backgroundColor: bgColor,
                            color: primaryColor,
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      AppTextRegular(
                        text: "${teacher.progressPercent}%",
                        color: descriptiveColor,
                        fontSize: 11,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Expanded(flex: 2, child: _ActionButton(teacher: teacher)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// CARD VIEW ROW (mobile)
// ─────────────────────────────────────────
class _TeacherCard extends StatelessWidget {
  final AuditTeacher teacher;
  const _TeacherCard({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + name + status
          Row(
            children: [
              AppContainer(
                width: 44,
                height: 44,
                bgColor: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
                alignment: Alignment.center,
                child: AppTextSemiBold(
                  text: teacher.initials,
                  color: primaryColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextSemiBold(
                      text: teacher.name,
                      color: navyBlueColor,
                      fontSize: 14,
                    ),
                    AppTextRegular(
                      text: teacher.department,
                      color: descriptiveColor,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: teacher.status),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE2E8F0), height: 1),
          const SizedBox(height: 12),

          // Details row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextRegular(
                      text: "Specialization",
                      color: iconColor,
                      fontSize: 11,
                    ),
                    AppTextRegular(
                      text: teacher.specialization,
                      color: descriptiveColor,
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextRegular(
                      text: "Due Date",
                      color: iconColor,
                      fontSize: 11,
                    ),
                    AppTextRegular(
                      text: teacher.dueDate,
                      color: descriptiveColor,
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Progress bar for in-progress
          if (teacher.status == AuditStatus.inProgress &&
              teacher.progressPercent != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: teacher.progressPercent! / 100,
                      backgroundColor: bgColor,
                      color: primaryColor,
                      minHeight: 5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AppTextRegular(
                  text: "${teacher.progressPercent}%",
                  color: descriptiveColor,
                  fontSize: 11,
                ),
              ],
            ),
          ],

          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: _ActionButton(teacher: teacher),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// ACTION BUTTON (shared)
// ─────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final AuditTeacher teacher;
  const _ActionButton({required this.teacher});

  @override
  Widget build(BuildContext context) {
    if (teacher.status == AuditStatus.completed) {
      return AppTextRegular(
        text: "View Report",
        color: primaryColor,
        fontSize: 13,
      );
    }

    return AppButton(
      txt: teacher.status == AuditStatus.inProgress
          ? "Continue"
          : "Start Audit",
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: BorderRadius.circular(8),
      bgColor: teacher.status == AuditStatus.inProgress
          ? const Color(0xFFEEF2FF)
          : primaryColor,
      txtColor: teacher.status == AuditStatus.inProgress
          ? primaryColor
          : whiteColor,
      onPress: () {
        Get.delete<AuditFormController>(tag: teacher.name, force: true);
        final ctrl = AuditFormController(
          teacherName: teacher.name,
          department: teacher.department,
          specialization: teacher.specialization,
          initials: teacher.initials,
        );
        Get.put(ctrl, tag: teacher.name);
        Get.to(() => AuditFormScreen(controller: ctrl));
      },
    );
  }
}

// ─────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final AuditStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    String label;
    IconData icon;

    switch (status) {
      case AuditStatus.pending:
        color = const Color(0xFFF59E0B);
        bg = const Color(0xFFFEF3C7);
        label = "Pending";
        icon = Icons.hourglass_empty_rounded;
        break;
      case AuditStatus.inProgress:
        color = primaryColor;
        bg = const Color(0xFFEEF2FF);
        label = "In Progress";
        icon = Icons.edit_note_rounded;
        break;
      case AuditStatus.completed:
        color = const Color(0xFF10B981);
        bg = const Color(0xFFD1FAE5);
        label = "Completed";
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    return AppContainer(
      bgColor: bg,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          AppTextRegular(text: label, color: color, fontSize: 12),
        ],
      ),
    );
  }
}
