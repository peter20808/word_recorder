class Word {
  int? id;

  String language;
  String source;
  String category;
  String word;
  String meaning;
  String note;

  bool favorite;

  DateTime createTime;

  int reviewCount;
  int correctCount;
  int wrongCount;

  Word({
    this.id,

    required this.language,
    required this.source,
    required this.category,
    required this.word,
    required this.meaning,
    required this.note,

    this.favorite = false,

    DateTime? createTime,

    this.reviewCount = 0,
    this.correctCount = 0,
    this.wrongCount = 0,
  }) : createTime = createTime ?? DateTime.now();
}