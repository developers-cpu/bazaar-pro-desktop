import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widget/app_dropdown.dart';
import '../widgets/market_timing/market_timing_dialog.dart';
class MarketTimingPage extends StatefulWidget {
  const MarketTimingPage({Key? key}) : super(key: key);
  @override
  State<MarketTimingPage> createState() => _MarketTimingPageState();
}
class _MarketTimingPageState extends State<MarketTimingPage> {
  String? _selectedExchange;
  final List<String> _exchanges = [
    'NSE',
    'MCX',
    'CE/PE',
    'OTHERS',
    'COMEX',
    'CRYPTO',
    'GIFT',
    'FOREX',
  ];
  void _onExchangeChanged(String? exchange) {
    if (exchange != null) {
      setState(() {
        _selectedExchange = exchange;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTimingDialog();
      });
    }
  }
  void _showTimingDialog() {
    if (_selectedExchange != null) {
      MarketTimingDialog.show(context, exchange: _selectedExchange!);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppDropdown(
                type: AppDropdownType.simple,
                hintText: 'Exchange',
                value: _selectedExchange,
                items: _exchanges,
                onChanged: _onExchangeChanged,
                width: 200.w,
                dropdownHeight: 300.h,
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
