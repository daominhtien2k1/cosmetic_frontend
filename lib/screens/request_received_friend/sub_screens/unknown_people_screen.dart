import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/unknow_people/unknow_people_bloc.dart';
import '../../../blocs/unknow_people/unknow_people_event.dart';
import '../../../blocs/unknow_people/unknow_people_state.dart';
import './widgets/unknown_person_container.dart';
import '../../../models/models.dart';
import '../../../routes.dart';

class UnknowPeopleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ListUnknownPeopleBloc>(context).add(ListUnknownPeopleFetched());
    return UnknowPeopleScreenContent();
  }
}

class UnknowPeopleScreenContent extends StatefulWidget {
  const UnknowPeopleScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<UnknowPeopleScreenContent> createState() =>
      _UnknowPeopleScreenContent();
}

class _UnknowPeopleScreenContent extends State<UnknowPeopleScreenContent> {
  @override
  Widget build(BuildContext context) {
    print("#POST OBSERVER: Rebuild");
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: Colors.white,
            title: const Text("Bạn bè",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            centerTitle: false,
            floating: true,
            actions: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: IconButton(
                  icon: const Icon(Icons.search),
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Row(children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 2, 0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade300),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Lời mời kết bạn'),
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey.shade300),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Routes.friend_screen);
                      },
                      child: Text('Tất cả bạn bè'),
                    )),
              ]),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text("Danh sách người bạn có thể biết:",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ))),
          ),
          ListUnknownPeopleList(),
        ],
      ),
    );
  }
}


class _UnknownPerson extends StatelessWidget {
  final UnknownPerson unknownPerson;
  const _UnknownPerson({Key? key, required this.unknownPerson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: UnknownPersonContainer(unknownPerson: unknownPerson)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _ListUnknownPeopleListState extends State<ListUnknownPeopleList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListUnknownPeopleBloc, ListUnknownPeopleState>(builder: (context, state) {
      final listUnknownPeople = state.listUnknownPeopleState;
      return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return index >= listUnknownPeople.listUnknownPeople.length
            ? const CircularProgressIndicator()
            : _UnknownPerson(unknownPerson: listUnknownPeople.listUnknownPeople[index]);
      }, childCount: listUnknownPeople.listUnknownPeople.length));
    });
  }
}

class ListUnknownPeopleList extends StatefulWidget {
  const ListUnknownPeopleList({
    Key? key,
  }) : super(key: key);

  @override
  State<ListUnknownPeopleList> createState() => _ListUnknownPeopleListState();
}
