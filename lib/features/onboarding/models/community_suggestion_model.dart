class CommunitySuggestionModel {
  const CommunitySuggestionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.membersLabel,
    required this.imageTag,
    this.description,
  });

  final int id;
  final String title;
  final String category;
  final String membersLabel;
  final String imageTag;
  final String? description;
}
