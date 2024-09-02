import '../repositories/ievent_repository.dart';

class UpdateStatusEventUsecase {

  final IEventRepository iEventRepository;

  UpdateStatusEventUsecase({required this.iEventRepository});

  Future<void> updateStatusEvent(String eventId, bool isActive) async {
    iEventRepository.updateEventStatus(eventId, isActive);
  }

}