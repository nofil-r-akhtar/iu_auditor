/// Question types matching backend enum
enum ApiQuestionType { rating, paragraph, mcq, yesNo }

extension ApiQuestionTypeX on ApiQuestionType {
  String get apiValue {
    switch (this) {
      case ApiQuestionType.rating:    return 'rating';
      case ApiQuestionType.paragraph: return 'paragraph';
      case ApiQuestionType.mcq:       return 'mcq';
      case ApiQuestionType.yesNo:     return 'yes_no';
    }
  }

  static ApiQuestionType fromApi(String v) {
    switch (v) {
      case 'rating':    return ApiQuestionType.rating;
      case 'paragraph': return ApiQuestionType.paragraph;
      case 'mcq':       return ApiQuestionType.mcq;
      case 'yes_no':    return ApiQuestionType.yesNo;
      default:          return ApiQuestionType.rating;
    }
  }
}

/// Question returned by GET /audit/forms/{form_id}/questions/
class AuditQuestionApi {
  final String id;
  final String questionText;
  final ApiQuestionType type;
  final List<String> options;   // only for mcq
  final bool isRequired;

  AuditQuestionApi({
    required this.id,
    required this.questionText,
    required this.type,
    required this.options,
    required this.isRequired,
  });

  factory AuditQuestionApi.fromJson(Map<String, dynamic> json) {
    final rawOpts = json['options'] as List<dynamic>? ?? [];
    return AuditQuestionApi(
      id:           json['id']?.toString() ?? '',
      questionText: json['question_text']?.toString() ?? '',
      type:         ApiQuestionTypeX.fromApi(json['question_type']?.toString() ?? 'rating'),
      options:      rawOpts.map((e) => e.toString()).toList(),
      isRequired:   json['is_required'] == true,
    );
  }
}
