import 'package:get/get.dart';
import 'package:iu_auditor/components/home_components/screen_table/screen_table_controller.dart';
import 'package:iu_auditor/screens/auth/login/login.dart';

class HomeController extends GetxController {
  final ScreenTableController upcomingAuditsTableController =
      ScreenTableController(rowsPerPage: 5);

  // Plain fields — GetBuilder rebuilds on update()
  int selectedIndex = 0;

  // User info — replace with real data from auth response
  String userName = 'Dr. Sarah Ahmed';
  String userRole = 'Auditor';
  String userInitial = 'S';

  // Stats
  int pendingCount = 3;
  int inProgressCount = 1;
  int completedCount = 8;

  // Upcoming audits data
  final List<Map<String, dynamic>> upcomingAudits = [
    {
      'name': 'Mr. Ali Khan',
      'department': 'Computer Science',
      'due': 'Due in 2 days',
      'urgency': 'high',
      'initials': 'MAK',
    },
    {
      'name': 'Ms. Fatima Oo',
      'department': 'Business Admin',
      'due': 'Due in 5 days',
      'urgency': 'medium',
      'initials': 'MFN',
    },
    {
      'name': 'Dr. Bilal Raza',
      'department': 'Electrical Eng.',
      'due': 'Due in 7 days',
      'urgency': 'low',
      'initials': 'DBR',
    },
    {
      'name': 'Prof. Hina Malik',
      'department': 'Mathematics',
      'due': 'Due in 10 days',
      'urgency': 'low',
      'initials': 'PHM',
    },
  ];

  // Recent activity
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

  void selectTab(int index) {
    selectedIndex = index;
    update(); // triggers GetBuilder rebuild
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void signOut() {
    Get.offAll(() => const Login());
  }

  void startNewAudit() {
    // Hook up to your audit creation screen when ready
    Get.snackbar(
      'Start New Audit',
      'This feature is coming soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewAllAudits() {
    // Navigate to audits tab
    selectTab(1);
  }
}
