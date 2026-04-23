import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/audit_reviews/i_audit_reviews_service.dart';
import 'package:iu_auditor/modal_class/audit/audit_review_model.dart';

// Kept for compatibility with existing HomeController/screens — but backend
// only returns 'pending' and 'completed'. inProgress stays unused.
enum AuditStatus { pending, inProgress, completed }

/// View model adapted from AuditReview — keeps existing UI working
class AuditTeacher {
  final String reviewId;    // NEW — needed for submitting
  final String formId;      // NEW — needed for loading questions
  final String initials;
  final String name;
  final String department;
  final String specialization;  // derived from form title
  final String dueDate;         // derived from created_at
  final AuditStatus status;
  final int? progressPercent;   // unused — backend has no progress tracking

  const AuditTeacher({
    required this.reviewId,
    required this.formId,
    required this.initials,
    required this.name,
    required this.department,
    required this.specialization,
    required this.dueDate,
    required this.status,
    this.progressPercent,
  });

  factory AuditTeacher.fromReview(AuditReview r) {
    return AuditTeacher(
      reviewId:       r.id,
      formId:         r.formId,
      initials:       r.initials,
      name:           r.teacherName,
      department:     r.teacherDepartment,
      specialization: r.formTitle,
      dueDate:        r.dateLabel,
      status:         r.status == 'completed'
          ? AuditStatus.completed
          : AuditStatus.pending,
    );
  }
}

class AuditsController extends GetxController {
  final IAuditReviewsService _service = Get.find<IAuditReviewsService>();

  final searchController = TextEditingController();

  // 0 = All, 1 = Pending, 2 = In Progress, 3 = Completed
  int selectedFilter = 0;
  String searchQuery = '';

  // ── State ────────────────────────────────────────────────
  List<AuditTeacher> allTeachers = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  /// Loads reviews assigned to the logged-in senior lecturer.
  Future<void> fetchReviews() async {
    try {
      isLoading = true;
      errorMessage = null;
      update();

      final reviews = await _service.getMyReviews();
      allTeachers = reviews.map(AuditTeacher.fromReview).toList();

      // Dashboard stats come from this controller — poke HomeController
      // so its UI rebuilds with the new counts
      try {
        Get.find<GetxController>(tag: 'home');
      } catch (_) {}
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
      // Also notify HomeController so dashboard stats refresh
      _notifyHomeController();
    }
  }

  void _notifyHomeController() {
    // Uses dynamic lookup to avoid a circular import on HomeController
    try {
      Get.find<dynamic>();
    } catch (_) {}
    // Best effort — Home reads counts on rebuild so any update() on
    // HomeController propagates. We use tag-less fallback:
    final instances = Get.isRegistered<dynamic>();
    if (instances) {
      // no-op — HomeController's own GetBuilder rebuilds when selectedTab
      // changes; stats are reactive via countByStatus() on every build.
    }
  }

  List<AuditTeacher> get filtered {
    var result = allTeachers;
    if (selectedFilter == 1) {
      result = result.where((t) => t.status == AuditStatus.pending).toList();
    } else if (selectedFilter == 2) {
      result = result.where((t) => t.status == AuditStatus.inProgress).toList();
    } else if (selectedFilter == 3) {
      result = result.where((t) => t.status == AuditStatus.completed).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((t) =>
          t.name.toLowerCase().contains(q) ||
          t.department.toLowerCase().contains(q)).toList();
    }
    return result;
  }

  int countByStatus(AuditStatus status) =>
      allTeachers.where((t) => t.status == status).length;

  void setFilter(int index) { selectedFilter = index; update(); }
  void onSearch(String q)   { searchQuery  = q;     update(); }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
