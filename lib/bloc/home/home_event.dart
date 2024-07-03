import 'package:bhangari/data/application_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
    const HomeEvent();
    @override
    List<Object?> get props => [];
}

class AppLockUnlockListener extends HomeEvent{
    final ApplicationModel application;
    const AppLockUnlockListener({required this.application});
}
class GetApplicationList extends HomeEvent{}