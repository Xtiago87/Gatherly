import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gatherly/app/data/models/event_model.dart';
import 'package:gatherly/app/domain/usecase/get_all_events_usecase.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../detail_event/detail_event.dart';


class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {

  final GetAllEventsUsecase _getAllEventsUsecase= Modular.get<GetAllEventsUsecase>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _fetchEvents();
  }

  Future<List<EventModel>> _fetchEvents() async {
    try {
      return await _getAllEventsUsecase.getAllEvents();
    } catch (e) {
      print('Erro ao recuperar eventos: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Modular.to.navigate('/'); // Navega para a página de login após sair
            },
          ),
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _getEventsStream(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar eventos'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Nenhum evento disponível'));
          } else {
            final events = snapshot.data!;

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final eventDoc = events[index];
                final event = EventModel.fromFirestore(eventDoc);

                final isParticipating = event.participants.contains(userId);
                final isCreator = event.creatorId == userId;

                return Card(
                  margin: EdgeInsets.all(8.0),
                  color: isParticipating ? Colors.blue.shade50 : null,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.0),
                    title: Row(
                      children: [
                        Expanded(child: Text(event.title)),
                        if (isCreator)
                          Icon(Icons.star, color: Colors.orange, size: 20),
                      ],
                    ),
                    subtitle: Text(_formatDateTime(event.date)),
                    trailing: Text(
                      'Participantes: ${event.participants.length}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Modular.to.pushNamed('/event_details/${event.id}');
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/create_event/-1');
        },
        child: Icon(Icons.add),
        tooltip: 'Criar Novo Evento',
      ),
    );
  }

  Stream<List<DocumentSnapshot>> _getEventsStream(String? userId) {
    final eventsCollection = FirebaseFirestore.instance.collection('events');

    // Consultas separadas
    final activeEventsStream = eventsCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs);

    final userCreatedEventsStream = eventsCollection
        .where('creatorId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs);

    return Rx.combineLatest2(
      activeEventsStream,
      userCreatedEventsStream,
          (List<DocumentSnapshot> activeEvents, List<DocumentSnapshot> userCreatedEvents) {
        final allEvents = <String, DocumentSnapshot>{};

        for (var event in activeEvents) {
          allEvents[event.id] = event;
        }

        for (var event in userCreatedEvents) {
          allEvents[event.id] = event;
        }

        return allEvents.values.toList();
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    return '${dateFormat.format(dateTime)} ${timeFormat.format(dateTime)}';
  }
}
