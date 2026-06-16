class AppLinks {
  AppLinks._();

  static final Uri support = Uri.parse(
    'https://hiromu04040620-svg.github.io/taxi_shift_app/',
  );

  static final Uri privacyPolicy = Uri.parse(
    'https://hiromu04040620-svg.github.io/taxi_shift_app/PRIVACY_POLICY.html',
  );

  static final Uri supportEmail = Uri(
    scheme: 'mailto',
    path: 'hiromu04040620@gmail.com',
    queryParameters: {'subject': 'TaxiShift サポート'},
  );
}
