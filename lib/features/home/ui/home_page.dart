import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../wallet/widgets/deposit_bottom_sheet.dart';
import '../../../core/constants/app_routes.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final holdings = const [
      _Holding(
        name: 'Solana',
        symbol: 'SOL',
        amount: '\$503.12',
        volume: '30 SOL',
        icon: Icons.layers_rounded,
      ),
      _Holding(
        name: 'Ethereum',
        symbol: 'ETH',
        amount: '\$503.12',
        volume: '50 ETH',
        icon: Icons.change_circle_outlined,
      ),
      _Holding(
        name: 'Bitcoin',
        symbol: 'BTC',
        amount: '\$26,927',
        volume: '2.05 BTC',
        icon: Icons.currency_bitcoin,
      ),
      _Holding(
        name: 'Litecoin',
        symbol: 'LTC',
        amount: '\$6,927',
        volume: '2.05 LTC',
        icon: Icons.flash_on_rounded,
      ),
      _Holding(
        name: 'Ripple',
        symbol: 'XRP',
        amount: '\$4,637',
        volume: '2.05 XRP',
        icon: Icons.blur_circular,
      ),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ───────── HEADER ─────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Home',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.push(AppRoutes.profile);
                  },
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ───────── PORTFOLIO CARD ─────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white12),
                color: AppColors.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Portfolio Value',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$87,430.12',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '+10.2% (3,657.00\$)',
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ───────── ACTION BUTTONS ─────────
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDepositBottomSheet(context);
                    },
                    child: const Text('Deposit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => context.push(AppRoutes.withdraw),
                    child: const Text('Withdraw'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ───────── HOLDINGS HEADER ─────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Holdings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),

            const SizedBox(height: 8),

            /// ───────── HOLDINGS LIST ─────────
            Expanded(
              child: ListView.separated(
                itemCount: holdings.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: Colors.white12),
                itemBuilder: (context, index) {
                  final h = holdings[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white10,
                      child: Icon(h.icon, color: Colors.white),
                    ),
                    title: Text(
                      h.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      h.symbol,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          h.amount,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          h.volume,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
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

class _Holding {
  const _Holding({
    required this.name,
    required this.symbol,
    required this.amount,
    required this.volume,
    required this.icon,
  });

  final String name;
  final String symbol;
  final String amount;
  final String volume;
  final IconData icon;
}
