import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet/data/datasources/local/tokens_local_datasource.dart';
import 'package:web3_wallet/domain/entities/tokens_entity.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('TokensLocalDatasource', () {
    late TokensLocalDatasource datasource;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      datasource = TokensLocalDatasource(mockPrefs);
    });

    group('saveTokens', () {
      test('should save tokens successfully', () async {
        // Given
        final tokens = [
          TokensEntity(
            contractAddress: '0x1234',
            symbol: 'ETH',
            name: 'Ethereum',
            balance: '0x8ac7230489e80000',
            decimals: 18,
          ),
        ];

        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);

        // When
        final result = await datasource.saveTokens(tokens);

        // Then
        expect(result, isTrue);
        verify(() => mockPrefs.setString(any(), any())).called(1);
      });
    });

    group('getTokens', () {
      test('should return tokens when data exists', () {
        // Given
        const tokensJson = '''
        {
          "tokens": [
            {
              "contractAddress": "0x1234",
              "symbol": "ETH",
              "name": "Ethereum",
              "balance": "0x8ac7230489e80000",
              "decimals": 18
            }
          ]
        }
        ''';

        when(() => mockPrefs.getString(any())).thenReturn(tokensJson);

        // When
        final result = datasource.getTokens();

        // Then
        expect(result, isNotNull);
        expect(result!.length, equals(1));
        expect(result.first.symbol, equals('ETH'));
        expect(result.first.name, equals('Ethereum'));
        expect(result.first.contractAddress, equals('0x1234'));
        expect(result.first.balance, equals('0x8ac7230489e80000'));
        expect(result.first.decimals, equals(18));
      });

      test('should return null when no data exists', () {
        // Given
        when(() => mockPrefs.getString(any())).thenReturn(null);

        // When
        final result = datasource.getTokens();

        // Then
        expect(result, isNull);
      });
    });
  });
}
