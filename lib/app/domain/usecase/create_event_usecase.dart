import 'package:gatherly/app/data/models/event_model.dart';
import 'package:gatherly/app/domain/repositories/ievent_repository.dart';

class CreateEventUsecase {

  final IEventRepository iEventRepository;

  CreateEventUsecase({required this.iEventRepository});

  Future<void> createEvent(EventModel event) async {
    iEventRepository.createEvent(event);
  }

}