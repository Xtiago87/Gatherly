import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gatherly/app/domain/usecase/get_event_usecase.dart';
import 'package:gatherly/app/domain/usecase/toogle_participation_event_usecase.dart';
import 'package:gatherly/app/domain/usecase/update_status_event_usecase.dart';
import 'package:intl/intl.dart';

import '../../../data/models/event_model.dart'; // Para formatação de data/hora

class EventDetailsPage extends StatefulWidget {
  final String eventId;

  EventDetailsPage({required this.eventId});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  late Stream<DocumentSnapshot> _eventStream;

  final GetEventUsecase _getEventUsecase = Modular.get<GetEventUsecase>();
  final ToogleParticipationEventUsecase _toogleParticipationEventUsecase= Modular.get<ToogleParticipationEventUsecase>();
  final UpdateStatusEventUsecase _updateStatusEventUsecase = Modular.get<UpdateStatusEventUsecase>();


  bool _isParticipating = false;
  late bool _isCreator;
  late bool _isActive;



  @override
  void initState() {
    super.initState();
    _eventStream = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .snapshots();
    _isParticipating = false;
    _isCreator = false;
    _isActive = true;
    _checkParticipationAndCreator();

  }

  Future<void> _checkParticipationAndCreator() async {
    try {
      final event = await _getEventUsecase.getEventById(widget.eventId);
      if (event != null) {
        setState(() {
          _isParticipating = event.participants.contains(FirebaseAuth.instance.currentUser?.uid);
          _isCreator = event.creatorId == FirebaseAuth.instance.currentUser?.uid;
          _isActive = event.isActive;
        });
      }
    } catch (e) {
      print('Erro ao verificar participação e criador: $e');
    }
  }

  Future<void> _toggleParticipation() async {
    try {
      await _toogleParticipationEventUsecase.toggleParticipant(widget.eventId);
      // Atualiza o estado de participação após a operação
    } catch (e) {
      print('Erro ao atualizar participação: $e');
    }
  }

  Future<void> _toggleEventStatus() async {
    try {
      await _updateStatusEventUsecase.updateStatusEvent(widget.eventId, !_isActive);
      // Atualize o estado local
      setState(() {
        _isActive = !_isActive;
      });
    } catch (e) {
      print('Erro ao atualizar status do evento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Evento'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _eventStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar detalhes do evento'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Nenhum dado disponível'));
          } else {
            final eventDoc = snapshot.data!;
            final event = EventModel.fromFirestore(eventDoc);
            _isParticipating = event.participants.contains(FirebaseAuth.instance.currentUser?.uid);
            _isCreator = event.creatorId == FirebaseAuth.instance.currentUser?.uid;
            _isActive = event.isActive;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _formatDateTime(event.date),
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.location,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Participantes: ${event.participants.length}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _toggleParticipation,
                    child: Text(_isParticipating ? 'Sair do Evento' : 'Participar do Evento'),
                  ),
                  SizedBox(height: 16),
                  if (_isCreator)
                    ElevatedButton(
                      onPressed: _toggleEventStatus,
                      child: Text(_isActive ? 'Desativar Evento' : 'Ativar Evento'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isActive ? Colors.orange : Colors.green,
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    return '${dateFormat.format(dateTime)} ${timeFormat.format(dateTime)}';
  }
}
