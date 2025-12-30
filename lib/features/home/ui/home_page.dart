import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final holdings = [
        const _Holding(name: 'Solana', amount: '\$503.12', volume: '30 SOL'),
        const _Holding(name: 'Ethereum', amount: '\$503.12', volume: '50 ETH'),
        const _Holding(name: 'Bitcoin', amount: '\$26,927', volume: '2.05 BTC'),
        const _Holding(name: 'Litecoin', amount: '\$6,927', volume: '2.05 LTC'),
        const _Holding(name: 'Ripple', amount: '\$4,637', volume: '2.05 XRP'),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Value',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                        '\$87,430.12',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.trending_up, color: AppColors.success, size: 18),
                        SizedBox(width: 4),
                        Text(
                          '+10.2% (3,657.00\$)',
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.auto_graph_rounded, color: AppColors.primary, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.south_west_rounded),
                    label: const Text('Deposit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.north_east_rounded),
                    label: const Text('Withdraw'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Holdings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            ...holdings.map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: ListTile(
                      title: Text(h.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(h.volume, style: const TextStyle(color: AppColors.textSecondary)),
                      trailing: Text(
                        h.amount,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _Holding {
  const _Holding({required this.name, required this.amount, required this.volume});

  final String name;
  final String amount;
  final String volume;
}
