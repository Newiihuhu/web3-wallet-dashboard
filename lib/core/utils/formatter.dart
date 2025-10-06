BigInt hexToBigInt(String hex) =>
    BigInt.parse(hex.startsWith('0x') ? hex.substring(2) : hex, radix: 16);

double bigIntToAmount(BigInt raw, int decimals) =>
    raw == BigInt.zero ? 0.0 : raw / BigInt.from(10).pow(decimals);

double hexToAmount(String hex, int decimals) =>
    bigIntToAmount(hexToBigInt(hex), decimals);

String shortenAddress(String address, {int prefix = 6, int suffix = 4}) {
  if (address.length <= prefix + suffix) return address;
  return '${address.substring(0, prefix)}...${address.substring(address.length - suffix)}';
}

String formatNumberWithCommas(double number, {int decimalPlaces = 2}) {
  final formatted = number.toStringAsFixed(decimalPlaces);
  final parts = formatted.split('.');
  final integerPart = parts[0];
  final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

  final formatter = RegExp(r'(\d)(?=(\d{3})+(?!\d))');
  final formattedInteger = integerPart.replaceAllMapped(
    formatter,
    (Match match) => '${match[1]},',
  );

  return formattedInteger + decimalPart;
}
