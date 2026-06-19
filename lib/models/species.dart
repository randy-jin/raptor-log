class Species {
  final String id;
  final String userId;
  final String commonName;
  final String? chineseName;
  final String? scientificName;
  final String? familyGroup;
  final String? descriptionEn;
  final String? descriptionZh;
  final int sortOrder;
  final DateTime createdAt;

  const Species({
    required this.id,
    required this.userId,
    required this.commonName,
    this.chineseName,
    this.scientificName,
    this.familyGroup,
    this.descriptionEn,
    this.descriptionZh,
    this.sortOrder = 0,
    required this.createdAt,
  });

  factory Species.fromJson(Map<String, dynamic> json) => Species(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        commonName: json['common_name'] as String,
        chineseName: json['chinese_name'] as String?,
        scientificName: json['scientific_name'] as String?,
        familyGroup: json['family_group'] as String?,
        descriptionEn: json['description_en'] as String?,
        descriptionZh: json['description_zh'] as String?,
        sortOrder: (json['sort_order'] as int?) ?? 0,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toInsertJson(String userId) => {
        'user_id': userId,
        'common_name': commonName,
        'chinese_name': chineseName,
        'scientific_name': scientificName,
        'family_group': familyGroup,
        'description_en': descriptionEn,
        'description_zh': descriptionZh,
        'sort_order': sortOrder,
      };

  String get displayName => chineseName != null
      ? '$chineseName / $commonName'
      : commonName;
}
