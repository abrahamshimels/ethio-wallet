import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ExchangePage extends StatelessWidget {
  const ExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final offers = const [
      _Offer(
        price: '13,600,973.66 USD',
        limits: '1000–3000 USD',
        orders: '653',
      ),
      _Offer(price: '13,650,973.66 USD', limits: '700–2300 USD', orders: '607'),
      _Offer(price: '13,700,973.66 USD', limits: '700–2300 USD', orders: '607'),
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
                const Text(
                  'P2P',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ───────── TOP TABS ─────────
            Row(
              children: const [
                _TopTab(title: 'Overview', active: true),
                _TopTab(title: 'My ads'),
                Spacer(),
              ],
            ),

            const SizedBox(height: 16),

            /// ───────── BUY / SELL SWITCH ─────────
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Buy',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Sell',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ───────── CRYPTO INPUT ─────────
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Crypto currency',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// ───────── FILTER ROW ─────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text('Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('Clean filter')),
              ],
            ),

            const SizedBox(height: 12),

            /// ───────── OFFERS LIST ─────────
            Expanded(
              child: ListView.separated(
                itemCount: offers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  final highlighted = index == 0;

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: highlighted ? AppColors.primary : Colors.white12,
                      ),
                      color: AppColors.card,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.orange,
                              child: Icon(
                                Icons.currency_bitcoin,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'BTC',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Bitcoin',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              offer.price,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'cryptoswap',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              offer.limits,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              offer.orders,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
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

/// ───────── SMALL TOP TAB ─────────
class _TopTab extends StatelessWidget {
  const _TopTab({required this.title, this.active = false});

  final String title;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : Colors.white38,
          decoration: active ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}

/// ───────── OFFER MODEL ─────────
class _Offer {
  const _Offer({
    required this.price,
    required this.limits,
    required this.orders,
  });

  final String price;
  final String limits;
  final String orders;
}
