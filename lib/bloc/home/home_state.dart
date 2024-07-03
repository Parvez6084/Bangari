import 'package:bhangari/data/application_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {

  final List<ApplicationModel> applicationList;

  const HomeState({ this.applicationList = const [] });

  HomeState copyWith({List<ApplicationModel>? applicationList}) {
    return HomeState(
        applicationList: applicationList ?? this.applicationList
    );
  }

  @override
  List<Object?> get props => [ applicationList ];

}