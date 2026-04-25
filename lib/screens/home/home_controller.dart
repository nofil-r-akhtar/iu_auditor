import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/apis/auth/i_auth_service.dart';
import 'package:iu_auditor/components/home_components/screen_table/screen_table_controller.dart';
import 'package:iu_auditor/modal_class/user/user_profile.dart';
import 'package:iu_auditor/screens/auth/login/login.dart';
import 'package:iu_auditor/screens/auth/login/login_controller.dart';
import 'package:iu_auditor/screens/home/audits/audits_controller.dart';

class HomeController extends GetxController {
  final IAuthService _authService = Get.find<IAuthService>();

  final ScreenTableController upcomingAuditsTableController =
      ScreenTableController(rowsPerPage: 5);

  int selectedIndex = 0;

  // ── User info — populated from profile API ────────────────
  String userName       = '';
  String userRole       = '';
  String userInitial    = '';
  String userEmail      = '';
  String userDepartment = '';
  bool isLoadingProfile = false;

  late final AuditsController _auditsController;

  int get pendingCount    => _auditsController.countByStatus(AuditStatus.pending);
  int get inProgressCount => _auditsController.countByStatus(AuditStatus.inProgress);
  int get completedCount  => _auditsController.countByStatus(AuditStatus.completed);

  List<Map<String, dynamic>> get upcomingAudits {
    return _auditsController.allTeachers
        .where((t) => t.status != AuditStatus.completed)
        .take(4)
        .map((t) => {
              'name':       t.name,
              'department': t.department,
              'due':        'Due ${t.dueDate}',
              'urgency':    t.status == AuditStatus.inProgress ? 'high' : 'low',
              'initials':   t.initials,
            })
        .toList();
  }

  /// ── Recent Activity — derived from actual review data ────
  /// Builds a sorted timeline of completed audits + newly assigned ones.
  List<Map<String, dynamic>> get recentActivity {
    final teachers = _auditsController.allTeachers
        .where((t) => t.createdAt != null)
        .toList()
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return teachers.take(5).map((t) {
      final isCompleted = t.status == AuditStatus.completed;
      return {
        'action':   isCompleted ? 'Completed audit for' : 'Audit assigned for',
        'target':   t.name,
        'time':     _relativeTime(t.createdAt!),
        'icon':     isCompleted ? 'complete' : 'start',
      };
    }).toList();
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1)   return 'Just now';
    if (diff.inMinutes < 60)  return '${diff.inMinutes}m ago';
    if (diff.inHours   < 24)  return '${diff.inHours}h ago';
    if (diff.inDays    < 7)   return '${diff.inDays}d ago';
    if (diff.inDays    < 30)  return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays    < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  @override
  void onInit() {
    super.onInit();
    _auditsController = Get.put(AuditsController());
    fetchProfile();   // 🔑 Always load profile fresh from API
  }

  /// Loads the logged-in user's profile from the auth/me API.
  /// Called automatically on init — guarantees profile is set even if
  /// LoginController didn't manage to push it before navigation.
  Future<void> fetchProfile() async {
    try {
      isLoadingProfile = true;
      update();

      final profile = await _authService.fetchProfile();
      if (profile != null) {
        setUserProfile(profile);
      }
    } catch (e) {
      debugPrint('HomeController fetchProfile error: $e');
    } finally {
      isLoadingProfile = false;
      update();
    }
  }

  /// Also called from LoginController for instant feedback —
  /// safe to call multiple times.
  void setUserProfile(UserProfile profile) {
    userName       = profile.name;
    userRole       = profile.roleLabel;
    userInitial    = profile.initials;
    userEmail      = profile.email;
    userDepartment = profile.department ?? '';
    update();

    // 🔒 Push the department to AuditsController so it can re-filter.
    // This handles the race where audits loaded before the profile.
    try {
      _auditsController.setLecturerDepartment(userDepartment);
    } catch (_) {}
  }

  void selectTab(int index) {
    selectedIndex = index;
    update();
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  void signOut() {
    Get.delete<LoginController>(force: true);
    ApiRequest.clearAuthToken();
    Get.offAll(() => const Login());
  }

  void startNewAudit() => selectTab(1);
  void viewAllAudits()  => selectTab(1);
}