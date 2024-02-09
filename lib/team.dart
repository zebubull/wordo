class Team {
    late final int id;
    late final String name;

    int ampAuto = 0;
    int speakerAuto = 0;

    int ampTele = 0;
    int speakerTele = 0;

    double offenseScore = 5.0;
    double defenseScore = 5.0;
    double overallScore = 5.0;

    bool leaves = false;
    bool hangs = false;
    bool trap = false;
    bool harmony = false;

    Team({required this.id, required this.name});

    Map<String, dynamic> toJson() =>
    {
      'id': id,
      'name': name,
      'ampAuto': ampAuto,
      'speakerAuto': speakerAuto,
      'ampTele': ampTele,
      'speakerTele': speakerTele,
      'offense': offenseScore,
      'defense': defenseScore,
      'overall': overallScore,
      'leaves': leaves,
      'hangs': hangs,
      'trap': trap,
      'harmony': harmony,
    };

    Team.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      ampAuto = json['ampAuto'];
      speakerAuto = json['speakerAuto'];
      ampTele = json['ampTele'];
      speakerTele = json['speakerTele'];
      offenseScore = json['offense'];
      defenseScore = json['defense'];
      overallScore = json['overall'];
      leaves = json['leaves'];
      hangs = json['hangs'];
      trap = json['trap'];
      harmony = json['harmony'];
    }
}
