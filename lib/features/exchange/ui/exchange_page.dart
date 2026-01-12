import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../service/p2p_service.dart';
import '../models/p2p_model.dart';
import '../widgets/create_p2p_bottom_sheet.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  final P2PService _p2pService = P2PService();
  String _selectedType = 'SELL'; // SELL ads appear under 'Buy' tab
  late Future<List<P2POrder>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _p2pService.getOrders();
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = _p2pService.getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: _refreshOrders,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh Orders',
                      ),
                      IconButton(
                        onPressed: () {
                           showCreateP2PBottomSheet(
                              context,
                              onOrderCreated: _refreshOrders,
                            );
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 28),
                        tooltip: 'Post Ad',
                      ),
                    ],
                  ),
                ],
              ),
  
              const SizedBox(height: 12),
  
              /// ───────── TOP TABS ─────────
              const Row(
                children: [
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
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedType = 'SELL'),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _selectedType == 'SELL' ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Buy',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _selectedType == 'SELL' ? Colors.white : Colors.white60,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedType = 'BUY'),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _selectedType == 'BUY' ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Sell',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _selectedType == 'BUY' ? Colors.white : Colors.white60,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
  
              const SizedBox(height: 24),
  
              /// ───────── OFFERS LIST ─────────
              Expanded(
                child: FutureBuilder<List<P2POrder>>(
                  future: _ordersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error loading orders: ${snapshot.error}'),
                      );
                    }
  
                    final orders = snapshot.data ?? [];
                    final filteredOrders = orders.where((o) => o.type == _selectedType).toList();
  
                    if (filteredOrders.isEmpty) {
                      return const Center(
                        child: Text('No active orders found'),
                      );
                    }
  
                    return ListView.separated(
                      itemCount: filteredOrders.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return _OrderTile(
                          order: order,
                          p2pService: _p2pService,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final P2POrder order;
  final P2PService p2pService;
  const _OrderTile({required this.order, required this.p2pService});

  Future<void> _handleAction(BuildContext context) async {
    if (order.type == 'BUY') {
      // Future: Sell flow
      return;
    }

    // Buy flow (from a SELL ad)
    final amountController = TextEditingController(text: order.cryptoAmount);
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text('Buy ${order.asset}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate: ${order.ratePerUnit} ETB/${order.asset}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Amount to Buy',
                suffixText: order.asset,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final amountStr = amountController.text;
      final amount = double.tryParse(amountStr);
      if (amount == null || amount <= 0) return;

      if (!context.mounted) return;

      try {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        final response = await p2pService.buyOrder(order.id, amount);
        
        if (!context.mounted) return;
        Navigator.pop(context); // Pop loading

        if (response.checkoutUrl.isNotEmpty) {
          final uri = Uri.parse(response.checkoutUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Redirecting to payment...'), backgroundColor: Colors.blue),
            );
          } else {
            throw 'Could not launch payment URL';
          }
        }
      } catch (e) {
        if (!context.mounted) return;
        // Check if loading dialog is still open by checking if we can pop
        // Navigator.of(context).pop() might fail if not careful, but usually fine here
        Navigator.of(context, rootNavigator: true).pop(); // Robust pop for dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
        color: AppColors.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _getAssetColor(order.asset).withValues(alpha: 0.1),
                child: Icon(
                  _getAssetIcon(order.asset),
                  color: _getAssetColor(order.asset),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.asset,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Order ID: #${order.id}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Text(
                    '${order.ratePerUnit} ETB',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text(
                    'Rate per unit',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
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
                    'Available amount',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.cryptoAmount} ${order.asset}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.birrAmount} ETB',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleAction(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: order.type == 'BUY' ? Colors.redAccent : Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(order.type == 'BUY' ? 'Sell' : 'Buy'),
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
