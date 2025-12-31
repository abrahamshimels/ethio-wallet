import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../widgets/deposit_bottom_sheet.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = const [
      _Transaction(
        name: 'Bitcoin',
        symbol: 'BTC',
        amount: '\$128,966.43',
        icon: Icons.currency_bitcoin,
      ),
      _Transaction(
        name: 'Ethereum',
        symbol: 'ETH',
        amount: '\$40,557.56',
        icon: Icons.change_circle_outlined,
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ───────── TITLE ─────────
            const Text(
              'WALLET',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 24),

            /// ───────── BALANCE ─────────
            const Text(
              'Current balance',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '\$246,084.21',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 20),

            /// ───────── ACTION BUTTONS ─────────
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:  () {
                      showDepositBottomSheet(context);
                    },
                    child: const Text('Deposit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.push(AppRoutes.withdraw),
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
                  'Transaction',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Last 4 days',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// ───────── TRANSACTIONS LIST ─────────
            Expanded(
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final tx = transactions[index];

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
                          backgroundColor: tx.symbol == 'BTC'
                              ? Colors.amber
                              : Colors.white,
                          child: Icon(
                            tx.icon,
                            color: tx.symbol == 'BTC'
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),

                        const SizedBox(width: 14),

                        /// NAME
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tx.symbol,
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
                              tx.amount,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Send',
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
      ),
    );
  }
}

/// ───────── TRANSACTION MODEL ─────────
class _Transaction {
  const _Transaction({
    required this.name,
    required this.symbol,
    required this.amount,
    required this.icon,
  });

  final String name;
  final String symbol;
  final String amount;
  final IconData icon;
}
