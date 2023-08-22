import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut; // system under testing
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test("Initial variable is correct", () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });

  group("get Articles", () {
    final articles = [
      Article(title: "Article 1", content: "Article 1 content"),
      Article(title: "Article 2", content: "Article 2 content"),
      Article(title: "Article 3", content: "Article 3 content"),
    ];

    test("get article", () async {
      when(() => mockNewsService.getArticles())
          .thenAnswer((invocation) async => articles);
      await sut.getArticles();

      verify(() => mockNewsService.getArticles()).called(1);
    });

    test("""check loading is true,
    populate the article,
    check loading is false""", () async {
      when(() => mockNewsService.getArticles()).thenAnswer(
          (invocation) async => articles); // like a function definition
      final future = sut.getArticles();
      expect(sut.isLoading, true);

      await future;
      expect(sut.articles, articles);

      expect(sut.isLoading, false);
    });
  });
}
