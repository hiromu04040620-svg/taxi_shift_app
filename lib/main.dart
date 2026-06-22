import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/services/in_app_purchase_bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInAppPurchasePlatform();
  await initializeDateFormatting('ja_JP');

  runApp(const ProviderScope(child: TaxiShiftApp()));
}
