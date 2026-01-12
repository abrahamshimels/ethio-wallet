import 'package:flutter/material.dart';
import '../models/balance_model.dart';
import '../widgets/withdraw_body.dart';

class WithdrawPage extends StatelessWidget {
  final List<BalanceBreakdown> assets;
  const WithdrawPage({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: WithdrawBody(assets: assets),
        ),
      ),
    );
  }
}
