class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  final String? description;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
    this.description,
  });

  // Factory untuk deserialisasi dari JSON ke Object Dart (Tahap 3)
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: (json['id'] as num?)?.toInt(),
      code: json['code'] as String? ?? '',
      title: json['title'] as String? ?? '',
      credits: (json['credits'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'planned',
      description: json['description'] as String?,
    );
  }

  // Method untuk serialisasi dari Object Dart ke JSON (Tahap 3)
  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
    if (description != null) 'description': description,
  };
}