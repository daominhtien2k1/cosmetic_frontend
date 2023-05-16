import 'package:cosmetic_frontend/blocs/event/event_bloc.dart';
import 'package:cosmetic_frontend/blocs/event_detail/event_detail_bloc.dart';
import 'package:cosmetic_frontend/blocs/product_carousel/product_carousel_bloc.dart';
import 'package:cosmetic_frontend/screens/onboard/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import './blocs/auth/auth_state.dart';
import './blocs/comment/comment_bloc.dart';
import './blocs/friend/friend_bloc.dart';
import './blocs/list_video/list_video_bloc.dart';
import './blocs/personal_info/personal_info_bloc.dart';
import './blocs/personal_post/personal_post_bloc.dart';
import './blocs/post/post_bloc.dart';
import './blocs/post_detail/post_detail_bloc.dart';
import './blocs/request_received_friend/request_received_friend_bloc.dart';
import './blocs/search/search_bloc.dart';
import './blocs/signup/signup_bloc.dart';
import './blocs/unknow_people/unknow_people_bloc.dart';

import 'screens/nav_screen.dart';
import 'screens/screens.dart';
import 'repositories/repositories.dart';
import 'routes.dart';

import 'simple_bloc_observer.dart';
import 'constants/material/theme.dart';

void main() async{
  // debug global BLOC, suggesting turn off, please override in debug local BLOC
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PostRepository postRepository = PostRepository();
    VideoRepository videoRepository = VideoRepository();
    SignupRepository signupRepository = SignupRepository();
    FriendRequestReceivedRepository friendRequestReceivedRepository = FriendRequestReceivedRepository();
    EventRepository eventRepository = EventRepository();

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
        BlocProvider<RequestReceivedFriendBloc>(
            lazy: false,
            create: (_) => RequestReceivedFriendBloc()
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
        BlocProvider<ListUnknownPeopleBloc>(
          lazy: false,
          create: (_) => ListUnknownPeopleBloc(),
        ),
        BlocProvider<SearchBloc>(
          lazy: false,
          create: (_) => SearchBloc(),
        ),
        BlocProvider<ProductCarouselBloc>(
          lazy: false,
          create: (_) => ProductCarouselBloc(),
        ),
        BlocProvider<EventBloc>(
          lazy: false,
          create: (_) => EventBloc(eventRepository: eventRepository),
        ),
        BlocProvider<EventDetailBloc>(
          lazy: false,
          create: (_) => EventDetailBloc(eventRepository: eventRepository),
        )
      ],
      child: MaterialApp(
        title: 'Fakebook',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.light(useMaterial3: true),
        theme: theme.toLightThemeData(),
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
                return MaterialPageRoute(builder: (_) => PersonalScreen(accountId: accountId));
              }
              // case Routes.messenger_screen: {
              //   return MaterialPageRoute(builder: (_) => MessengerScreen());
              // }
              case Routes.friend_screen: {
                return MaterialPageRoute(builder: (_) => FriendScreen());
              }
              case Routes.unknow_people_screen: {
                return MaterialPageRoute(builder: (_) => UnknowPeopleScreen());
              }
              case Routes.event_detail_screen: {
                final String eventId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => EventDetailScreen(eventId: eventId));
              }
              default:
                return MaterialPageRoute(builder: (_) => NavScreen());
            }
        }
      ),
    );
  }
}

