class Team {
  int number = 0;
  String? name;

  Team({required this.number, this.name});

  @override
  bool operator ==(Object other) {
    return other is Team &&
        other.runtimeType == runtimeType &&
        other.number == number;
  }

  @override
  int get hashCode => number;
}
