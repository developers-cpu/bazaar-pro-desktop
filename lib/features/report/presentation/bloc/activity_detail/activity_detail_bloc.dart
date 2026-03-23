import 'package:flutter_bloc/flutter_bloc.dart';
import 'activity_detail_event.dart';
import 'activity_detail_state.dart';

class ActivityDetailBloc
    extends Bloc<ActivityDetailEvent, ActivityDetailState> {
  String? _lastActivityName;
  String? _lastValueType;

  ActivityDetailBloc() : super(ActivityDetailInitial()) {
    on<FetchActivityDetails>(_onFetchActivityDetails);
    on<FilterActivityDetails>(_onFilterActivityDetails);
  }

  void _onFilterActivityDetails(
    FilterActivityDetails event,
    Emitter<ActivityDetailState> emit,
  ) {
    if (_lastActivityName != null) {
      _onFetchActivityDetails(
        FetchActivityDetails(
          activityName: _lastActivityName!,
          valueType: _lastValueType,
        ),
        emit,
      );
    }
  }

  void _onFetchActivityDetails(
    FetchActivityDetails event,
    Emitter<ActivityDetailState> emit,
  ) {
    _lastActivityName = event.activityName;
    _lastValueType = event.valueType;
    emit(ActivityDetailLoading());
    try {
      List<Map<String, dynamic>> data = [];
      switch (event.activityName) {
        case 'Leverage':
          data = List.generate(
            10,
            (index) => {
              'oldLeverage': '1:1',
              'newLeverage': '1:2',
              'updatedOn': DateTime(2026, 2, 12, 0, 30, 52),
              'updatedBy': index % 3 == 0
                  ? 'Admin'
                  : (index % 3 == 1 ? 'Super Admin' : 'Master'),
            },
          );
          break;
        case 'Brokerage':
        case 'Trade margin':
        case 'Profit Square off':
        case 'Time Restriction for SL / Limit':
        case 'Allowed Exchange':
        case 'High Low Between Limit / SL':
        case 'Intraday Square off':
          final exchanges = [
            'MCX',
            'NSE',
            'CE/PE',
            'CRYPTO',
            'USSTOCK',
            'GIFT',
            'COMEX',
            'FOREX',
            'OTEHRS',
          ];
          data = exchanges.map((ex) {
            if (event.activityName == 'Brokerage') {
              return {
                'exchange': ex,
                'oldValue': '2500',
                'newValue': '1500',
                'updatedOn': DateTime(2026, 2, 12, 12, 30, 52),
                'updatedBy': 'Admin',
              };
            } else if (event.activityName == 'Trade margin') {
              return {
                'exchange': ex,
                'intOldA': ex == 'MCX' ? '500' : '2500',
                'intNewA': ex == 'MCX' ? '1000' : '1500',
                'intOldP': ex == 'MCX' ? '500' : '2500',
                'intNewP': ex == 'MCX' ? '1000' : '1500',
                'cfOldA': ex == 'MCX' ? '500' : '2500',
                'cfNewA': ex == 'MCX' ? '1000' : '1500',
                'cfOldP': ex == 'MCX' ? '500' : '2500',
                'cfNewP': ex == 'MCX' ? '1000' : '1500',
                'updatedOn': DateTime(2026, 2, 12, 12, 30, 52),
                'updatedBy': 'Admin',
              };
            } else {
              return {
                'exchange': ex,
                'oldDetails': event.valueType == 'time'
                    ? (exchanges.indexOf(ex) % 2 == 0 ? '30' : '20')
                    : (exchanges.indexOf(ex) % 2 == 0
                          ? 'Allowed'
                          : 'Not Allowed'),
                'newDetails': event.valueType == 'time'
                    ? (exchanges.indexOf(ex) % 2 == 0 ? '20' : '30')
                    : (exchanges.indexOf(ex) % 2 == 0
                          ? 'Not Allowed'
                          : 'Allowed'),
                'updatedOn': DateTime(2026, 2, 12, 12, 30, 52),
                'updatedBy': 'Admin',
              };
            }
          }).toList();
          break;
        case 'Bet':
          data = List.generate(
            8,
            (index) => {
              'oldBet': index % 2 == 0 ? 'OFF' : 'ON',
              'newBet': index % 2 == 0 ? 'ON' : 'OFF',
              'updatedOn': DateTime(2026, 2, 12, 12, 30, 52),
              'updatedBy': 'Admin',
            },
          );
          break;
        case 'Exchange Group':
          data = [
            {
              'oldGroup': 'NSE_2X',
              'newGroup': 'Removed',
              'updatedOn': DateTime(2026, 2, 12, 0, 30, 52),
              'updatedBy': 'Super Admin',
            },
            {
              'oldGroup': '-',
              'newGroup': 'NSE_6X',
              'updatedOn': DateTime(2026, 2, 12, 0, 30, 52),
              'updatedBy': 'Super Admin',
            },
            {
              'oldGroup': '-',
              'newGroup': 'NSE_8X',
              'updatedOn': DateTime(2026, 2, 12, 0, 30, 52),
              'updatedBy': 'Super Admin',
            },
            {
              'oldGroup': '-',
              'newGroup': 'NSE_10X',
              'updatedOn': DateTime(2026, 2, 12, 0, 30, 52),
              'updatedBy': 'Admin',
            },
            {
              'oldGroup': '-',
              'newGroup': 'NSE_7X',
              'updatedOn': DateTime(2026, 2, 12, 0, 30, 52),
              'updatedBy': 'Super Admin',
            },
            {
              'oldGroup': '-',
              'newGroup': 'NSE_9X',
              'updatedOn': DateTime(2026, 2, 12, 0, 30, 52),
              'updatedBy': 'Admin',
            },
          ];
          break;
        case 'Close Only':
        case 'View Only':
        case 'Status':
        case 'Stauts':
        case 'Lock User':
        case 'Allow Chat with Super Admin':
        case 'Fresh Order':
        case 'Fifteen Days':
          data = List.generate(
            9,
            (index) => {
              'updatedOn': DateTime(2026, 2, 12, 12, 30, 52),
              'updatedBy': index % 2 == 0 ? 'Admin' : 'Super Admin',
            },
          );
          final type = event.valueType ?? 'allowed';
          for (var item in data) {
            if (type == 'onOff') {
              item['old'] = data.indexOf(item) % 2 == 0 ? 'OFF' : 'ON';
              item['new'] = data.indexOf(item) % 2 == 0 ? 'ON' : 'OFF';
            } else if (type == 'yesNo') {
              item['old'] = data.indexOf(item) % 2 == 0 ? 'Yes' : 'No';
              item['new'] = data.indexOf(item) % 2 == 0 ? 'No' : 'Yes';
            } else {
              item['old'] = data.indexOf(item) % 2 == 0
                  ? 'Allowed'
                  : 'Not Allowed';
              item['new'] = data.indexOf(item) % 2 == 0
                  ? 'Not Allowed'
                  : 'Allowed';
            }
          }
          break;
        default:
          data = [];
      }
      List<Map<String, dynamic>>? intradayDetails;
      List<Map<String, dynamic>>? cfDetails;
      if (event.activityName == 'Trade margin') {
        intradayDetails = data
            .map(
              (e) => {
                'exchange': e['exchange'],
                'oldA': e['intOldA'],
                'newA': e['intNewA'],
                'oldP': e['intOldP'],
                'newP': e['intNewP'],
                'updatedOn': e['updatedOn'],
                'updatedBy': e['updatedBy'],
              },
            )
            .toList();
        cfDetails = data
            .map(
              (e) => {
                'exchange': e['exchange'],
                'oldA': e['cfOldA'],
                'newA': e['cfNewA'],
                'oldP': e['cfOldP'],
                'newP': e['cfNewP'],
                'updatedOn': e['updatedOn'],
                'updatedBy': e['updatedBy'],
              },
            )
            .toList();
      }
      emit(
        ActivityDetailLoaded(
          details: data,
          recordCount: data.length,
          intradayDetails: intradayDetails,
          cfDetails: cfDetails,
        ),
      );
    } catch (e) {
      emit(ActivityDetailError(e.toString()));
    }
  }
}
