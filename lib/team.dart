class Team {
    final int id;
    final String name;

    int ampAuto = 0;
    int speakerAuto = 0;

    int ampTele = 0;
    int speakerTele = 0;

    double offenseScore = 5.0;
    double defenseScore = 5.0;
    double overallScore = 5.0;

    Team({required this.id, required this.name});
}
