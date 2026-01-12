import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/balance_model.dart';
import '../models/withdraw_response_model.dart';
import '../service/wallet_service.dart';

class WithdrawBody extends StatefulWidget {
  final List<BalanceBreakdown> assets;
  const WithdrawBody({super.key, required this.assets});

  @override
  State<WithdrawBody> createState() => _WithdrawBodyState();
}

class _WithdrawBodyState extends State<WithdrawBody> {
  int step = 0;
  final WalletService _walletService = WalletService();

  BalanceBreakdown? selectedAsset;
  
  final addressController = TextEditingController();
  final amountController = TextEditingController();
  final passwordController = TextEditingController();
  final noteController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  WithdrawResponse? _withdrawResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 24),
        if (step == 0) _coinStep(),
        if (step == 1) _detailsStep(),
        if (step == 2) _reviewStep(),
        if (step == 3) _successStep(),
      ],
    );
  }

  // ───────── HEADER ─────────
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          [
            'Select Asset',
            'Withdrawal Details',
            'Confirm Withdrawal',
            'Success',
          ][step],
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        if (step > 0 && step < 3)
          TextButton(
            onPressed: () => setState(() => step--),
            child: const Text('Back'),
          ),
      ],
    );
  }

  // ───────── STEP 1 ─────────
  Widget _coinStep() {
    if (widget.assets.isEmpty) {
      return const Center(
        child: Text('No assets available for withdrawal.'),
      );
    }

    return Column(
      children: widget.assets.map((asset) {
        return _tile(
          title: asset.symbol,
          subtitle: 'Balance: ${asset.balance} ${asset.symbol}',
          leadingIcon: _getAssetIcon(asset.symbol),
          iconColor: _getAssetColor(asset.symbol),
          onTap: () {
            if ((double.tryParse(asset.balance.toString()) ?? 0) <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Insufficient balance. You cannot withdraw ${asset.symbol} at this time.'),
                  backgroundColor: AppColors.danger,
                ),
              );
              return;
            }
            setState(() {
              selectedAsset = asset;
              step = 1;
            });
          },
        );
      }).toList(),
    );
  }

  // ───────── STEP 2 ─────────
  Widget _detailsStep() {
    return Column(
      children: [
        TextField(
          controller: addressController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Recipient Address',
            hintText: 'Enter destination address',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Amount',
            suffixText: selectedAsset?.symbol,
            hintText: '0.00',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Withdraw Password',
            hintText: 'Enter your 6-digit password',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: noteController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Note (Optional)',
            hintText: 'Description for this withdrawal',
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (addressController.text.isNotEmpty && amountController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                setState(() => step = 2);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
              }
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  // ───────── STEP 3 ─────────
  Widget _reviewStep() {
    return Column(
      children: [
        _reviewRow('Asset', selectedAsset!.symbol),
        _reviewRow('Recipient', addressController.text),
        _reviewRow('Amount', '${amountController.text} ${selectedAsset!.symbol}'),
        _reviewRow('Note', noteController.text.isEmpty ? 'N/A' : noteController.text),
        const SizedBox(height: 32),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: AppColors.danger, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleWithdrawal,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                  )
                : const Text('Confirm & Withdraw'),
          ),
        ),
      ],
    );
  }

  Future<void> _handleWithdrawal() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _walletService.withdraw({
        "asset": selectedAsset!.symbol,
        "amount": amountController.text,
        "withdraw_address": addressController.text,
        "withdraw_password": passwordController.text,
        "senderNote": noteController.text,
      });

      if (mounted) {
        if (response.withdraw != null || response.message.toLowerCase().contains('submitted')) {
          // Success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successful transfer'),
              backgroundColor: AppColors.success,
            ),
          );
          
          setState(() {
            _withdrawResponse = response;
            _isLoading = false;
            step = 3;
          });

          // Return to home page after a short delay to allow success view to be seen, 
          // or pop immediately and go to home. Let's show success view for 2 seconds then go home.
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              context.go('/home');
            }
          });
        } else {
          // Failure
          String errorMessage = response.message;
          if (response.errorCode != null) {
            errorMessage = '$errorMessage (${response.errorCode})';
          }
          setState(() {
            _isLoading = false;
            _errorMessage = errorMessage;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Withdrawal failed. Please check your inputs or try again later.';
        });
      }
    }
  }

  // ───────── STEP 4 ─────────
  Widget _successStep() {
    final withdraw = _withdrawResponse?.withdraw;
    final tatum = _withdrawResponse?.tatumResponse;

    return Column(
      children: [
        const Icon(Icons.check_circle, size: 72, color: AppColors.success),
        const SizedBox(height: 16),
        Text(
          _withdrawResponse?.message ?? 'Withdrawal Submitted',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 24),
        if (withdraw != null) ...[
          _successRow('Asset', withdraw.asset),
          _successRow('Recipient', withdraw.toAddress),
          _successRow('Amount', withdraw.amountBase),
          _successRow('Fee', withdraw.feeBase),
          _successRow('Status', withdraw.status, color: AppColors.success),
        ],
        if (tatum != null) ...[
          const SizedBox(height: 12),
          _successRow('Reference', tatum.reference),
        ],
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Return to Wallet'),
          ),
        ),
      ],
    );
  }

  Widget _successRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: color ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── HELPERS ─────────
  Widget _tile({
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
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
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

  Widget _reviewRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: highlight ? AppColors.success : Colors.white,
              ),
            ),
          ),
        ],
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
