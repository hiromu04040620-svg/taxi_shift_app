import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/core/services/ad_environment_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('taxi_shift_test/ad_environment');
  late String? response;
  late Object? error;
  late MethodChannelAdEnvironmentGateway gateway;

  setUp(() {
    response = null;
    error = null;
    gateway = const MethodChannelAdEnvironmentGateway(channel: channel);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          expect(call.method, 'getEnvironment');
          if (error != null) throw error!;
          return response;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('sandbox応答をSandbox環境へ変換する', () async {
    response = 'sandbox';

    expect(await gateway.current(), AdStoreEnvironment.sandbox);
  });

  test('production応答を本番環境へ変換する', () async {
    response = 'production';

    expect(await gateway.current(), AdStoreEnvironment.production);
  });

  test('不明な応答は未対応環境として安全側へ倒す', () async {
    response = 'unexpected';

    expect(await gateway.current(), AdStoreEnvironment.unsupported);
  });

  test('MethodChannel失敗は未対応環境としてアプリを継続する', () async {
    error = PlatformException(code: 'not_available');

    expect(await gateway.current(), AdStoreEnvironment.unsupported);
  });
}
