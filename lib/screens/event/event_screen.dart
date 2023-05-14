import 'package:cosmetic_frontend/blocs/event/event_bloc.dart';
import 'package:cosmetic_frontend/blocs/event/event_event.dart';
import 'package:cosmetic_frontend/blocs/event/event_state.dart';
import 'package:cosmetic_frontend/screens/event/widgets/event_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cosmetic_frontend/models/models.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with TickerProviderStateMixin {
  late final TabController _eventTabController;

  @override
  void initState() {
    super.initState();
    _eventTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _eventTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        title: Text("Ưu đãi"),
        bottom: TabBar(
          controller: _eventTabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.card_giftcard),
              text: "Sự kiện"
            ),
            Tab(
              icon: Icon(Icons.discount),
              text: "Mã giảm giá"
            )
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _eventTabController,
          children: <Widget>[
            EventScreenContent(),
            Center(
              child: Text("It's rainy here"),
            )
          ],
        ),
      ),
    );
  }
}

class EventScreenContent extends StatefulWidget {
  const EventScreenContent({Key? key}) : super(key: key);

  @override
  State<EventScreenContent> createState() => _EventScreenContentState();
}

class _EventScreenContentState extends State<EventScreenContent> {
  String searchBy = "all";

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<EventBloc>(context).add(EventFetch(searchBy: searchBy));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              searchBy == "all" ?
              FilledButton(
                onPressed: (){
                  setState(() {
                    searchBy = "all";
                  });
                },
                child: Text("Tất cả")
              ) :
              OutlinedButton(
                onPressed: (){
                  setState(() {
                    searchBy = "all";
                  });
                },
                child: Text("Tất cả")
              ),

              SizedBox(width: 8),

              searchBy == "happening" ?
              FilledButton(
                  onPressed: (){
                    setState(() {
                      searchBy = "happening";
                    });
                  },
                  child: Text("Đang diễn ra")
              ) :
              OutlinedButton(
                  onPressed: (){
                    setState(() {
                      searchBy = "happening";
                    });
                  },
                  child: Text("Đang diễn ra")
              ),

              SizedBox(width: 8),

              searchBy == "ended" ?
              FilledButton(
                  onPressed: (){
                    setState(() {
                      searchBy = "ended";
                    });
                  },
                  child: Text("Đã kết thúc")
              ) :
              OutlinedButton(
                  onPressed: (){
                    setState(() {
                      searchBy = "ended";
                    });
                  },
                  child: Text("Đã kết thúc")
              ),
            ],
          ),
        ),
        BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            switch (state.eventStatus) {
              case EventStatus.initial:
                return CircularProgressIndicator();
              case EventStatus.loading:
                return CircularProgressIndicator();
              case EventStatus.failure:
                return Text("Failed");
              case EventStatus.success: {
                final EventList eventList = state.eventList;
                final List<Event>? happeningEventList = eventList.happeningEventList;
                final List<Event>? endedEventList = eventList.endedEventList;
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (searchBy != "ended") Container(
                          width: double.infinity,
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: Border.all(width: 0, color: Colors.transparent),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Đang diễn ra", style: Theme.of(context).textTheme.titleMedium),
                                  SizedBox(height: 12),
                                  HappeningEventList(happeningEventList: happeningEventList),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(height: 1, thickness: 8, color: Colors.grey[50]),
                        if (searchBy != "happening") Container(
                          width: double.infinity,
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: Border.all(width: 0, color: Colors.transparent),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Đã kết thúc", style: Theme.of(context).textTheme.titleMedium),
                                  SizedBox(height: 12),
                                  EndedEventList(endedEventList: endedEventList)

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }
        ),
       

      ],
    );
  }
}

class HappeningEventList extends StatelessWidget {
  List<Event>? happeningEventList;

  HappeningEventList({Key? key, this.happeningEventList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return happeningEventList != null ?
    ListView.builder(
      itemCount: happeningEventList!.length,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        final Event event = happeningEventList![index];
        return EventContainer(event: event);
      }
    )
    : SizedBox();
  }
}

class EndedEventList extends StatelessWidget {
  List<Event>? endedEventList;

  EndedEventList({Key? key, this.endedEventList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return endedEventList != null ?
    ListView.builder(
        itemCount: endedEventList!.length,
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          final Event event = endedEventList![index];
          return EventContainer(event: event);
        }
    )
        : SizedBox();
  }
}