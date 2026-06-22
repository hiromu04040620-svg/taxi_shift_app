import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../../application/providers/app_settings_controller.dart';
import '../../../../../core/config/premium_config.dart';
import '../../../../../core/theme/design_tokens.dart';
import '../../../../../domain/models/app_settings.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class PremiumSection extends ConsumerStatefulWidget {
  final AppSettings settings;

  const PremiumSection({super.key, required this.settings});

  @override
  ConsumerState<PremiumSection> createState() => _PremiumSectionState();
}

class _PremiumSectionState extends ConsumerState<PremiumSection> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  ProductDetails? _removeAdsProduct;
  bool _isStoreAvailable = false;
  bool _isLoading = true;
  bool _isPurchasing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        if (!mounted) return;
        setState(() {
          _isPurchasing = false;
          _errorMessage = '購入状態の確認に失敗しました。時間をおいて再度お試しください。';
        });
      },
    );
    unawaited(_loadProduct());
  }

  @override
  void dispose() {
    unawaited(_purchaseSubscription?.cancel());
    super.dispose();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isAvailable = await _inAppPurchase.isAvailable();
      if (!mounted) return;

      if (!isAvailable) {
        setState(() {
          _isStoreAvailable = false;
          _removeAdsProduct = null;
          _isLoading = false;
          _errorMessage = 'App Store に接続できませんでした。';
        });
        return;
      }

      final response = await _inAppPurchase.queryProductDetails({
        PremiumConfig.removeAdsProductId,
      });
      if (!mounted) return;

      final product = response.productDetails.isNotEmpty
          ? response.productDetails.first
          : null;
      setState(() {
        _isStoreAvailable = true;
        _removeAdsProduct = product;
        _isLoading = false;
        _errorMessage = product == null ? '広告非表示の商品情報を取得できませんでした。' : null;
      });
    } on PlatformException {
      if (!mounted) return;
      setState(() {
        _isStoreAvailable = false;
        _removeAdsProduct = null;
        _isLoading = false;
        _errorMessage = 'App Store の購入情報を取得できませんでした。';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isStoreAvailable = false;
        _removeAdsProduct = null;
        _isLoading = false;
        _errorMessage = '購入情報の読み込みに失敗しました。';
      });
    }
  }

  Future<void> _buyRemoveAds() async {
    final product = _removeAdsProduct;
    if (product == null || _isPurchasing || widget.settings.isPremium) {
      return;
    }

    setState(() {
      _isPurchasing = true;
      _errorMessage = null;
    });

    final param = PurchaseParam(productDetails: product);
    try {
      final started = await _inAppPurchase.buyNonConsumable(
        purchaseParam: param,
      );
      if (!started && mounted) {
        setState(() {
          _isPurchasing = false;
          _errorMessage = '購入を開始できませんでした。';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isPurchasing = false;
        _errorMessage = '購入を開始できませんでした。';
      });
    }
  }

  Future<void> _restorePurchases() async {
    if (_isPurchasing) return;

    setState(() {
      _isPurchasing = true;
      _errorMessage = null;
    });

    try {
      await _inAppPurchase.restorePurchases();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isPurchasing = false;
        _errorMessage = '購入の復元に失敗しました。';
      });
    }
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    var handledTargetProduct = false;

    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID != PremiumConfig.removeAdsProductId) {
        continue;
      }

      handledTargetProduct = true;

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          if (mounted) {
            setState(() {
              _isPurchasing = true;
              _errorMessage = null;
            });
          }
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await ref
              .read(appSettingsControllerProvider.notifier)
              .updatePremiumStatus(true);
          if (mounted) {
            setState(() {
              _isPurchasing = false;
              _errorMessage = null;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('広告非表示が有効になりました。')));
          }
          break;
        case PurchaseStatus.error:
          if (mounted) {
            setState(() {
              _isPurchasing = false;
              _errorMessage = purchaseDetails.error?.message ?? '購入に失敗しました。';
            });
          }
          break;
        case PurchaseStatus.canceled:
          if (mounted) {
            setState(() {
              _isPurchasing = false;
            });
          }
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }

    if (!handledTargetProduct && mounted && _isPurchasing) {
      setState(() {
        _isPurchasing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isPremium = widget.settings.isPremium;
    final product = _removeAdsProduct;
    final canPurchase =
        PremiumConfig.monetizationEnabled &&
        _isStoreAvailable &&
        product != null &&
        !_isPurchasing &&
        !isPremium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'プレミアム'),
        SettingTile(
          leading: Icon(
            isPremium ? Icons.verified : Icons.workspace_premium_outlined,
            color: isPremium ? colorScheme.primary : null,
          ),
          title: '広告非表示',
          subtitle: isPremium
              ? '購入済み'
              : product != null
              ? '${product.price} / 買い切り'
              : '購入情報を確認しています',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              FilledButton.icon(
                onPressed: canPurchase ? _buyRemoveAds : null,
                icon: _isPurchasing
                    ? const SizedBox.square(
                        dimension: AppIconSize.sm,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.shopping_bag_outlined),
                label: Text(
                  isPremium
                      ? '購入済み'
                      : _isPurchasing
                      ? '処理中'
                      : product != null
                      ? '広告非表示を購入'
                      : '購入情報を読み込み中',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: _isPurchasing ? null : _restorePurchases,
                icon: const Icon(Icons.restore),
                label: const Text('購入を復元'),
              ),
              if (!_isLoading && product == null) ...[
                const SizedBox(height: AppSpacing.sm),
                TextButton.icon(
                  onPressed: _loadProduct,
                  icon: const Icon(Icons.refresh),
                  label: const Text('購入情報を再読み込み'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
