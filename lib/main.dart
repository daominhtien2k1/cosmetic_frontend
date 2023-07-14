import 'package:cosmetic_frontend/screens/onboard/onboard_screen.dart';
import 'package:cosmetic_frontend/screens/review/review_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/comment/comment_bloc.dart';
import 'blocs/list_video/list_video_bloc.dart';
import 'blocs/personal_info/personal_info_bloc.dart';
import 'blocs/personal_post/personal_post_bloc.dart';
import 'blocs/post/post_bloc.dart';
import 'blocs/post_detail/post_detail_bloc.dart';
import 'blocs/search/search_bloc.dart';
import 'blocs/signup/signup_bloc.dart';
import 'blocs/friend/friend_bloc.dart';
import 'blocs/unknown_people/unknown_people_bloc.dart';
import 'blocs/friend_request_received/friend_request_received_bloc.dart';
import 'blocs/event/event_bloc.dart';
import 'blocs/event_detail/event_detail_bloc.dart';
import 'blocs/product/product_bloc.dart';
import 'blocs/product_carousel/product_carousel_bloc.dart';
import 'blocs/block/block_bloc.dart';
import 'blocs/brand_detail/brand_detail_bloc.dart';
import 'blocs/my_storage_product/my_storage_product_bloc.dart';
import 'blocs/product_bookmark/product_bookmark_bloc.dart';
import 'blocs/product_characteristic/product_characteristic_bloc.dart';
import 'blocs/reply/reply_bloc.dart';
import 'blocs/retrieve_review/retrieve_review_bloc.dart';
import 'blocs/review/review_bloc.dart';
import 'blocs/review_detail/review_detail_bloc.dart';
import 'blocs/followed_brand/followed_brand_bloc.dart';
import 'blocs/product_detail/product_detail_bloc.dart';
import 'localization.dart';
import 'screens/nav_screen.dart';
import 'screens/screens.dart';
import 'repositories/repositories.dart';
import 'routes.dart';

import 'simple_bloc_observer.dart';
import 'constants/material/theme.dart';


