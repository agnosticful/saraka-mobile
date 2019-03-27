import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saraka/blocs.dart';

class FirestoreStudy extends Study {
  FirestoreStudy(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        studiedAt = (snapshot.data['studiedAt'] as Timestamp).toDate(),
        certainty = StudyCertainty.parse(snapshot.data['certainty']),
        nextStudyInterval =
            Duration(milliseconds: snapshot.data['nextStudyInterval']);

  @override
  final DateTime studiedAt;

  @override
  final StudyCertainty certainty;

  @override
  final Duration nextStudyInterval;
}
