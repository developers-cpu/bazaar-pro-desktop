import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widget/svg_icon.dart';

class MarketWatchTickerStrip extends StatefulWidget {
  final List<MarketTickerQuote> quotes;
  final Duration animationDuration;
  final Duration updateInterval;

  const MarketWatchTickerStrip({
    super.key,
    this.quotes = _defaultQuotes,
    this.animationDuration = const Duration(seconds: 18),
    this.updateInterval = const Duration(seconds: 2),
  });

  static const List<MarketTickerQuote> _defaultQuotes = [
    MarketTickerQuote(symbol: 'NIFTY 50', price: 22583.55, changePercent: 0.56),
    MarketTickerQuote(symbol: 'NIFTY', price: 47825.35, changePercent: 0.56),
    MarketTickerQuote(
      symbol: 'FINNIFTY',
      price: 21568.48,
      changePercent: -0.39,
    ),
    MarketTickerQuote(symbol: 'SENSEX', price: 74060.26, changePercent: 0.56),
    MarketTickerQuote(
      symbol: 'BANKNIFTY',
      price: 48352.89,
      changePercent: -0.29,
    ),
  ];

  @override
  State<MarketWatchTickerStrip> createState() => _MarketWatchTickerStripState();
}

class _MarketWatchTickerStripState extends State<MarketWatchTickerStrip>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  final GlobalKey _segmentKey = GlobalKey();
  late final AnimationController _tickerController;
  late List<MarketTickerQuote> _quotes;
  double _segmentWidth = 0;
  Timer? _pulseTimer;

  @override
  void initState() {
    super.initState();
    _quotes = widget.quotes;
    _tickerController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();
    _scheduleSegmentMeasure();
    _pulseTimer = Timer.periodic(widget.updateInterval, (_) {
      if (!mounted) return;
      setState(() {
        _quotes = _quotes.map(_mutateQuote).toList(growable: false);
      });
      _scheduleSegmentMeasure();
    });
  }

  @override
  void didUpdateWidget(MarketWatchTickerStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quotes != widget.quotes) {
      _quotes = widget.quotes;
      _scheduleSegmentMeasure();
    }
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    _tickerController.dispose();
    super.dispose();
  }

  MarketTickerQuote _mutateQuote(MarketTickerQuote quote) {
    final nextPercent = (quote.changePercent + (_random.nextDouble() - 0.5))
        .clamp(-2.99, 2.99);
    final priceDelta = (_random.nextDouble() - 0.5) * (quote.price * 0.0025);
    final nextPrice = max(0.0, quote.price + priceDelta);
    return quote.copyWith(price: nextPrice, changePercent: nextPercent);
  }

  void _scheduleSegmentMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final context = _segmentKey.currentContext;
      final renderBox = context?.findRenderObject() as RenderBox?;
      final measuredWidth = renderBox?.size.width ?? 0;
      if (measuredWidth > 0 && measuredWidth != _segmentWidth) {
        setState(() {
          _segmentWidth = measuredWidth;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(bottom: BorderSide(color: AppColors.borderColor)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final segmentWidth = _segmentWidth > 0
                ? _segmentWidth
                : constraints.maxWidth;
            final repeatCount = max(
              3,
              (constraints.maxWidth / segmentWidth).ceil() + 2,
            );
            return AnimatedBuilder(
              animation: _tickerController,
              builder: (context, child) {
                final offset = -segmentWidth * _tickerController.value;
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: max(
                          constraints.maxWidth + segmentWidth,
                          segmentWidth * repeatCount,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildQuoteSegment(key: _segmentKey),
                          for (int index = 1; index < repeatCount; index++)
                            _buildQuoteSegment(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuoteSegment({Key? key}) {
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final quote in _quotes) _TickerQuoteTile(quote: quote),
        SizedBox(width: 24.w),
      ],
    );
  }
}

class MarketTickerQuote {
  final String symbol;
  final double price;
  final double changePercent;

  const MarketTickerQuote({
    required this.symbol,
    required this.price,
    required this.changePercent,
  });

  String get formattedPrice => NumberFormat('#,##0.00').format(price);

  String get formattedPercent => changePercent.abs().toStringAsFixed(2);

  MarketTickerQuote copyWith({
    String? symbol,
    double? price,
    double? changePercent,
  }) {
    return MarketTickerQuote(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      changePercent: changePercent ?? this.changePercent,
    );
  }
}

class _TickerQuoteTile extends StatelessWidget {
  final MarketTickerQuote quote;

  const _TickerQuoteTile({required this.quote});

  @override
  Widget build(BuildContext context) {
    final isPositive = quote.changePercent >= 0;
    final color = isPositive ? AppColors.buyColor : AppColors.sellColor;
    final iconAsset = isPositive ? AppImages.buyIcon : AppImages.sellIcon;

    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: SizedBox(
        height: 28.h,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 130.w),
              child: Text(
                quote.symbol,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.openSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              quote.formattedPrice,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                  color: color,
              ),
            ),
            SizedBox(width: 4.w),
            SvgIcon(
              assetPath: iconAsset,
              isActive: true,
              size: 12.sp,
              activeColor: color,
            ),
            SizedBox(width: 2.w),
            Text(
              '${quote.formattedPercent}%',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
