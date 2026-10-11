class Course {
  final String code;
  final String title;
  final int credits;
  final String status;
  final String? description;

  Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      credits: (json['credits'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'planned',
      description: json['description'] as String?,
    );
  }
}