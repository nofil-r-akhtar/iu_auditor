class AuditReview {
  final String id;
  final String teacherId;
  final String formId;
  final String status;
  final String? notes;
  final String createdAt;
  final String teacherName;
  final String teacherEmail;
  final String teacherDepartment;
  final String formTitle;
  final String formDepartment;

  AuditReview({
    required this.id,
    required this.teacherId,
    required this.formId,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.teacherName,
    required this.teacherEmail,
    required this.teacherDepartment,
    required this.formTitle,
    required this.formDepartment,
  });

  factory AuditReview.fromJson(Map<String, dynamic> json) {
    final teacher = json['teachers']    as Map<String, dynamic>? ?? {};
    final form    = json['audit_forms'] as Map<String, dynamic>? ?? {};
    return AuditReview(
      id:                json['id']?.toString() ?? '',
      teacherId:         json['teacher_id']?.toString() ?? '',
      formId:            json['form_id']?.toString() ?? '',
      status:            json['status']?.toString() ?? 'pending',
      notes:             json['notes']?.toString(),
      createdAt:         json['created_at']?.toString() ?? '',
      teacherName:       teacher['name']?.toString() ?? '—',
      teacherEmail:      teacher['email']?.toString() ?? '',
      teacherDepartment: teacher['department']?.toString() ?? '—',
      formTitle:         form['title']?.toString() ?? '',
      formDepartment:    form['department']?.toString() ?? '',
    );
  }

  String get initials {
    final parts = teacherName.trim().split(RegExp(r'\s+'));
    return parts
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase())
        .take(3).join();
  }

  String get dateLabel {
    if (createdAt.length < 10) return createdAt;
    try {
      final d = DateTime.parse(createdAt);
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return '${months[d.month - 1]} ${d.day}';
    } catch (_) { return createdAt.substring(0, 10); }
  }
}
