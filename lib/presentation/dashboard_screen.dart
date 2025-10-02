import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet_dashboard/common/injection/service_locator.dart';
import 'package:web3_wallet_dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:web3_wallet_dashboard/presentation/widgets/wallet_overview_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wallet Dashboard'),
          backgroundColor: const Color.fromARGB(255, 175, 175, 175),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Address: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  shortenAddress('0x86bBF3f5B7fd6bB206f0070fAcF88556aB905088'),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: '0x86bBF3f5B7fd6bB206f0070fAcF88556aB905088',
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Address copied to clipboard')),
                    );
                  },
                  icon: Icon(Icons.copy, color: Colors.blueGrey[500], size: 16),
                ),
              ],
            ),
            Text('Last sync: 10/01/2025 10:00:00'),
            WalletOverviewWidget(),
          ],
        ),
      ),
    );
  }
}

String shortenAddress(String address, {int prefix = 6, int suffix = 4}) {
  if (address.length <= prefix + suffix) return address;
  return '${address.substring(0, prefix)}...${address.substring(address.length - suffix)}';
}
