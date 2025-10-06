import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3_wallet/core/exception/app_exception.dart';
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
      test('should throw exception when save tokens fails', () async {
        // Given
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenThrow(LocalStorageException('Save tokens failed'));
        final tokens = [
          TokensEntity(
            contractAddress: '0x1234',
            symbol: 'ETH',
            name: 'Ethereum',
            balance: '0x8ac7230489e80000',
            decimals: 18,
          ),
        ];

        // Then
        expect(
          () => datasource.saveTokens(tokens),
          throwsA(isA<LocalStorageException>()),
        );
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
      test('should throw exception when get tokens fails', () {
        // Given
        when(
          () => mockPrefs.getString(any()),
        ).thenThrow(LocalStorageException('Get tokens failed'));

        // When & Then
        expect(
          () => datasource.getTokens(),
          throwsA(isA<LocalStorageException>()),
        );
        verify(() => mockPrefs.getString(any())).called(1);
      });
    });
    group('hasTokensData', () {
      test('should return true when data exists', () {
        // Given
        when(() => mockPrefs.containsKey(any())).thenReturn(true);

        // When
        final result = datasource.hasTokensData();

        // Then
        expect(result, isTrue);
        verify(() => mockPrefs.containsKey(any())).called(1);
      });
      test('should return false when data does not exist', () {
        // Given
        when(() => mockPrefs.containsKey(any())).thenReturn(false);

        // When
        final result = datasource.hasTokensData();

        // Then
        expect(result, isFalse);
        verify(() => mockPrefs.containsKey(any())).called(1);
      });
    });
  });
}
