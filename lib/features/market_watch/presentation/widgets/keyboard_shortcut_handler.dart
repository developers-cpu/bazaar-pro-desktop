import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../tools/presentation/widgets/messages/messages_dialog.dart';
import 'market_depth_dialog.dart';
import 'order/common_order_dialog.dart';


class KeyboardShortcutHandler extends StatelessWidget {
  final Widget child;
  const KeyboardShortcutHandler({Key? key, required this.child})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.f1): const BuyOrderIntent(),
        const SingleActivator(LogicalKeyboardKey.f2): const SellOrderIntent(),
        const SingleActivator(LogicalKeyboardKey.f3):
            const PendingOrdersIntent(),
        const SingleActivator(LogicalKeyboardKey.f5): const MarketDepthIntent(),
        const SingleActivator(LogicalKeyboardKey.f6):
            const NetPositionsIntent(),
        const SingleActivator(LogicalKeyboardKey.f8): const TradesIntent(),
        const SingleActivator(LogicalKeyboardKey.f9): const DealsIntent(),
        const SingleActivator(LogicalKeyboardKey.f10): const MessagesIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          BuyOrderIntent: BuyOrderAction(context),
          SellOrderIntent: SellOrderAction(context),
          PendingOrdersIntent: PendingOrdersAction(context),
          MarketDepthIntent: MarketDepthAction(context),
          NetPositionsIntent: NetPositionsAction(context),
          TradesIntent: TradesAction(context),
          DealsIntent: DealsAction(context),
          MessagesIntent: MessagesAction(context),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }
}

class BuyOrderIntent extends Intent {
  const BuyOrderIntent();
}

class SellOrderIntent extends Intent {
  const SellOrderIntent();
}

class PendingOrdersIntent extends Intent {
  const PendingOrdersIntent();
}

class NetPositionsIntent extends Intent {
  const NetPositionsIntent();
}

class TradesIntent extends Intent {
  const TradesIntent();
}

class DealsIntent extends Intent {
  const DealsIntent();
}

class MessagesIntent extends Intent {
  const MessagesIntent();
}

class MarketDepthIntent extends Intent {
  const MarketDepthIntent();
}

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

class PendingOrdersAction extends Action<PendingOrdersIntent> {
  final BuildContext context;
  PendingOrdersAction(this.context);
  @override
  Object? invoke(PendingOrdersIntent intent) {
    Navigator.of(context).pushReplacementNamed('/pending_order-orders');
    return null;
  }
}

class NetPositionsAction extends Action<NetPositionsIntent> {
  final BuildContext context;
  NetPositionsAction(this.context);
  @override
  Object? invoke(NetPositionsIntent intent) {
    Navigator.of(context).pushReplacementNamed('/net-position');
    return null;
  }
}

class TradesAction extends Action<TradesIntent> {
  final BuildContext context;
  TradesAction(this.context);
  @override
  Object? invoke(TradesIntent intent) {
    Navigator.of(context).pushReplacementNamed('/trades');
    return null;
  }
}

class DealsAction extends Action<DealsIntent> {
  final BuildContext context;
  DealsAction(this.context);
  @override
  Object? invoke(DealsIntent intent) {
    Navigator.of(context).pushReplacementNamed('/deals');
    return null;
  }
}

class MessagesAction extends Action<MessagesIntent> {
  final BuildContext context;
  MessagesAction(this.context);
  @override
  Object? invoke(MessagesIntent intent) {
    MessagesDialog.show(context);
    return null;
  }
}

class KeyboardShortcutListener extends StatefulWidget {
  final Widget child;
  const KeyboardShortcutListener({Key? key, required this.child})
    : super(key: key);
  @override
  State<KeyboardShortcutListener> createState() =>
      _KeyboardShortcutListenerState();
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
      } else if (event.logicalKey == LogicalKeyboardKey.f3) {
        Navigator.of(context).pushReplacementNamed('/pending_order-orders');
      } else if (event.logicalKey == LogicalKeyboardKey.f5) {
        MarketDepthDialog.show(context);
      } else if (event.logicalKey == LogicalKeyboardKey.f6) {
        Navigator.of(context).pushReplacementNamed('/net-position');
      } else if (event.logicalKey == LogicalKeyboardKey.f8) {
        Navigator.of(context).pushReplacementNamed('/trades');
      } else if (event.logicalKey == LogicalKeyboardKey.f9) {
        Navigator.of(context).pushReplacementNamed('/deals');
      } else if (event.logicalKey == LogicalKeyboardKey.f10) {
        MessagesDialog.show(context);
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
