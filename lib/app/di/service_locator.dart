import '../../injection_container.dart' as legacy_di;

final sl = legacy_di.sl;

Future<void> initServiceLocator() async {
  await legacy_di.init();
}

T resolve<T extends Object>() => sl<T>();
