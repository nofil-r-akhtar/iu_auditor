import 'package:get/get.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/components/home_components/screen_table/screen_table_controller.dart';
import 'package:iu_auditor/modal_class/user/user_profile.dart';
import 'package:iu_auditor/screens/auth/login/login.dart';
import 'package:iu_auditor/screens/auth/login/login_controller.dart';
import 'package:iu_auditor/screens/home/audits/audits_controller.dart';

class HomeController extends GetxController {
  final ScreenTableController upcomingAuditsTableController =
      ScreenTableController(rowsPerPage: 5);

  int selectedIndex = 0;

  // ── User info — populated from profile API after login ────
  String userName       = '';
  String userRole       = '';
  String userInitial    = '';
  String userEmail      = '';
  String userDepartment = '';

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

  final List<Map<String, dynamic>> recentActivity = [
    {'action': 'Started audit for',    'target': 'Dr. Bilal Raza',    'time': '3 days ago',  'icon': 'start'},
    {'action': 'Completed audit for',  'target': 'Ms. Zainab Ahmed',  'time': '1 week ago',  'icon': 'complete'},
    {'action': 'Submitted report for', 'target': 'Mr. Tariq Hussain', 'time': '2 weeks ago', 'icon': 'submit'},
  ];

  @override
  void onInit() {
    super.onInit();
    _auditsController = Get.put(AuditsController());
  }

  /// Called from LoginController after successful login
  void setUserProfile(UserProfile profile) {
    userName       = profile.name;
    userRole       = profile.roleLabel;
    userInitial    = profile.initials;
    userEmail      = profile.email;
    userDepartment = profile.department ?? '';
    update();
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