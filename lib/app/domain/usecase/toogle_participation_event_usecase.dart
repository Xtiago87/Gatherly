import '../repositories/ievent_repository.dart';

class ToogleParticipationEventUsecase {

  final IEventRepository iEventRepository;

  ToogleParticipationEventUsecase({required this.iEventRepository});

  Future<void> toggleParticipant(String eventId) async {
    iEventRepository.toggleParticipant(eventId);
  }

}