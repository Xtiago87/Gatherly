import 'package:gatherly/app/data/models/event_model.dart';

abstract class IEventRepository {
  Future<EventModel?> getEventById(String eventId);
  Future<List<EventModel>> getAllEvents();
  Future<void> createEvent(EventModel event);
  Future<void> updateEventStatus(String eventId, bool isActive);
  Future<void> addParticipant(String eventId, String participantId);
  Future<void> toggleParticipant(String eventId);
}