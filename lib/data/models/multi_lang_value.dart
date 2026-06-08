class MultiLangValue {
  const MultiLangValue({this.ar = '', this.en = ''});

  final String ar;
  final String en;

  MultiLangValue copyWith({String? ar, String? en}) =>
      MultiLangValue(ar: ar ?? this.ar, en: en ?? this.en);

  Map<String, String> toJson() => {'ar': ar, 'en': en};

  @override
  String toString() => 'MultiLangValue(ar: $ar, en: $en)';
}
