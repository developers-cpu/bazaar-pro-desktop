import 'trade_settings_remote_data_source.dart';
import '../../models/trade_settings/trade_setting_model.dart';

class TradeSettingsRemoteDataSourceImpl
    implements TradeSettingsRemoteDataSource {
  final List<TradeSettingModel> _mockTradeSettings = [

    ...['NSE', 'MCX', 'CRYPTO', 'CE/PE', 'GIFT', 'OTHERS', 'FOREX', 'COMEX FUTURE', 'COMEX SPOT', 'USSTOCK']
        .expand((ex) => [
              'ABB25DECFUT',
              'ABCAPITAL25DECFUT',
              'ADANIENSOL25DECFUT',
              '360ONE25DECFUT',
              'BAJAJ-AUTO25DECFUT',
              'AXISBANK25DECFUT',
              'ADANIENT25DECFUT',
              'ADANIGREEN25DECFUT',
              'AUROPHARMA25DECFUT',
            ].asMap().entries.map((e) {
              final isAmountWise = e.key % 2 != 0;
              return TradeSettingModel(
                id: '${ex.toLowerCase()}_${e.key}',
                exchange: ex,
                symbol: ex == 'NSE' ? e.value : '${ex}_${e.value}',
                marginType: isAmountWise ? 'Amount Wise' : 'Percentage',
                intMarginPercentage: isAmountWise ? '-' : '2500',
                cfMarginPercentage: isAmountWise ? '-' : '2500',
                intMarginAmt: isAmountWise ? '2500' : '-',
                cfMarginAmt: isAmountWise ? '2500' : '-',
                brokerageType: 'Turnover Wise',
                turnoverWiseBrokerageRs:
                    e.key == 4 || e.key == 8 ? '-' : '2500',
                lotWiseBrokerageAmt: '-',
                updatedOn: '26/12/25 | 12:00:00 AM',
                updatedBy: 'DEMO4',
                leverageMultiplier: '1:10',
                tradeSecondsLimit: _getTradeSeconds(e.key),
              );
            })),


    TradeSettingModel(
      id: '1',
      exchange: 'MCX',
      marginType: 'Percentage Wise',
      intMarginPercentage: '500',
      cfMarginPercentage: '500',
      intMarginAmt: '-',
      cfMarginAmt: '-',
      brokerageType: 'Turnover Wise',
      turnoverWiseBrokerageRs: '500',
      lotWiseBrokerageAmt: '-',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
    TradeSettingModel(
      id: '2',
      exchange: 'NSE',
      marginType: 'Both',
      intMarginPercentage: '2500',
      cfMarginPercentage: '2500',
      intMarginAmt: '2500',
      cfMarginAmt: '2500',
      brokerageType: 'Both',
      turnoverWiseBrokerageRs: '2500',
      lotWiseBrokerageAmt: '2500',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
    TradeSettingModel(
      id: '3',
      exchange: 'CE/PE',
      marginType: 'Amount Wise',
      intMarginPercentage: '-',
      cfMarginPercentage: '-',
      intMarginAmt: '2500',
      cfMarginAmt: '2500',
      brokerageType: 'Lot Wise',
      turnoverWiseBrokerageRs: '-',
      lotWiseBrokerageAmt: '2500',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
    TradeSettingModel(
      id: '4',
      exchange: 'GIFT',
      marginType: 'Amount Wise',
      intMarginPercentage: '-',
      cfMarginPercentage: '-',
      intMarginAmt: '2500',
      cfMarginAmt: '2500',
      brokerageType: 'Lot Wise',
      turnoverWiseBrokerageRs: '-',
      lotWiseBrokerageAmt: '2500',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
    TradeSettingModel(
      id: '5',
      exchange: 'OTHERS',
      marginType: 'Both',
      intMarginPercentage: '2500',
      cfMarginPercentage: '2500',
      intMarginAmt: '2500',
      cfMarginAmt: '2500',
      brokerageType: 'Both',
      turnoverWiseBrokerageRs: '2500',
      lotWiseBrokerageAmt: '2500',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
    TradeSettingModel(
      id: '6',
      exchange: 'CRYPTO',
      marginType: 'Percentage Wise',
      intMarginPercentage: '2500',
      cfMarginPercentage: '2500',
      intMarginAmt: '-',
      cfMarginAmt: '-',
      brokerageType: 'Lot Wise',
      turnoverWiseBrokerageRs: '-',
      lotWiseBrokerageAmt: '2500',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
    TradeSettingModel(
      id: '7',
      exchange: 'COMEX FUTURE',
      marginType: 'Both',
      intMarginPercentage: '2500',
      cfMarginPercentage: '2500',
      intMarginAmt: '2500',
      cfMarginAmt: '2500',
      brokerageType: 'Both',
      turnoverWiseBrokerageRs: '2500',
      lotWiseBrokerageAmt: '2500',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
    TradeSettingModel(
      id: 'ex_comex_spot',
      exchange: 'COMEX SPOT',
      marginType: 'Both',
      intMarginPercentage: '2500',
      cfMarginPercentage: '2500',
      intMarginAmt: '2500',
      cfMarginAmt: '2500',
      brokerageType: 'Both',
      turnoverWiseBrokerageRs: '2500',
      lotWiseBrokerageAmt: '2500',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
    TradeSettingModel(
      id: '8',
      exchange: 'FOREX',
      marginType: 'Both',
      intMarginPercentage: '2500',
      cfMarginPercentage: '2500',
      intMarginAmt: '2500',
      cfMarginAmt: '2500',
      brokerageType: 'Both',
      turnoverWiseBrokerageRs: '2500',
      lotWiseBrokerageAmt: '2500',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
    TradeSettingModel(
      id: '9',
      exchange: 'USSTOCK',
      marginType: 'Percentage Wise',
      intMarginPercentage: '2500',
      cfMarginPercentage: '2500',
      intMarginAmt: '-',
      cfMarginAmt: '-',
      brokerageType: 'Lot Wise',
      turnoverWiseBrokerageRs: '-',
      lotWiseBrokerageAmt: '2500',
      updatedOn: '26/12/25 | 12:00:00 AM',
      updatedBy: 'DEMO4',
      leverageMultiplier: '1:10',
      tradeSecondsLimit: '01',
    ),
  ];

  static String _getTradeSeconds(int index) {
    final values = ['30', '30', '06', '30', '60', '30', '20', '30', '01'];
    if (index < values.length) return values[index];
    return '01';
  }
  @override
  Future<List<TradeSettingModel>> getTradeSettings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTradeSettings;
  }

  @override
  Future<bool> updateTradeSettings({
    required List<String> ids,
    TradeSettingModel? details,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }
}