import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../service/wallet_service.dart';

class AddWalletBottomSheet extends StatefulWidget {
  final List<String> existingAssets;
  final VoidCallback onWalletCreated;

  const AddWalletBottomSheet({
    super.key,
    required this.existingAssets,
    required this.onWalletCreated,
  });

  @override
  State<AddWalletBottomSheet> createState() => _AddWalletBottomSheetState();
}

class _AddWalletBottomSheetState extends State<AddWalletBottomSheet> {
  final WalletService _walletService = WalletService();
  final List<String> _supportedAssets = ['BTC', 'ETH', 'MATIC', 'USDT'];
  String? _selectedAsset;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final availableAssets = _supportedAssets
        .where((asset) => !widget.existingAssets.contains(asset))
        .toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add New Wallet',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Select an asset to create a new wallet address.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          if (availableAssets.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'All supported wallets are already created.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableAssets.map((asset) {
                final isSelected = _selectedAsset == asset;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAsset = asset;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      asset,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedAsset == null || _isLoading
                  ? null
                  : _handleCreateWallet,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      'Create Wallet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _handleCreateWallet() async {
    if (_selectedAsset == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _walletService.createWallet(_selectedAsset!);

      if (mounted) {
        if (response.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error!),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );
          widget.onWalletCreated();
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create wallet. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

void showAddWalletBottomSheet(
  BuildContext context, {
  required List<String> existingAssets,
  required VoidCallback onWalletCreated,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AddWalletBottomSheet(
        existingAssets: existingAssets,
        onWalletCreated: onWalletCreated,
      ),
    ),
  );
}
