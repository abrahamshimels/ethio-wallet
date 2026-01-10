import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../wallet/service/wallet_service.dart';
import '../../wallet/models/balance_model.dart';
import '../../wallet/widgets/deposit_bottom_sheet.dart';
import '../../../core/constants/app_routes.dart';
import 'package:go_router/go_router.dart';
import '../service/market_service.dart';
import '../models/market_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WalletService _walletService = WalletService();
  final MarketService _marketService = MarketService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          _walletService.getBalance(),
          _marketService.getMarketData(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error fetching data'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final balanceData = snapshot.data?[0] as BalanceResponse?;
          final marketData = snapshot.data?[1] as MarketResponse?;
          
          final portfolioValue = balanceData?.totalBalance ?? 0.0;
          final coins = marketData?.hot ?? [];

          return Padding(
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
                        '\$${portfolioValue.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Live Balance',
                        style: TextStyle(
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

                /// ───────── MARKET HEADER ─────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hot Market',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    TextButton(onPressed: () {}, child: const Text('See All')),
                  ],
                ),

                const SizedBox(height: 8),

                /// ───────── MARKET LIST ─────────
                Expanded(
                  child: ListView.separated(
                    itemCount: coins.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Colors.white12),
                    itemBuilder: (context, index) {
                      final coin = coins[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white10,
                          backgroundImage: NetworkImage(coin.image),
                        ),
                        title: Text(
                          coin.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          coin.symbol.toUpperCase(),
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '\$${coin.lastPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${coin.change24h > 0 ? '+' : ''}${coin.change24h.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: coin.change24h >= 0
                                    ? AppColors.success
                                    : AppColors.danger,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
          );
        },
      ),
    );
  }
}

