import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable{

}


class HomeInit extends HomeState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class HomeLoading extends HomeState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class HomeLoaded extends HomeState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class HomeError extends HomeState{
  final String error;
  HomeError(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}