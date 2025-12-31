import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'withdraw_models.dart';

class WithdrawBody extends StatefulWidget {
  const WithdrawBody({super.key});

  @override
  State<WithdrawBody> createState() => _WithdrawBodyState();
}

class _WithdrawBodyState extends State<WithdrawBody> {
  int step = 0;

  WithdrawCoin? selectedCoin;
  WithdrawNetwork? selectedNetwork;

  final addressController = TextEditingController();
  final amountController = TextEditingController();

  final coins = const [
    WithdrawCoin(
      name: 'Bitcoin',
      symbol: 'BTC',
      balance: 0.054,
      networks: [WithdrawNetwork(name: 'BTC', fee: 0.0005, minAmount: 0.001)],
    ),
    WithdrawCoin(
      name: 'Ethereum',
      symbol: 'ETH',
      balance: 1.23,
      networks: [WithdrawNetwork(name: 'ERC20', fee: 0.005, minAmount: 0.01)],
    ),
    WithdrawCoin(
      name: 'USDT',
      symbol: 'USDT',
      balance: 245.0,
      networks: [
        WithdrawNetwork(name: 'ERC20', fee: 5, minAmount: 20),
        WithdrawNetwork(name: 'TRC20', fee: 1, minAmount: 10),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        const SizedBox(height: 24),
        if (step == 0) _coinStep(),
        if (step == 1) _networkStep(),
        if (step == 2) _detailsStep(),
        if (step == 3) _reviewStep(),
        if (step == 4) _successStep(),
      ],
    );
  }

  // ───────── HEADER ─────────
  Widget _header() {
    return Text(
      [
        'Select Coin',
        'Select Network',
        'Withdrawal Details',
        'Confirm Withdrawal',
        'Success',
      ][step],
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
    );
  }

  // ───────── STEP 1 ─────────
  Widget _coinStep() {
    return Column(
      children: coins.map((coin) {
        return _tile(
          title: coin.name,
          subtitle: 'Balance: ${coin.balance} ${coin.symbol}',
          onTap: () {
            setState(() {
              selectedCoin = coin;
              step = 1;
            });
          },
        );
      }).toList(),
    );
  }

  // ───────── STEP 2 ─────────
  Widget _networkStep() {
    return Column(
      children: selectedCoin!.networks.map((net) {
        return _tile(
          title: net.name,
          subtitle:
              'Fee: ${net.fee} ${selectedCoin!.symbol} • Min: ${net.minAmount}',
          onTap: () {
            setState(() {
              selectedNetwork = net;
              step = 2;
            });
          },
        );
      }).toList(),
    );
  }

  // ───────── STEP 3 ─────────
  Widget _detailsStep() {
    return Column(
      children: [
        TextField(
          controller: addressController,
          decoration: const InputDecoration(labelText: 'Recipient Address'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            suffixText: selectedCoin!.symbol,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => setState(() => step = 3),
          child: const Text('Continue'),
        ),
      ],
    );
  }

  // ───────── STEP 4 ─────────
  Widget _reviewStep() {
    final amount = double.tryParse(amountController.text) ?? 0;
    final receive = amount - selectedNetwork!.fee;

    return Column(
      children: [
        _reviewRow('Coin', selectedCoin!.symbol),
        _reviewRow('Network', selectedNetwork!.name),
        _reviewRow('Amount', amountController.text),
        _reviewRow('Fee', '${selectedNetwork!.fee}'),
        _reviewRow(
          'Receive',
          '$receive ${selectedCoin!.symbol}',
          highlight: true,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => setState(() => step = 4),
          child: const Text('Confirm Withdrawal'),
        ),
      ],
    );
  }

  // ───────── STEP 5 ─────────
  Widget _successStep() {
    return Column(
      children: const [
        Icon(Icons.check_circle, size: 72, color: Colors.green),
        SizedBox(height: 16),
        Text(
          'Withdrawal Submitted',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 8),
        Text(
          'Your withdrawal is pending approval.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // ───────── HELPERS ─────────
  Widget _tile({
    required String title,
    required String subtitle,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reviewRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: highlight ? Colors.green : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
