class DashboardEvent {
  const DashboardEvent();
}

class GetEthBalanceEvent extends DashboardEvent {
  final String address;
  const GetEthBalanceEvent({required this.address});
}