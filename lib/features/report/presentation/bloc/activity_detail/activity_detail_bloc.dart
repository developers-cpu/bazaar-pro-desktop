import 'package:flutter_bloc/flutter_bloc.dart';
import 'activity_detail_event.dart';
import 'activity_detail_state.dart';

class ActivityDetailBloc
    extends Bloc<ActivityDetailEvent, ActivityDetailState> {
  ActivityDetailBloc() : super(ActivityDetailInitial()) {
    on<FetchActivityDetails>(_onFetchActivityDetails);
  }

  void _onFetchActivityDetails(
    FetchActivityDetails event,
    Emitter<ActivityDetailState> emit,
  ) {
    emit(ActivityDetailLoading());

    try {
      List<Map<String, dynamic>> data = [];
      const int mockRecordCount = 12550;

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
                'oldA': '2500',
                'newA': '1500',
                'oldP': '2500',
                'newP': '1500',
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

      emit(ActivityDetailLoaded(details: data, recordCount: mockRecordCount));
    } catch (e) {
      emit(ActivityDetailError(e.toString()));
    }
  }
}
