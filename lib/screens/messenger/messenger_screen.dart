import 'package:cosmetic_frontend/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MessengerScreen extends StatefulWidget {

  MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

// phải đặt StreamChat ở đầu App, nếu không không chạy
class _MessengerScreenState extends State<MessengerScreen> {
  late Future<OwnUser> connectStreamChat;
  late final client;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client = StreamChat.of(context).client;
    final user = BlocProvider.of<AuthBloc>(context).state.authUser;
    connectStreamChat = client.connectUser(
        User(id: user.id),
        client.devToken(user.id).rawValue
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    client.disconnectUser();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: connectStreamChat,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return ChannelListPage();
            }
            return Center(child: Text("Không có kết nối mạng"));
          }
        )
      ),
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final streamChannelListController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    sort: const [SortOption('last_message_at')],
    limit: 10,
  );

  @override
  void dispose() {
    streamChannelListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamChannelListHeader(
        titleBuilder: (context, status, client) {
          return Text("Đoạn chat");
        },
        leading: BackButton(),
        showConnectionStateTile: true,
        centerTitle: true,
        onNewChatButtonTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => UserListPage()) );
        },
      ),
      body: RefreshIndicator(
        onRefresh: streamChannelListController.refresh,
        child: StreamChannelListView(
          controller: streamChannelListController,
          onChannelTap: (channel) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return StreamChannel(
                    channel: channel,
                    child: const ChannelPage(),
                  );
                },
              ),
            );
          },
        )
      ),
    );
  }

}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: [
          Expanded(
            child: StreamMessageListView(
              threadBuilder: (_, parentMessage) => ThreadPage(
                parent: parentMessage,
              ),
            ),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}


class ThreadPage extends StatelessWidget {
  const ThreadPage({
    Key? key,
    this.parent,
  }) : super(key: key);

  final Message? parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamThreadHeader(
        parent: parent!,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: parent,
            ),
          ),
          StreamMessageInput(
            messageInputController: StreamMessageInputController(
              message: Message(parentId: parent!.id),
            ),
          ),
        ],
      ),
    );
  }
}
