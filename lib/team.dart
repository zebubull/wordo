enum Drivetrain {
  trank,
  swerve,
  mecanum,
}

extension DrivetrainFriendly on Drivetrain {
  String toFriendly() {
    return switch (this) {
      Drivetrain.trank => "Trank",
      Drivetrain.swerve => "Swerve",
      Drivetrain.mecanum => "Mecanum",
    };
  }
}

enum Pickup {
  defenseBot,
  floor,
  substation,
  both,
}

extension ParseFriendly on Pickup {
  String toFriendly() {
    return switch (this) {
      Pickup.defenseBot => "None",
      Pickup.floor => "Floor",
      Pickup.substation => "Substation",
      Pickup.both => "Both",
    };
  }
}

class Team {
    late final int id;
    late final String name;

    double weight = 80.0;
    bool underStage = false;
    Drivetrain drivetrain = Drivetrain.trank;
    String funFact = '';

    int ampAuto = 0;
    int speakerAuto = 0;
    bool leaves = false;

    int ampTele = 0;
    int speakerTele = 0;
    Pickup pickup = Pickup.defenseBot;

    bool hangs = false;
    bool trap = false;
    bool harmony = false;

    double offenseScore = 5.0;
    double defenseScore = 5.0;
    double overallScore = 5.0;
    double cycleTime = 0.0;


    Team({required this.id, required this.name});

    Map<String, dynamic> toJson() =>
    {
      'id': id,
      'name': name,
      'amp_auto': ampAuto,
      'speaker_auto': speakerAuto,
      'amp_tele': ampTele,
      'speaker_tele': speakerTele,
      'offense': offenseScore,
      'defense': defenseScore,
      'overall': overallScore,
      'leaves': leaves,
      'hangs': hangs,
      'trap': trap,
      'harmony': harmony,
      'weight': weight,
      'under_stage': underStage,
      'drivetrain': drivetrain,
      'fun_fact': funFact,
      'pickup': pickup,
      'cycle_time': cycleTime,
    };

    Team.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      ampAuto = json['amp_auto'];
      speakerAuto = json['speaker_auto'];
      ampTele = json['amp_tele'];
      speakerTele = json['speaker_tele'];
      offenseScore = json['offense'];
      defenseScore = json['defense'];
      overallScore = json['overall'];
      leaves = json['leaves'];
      hangs = json['hangs'];
      trap = json['trap'];
      harmony = json['harmony'];
      weight = json['weight'];
      underStage = json['under_stage'];
      drivetrain = json['drivetrain'];
      funFact = json['fun_fact'];
      pickup = json['pickup'];
      cycleTime = json['cycle_time'];
    }
}
