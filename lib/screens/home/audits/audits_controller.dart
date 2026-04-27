import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/apis/audit_reviews/i_audit_reviews_service.dart';
import 'package:iu_auditor/modal_class/audit/audit_review_model.dart';

enum AuditStatus { pending, inProgress, completed }

class AuditTeacher {
  final String reviewId;
  final String formId;
  final String initials;
  final String name;
  final String department;
  final String specialization;
  final String dueDate;
  final DateTime? createdAt;
  final AuditStatus status;
  final int? progressPercent;

  const AuditTeacher({
    required this.reviewId,
    required this.formId,
    required this.initials,
    required this.name,
    required this.department,
    required this.specialization,
    required this.dueDate,
    this.createdAt,
    required this.status,
    this.progressPercent,
  });

  factory AuditTeacher.fromReview(AuditReview r) {
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(r.createdAt);
    } catch (_) {}

    return AuditTeacher(
      reviewId:       r.id,
      formId:         r.formId,
      initials:       r.initials,
      name:           r.teacherName,
      department:     r.teacherDepartment,
      specialization: r.formTitle,
      dueDate:        r.dateLabel,
      createdAt:      parsedDate,
      status:         r.status == 'completed'
          ? AuditStatus.completed
          : AuditStatus.pending,
    );
  }

  AuditTeacher copyWithStatus(AuditStatus newStatus) {
    return AuditTeacher(
      reviewId:       reviewId,
      formId:         formId,
      initials:       initials,
      name:           name,
      department:     department,
      specialization: specialization,
      dueDate:        dueDate,
      createdAt:      createdAt,
      status:         newStatus,
      progressPercent: progressPercent,
    );
  }
}

class AuditsController extends GetxController {
  final IAuditReviewsService _service = Get.find<IAuditReviewsService>();
  final IAuthService _authService = Get.find<IAuthService>();

  final searchController = TextEditingController();

  int selectedFilter = 0;
  String searchQuery = '';

  // ── State ─────────────────────────────────────────────────
  /// Raw reviews from API — kept as backup for re-filtering when profile loads
  List<AuditTeacher> _allFromApi = [];

  /// Filtered list (by department) — what the UI actually shows
  List<AuditTeacher> allTeachers = [];

  bool isLoading = false;
  String? errorMessage;

  /// Logged-in lecturer's department — used to gate visibility.
  /// Empty string means we haven't fetched the profile yet.
  String _lecturerDepartment = '';

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  /// Fetches profile + reviews together so the department filter is
  /// applied correctly on the very first render.
  Future<void> _bootstrap() async {
    try {
      isLoading = true;
      errorMessage = null;
      update();

      // 1. Get lecturer's profile (for department) and reviews in parallel
      final results = await Future.wait([
        _authService.fetchProfile(),
        _service.getMyReviews(),
      ]);

      final profile = results[0] as dynamic;
      final reviews = results[1] as List<AuditReview>;

      _lecturerDepartment = profile?.department ?? '';
      _allFromApi = reviews.map(AuditTeacher.fromReview).toList();

      _applyDepartmentFilter();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Lighter refetch — only reloads reviews, keeps cached department.
  Future<void> fetchReviews() async {
    try {
      isLoading = true;
      errorMessage = null;
      update();

      final reviews = await _service.getMyReviews();
      _allFromApi = reviews.map(AuditTeacher.fromReview).toList();

      // If we never got the department (race condition), grab it now
      if (_lecturerDepartment.isEmpty) {
        try {
          final profile = await _authService.fetchProfile();
          _lecturerDepartment = profile?.department ?? '';
        } catch (_) {}
      }

      _applyDepartmentFilter();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  /// 🔒 Department filter — extra client-side safety on top of backend filter.
  /// If department isn't loaded yet (race condition or missing field),
  /// show what the API returned — backend already filtered it server-side.
  void _applyDepartmentFilter() {
    if (_lecturerDepartment.isEmpty) {
      // No department known → trust backend's filter, show everything API gave us
      allTeachers = List.from(_allFromApi);
      return;
    }
    allTeachers = _allFromApi
        .where((t) => t.department.toLowerCase() ==
                      _lecturerDepartment.toLowerCase())
        .toList();
  }

  /// Called by HomeController when profile arrives — useful if the profile
  /// loads AFTER the audits do (rare race condition).
  void setLecturerDepartment(String department) {
    if (_lecturerDepartment == department) return;
    _lecturerDepartment = department;
    _applyDepartmentFilter();
    update();
  }

  void markCompletedLocally(String reviewId) {
    final apiIdx = _allFromApi.indexWhere((t) => t.reviewId == reviewId);
    if (apiIdx >= 0) {
      _allFromApi[apiIdx] =
          _allFromApi[apiIdx].copyWithStatus(AuditStatus.completed);
    }
    final visIdx = allTeachers.indexWhere((t) => t.reviewId == reviewId);
    if (visIdx >= 0) {
      allTeachers[visIdx] =
          allTeachers[visIdx].copyWithStatus(AuditStatus.completed);
      update();
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