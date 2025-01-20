import 'package:apod/app/core/entities/apod_entity.dart';
import 'package:apod/app/modules/favorites_details/data/favorite_details_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';

class MockHomeWidgetHelper extends Mock implements HomeWidgetHelper {}

class MockImageLoader extends Mock implements ImageLoader {}

void main() {
  late SaveApodInHomeServiceImpl service;
  late MockHomeWidgetHelper mockHelper;
  late MockImageLoader mockImageLoader;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const Size(800, 800));
    registerFallbackValue('fallback string');
    registerFallbackValue(
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 800, maxWidth: 800),
      ),
    );
  });

  setUp(() {
    mockHelper = MockHomeWidgetHelper();
    mockImageLoader = MockImageLoader();
    service = SaveApodInHomeServiceImpl(
      helper: mockHelper,
      imageLoader: mockImageLoader,
    );
  });

  test('Should call renderWidget and updateWidget when everything goes well',
      () async {
    final apod = ApodEntity(
      title: 'Teste',
      url: 'https://apod.nasa.gov/apod/image/2501/MarsLOc_Jan13_1024c.jpg',
      date: DateTime(2023),
      explanation: 'Uma imagem de teste',
      mediaType: MediaType.image,
      serviceVersion: 'v1',
    );

    when(
      () => mockHelper.renderWidget(
        any(),
        key: any(named: 'key'),
        logicalSize: any(named: 'logicalSize'),
      ),
    ).thenAnswer((_) async => 'mocked-result');
    when(() => mockHelper.printLog(any<String>())).thenReturn(null);

    when(() => mockHelper.updateWidget(androidName: any(named: 'androidName')))
        .thenAnswer((_) async => Future.value());
    when(() => mockImageLoader.loadImage(any<String>()))
        .thenAnswer((_) async {});
    when(() => mockHelper.printDebug(any())).thenReturn(null);

    await service.call(apod);

    verify(
      () => mockHelper.renderWidget(
        any(),
        key: 'apodImageRendered',
        logicalSize: const Size(800, 800),
      ),
    ).called(1);

    verify(
      () => mockHelper.updateWidget(androidName: 'ApodWidget'),
    ).called(1);

    verify(
      () => mockHelper.printDebug('mocked-result'),
    ).called(1);

    verifyNoMoreInteractions(mockHelper);
  });

  test('Should catch exception when rendering and log error', () async {
    final apod = ApodEntity(
      title: 'Teste',
      url: 'https://apod.nasa.gov/apod/image/2501/MarsLOc_Jan13_1024c.jpg',
      date: DateTime(2023),
      explanation: 'Uma imagem de teste',
      mediaType: MediaType.image,
      serviceVersion: 'v1',
    );
    when(() => mockImageLoader.loadImage(any<String>()))
        .thenAnswer((_) async {});
    when(
      () => mockHelper.renderWidget(
        any(),
        key: any(named: 'key'),
        logicalSize: any(named: 'logicalSize'),
      ),
    ).thenThrow(Exception('Falha no renderWidget'));
    when(() => mockHelper.printLog(any<String>())).thenReturn(null);

    when(() => mockHelper.updateWidget(androidName: any(named: 'androidName')))
        .thenAnswer((_) async => Future.value());

    when(() => mockHelper.printDebug(any())).thenReturn(null);

    await service.call(apod);

    verify(
      () => mockHelper.renderWidget(
        any(),
        key: 'apodImageRendered',
        logicalSize: const Size(800, 800),
      ),
    ).called(1);

    verifyNever(
        () => mockHelper.updateWidget(androidName: any(named: 'androidName')));

    verify(() => mockHelper.printLog(any<String>())).called(1);

    verifyNoMoreInteractions(mockHelper);
  });
}
