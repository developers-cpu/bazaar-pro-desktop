import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widget/custom_input_field.dart';
import '../../../../../core/widget/app_radio_group.dart';
import '../../../../../core/widget/common_dilog_box.dart';
import '../../../../../core/widget/app_date_picker.dart';
import '../../../domain/entities/symbol_settings/symbol_setting.dart';

class SymbolEditDialog extends StatefulWidget {
  final SymbolSetting item;
  final void Function(SymbolSetting updated) onSave;

  const SymbolEditDialog({super.key, required this.item, required this.onSave});

  static void show(
    BuildContext context, {
    required SymbolSetting item,
    required void Function(SymbolSetting updated) onSave,
  }) {
    CommonDialog.show(
      context: context,
      title: 'Symbol Edit - ${item.symbol}',
      width: 800.w,
      height: 460.h,
      scrollable: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      contentBuilder: (ctx, close) => SymbolEditDialog(
        item: item,
        onSave: (updated) {
          onSave(updated);
          close();
        },
      ),
      showButtons: false,
    );
  }

  @override
  State<SymbolEditDialog> createState() => _SymbolEditDialogState();
}

class _SymbolEditDialogState extends State<SymbolEditDialog> {
  late String _exchange;
  late TextEditingController _symbolTitleCtrl;
  DateTime? _expiryDate;
  DateTime? _closeDate;
  DateTime? _cutDate;
  DateTime? _launchDate;
  late String _tradeAttribute;
  late bool _allowTrade;
  late bool _defaultInWatchlist;
  late String _status;
  late bool _autoTickSize;
  late TextEditingController _descCtrl;
  late TextEditingController _lotSizeCtrl;
  late TextEditingController _sizeCtrl;

  static const _exchanges = [
    'NSE',
    'MCX',
    'CE/PE',
    'GIFT',
    'OTHERS',
    'CRYPTO',
    'COMEX',
    'FOREX',
    'USSTOCKS',
    'CDS',
  ];

  @override
  void initState() {
    super.initState();
    _exchange = widget.item.exchange;
    _symbolTitleCtrl = TextEditingController(text: widget.item.symbolTitle);
    _expiryDate = _parseDate(widget.item.expiryDate);
    _closeDate = _parseDate(widget.item.closeDate);
    _cutDate = _parseDate(widget.item.cutDate);
    _launchDate = _parseDate(widget.item.launchDate);
    _tradeAttribute = widget.item.tradeAttribute;
    _allowTrade = widget.item.allowTrade;
    _defaultInWatchlist = widget.item.defaultInWatchlist;
    _status = widget.item.status;
    _autoTickSize = widget.item.autoTickSize;
    _descCtrl = TextEditingController(text: widget.item.description);
    _lotSizeCtrl = TextEditingController(text: widget.item.lotSize);
    _sizeCtrl = TextEditingController(text: widget.item.size);
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}
    return null;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _symbolTitleCtrl.dispose();
    _descCtrl.dispose();
    _lotSizeCtrl.dispose();
    _sizeCtrl.dispose();
    super.dispose();
  }

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: 4.h),
    child: Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryBlue,
      ),
    ),
  );

  Widget _gap() => SizedBox(width: 8.w);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Symbol'),
                  CustomInputField(
                    hintText: '',
                    controller: TextEditingController(text: widget.item.symbol),
                    readOnly: true,
                    height: 35.h,
                    fillColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
            _gap(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Symbols Title'),
                  CustomInputField(
                    controller: _symbolTitleCtrl,
                    hintText: 'Enter title',
                    height: 35.h,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Exchange'),
            AppRadioGroup<String>(
              value: _exchange,
              spacing: 6.w,
              options: _exchanges
                  .map((e) => RadioOption(label: e, value: e))
                  .toList(),
              onChanged: (val) => setState(() => _exchange = val!),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppDatePicker(
                label: 'Expiry Date',
                value: _expiryDate,
                onChanged: (val) => setState(() => _expiryDate = val),
              ),
            ),
            _gap(),
            Expanded(
              child: AppDatePicker(
                label: 'Close Date',
                value: _closeDate,
                onChanged: (val) => setState(() => _closeDate = val),
              ),
            ),
            _gap(),
            Expanded(
              child: AppDatePicker(
                label: 'Cut Date',
                value: _cutDate,
                onChanged: (val) => setState(() => _cutDate = val),
              ),
            ),
            _gap(),
            Expanded(
              child: AppDatePicker(
                label: 'Launch Date',
                value: _launchDate,
                onChanged: (val) => setState(() => _launchDate = val),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Description'),
                  CustomInputField(
                    controller: _descCtrl,
                    hintText: 'Enter description',
                    height: 35.h,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
      SizedBox(height: 10.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Lot Size'),
                  CustomInputField(
                    controller: _lotSizeCtrl,
                    hintText: '50',
                    height: 35.h,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Trade Attribute'),
                  AppRadioGroup<String>(
                    value: _tradeAttribute,
                    spacing: 8.w,
                    options: const [
                      RadioOption(label: 'full', value: 'full'),
                      RadioOption(label: 'close', value: 'close'),
                      RadioOption(label: 'block', value: 'block'),
                    ],
                    onChanged: (val) => setState(() => _tradeAttribute = val!),
                  ),
                ],
              ),
            ),
            _gap(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Allow Trade'),
                  AppRadioGroup<bool>(
                    value: _allowTrade,
                    options: const [
                      RadioOption(label: 'Yes', value: true),
                      RadioOption(label: 'No', value: false),
                    ],
                    onChanged: (val) => setState(() => _allowTrade = val!),
                  ),
                ],
              ),
            ),
            _gap(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Default In Watchlist'),
                  AppRadioGroup<bool>(
                    value: _defaultInWatchlist,
                    options: const [
                      RadioOption(label: 'Yes', value: true),
                      RadioOption(label: 'No', value: false),
                    ],
                    onChanged: (val) =>
                        setState(() => _defaultInWatchlist = val!),
                  ),
                ],
              ),
            ),
            _gap(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Status'),
                  AppRadioGroup<String>(
                    value: _status,
                    options: const [
                      RadioOption(label: 'Open', value: 'Open'),
                      RadioOption(label: 'Close', value: 'Close'),
                    ],
                    onChanged: (val) => setState(() => _status = val!),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Auto Tick Size'),
                  AppRadioGroup<bool>(
                    value: _autoTickSize,
                    options: const [
                      RadioOption(label: 'Yes', value: true),
                      RadioOption(label: 'No', value: false),
                    ],
                    onChanged: (val) => setState(() => _autoTickSize = val!),
                  ),
                ],
              ),
            ),
            _gap(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Size (If No):'),
                  CustomInputField(
                    controller: _sizeCtrl,
                    hintText: '0.10',
                    height: 35.h,
                    readOnly: _autoTickSize,
                    fillColor: _autoTickSize ? Colors.grey[200] : null,
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),

        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final updated = widget.item.copyWith(
                  exchange: _exchange,
                  symbolTitle: _symbolTitleCtrl.text,
                  expiryDate: _formatDate(_expiryDate),
                  closeDate: _formatDate(_closeDate),
                  cutDate: _formatDate(_cutDate),
                  launchDate: _formatDate(_launchDate),
                  tradeAttribute: _tradeAttribute,
                  allowTrade: _allowTrade,
                  defaultInWatchlist: _defaultInWatchlist,
                  status: _status,
                  autoTickSize: _autoTickSize,
                  description: _descCtrl.text,
                  lotSize: _lotSizeCtrl.text,
                  size: _sizeCtrl.text,
                );
                widget.onSave(updated);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ],
    );
  }
}
