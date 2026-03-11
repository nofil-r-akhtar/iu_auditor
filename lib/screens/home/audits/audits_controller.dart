import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AuditStatus { pending, inProgress, completed }

class AuditTeacher {
  final String initials;
  final String name;
  final String department;
  final String specialization;
  final String dueDate;
  final AuditStatus status;
  final int? progressPercent; // only for inProgress

  const AuditTeacher({
    required this.initials,
    required this.name,
    required this.department,
    required this.specialization,
    required this.dueDate,
    required this.status,
    this.progressPercent,
  });
}

class AuditsController extends GetxController {
  final searchController = TextEditingController();

  // 0 = All, 1 = Pending, 2 = In Progress, 3 = Completed
  int selectedFilter = 0;
  String searchQuery = '';

  final List<AuditTeacher> allTeachers = const [
    AuditTeacher(
      initials: 'MAK',
      name: 'Mr. Ali Khan',
      department: 'Computer Science',
      specialization: 'AI/ML',
      dueDate: 'Mar 20',
      status: AuditStatus.pending,
    ),
    AuditTeacher(
      initials: 'MFN',
      name: 'Ms. Fatima Noor',
      department: 'Business Admin',
      specialization: 'Marketing',
      dueDate: 'Mar 22',
      status: AuditStatus.pending,
    ),
    AuditTeacher(
      initials: 'DBR',
      name: 'Dr. Bilal Raza',
      department: 'Engineering',
      specialization: 'Power Systems',
      dueDate: 'Mar 18',
      status: AuditStatus.inProgress,
      progressPercent: 60,
    ),
    AuditTeacher(
      initials: 'SSK',
      name: 'Ms. Sara Siddiqui',
      department: 'Social Sciences',
      specialization: 'Psychology',
      dueDate: 'Mar 10',
      status: AuditStatus.inProgress,
      progressPercent: 30,
    ),
    AuditTeacher(
      initials: 'MOF',
      name: 'Mr. Omar Farooq',
      department: 'Computer Science',
      specialization: 'Cyber Security',
      dueDate: 'Mar 8',
      status: AuditStatus.completed,
    ),
    AuditTeacher(
      initials: 'MHM',
      name: 'Ms. Hira Malik',
      department: 'Law',
      specialization: 'Corporate Law',
      dueDate: 'Mar 25',
      status: AuditStatus.pending,
    ),
    AuditTeacher(
      initials: 'ZAK',
      name: 'Dr. Zainab Ahmed',
      department: 'Medicine',
      specialization: 'Pharmacology',
      dueDate: 'Mar 28',
      status: AuditStatus.completed,
    ),
  ];

  List<AuditTeacher> get filtered {
    List<AuditTeacher> result = allTeachers;

    // Apply status filter
    if (selectedFilter == 1) {
      result = result.where((t) => t.status == AuditStatus.pending).toList();
    } else if (selectedFilter == 2) {
      result = result.where((t) => t.status == AuditStatus.inProgress).toList();
    } else if (selectedFilter == 3) {
      result = result.where((t) => t.status == AuditStatus.completed).toList();
    }

    // Apply search
    if (searchQuery.isNotEmpty) {
      result = result
          .where(
            (t) =>
                t.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                t.department.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return result;
  }

  int countByStatus(AuditStatus status) =>
      allTeachers.where((t) => t.status == status).length;

  void setFilter(int index) {
    selectedFilter = index;
    update();
  }

  void onSearch(String query) {
    searchQuery = query;
    update();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
