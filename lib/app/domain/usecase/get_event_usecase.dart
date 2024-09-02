import 'package:gatherly/app/data/models/event_model.dart';

import '../repositories/ievent_repository.dart';

class GetEventUsecase {

  final IEventRepository iEventRepository;

  GetEventUsecase({required this.iEventRepository});

  Future<EventModel?> getEventById(String eventId) async {
    return iEventRepository.getEventById(eventId);
  }

}