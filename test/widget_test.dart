import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aisley_flutter/core/utils/formatters.dart';
import 'package:aisley_flutter/main.dart';

// 1x1 transparent PNG bytes for mocking NetworkImage in widget tests
final Uint8List _kTransparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
]);

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest();
  }
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _kTransparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_kTransparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  group('Aisley Formatters & Logic Tests', () {
    test('PHP currency formatter formats correctly', () {
      expect(AisleyFormatters.formatPhp(14850.0), '₱14,850.00');
      expect(AisleyFormatters.formatPhp(1000.5), '₱1,000.50');
      expect(AisleyFormatters.formatPhp(0.0), '₱0.00');
    });

    test('Age calculation accurately calculates age from ISO date', () {
      final age30YearsAgo = DateTime.now().subtract(const Duration(days: 365 * 30 + 8));
      final isoStr = AisleyFormatters.toIsoDate(age30YearsAgo);
      final calculatedAge = AisleyFormatters.calculateAge(isoStr);
      expect(calculatedAge, greaterThanOrEqualTo(30));
    });
  });

  group('Aisley Buyer App Widget Smoke Tests', () {
    testWidgets('App renders login screen with 1-click test buttons', (WidgetTester tester) async {
      await tester.pumpWidget(const AisleyBuyerApp());
      await tester.pumpAndSettle();

      expect(find.text('AISLEY CLIENTELE PORTAL'), findsOneWidget);
      expect(find.text('Approved Buyer'), findsOneWidget);
      expect(find.text('Pending Buyer'), findsOneWidget);
      expect(find.text('Sign In to Storefront'), findsOneWidget);
    });

    testWidgets('Tapping Approved Buyer fast access logs in to Storefront', (WidgetTester tester) async {
      await tester.pumpWidget(const AisleyBuyerApp());
      await tester.pumpAndSettle();

      // Tap the Approved Buyer button
      await tester.tap(find.text('Approved Buyer'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Now we should be on the storefront with 4 navigation bar items
      expect(find.text('AISLEY'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Tapping product opens quick sheet and see more navigates to full page', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const AisleyBuyerApp());
      await tester.pumpAndSettle();

      // Login
      await tester.tap(find.text('Approved Buyer'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Tap on first product
      final productFinder = find.text('Signature Noir Structured Silk Blazer');
      expect(productFinder, findsOneWidget);
      await tester.ensureVisible(productFinder);
      await tester.pumpAndSettle();
      await tester.tap(productFinder);
      await tester.pumpAndSettle();

      // Quick sheet should be visible
      final seeMoreFinder = find.text('See Full Details, Reviews & Atelier Info');
      expect(seeMoreFinder, findsOneWidget);
      await tester.ensureVisible(seeMoreFinder);
      await tester.pumpAndSettle();

      // Tap See Full Details
      await tester.tap(seeMoreFinder);
      await tester.pumpAndSettle();

      // Full page should be open with reviews and craftsmanship story
      expect(find.text('Craftsmanship & Story'), findsOneWidget);
      expect(find.text('Clientele Reviews'), findsOneWidget);
      expect(find.text('You May Also Like'), findsOneWidget);
    });
  });
}
