import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ExchangePage extends StatelessWidget {
  const ExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    final offers = const [
      _Offer(
        symbol: 'BTC',
        name: 'Bitcoin',
        price: '13,600,973.66 USD',
        trader: 'cryptoswap',
        limits: '1000–3000 USD',
      ),
      _Offer(
        symbol: 'BTC',
        name: 'Bitcoin',
        price: '13,650,973.66 USD',
        trader: 'cryptoswap',
        limits: '700–2300 USD',
      ),
    ];

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'P2P Exchange',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(text: 'Buy'),
                Tab(text: 'Sell'),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Crypto'),
                    selected: true,
                    onSelected: (_) {},
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('USD'),
                    selected: false,
                    onSelected: (_) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  _OfferList(offers: offers),
                  _OfferList(offers: offers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferList extends StatelessWidget {
  const _OfferList({required this.offers});

  final List<_Offer> offers;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      child: Text(
                        offer.symbol,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          offer.symbol,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            offer.price,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Trader',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            offer.trader,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Limits',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer.limits,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Exchange'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: offers.length,
    );
  }
}

class _Offer {
  const _Offer({
    required this.symbol,
    required this.name,
    required this.price,
    required this.trader,
    required this.limits,
  });

  final String symbol;
  final String name;
  final String price;
  final String trader;
  final String limits;
}
