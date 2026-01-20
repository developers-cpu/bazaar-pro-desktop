import 'package:dio/dio.dart';
import '../../models/script_quantity/script_quantity_model.dart';

/// Script Quantity remote data source interface
abstract class ScriptQuantityRemoteDataSource {
  Future<List<ScriptQuantityModel>> getScriptQuantities({
    required String exchange,
    required String group,
  });
  Future<List<String>> getExchanges();
  Future<List<String>> getGroups(String exchange);
}

/// Script Quantity remote data source implementation
class ScriptQuantityRemoteDataSourceImpl implements ScriptQuantityRemoteDataSource {
  final Dio dio;

  ScriptQuantityRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ScriptQuantityModel>> getScriptQuantities({
    required String exchange,
    required String group,
  }) async {
    try {
      // TODO: Replace with actual API call
      // final response = await dio.get(
      //   '/script-quantities',
      //   queryParameters: {
      //     'exchange': exchange,
      //     'group': group,
      //   },
      // );
      // return (response.data as List)
      //     .map((e) => ScriptQuantityModel.fromJson(e))
      //     .toList();

      // Mock data for development
      await Future.delayed(const Duration(milliseconds: 500));
      return _generateMockData(exchange, group);
    } catch (e) {
      throw Exception('Failed to fetch script quantities: $e');
    }
  }

  @override
  Future<List<String>> getExchanges() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 200));
      return ['NSE', 'MCX', 'CE/PE', 'OTHERS', 'COMEX', 'CRYPTO', 'GIFT', 'FOREX'];
    } catch (e) {
      throw Exception('Failed to fetch exchanges: $e');
    }
  }

  @override
  Future<List<String>> getGroups(String exchange) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 200));

      // Return groups based on exchange
      if (exchange == 'NSE') {
        return ['NSE_X', 'NSE_2X', 'NSE_3X', 'NSE_4X'];
      } else if (exchange == 'MCX') {
        return ['MCX_GOLD', 'MCX_SILVER', 'MCX_CRUDE'];
      } else if (exchange == 'CE/PE') {
        return ['CE/PE_X', 'CE/PE_2X'];
      }

      return ['${exchange}_X', '${exchange}_2X', '${exchange}_3X'];
    } catch (e) {
      throw Exception('Failed to fetch groups: $e');
    }
  }

  /// Generate mock data for development
  List<ScriptQuantityModel> _generateMockData(String exchange, String group) {
    final List<ScriptQuantityModel> quantities = [];
    final symbols = [
      'NIFTY25N0425550CE',
      'NIFTY25N0425550CE',
      'NIFTY25N0425550CE',
      'NIFTY25N0425550CE',
      'GOLD',
      'GOLD',
      'GOLD05DEC',
      'GOLD05DEC',
      'SILVER',
      'CRUDEOIL20OCT',
      'SILVER05DEC',
      'SILVER',
      'GOLD05DEC',
      'NIFTY25N0425550CE',
      'SILVER05DEC',
      'SILVER',
    ];

    final breakupQtys = [95.0, 178.0, 50.0, 29.0, 125.0, 30003.0, 3000.0, 2000.0, 4000.0, 10000.0, 500.0, 75.0, 52.0, 645.0, 500.0, 75.0];
    final maxQtys = [95.0, 178.0, 50.0, 29.0, 125.0, 30003.0, 3000.0, 2000.0, 4000.0, 10000.0, 500.0, 75.0, 52.0, 645.0, 500.0, 75.0];

    for (int i = 0; i < symbols.length; i++) {
      quantities.add(ScriptQuantityModel(
        id: 'sq_$i',
        symbol: symbols[i],
        breakupQty: breakupQtys[i],
        maxQty: maxQtys[i],
      ));
    }

    return quantities;
  }
}