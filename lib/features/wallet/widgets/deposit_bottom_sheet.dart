import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../models/balance_model.dart';
import '../models/wallet_address_model.dart';
import '../service/wallet_service.dart';

/// CALL THIS METHOD FROM ANY PAGE
void showDepositBottomSheet(BuildContext context, {required List<BalanceBreakdown> assets}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DepositBottomSheet(assets: assets),
  );
}

class _DepositBottomSheet extends StatefulWidget {
  final List<BalanceBreakdown> assets;
  const _DepositBottomSheet({required this.assets});

  @override
  State<_DepositBottomSheet> createState() => _DepositBottomSheetState();
}

class _DepositBottomSheetState extends State<_DepositBottomSheet> {
  int step = 0;
  final WalletService _walletService = WalletService();

  BalanceBreakdown? selectedAsset;
  WalletAddressResponse? walletAddress;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(),
            const SizedBox(height: 20),
            if (step == 0) _coinStep(),
            if (step == 1) _qrStep(),
          ],
        ),
      ),
    );
  }

  // ───────────────── HEADER ─────────────────
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          step == 0 ? 'Select Asset' : 'Deposit ${selectedAsset?.symbol}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  // ───────────────── STEP 1 ─────────────────
  Widget _coinStep() {
    if (widget.assets.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'No wallets available. Please create one first.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Column(
      children: widget.assets.map((asset) {
        return _selectTile(
          title: asset.symbol,
          subtitle: 'Available: ${asset.balance}',
          leadingIcon: _getAssetIcon(asset.symbol),
          iconColor: _getAssetColor(asset.symbol),
          onTap: () => _handleAssetSelection(asset),
        );
      }).toList(),
    );
  }

  Future<void> _handleAssetSelection(BalanceBreakdown asset) async {
    setState(() {
      selectedAsset = asset;
      _isLoading = true;
      step = 1;
    });

    try {
      final response = await _walletService.getWalletAddress(asset.symbol);
      setState(() {
        walletAddress = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        step = 0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch deposit address.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ───────────────── STEP 2 ─────────────────
  Widget _qrStep() {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (walletAddress == null) return const SizedBox.shrink();

    final address = walletAddress!.address;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: QrImageView(
            data: address,
            size: 180,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${selectedAsset!.symbol} Address',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18, color: AppColors.primary),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: address));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Address copied')),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Only send ${selectedAsset!.symbol} to this address. Sending other assets may result in permanent loss.',
                  style: const TextStyle(color: Colors.orange, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ───────────────── TILE ─────────────────
  Widget _selectTile({
    required String title,
    required String subtitle,
    required IconData leadingIcon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor.withValues(alpha: 0.1),
                child: Icon(leadingIcon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAssetColor(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'BTC': return Colors.orange;
      case 'ETH': return Colors.blueAccent;
      case 'MATIC': return Colors.purpleAccent;
      case 'USDT': return Colors.green;
      default: return Colors.white70;
    }
  }

  IconData _getAssetIcon(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'BTC': return Icons.currency_bitcoin;
      case 'ETH': return Icons.change_circle_outlined;
      case 'MATIC': return Icons.layers_outlined;
      case 'USDT': return Icons.attach_money;
      default: return Icons.account_balance_wallet_outlined;
    }
  }
}
