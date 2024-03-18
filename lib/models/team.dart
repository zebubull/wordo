class Team {
  final int number;
  final String name;

  Team({required this.number, required this.name});

  @override
  bool operator ==(Object other) {
    return other is Team &&
        other.runtimeType == runtimeType &&
        other.number == number;
  }

  @override
  int get hashCode => number;
}
