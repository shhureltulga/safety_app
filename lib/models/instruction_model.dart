class Instruction {
  final int id;
  final String title;
  final String videoUrl;
  final String? pdfUrl;
  final int? totalPages;
  final int phase;
  final bool requiresFullWatch;
  final DateTime createdAt;

  Instruction({
    required this.id,
    required this.title,
    required this.videoUrl,
    this.pdfUrl,
    this.totalPages, 
    required this.phase,
    required this.requiresFullWatch,
    required this.createdAt,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(
      id: json['id'],
      title: json['title'],
      videoUrl: json['videoUrl'],
      pdfUrl: json['pdfUrl'],
      totalPages: json['totalPages'],
      phase: json['phase'] ?? 0,
      requiresFullWatch: json['requiresFullWatch'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