void main() async {
  const streamKey = 'r4gwepwebt8y';
  final client = StreamChatClient(
    streamKey,
    logLevel: Level.OFF,
  );
  // debug global BLOC, suggesting turn off, please override in debug local BLOC
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorWidget(details.exception);
  };
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;
  const MyApp({super.key, required this.client});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PostRepository postRepository = PostRepository();
    VideoRepository videoRepository = VideoRepository();
    SignupRepository signupRepository = SignupRepository();
    FriendRequestReceivedRepository friendRequestReceivedRepository = FriendRequestReceivedRepository();
    EventRepository eventRepository = EventRepository();
    ProductRepository productRepository = ProductRepository();
    ReviewRepository reviewRepository = ReviewRepository();

    final theme = CosmeticTheme();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          lazy: false,
          create: (_) => AuthBloc()..add(KeepSession())
        ),
        BlocProvider<PostBloc>(
          lazy: false,
          create: (_) => PostBloc(postRepository: postRepository),
        ),
        BlocProvider<PostDetailBloc>(
          lazy: false,
          create: (_) => PostDetailBloc(postRepository: postRepository)
        ),
        BlocProvider<PersonalPostBloc>(
          lazy: false,
          create: (_) => PersonalPostBloc(postRepository: postRepository)
        ),
        BlocProvider<CommentBloc>(
          lazy: false,
          create: (_) => CommentBloc(),
        ),
        BlocProvider<ListVideoBloc>(
            lazy: false,
            create: (_) => ListVideoBloc(videoRepository: videoRepository)
        ),
        BlocProvider<FriendRequestReceivedBloc>(
            lazy: false,
            create: (_) => FriendRequestReceivedBloc()
        ),
        BlocProvider<PersonalInfoBloc>(
          lazy: false,
          create: (_) => PersonalInfoBloc(),
        ),
        BlocProvider<FriendBloc>(
          lazy: false,
          create: (_) => FriendBloc(),
        ),
        BlocProvider<SignupBloc>(
          lazy: false,
          create: (_) => SignupBloc(signupRepository: signupRepository),
        ),
        BlocProvider<UnknownPeopleBloc>(
          lazy: false,
          create: (_) => UnknownPeopleBloc(),
        ),
        BlocProvider<SearchBloc>(
          lazy: false,
          create: (_) => SearchBloc(),
        ),
        BlocProvider<ProductCarouselBloc>(
          lazy: false,
          create: (_) => ProductCarouselBloc(productRepository: productRepository),
        ),
        BlocProvider<EventBloc>(
          lazy: false,
          create: (_) => EventBloc(eventRepository: eventRepository),
        ),
        BlocProvider<EventDetailBloc>(
          lazy: false,
          create: (_) => EventDetailBloc(eventRepository: eventRepository),
        ),
        BlocProvider<ProductBloc>(
          lazy: false,
          create: (_) => ProductBloc(productRepository: productRepository)
        ),
        BlocProvider<ProductDetailBloc>(
          lazy: false,
          create: (_) => ProductDetailBloc(productRepository: productRepository)
        ),
        BlocProvider<ReviewBloc>(
          lazy: false,
          create: (_) => ReviewBloc(reviewRepository: reviewRepository)
        ),
        BlocProvider<ProductCharacteristicBloc>(
          lazy: false,
          create: (_) => ProductCharacteristicBloc(reviewRepository: reviewRepository)
        ),
        BlocProvider<ReviewDetailBloc>(
          lazy: false,
          create: (_) => ReviewDetailBloc(reviewRepository: reviewRepository)
        ),
        BlocProvider<ReplyBloc>(
          lazy: false,
          create: (_) => ReplyBloc(),
        ),
        BlocProvider<RetrieveReviewBloc>(
          lazy: false,
          create: (_) => RetrieveReviewBloc(reviewRepository: reviewRepository),
        ),
        BlocProvider<BrandDetailBloc>(
          lazy: false,
          create: (_) => BrandDetailBloc()
        ),
        BlocProvider<StorageProductBloc>(
          lazy: false,
          create: (_) => StorageProductBloc(productRepository: productRepository)
        ),
        BlocProvider<ProductBookmarkBloc>(
          lazy: false,
          create: (_) => ProductBookmarkBloc()
        ),
        BlocProvider<FollowedBrandBloc>(
          lazy: false,
          create: (_) => FollowedBrandBloc()
        ),
        BlocProvider<BlockBloc>(
          lazy: false,
          create: (_) => BlockBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Cosmetica',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.light(useMaterial3: true),
        theme: theme.toLightThemeData(),
        supportedLocales: const [
          // Add support for additional 'vi' locale
          Locale('vi'),
          Locale('en'),
          Locale('hi'),
          Locale('fr'),
          Locale('it'),
          Locale('es'),
          Locale('ja'),
          Locale('ko')
        ],
        // locales are the locales of the device
        // supportedLocales are the app supported locales
        localeListResolutionCallback: (locales, supportedLocales) {
          // We map the supported locales to language codes
          // note that this is completely optional and this logic can be changed as you like
          // print(supportedLocales); // [vi, en, hi, fr, it, es, ja, ko]
          final supportedLanguageCodes = supportedLocales.map((e) => e.languageCode);
          // print(supportedLanguageCodes); // (vi, en, hi, fr, it, es, ja, ko)
          // print(locales); // [en_US, vi_VN]
          final localesCodes = locales?.map((e) => e.languageCode);
          // print(localesCodes); // (en, vi)
          if (locales != null) {
            // we iterate over the locales and find the first one that is supported
            for (final locale in locales) {
              // print(locale); // en_US
              if (supportedLanguageCodes.contains(locale.languageCode) && locale.languageCode == 'vi') {
                return locale;
              }
            }
          }
          // print("Không nhảy vào đây");
          // if we didn't find a supported language, we return the English language
          return const Locale('en');
        },
        // Add overridden "NnStreamChatLocalizations.delegate" along with
        // "GlobalStreamChatLocalizations.delegates"
        localizationsDelegates: const [
          NnStreamChatLocalizations.delegate,
          ...GlobalStreamChatLocalizations.delegates,
        ],
        builder: (context, child) {
          final streamChatTheme = StreamChatThemeData.fromTheme(theme.toLightThemeData());
          // final customStreamChatTheme = streamChatTheme.copyWith(
          //
          // );
          return StreamChat(
              streamChatThemeData: streamChatTheme,
              client: client,
              child: child
          );
        },
        home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              switch (state.status) {
                case AuthStatus.unknown:
                  return LoginScreen();
                case AuthStatus.unauthenticated:
                  return LoginScreen();
                case AuthStatus.loginFail:
                  return LoginScreen(fail: true);
                case AuthStatus.authenticated:
                  return NavScreen();
                case AuthStatus.firstTimeUseApp:
                  return OnboardScreen();
              }
            }
        ),
        onGenerateRoute: (settings) {
            switch (settings.name) {
              // case Routes.home_screen:
              //   return MyApp(); // lỗi
              //   break;
              // Bởi vì cập nhật state bằng Bloc nên không cần push từ Login
              case Routes.login_screen:
                return MaterialPageRoute(builder: (_) => LoginScreen());
                break;
              case Routes.signup_screen:
                return MaterialPageRoute(builder: (_) => SignupScreen());
                break;
              case Routes.nav_screen:
                return MaterialPageRoute(builder: (_) => NavScreen());
                break;
              case Routes.post_detail_screen: {
                // return MaterialPageRoute(builder: (_) => PostDetailScreen()); // null arguments ???
                final postId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: postId));
              }
              case Routes.create_post_screen:
                return MaterialPageRoute(builder: (_) => CreatePostScreen());
              case Routes.emotion_screen:
                return MaterialPageRoute(builder: (_) => EmotionScreen());
              case Routes.personal_screen: {
                final String? accountId = settings.arguments as String?;
                // return MaterialPageRoute(builder: (_) => PersonalScreen(accountId: accountId));
                return MaterialPageRoute(builder: (_) => PersonalBrandWrapScreen(accountId: accountId));
              }
              case Routes.messenger_screen: {
                return MaterialPageRoute(builder: (_) => MessengerScreen());
              }
              case Routes.friend_screen: {
                return MaterialPageRoute(builder: (_) => FriendScreen());
              }
              case Routes.unknown_people_screen: {
                return MaterialPageRoute(builder: (_) => UnknownPeopleScreen());
              }
              case Routes.request_friend_screen: {
                return MaterialPageRoute(builder: (_) => RequestFriendScreen());
              }
              case Routes.event_detail_screen: {
                final String eventId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => EventDetailScreen(eventId: eventId));
              }
              // case Routes.product_detail_screen: {
              //   final productId = settings.arguments as String;
              //   return MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: productId));
              // }
              // case Routes.quick_create_review_screen: {
              //   final String productId = settings.arguments as String;
              //   return MaterialPageRoute(builder: (_) => QuickCreateReviewScreen(productId: productId));
              // }
              // case Routes.standard_create_review_screen: {
              //   final args = settings.arguments as Map<String, dynamic>;
              //   final String productId = args["productId"];
              //   final String productImageUrl = args["productImageUrl"];
              //   final String productName = args["productName"];
              //   final int rating = args["rating"];
              //   return MaterialPageRoute(builder: (_) => StandardCreateReviewScreen(
              //       productId: productId, productImageUrl: productImageUrl,
              //       productName: productName, rating: rating
              //   ));
              // }
              // case Routes.detail_create_review_screen: {
              //   final args = settings.arguments as Map<String, dynamic>;
              //   final String productId = args["productId"];
              //   final String productImageUrl = args["productImageUrl"];
              //   final String productName = args["productName"];
              //   final int rating = args["rating"];
              //   return MaterialPageRoute(builder: (_) => DetailCreateReviewScreen(
              //       productId: productId, productImageUrl: productImageUrl,
              //       productName: productName, rating: rating
              //   ));
              // }
              // case Routes.instruction_create_review_screen: {
              //   final String productId = settings.arguments as String;
              //   return MaterialPageRoute(builder: (_) => InstructionCreateReviewScreen(productId: productId));
              // }
              case Routes.product_characteristic_screen: {
                final String productId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => ProductCharacteristicScreen(productId: productId));
              }
              case Routes.review_detail_screen: {
                final String reviewId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => ReviewDetailScreen(reviewId: reviewId));
              }
              default:
                return MaterialPageRoute(builder: (_) => NavScreen());
            }
        }
      ),
    );
  }
}
