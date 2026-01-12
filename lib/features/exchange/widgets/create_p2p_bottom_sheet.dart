import 'package:flutter/material.dart';
import '../models/p2p_model.dart';
import '../service/p2p_service.dart';
import '../../../core/constants/app_colors.dart';

void showCreateP2PBottomSheet(BuildContext context, {required VoidCallback onOrderCreated}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _CreateP2PBottomSheet(onOrderCreated: onOrderCreated),
  );
}

class _CreateP2PBottomSheet extends StatefulWidget {
  final VoidCallback onOrderCreated;
  const _CreateP2PBottomSheet({required this.onOrderCreated});

  @override
  State<_CreateP2PBottomSheet> createState() => _CreateP2PBottomSheetState();
}

class _CreateP2PBottomSheetState extends State<_CreateP2PBottomSheet> {
  final P2PService _p2pService = P2PService();
  final _amountController = TextEditingController();
  final _rateController = TextEditingController();
  final _totalController = TextEditingController();

  String _type = 'SELL'; // Default to SELL for posting an ad
  String _asset = 'ETH';
  bool _isLoading = false;

  final List<String> _assets = ['BTC', 'ETH', 'MATIC', 'USDT'];

  void _calculateTotal() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    _totalController.text = (amount * rate).toStringAsFixed(2);
  }

  Future<void> _submit() async {
    if (_amountController.text.isEmpty || _rateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _p2pService.createOrder(CreateP2PRequest(
        type: _type,
        asset: _asset,
        cryptoAmount: _amountController.text,
        birrAmount: _totalController.text,
        ratePerUnit: double.parse(_rateController.text),
      ));

      if (mounted) {
        widget.onOrderCreated();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('P2P Order Created Successfully'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating order: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Create P2P Ad',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          /// Switch Buy/Sell
          Row(
            children: [
              _typeButton('SELL', 'Sell Crypto'),
              const SizedBox(width: 12),
              _typeButton('BUY', 'Buy Crypto'),
            ],
          ),
          const SizedBox(height: 20),

          /// Asset Selection
          const Text('Select Asset', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _assets.map((a) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(a),
                  selected: _asset == a,
                  onSelected: (val) => setState(() => _asset = a),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.card,
                  labelStyle: TextStyle(color: _asset == a ? Colors.white : Colors.white60),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 20),

          /// Crypto Amount
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Crypto Amount',
              hintText: '0.00',
              suffixText: _asset,
            ),
            onChanged: (_) => _calculateTotal(),
          ),
          const SizedBox(height: 16),

          /// Rate per Unit
          TextField(
            controller: _rateController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Rate (ETB per unit)',
              hintText: '0.00',
              suffixText: 'ETB',
            ),
            onChanged: (_) => _calculateTotal(),
          ),
          const SizedBox(height: 16),

          /// Total Birr Amount (Read only)
          TextField(
            controller: _totalController,
            readOnly: true,
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              labelText: 'Total Value',
              suffixText: 'ETB',
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : const Text('Post Advertisement'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeButton(String type, String label) {
    final active = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? (type == 'SELL' ? Colors.redAccent.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2)) : AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: active ? (type == 'SELL' ? Colors.redAccent : Colors.green) : Colors.transparent),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: active ? (type == 'SELL' ? Colors.redAccent : Colors.green) : Colors.white60,
            ),
          ),
        ),
      ),
    );
  }
}
