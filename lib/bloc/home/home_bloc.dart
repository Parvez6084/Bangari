import 'package:bhangari/bloc/home/home_event.dart';
import 'package:bhangari/bloc/home/home_state.dart';
import 'package:bloc/bloc.dart';
import 'package:device_apps/device_apps.dart';

import '../../data/application_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{

  List<ApplicationModel> applicationList = [];

  HomeBloc() : super(const HomeState()){
      on<GetApplicationList>(_getApplicationList);
      on<AppLockUnlockListener>(_appLockUnlockListener);
  }

  void _getApplicationList(GetApplicationList event, Emitter<HomeState> emit)async {

    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
    );

    for (var app in apps) {
      applicationList.add(ApplicationModel(app: app));
    }

    emit(state.copyWith(applicationList: List.from(applicationList)));

  }

  void _appLockUnlockListener (AppLockUnlockListener event, Emitter<HomeState> emit){
      final index = applicationList.indexWhere((element) => element.app.packageName == event.application.app.packageName);
      applicationList[index] = event.application;
      emit(state.copyWith(applicationList: List.from(applicationList)));
  }

}

