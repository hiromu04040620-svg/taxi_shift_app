import 'package:flutter/services.dart';

enum AdStoreEnvironment { sandbox, production, unsupported }

abstract interface class AdEnvironmentGateway {
  Future<AdStoreEnvironment> current();
}

class MethodChannelAdEnvironmentGateway implements AdEnvironmentGateway {
  static const MethodChannel _defaultChannel = MethodChannel(
    'com.sasame.takushiftokun/ad_environment',
  );

  final MethodChannel channel;

  const MethodChannelAdEnvironmentGateway({this.channel = _defaultChannel});

  @override
  Future<AdStoreEnvironment> current() async {
    try {
      final environment = await channel.invokeMethod<String>('getEnvironment');
      return switch (environment) {
        'sandbox' => AdStoreEnvironment.sandbox,
        'production' => AdStoreEnvironment.production,
        _ => AdStoreEnvironment.unsupported,
      };
    } on PlatformException {
      return AdStoreEnvironment.unsupported;
    } on MissingPluginException {
      return AdStoreEnvironment.unsupported;
    }
  }
}
