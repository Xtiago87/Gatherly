import 'package:flutter_modular/flutter_modular.dart';
import 'package:gatherly/app/data/repositories/auth_repository_impl.dart';
import 'package:gatherly/app/data/repositories/event_repository_impl.dart';
import 'package:gatherly/app/data/services/firebase_auth_service.dart';
import 'package:gatherly/app/domain/repositories/ilogin_repository.dart';
import 'package:gatherly/app/domain/repositories/ievent_repository.dart';
import 'package:gatherly/app/domain/usecase/get_all_events_usecase.dart';
import 'package:gatherly/app/domain/usecase/get_event_usecase.dart';
import 'package:gatherly/app/domain/usecase/login_usecase.dart';
import 'package:gatherly/app/domain/usecase/register_usecase.dart';
import 'package:gatherly/app/domain/usecase/create_event_usecase.dart';
import 'package:gatherly/app/domain/usecase/toogle_participation_event_usecase.dart';
import 'package:gatherly/app/domain/usecase/update_status_event_usecase.dart';
import 'package:gatherly/app/presentation/controllers/create_account/create_account_controller.dart';
import 'package:gatherly/app/presentation/controllers/login/login_controller.dart';
import 'package:gatherly/app/presentation/screens/create_account/create_account_screen.dart';
import 'package:gatherly/app/presentation/screens/create_event/create_event_screen.dart';
import 'package:gatherly/app/presentation/screens/detail_event/detail_event.dart';
import 'package:gatherly/app/presentation/screens/events/events_screen.dart';
import 'package:gatherly/app/presentation/screens/login/login_screen.dart';
import 'package:gatherly/app/presentation/screens/navigation/bottom_nav_screen.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton<AuthService>(AuthService.new);
    i.addLazySingleton<IAuthRepository>(AuthRepositoryImpl.new);
    i.addLazySingleton<LoginUsecase>(LoginUsecase.new);
    i.addLazySingleton<RegisterUsecase>(RegisterUsecase.new);
    i.addLazySingleton<IEventRepository>(EventRepositoryImpl.new);
    i.addLazySingleton<CreateEventUsecase>(CreateEventUsecase.new);
    i.addLazySingleton<GetAllEventsUsecase>(GetAllEventsUsecase.new);
    i.addLazySingleton<GetEventUsecase>(GetEventUsecase.new);
    i.addLazySingleton<ToogleParticipationEventUsecase>(ToogleParticipationEventUsecase.new);
    i.addLazySingleton<UpdateStatusEventUsecase>(UpdateStatusEventUsecase.new);
    i.add<CreateAccountController>(CreateAccountController.new);
    i.add<LoginController>(LoginController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const LoginScreen());
    r.child('/register', child: (context) => CreateAccountScreen());
    r.child('/nav_screen', child: (context) => EventsScreen());
    r.child('/event_details/:id', child: (context) => EventDetailsPage(eventId: r.args.params['id']));

    r.child('/create_event/:id', child: (context) => CreateEventScreen(id: int.parse(r.args.params['id']),));
  }
}
