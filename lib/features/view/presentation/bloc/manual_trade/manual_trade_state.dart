import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ManualTradeState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final bool showConfirmDialog;
  final List<String> users;
  final List<String> exchanges;
  final List<String> symbols;
  final List<String> tradeDisplayOptions;
  final String? selectedUser;
  final String? selectedExchange;
  final String? selectedSymbol;
  final String qty;
  final String lot;
  final String price;
  final bool isBrkCalculated;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? selectedTradeDisplay;
  final String deviceId;
  final String device;
  final String ipAddress;
  const ManualTradeState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.showConfirmDialog = false,
    this.users = const [],
    this.exchanges = const [],
    this.symbols = const [],
    this.tradeDisplayOptions = const ['Master', 'Client'],
    this.selectedUser,
    this.selectedExchange,
    this.selectedSymbol,
    this.qty = '',
    this.lot = '1',
    this.price = '',
    this.isBrkCalculated = false,
    this.selectedDate,
    this.selectedTime,
    this.selectedTradeDisplay,
    this.deviceId = '',
    this.device = '',
    this.ipAddress = '',
  });
  ManualTradeState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    bool? showConfirmDialog,
    List<String>? users,
    List<String>? exchanges,
    List<String>? symbols,
    List<String>? tradeDisplayOptions,
    String? selectedUser,
    String? selectedExchange,
    String? selectedSymbol,
    String? qty,
    String? lot,
    String? price,
    bool? isBrkCalculated,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    String? selectedTradeDisplay,
    String? deviceId,
    String? device,
    String? ipAddress,
  }) {
    return ManualTradeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      showConfirmDialog: showConfirmDialog ?? this.showConfirmDialog,
      users: users ?? this.users,
      exchanges: exchanges ?? this.exchanges,
      symbols: symbols ?? this.symbols,
      tradeDisplayOptions: tradeDisplayOptions ?? this.tradeDisplayOptions,
      selectedUser: selectedUser ?? this.selectedUser,
      selectedExchange: selectedExchange ?? this.selectedExchange,
      selectedSymbol: selectedSymbol ?? this.selectedSymbol,
      qty: qty ?? this.qty,
      lot: lot ?? this.lot,
      price: price ?? this.price,
      isBrkCalculated: isBrkCalculated ?? this.isBrkCalculated,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedTradeDisplay: selectedTradeDisplay ?? this.selectedTradeDisplay,
      deviceId: deviceId ?? this.deviceId,
      device: device ?? this.device,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    successMessage,
    showConfirmDialog,
    users,
    exchanges,
    symbols,
    tradeDisplayOptions,
    selectedUser,
    selectedExchange,
    selectedSymbol,
    qty,
    lot,
    price,
    isBrkCalculated,
    selectedDate,
    selectedTime,
    selectedTradeDisplay,
    deviceId,
    device,
    ipAddress,
  ];
}
