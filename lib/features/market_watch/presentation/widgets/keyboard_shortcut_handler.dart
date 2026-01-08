import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'market_depth_dialog.dart';
import 'order/common_order_dialog.dart';


/// Keyboard Shortcut Handler Widget
class KeyboardShortcutHandler extends StatelessWidget {
  final Widget child;

  const KeyboardShortcutHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.f1): const BuyOrderIntent(),
        const SingleActivator(LogicalKeyboardKey.f2): const SellOrderIntent(),
        const SingleActivator(LogicalKeyboardKey.f5): const MarketDepthIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          BuyOrderIntent: BuyOrderAction(context),
          SellOrderIntent: SellOrderAction(context),
          MarketDepthIntent: MarketDepthAction(context),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}

// ==================== INTENTS ====================

class BuyOrderIntent extends Intent {
  const BuyOrderIntent();
}

class SellOrderIntent extends Intent {
  const SellOrderIntent();
}

class MarketDepthIntent extends Intent {
  const MarketDepthIntent();
}

// ==================== ACTIONS ====================

class BuyOrderAction extends Action<BuyOrderIntent> {
  final BuildContext context;

  BuyOrderAction(this.context);

  @override
  Object? invoke(BuyOrderIntent intent) {
    CommonOrderDialog.showBuyOrder(context);
    return null;
  }
}

class SellOrderAction extends Action<SellOrderIntent> {
  final BuildContext context;

  SellOrderAction(this.context);

  @override
  Object? invoke(SellOrderIntent intent) {
    CommonOrderDialog.showSellOrder(context);
    return null;
  }
}

class MarketDepthAction extends Action<MarketDepthIntent> {
  final BuildContext context;

  MarketDepthAction(this.context);

  @override
  Object? invoke(MarketDepthIntent intent) {
    MarketDepthDialog.show(context);
    return null;
  }
}

/// Alternative: RawKeyboardListener based implementation
/// Use this if Shortcuts/Actions don't work in your setup
class KeyboardShortcutListener extends StatefulWidget {
  final Widget child;

  const KeyboardShortcutListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<KeyboardShortcutListener> createState() => _KeyboardShortcutListenerState();
}

class _KeyboardShortcutListenerState extends State<KeyboardShortcutListener> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f1) {
        CommonOrderDialog.showBuyOrder(context);
      } else if (event.logicalKey == LogicalKeyboardKey.f2) {
        CommonOrderDialog.showSellOrder(context);
      } else if (event.logicalKey == LogicalKeyboardKey.f5) {
        MarketDepthDialog.show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: widget.child,
    );
  }
}