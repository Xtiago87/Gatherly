import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  String creatorId;
  final List<String> participants;
  final bool isActive;


  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.creatorId,
    required this.participants,
    required this.isActive,
  });

  // Método para converter um documento Firestore em um objeto Event
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      creatorId: data['creatorId'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
      isActive: data['isActive'] ?? true,
    );
  }

  // Método para converter um objeto Event em um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'location': location,
      'creatorId': creatorId,
      'participants': participants,
      'isActive': isActive,
    };
  }
}