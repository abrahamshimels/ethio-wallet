import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../service/wallet_service.dart';
import '../models/balance_model.dart';
import '../widgets/deposit_bottom_sheet.dart';
import '../widgets/add_wallet_bottom_sheet.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final WalletService _walletService = WalletService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<BalanceResponse>(
          future: _walletService.getBalance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error fetching balance'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data;
            final totalBalance = data?.totalBalance ?? 0.0;
            final breakdown = data?.breakdown ?? [];

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ───────── TITLE ─────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'WALLET',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setState(() {}),
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Refresh Balance',
                          ),
                          IconButton(
                            onPressed: () {
                              final currentAssets = breakdown.map((e) => e.symbol).toList();
                              showAddWalletBottomSheet(
                                context,
                                existingAssets: currentAssets,
                                onWalletCreated: () {
                                  setState(() {});
                                },
                              );
                            },
                            icon: const Icon(Icons.add_circle_outline, size: 28),
                            tooltip: 'Add Wallet',
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// ───────── BALANCE ─────────
                  const Text(
                    'Current balance',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${totalBalance.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                  ),

                  const SizedBox(height: 20),

                  /// ───────── ACTION BUTTONS ─────────
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showDepositBottomSheet(context, assets: breakdown);
                          },
                          child: const Text('Deposit'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push(AppRoutes.withdraw, extra: breakdown),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Withdraw'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// ───────── TRANSACTIONS HEADER ─────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Assets',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Total Breakdown',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// ───────── ASSETS LIST ─────────
                  Expanded(
                    child: ListView.separated(
                      itemCount: breakdown.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final asset = breakdown[index];
                        final symbol = asset.symbol;
                        final balance = asset.balance;
                        final balanceInUSDT = asset.balanceInUSDT;

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                                /// ICON
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: _getAssetColor(symbol).withValues(alpha: 0.2),
                                  child: Icon(
                                    _getAssetIcon(symbol),
                                    color: _getAssetColor(symbol),
                                    size: 24,
                                  ),
                                ),

                                const SizedBox(width: 14),

                              /// NAME
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    symbol,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    balance.toString(),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              /// AMOUNT + TYPE
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${balanceInUSDT.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Wallet',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getAssetColor(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'BTC':
        return Colors.orange;
      case 'ETH':
        return Colors.blueAccent;
      case 'MATIC':
        return Colors.purpleAccent;
      case 'USDT':
        return Colors.green;
      default:
        return Colors.white70;
    }
  }

  IconData _getAssetIcon(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'BTC':
        return Icons.currency_bitcoin;
      case 'ETH':
        return Icons.change_circle_outlined;
      case 'MATIC':
        return Icons.layers_outlined;
      case 'USDT':
        return Icons.attach_money;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }
}

