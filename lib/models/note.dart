enum NoteType { birthday, event, other }

class Note {
  final String id;
  final String dateKey; // yyyy-MM-dd
  final NoteType type;
  final String title;
  final String text;

  Note({
    required this.id,
    required this.dateKey,
    required this.type,
    required this.title,
    this.text = '',
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'date': dateKey, 'type': type.name, 'title': title, 'text': text};

  factory Note.fromJson(Map<String, dynamic> j) => Note(
        id: j['id'],
        dateKey: j['date'],
        type: NoteType.values.firstWhere((e) => e.name == j['type'],
            orElse: () => NoteType.other),
        title: j['title'] ?? '',
        text: j['text'] ?? '',
      );
}