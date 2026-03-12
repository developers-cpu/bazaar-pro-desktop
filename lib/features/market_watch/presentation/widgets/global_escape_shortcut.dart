import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/routes/navigator_key.dart';

class GlobalEscapeIntent extends Intent {
  const GlobalEscapeIntent();
}

class GlobalEscapeAction extends Action<GlobalEscapeIntent> {
  @override
  Object? invoke(GlobalEscapeIntent intent) {
    final context = globalNavigatorKey.currentContext;
    if (context != null) {
      final canPop = Navigator.of(context).canPop();
      if (canPop) {
        Navigator.pop(context);
        return null;
      }

      String? topRouteName;
      Navigator.popUntil(context, (route) {
        topRouteName = route.settings.name;
        return true;
      });

      if (topRouteName != '/market-watch' && topRouteName != AppRoutes.login) {
        globalNavigatorKey.currentState?.pushReplacementNamed('/market-watch');
      }
    }
    return null;
  }
}

class GlobalEscapeShortcut extends StatelessWidget {
  final Widget child;

  const GlobalEscapeShortcut({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.escape): const GlobalEscapeIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          GlobalEscapeIntent: GlobalEscapeAction(),
        },
        child: child,
      ),
    );
  }
}
