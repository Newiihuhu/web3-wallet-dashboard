abstract class WalletAddressRepository {
  Future<String> getSavedWalletAddress();
  bool hasSavedWalletAddress();
  Future<bool> saveWalletAddress(String address);
}
