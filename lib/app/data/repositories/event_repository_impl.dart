import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gatherly/app/data/models/event_model.dart';
import 'package:gatherly/app/domain/repositories/ievent_repository.dart';

class EventRepositoryImpl implements IEventRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Future<void> addParticipant(String eventId, String participantId) async {
    try {
      // Recupera o documento do evento
      DocumentSnapshot doc = await _firestore.collection('events').doc(eventId).get();

      if (doc.exists) {
        // Converte o documento Firestore em um objeto Event
        EventModel event = EventModel.fromFirestore(doc);

        // Verifica se o participante já não está na lista
        if (!event.participants.contains(participantId)) {
          // Adiciona o novo participante à lista
          event.participants.add(participantId);

          // Atualiza o documento do evento no Firestore com a nova lista de participantes
          await _firestore.collection('events').doc(eventId).update({
            'participants': event.participants,
          });

          print('Participante adicionado com sucesso.');
        } else {
          print('Participante já está na lista.');
        }
      } else {
        print('Evento não encontrado.');
      }
    } catch (e) {
      print('Erro ao adicionar participante: $e');
    }
  }

  @override
  Future<void> createEvent(EventModel event) async {
    try {
      // Obtém o usuário autenticado atual
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Atribui o UID do usuário autenticado como creatorId do evento
        event.creatorId = currentUser.uid;

        // Cria o evento na coleção 'events'
        await _firestore.collection('events').add(event.toFirestore());
        print('Evento criado com sucesso.');
      } else {
        print('Usuário não autenticado.');
      }
    } catch (e) {
      print('Erro ao criar o evento: $e');
    }
  }


  @override
  Future<List<EventModel>> getAllEvents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('events').get();

      return querySnapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e) {
      print('Erro ao recuperar eventos: $e');
      return [];
    }
  }

  @override
  Future<EventModel?> getEventById(String eventId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('events').doc(eventId).get();

      if (doc.exists) {
        return EventModel.fromFirestore(doc);
      } else {
        print('Evento não encontrado.');
        return null;
      }
    } catch (e) {
      print('Erro ao recuperar o evento: $e');
      return null;
    }
  }

  @override
  Future<void> updateEventStatus(String eventId, bool isActive) async {
    await _firestore.collection('events').doc(eventId).update({
      'isActive': isActive,
    });
  }

  @override
  Future<void> toggleParticipant(String eventId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    try {
      final doc = await _firestore.collection('events').doc(eventId).get();
      final event = EventModel.fromFirestore(doc);

      if (event.participants.contains(userId)) {
        await _firestore.collection('events').doc(eventId).update({
          'participants': FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firestore.collection('events').doc(eventId).update({
          'participants': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      print('Erro ao atualizar participação: $e');
    }
  }
}