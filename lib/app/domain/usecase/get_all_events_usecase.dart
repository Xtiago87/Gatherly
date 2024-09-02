import 'package:gatherly/app/data/models/event_model.dart';

import '../repositories/ievent_repository.dart';

class GetAllEventsUsecase {

  final IEventRepository iEventRepository;

  GetAllEventsUsecase({required this.iEventRepository});

  Future<List<EventModel>> getAllEvents() async {
    return iEventRepository.getAllEvents();
  }

}