import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_colors.dart';
import 'deposit_models.dart';

/// CALL THIS METHOD FROM ANY PAGE
void showDepositBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _DepositBottomSheet(),
  );
}

class _DepositBottomSheet extends StatefulWidget {
  const _DepositBottomSheet();

  @override
  State<_DepositBottomSheet> createState() => _DepositBottomSheetState();
}

class _DepositBottomSheetState extends State<_DepositBottomSheet> {
  int step = 0;

  DepositCoin? selectedCoin;
  DepositNetwork? selectedNetwork;

  final coins = const [
    DepositCoin(
      name: 'Bitcoin',
      symbol: 'BTC',
      networks: [
        DepositNetwork(name: 'BTC', address: 'bc1qexamplebtcaddress123456'),
      ],
    ),
    DepositCoin(
      name: 'Ethereum',
      symbol: 'ETH',
      networks: [
        DepositNetwork(
          name: 'ERC20',
          address: '0xExampleEthereumAddress123456',
        ),
      ],
    ),
    DepositCoin(
      name: 'USDT',
      symbol: 'USDT',
      networks: [
        DepositNetwork(name: 'ERC20', address: '0xExampleERC20Address'),
        DepositNetwork(name: 'TRC20', address: 'TExampleTronAddress'),
        DepositNetwork(name: 'BEP20', address: '0xExampleBSCAddress'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(),
            const SizedBox(height: 20),
            if (step == 0) _coinStep(),
            if (step == 1) _networkStep(),
            if (step == 2) _qrStep(),
          ],
        ),
      ),
    );
  }

  // ───────────────── HEADER ─────────────────
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          step == 0
              ? 'Select Coin'
              : step == 1
              ? 'Select Network'
              : 'Deposit',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  // ───────────────── STEP 1 ─────────────────
  Widget _coinStep() {
    return Column(
      children: coins.map((coin) {
        return _selectTile(
          title: coin.name,
          subtitle: coin.symbol,
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

  // ───────────────── STEP 2 ─────────────────
  Widget _networkStep() {
    return Column(
      children: selectedCoin!.networks.map((network) {
        return _selectTile(
          title: network.name,
          subtitle: 'Network',
          onTap: () {
            setState(() {
              selectedNetwork = network;
              step = 2;
            });
          },
        );
      }).toList(),
    );
  }

  // ───────────────── STEP 3 ─────────────────
  Widget _qrStep() {
    final address = selectedNetwork!.address;

    return Column(
      children: [
        QrImageView(data: address, size: 180, foregroundColor: Colors.white),
        const SizedBox(height: 16),
        Text(
          '${selectedCoin!.symbol} • ${selectedNetwork!.name}',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: address));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Address copied')),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Send only the selected network assets to this address.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  // ───────────────── TILE ─────────────────
  Widget _selectTile({
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
}
