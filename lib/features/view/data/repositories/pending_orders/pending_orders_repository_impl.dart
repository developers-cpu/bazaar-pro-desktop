import 'package:bazarpro/core/widget/table/table_export_service.dart';
import 'package:bazarpro/core/widget/table/view_data_table.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/pending_orders/pending_order.dart';
import '../../../domain/repositories/pending_orders/pending_orders_repository.dart';
import '../../datasources/pending_order/pending_orders_remote_datasource.dart';

class PendingOrdersRepositoryImpl implements PendingOrdersRepository {
  final PendingOrdersRemoteDataSource remoteDataSource;
  PendingOrdersRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<PendingOrder>>> getPendingOrders() async {
    try {
      final orders = await remoteDataSource.getPendingOrders();
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PendingOrder>>> getPendingOrdersWithFilters({
    String? client,
    String? exchange,
    String? symbol,
    String? type,
  }) async {
    try {
      final orders = await remoteDataSource.getPendingOrdersWithFilters(
        client: client,
        exchange: exchange,
        symbol: symbol,
        type: type,
      );
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getClients() async {
    try {
      final clients = await remoteDataSource.getClients();
      return Right(clients);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getExchanges() async {
    try {
      final exchanges = await remoteDataSource.getExchanges();
      return Right(exchanges);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSymbols() async {
    try {
      final symbols = await remoteDataSource.getSymbols();
      return Right(symbols);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  List<String> getOrderTypes() {
    return [
      'All',
      'Buy',
      'Sell',
      'Buy Limit',
      'Buy Stop',
      'Sell Limit',
      'Sell Stop',
    ];
  }

  @override
  Future<Either<Failure, String>> exportToPdf(List<PendingOrder> orders) async {
    try {
      const columns = [
        ViewTableColumn(id: 'userId', label: 'U.NAME', width: 100),
        ViewTableColumn(id: 'upline', label: 'P.USER', width: 100),
        ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
        ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120),
        ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 140),
        ViewTableColumn(id: 'buySell', label: 'B/S', width: 120),
        ViewTableColumn(id: 'qty', label: 'QTY', width: 80, isNumeric: true),
        ViewTableColumn(id: 'lot', label: 'LOT', width: 70, isNumeric: true),
        ViewTableColumn(id: 'orderType', label: 'TYPE', width: 100),
        ViewTableColumn(
          id: 'triggerPrice',
          label: 'TRIG.',
          width: 90,
          isNumeric: true,
        ),
        ViewTableColumn(id: 'cmp', label: 'CMP', width: 90, isNumeric: true),
        ViewTableColumn(
          id: 'rPrice',
          label: 'R.PRICE',
          width: 90,
          isNumeric: true,
        ),
      ];
      final dtf = DateFormat('dd/MM/yy HH:mm');
      await TableExportService.exportAsPdf<PendingOrder>(
        title: 'Pending Orders',
        columns: columns,
        data: orders,
        cellValueExtractor: (o, col) {
          switch (col.id) {
            case 'userId':
              return o.userId;
            case 'upline':
              return o.upline;
            case 'exchange':
              return o.exchange;
            case 'symbol':
              return o.symbol;
            case 'orderDateTime':
              return dtf.format(o.orderDateTime);
            case 'buySell':
              return o.buySell;
            case 'qty':
              return o.qty.toStringAsFixed(2);
            case 'lot':
              return o.lot.toStringAsFixed(2);
            case 'orderType':
              return o.orderType;
            case 'triggerPrice':
              return o.triggerPrice.toStringAsFixed(2);
            case 'cmp':
              return o.cmp.toStringAsFixed(2);
            case 'rPrice':
              return o.rPrice.toStringAsFixed(2);
            default:
              return '-';
          }
        },
      );
      return Right(
        'pending_orders_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      return Left(ExportFailure('Failed to export PDF: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportToExcel(
    List<PendingOrder> orders,
  ) async {
    try {
      const columns = [
        ViewTableColumn(id: 'userId', label: 'U.NAME', width: 100),
        ViewTableColumn(id: 'upline', label: 'P.USER', width: 100),
        ViewTableColumn(id: 'exchange', label: 'EXCH', width: 70),
        ViewTableColumn(id: 'symbol', label: 'SYMBOL', width: 120),
        ViewTableColumn(id: 'orderDateTime', label: 'ORDER D/T', width: 140),
        ViewTableColumn(id: 'buySell', label: 'B/S', width: 120),
        ViewTableColumn(id: 'qty', label: 'QTY', width: 80, isNumeric: true),
        ViewTableColumn(id: 'lot', label: 'LOT', width: 70, isNumeric: true),
        ViewTableColumn(id: 'orderType', label: 'TYPE', width: 100),
        ViewTableColumn(
          id: 'triggerPrice',
          label: 'TRIG.',
          width: 90,
          isNumeric: true,
        ),
        ViewTableColumn(id: 'cmp', label: 'CMP', width: 90, isNumeric: true),
        ViewTableColumn(
          id: 'rPrice',
          label: 'R.PRICE',
          width: 90,
          isNumeric: true,
        ),
      ];
      final dtf = DateFormat('dd/MM/yy HH:mm');
      await TableExportService.exportAsExcel<PendingOrder>(
        title: 'Pending Orders',
        columns: columns,
        data: orders,
        cellValueExtractor: (o, col) {
          switch (col.id) {
            case 'userId':
              return o.userId;
            case 'upline':
              return o.upline;
            case 'exchange':
              return o.exchange;
            case 'symbol':
              return o.symbol;
            case 'orderDateTime':
              return dtf.format(o.orderDateTime);
            case 'buySell':
              return o.buySell;
            case 'qty':
              return o.qty.toStringAsFixed(2);
            case 'lot':
              return o.lot.toStringAsFixed(2);
            case 'orderType':
              return o.orderType;
            case 'triggerPrice':
              return o.triggerPrice.toStringAsFixed(2);
            case 'cmp':
              return o.cmp.toStringAsFixed(2);
            case 'rPrice':
              return o.rPrice.toStringAsFixed(2);
            default:
              return '-';
          }
        },
      );
      return Right(
        'pending_orders_${DateTime.now().millisecondsSinceEpoch}.xlsx',
      );
    } catch (e) {
      return Left(ExportFailure('Failed to export Excel: $e'));
    }
  }
}
