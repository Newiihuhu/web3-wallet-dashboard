import 'package:flutter/material.dart';
import 'package:web3_wallet/presentation/dashboard_constant.dart';

class DashboardErrorWidget extends StatelessWidget {
  const DashboardErrorWidget({
    super.key,
    required this.onRefresh,
  });
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                DashboardConstant.somethingWentWrong,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRefresh,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
                child: const Text(DashboardConstant.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
