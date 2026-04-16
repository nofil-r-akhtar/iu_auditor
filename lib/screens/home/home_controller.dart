import 'package:get/get.dart';
import 'package:iu_auditor/apis/api_request.dart';
import 'package:iu_auditor/components/home_components/screen_table/screen_table_controller.dart';
import 'package:iu_auditor/screens/auth/login/login.dart';
import 'package:iu_auditor/screens/auth/login/login_controller.dart';
import 'package:iu_auditor/screens/home/audits/audits_controller.dart';

class HomeController extends GetxController {
  final ScreenTableController upcomingAuditsTableController =
      ScreenTableController(rowsPerPage: 5);

  int selectedIndex = 0;

  // User info — populated from auth response when real API is active
  String userName = 'Dr. Sarah Ahmed';
  String userRole = 'Auditor';
  String userInitial = 'S';

  // FIX: stats are now derived from AuditsController — the single source
  // of truth for teacher data. HomeController pre-registers AuditsController
  // in onInit so it's available even before AuditsScreen is opened.
  // When AuditsScreen calls Get.put(AuditsController()), GetX returns the
  // same existing instance — no duplication, no conflict.
  late final AuditsController _auditsController;

  int get pendingCount => _auditsController.countByStatus(AuditStatus.pending);
  int get inProgressCount =>
      _auditsController.countByStatus(AuditStatus.inProgress);
  int get completedCount =>
      _auditsController.countByStatus(AuditStatus.completed);

  // Upcoming audits — sourced from AuditsController so dashboard and
  // audits tab always show the same data
  List<Map<String, dynamic>> get upcomingAudits {
    return _auditsController.allTeachers
        .where((t) => t.status != AuditStatus.completed)
        .take(4)
        .map((t) {
          final urgency = t.status == AuditStatus.inProgress ? 'high' : 'low';
          return {
            'name': t.name,
            'department': t.department,
            'due': 'Due ${t.dueDate}',
            'urgency': urgency,
            'initials': t.initials,
          };
        })
        .toList();
  }

  // Recent activity — static for now, replace with API data later
  final List<Map<String, dynamic>> recentActivity = [
    {
      'action': 'Started audit for',
      'target': 'Dr. Bilal Raza',
      'time': '3 days ago',
      'icon': 'start',
    },
    {
      'action': 'Completed audit for',
      'target': 'Ms. Zainab Ahmed',
      'time': '1 week ago',
      'icon': 'complete',
    },
    {
      'action': 'Submitted report for',
      'target': 'Mr. Tariq Hussain',
      'time': '2 weeks ago',
      'icon': 'submit',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Pre-register AuditsController so stats are available immediately
    // on the dashboard without waiting for AuditsScreen to open.
    _auditsController = Get.put(AuditsController());
  }

  void selectTab(int index) {
    selectedIndex = index;
    update();
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void signOut() {
    Get.delete<LoginController>(force: true);
    // FIX: clear the Bearer token so it isn't carried over to the next session
    ApiRequest.clearAuthToken();
    Get.offAll(() => const Login());
  }

  void startNewAudit() {
    Get.snackbar(
      'Start New Audit',
      'This feature is coming soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewAllAudits() {
    selectTab(1);
  }
}
