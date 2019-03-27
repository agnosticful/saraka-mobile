import './study_certainty.dart';

abstract class Study {
  DateTime get studiedAt;

  StudyCertainty get certainty;

  Duration get nextStudyInterval;

  double get maturity => calculateMaturity(nextStudyInterval);

  static calculateMaturity(Duration nextStudyInterval) =>
      nextStudyInterval.inMilliseconds / (1000 * 60 * 60 * 24 * 365);
}
