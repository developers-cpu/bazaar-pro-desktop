import '../../../domain/entities/broker_list/client_breakdown.dart';

abstract class ClientBreakdownRemoteDataSource {
  Future<ClientBreakdown> getClientBreakdown(
    String brokerId,
    String clientName,
  );
}

class ClientBreakdownRemoteDataSourceImpl
    implements ClientBreakdownRemoteDataSource {
  @override
  Future<ClientBreakdown> getClientBreakdown(
    String brokerId,
    String clientName,
  ) async {
    return ClientBreakdown(
      brokerId: brokerId,
      clientName: clientName,
      sections: [
        const ClientBreakdownSection(
          title: "NSE",
          rows: [
            ClientBreakdownRow(
              label: "NSE",
              turnover: "100 CR",
              brokerage: 2500,
            ),
          ],
        ),
        const ClientBreakdownSection(
          title: "MCX",
          isSymbolBased: true,
          rows: [
            ClientBreakdownRow(
              label: "GOLD",
              turnover: "500 LOT",
              brokerage: 2500,
            ),
            ClientBreakdownRow(
              label: "GOLD MINI",
              turnover: "500 LOT",
              brokerage: 600,
            ),
            ClientBreakdownRow(
              label: "SILVER",
              turnover: "500 LOT",
              brokerage: 750,
            ),
            ClientBreakdownRow(
              label: "SILVER MINI",
              turnover: "500 LOT",
              brokerage: 1250,
            ),
            ClientBreakdownRow(
              label: "SILVER MIC",
              turnover: "500 LOT",
              brokerage: 5100,
            ),
          ],
        ),
        const ClientBreakdownSection(
          title: "CE/PE",
          rows: [
            ClientBreakdownRow(
              label: "CE/PE",
              turnover: "100 CR",
              brokerage: 2500,
            ),
          ],
        ),
        const ClientBreakdownSection(
          title: "GIFTNIFTY",
          rows: [
            ClientBreakdownRow(
              label: "GIFTYNIFTY",
              turnover: "100 CR",
              brokerage: 2500,
            ),
          ],
        ),
        const ClientBreakdownSection(
          title: "OTHER",
          isSymbolBased: true,
          hasFooter: true,
          rows: [
            ClientBreakdownRow(
              label: "DOWJONSE",
              turnover: "500 LOT",
              brokerage: 2500,
            ),
            ClientBreakdownRow(
              label: "NASDQ",
              turnover: "500 LOT",
              brokerage: 600,
            ),
            ClientBreakdownRow(
              label: "S&P",
              turnover: "500 LOT",
              brokerage: 750,
            ),
          ],
        ),
      ],
    );
  }
}