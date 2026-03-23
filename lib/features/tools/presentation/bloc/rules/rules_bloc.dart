import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/entities/rule_entity.dart';
import '../../../domain/usecases/get_rules_usecase.dart';
part 'rules_event.dart';
part 'rules_state.dart';

class RulesBloc extends Bloc<RulesEvent, RulesState> {
  final GetRulesUseCase getRules;
  RulesBloc({required this.getRules}) : super(RulesLoading()) {
    on<LoadRules>(_onLoadRules);
  }
  Future<void> _onLoadRules(LoadRules event, Emitter<RulesState> emit) async {
    emit(RulesLoading());
    final result = await getRules(NoParams());
    result.fold((failure) => emit(const RulesError('Failed to load rules')), (
      rules,
    ) {
      emit(RulesLoaded(rules));
    });
  }
}
