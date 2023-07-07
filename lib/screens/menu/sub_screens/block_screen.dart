import 'package:cosmetic_frontend/blocs/block/block_bloc.dart';
import 'package:cosmetic_frontend/blocs/block/block_event.dart';
import 'package:cosmetic_frontend/blocs/block/block_state.dart';
import 'package:cosmetic_frontend/blocs/personal_info/personal_info_bloc.dart';
import 'package:cosmetic_frontend/blocs/personal_info/personal_info_event.dart';
import 'package:cosmetic_frontend/models/blocked_account_model.dart';
import 'package:cosmetic_frontend/routes.dart';
import 'package:cosmetic_frontend/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<BlockBloc>(context).add(BlockedAccountFetched());
    return BlockScreenContent();
  }
}

class BlockScreenContent extends StatefulWidget {
  const BlockScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<BlockScreenContent> createState() => _BlockScreenContent();
}

class _BlockScreenContent extends State<BlockScreenContent> {
  @override
  Widget build(BuildContext context) {
    final hasPagePushed = Navigator.of(context).canPop();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("Chặn"),
              actions: [
                IconButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                    icon: Icon(Icons.search)
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Text("Danh sách chặn", style: Theme.of(context).textTheme.titleLarge)),
            ),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                sliver: BlockedAccountList()
            ),
          ],
        ),
      ),
    );
  }
}

class BlockedAccountList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlockBloc, BlockState>(
        builder: (context, state) {
          switch (state.status) {
            case BlockStatus.initial:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case BlockStatus.loading:
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            case BlockStatus.failure:
              return SliverToBoxAdapter(child: Text("Failed"));
            case BlockStatus.success: {
              final List<BlockedAccount> blockedAccounts = state.blockedAccounts;
              final count = blockedAccounts.length;
              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.personal_screen, arguments: blockedAccounts[index].account)
                              .then((value) {
                            // để an toàn thì cứ fetch lại PersonalInfo xem
                            BlocProvider.of<PersonalInfoBloc>(context).add(PersonalInfoFetched());
                            BlocProvider.of<BlockBloc>(context).add(BlockedAccountFetched());
                          });
                        },
                        child: BlockedAccountContainer(blockedAccount: blockedAccounts[index])
                      );
                    },
                    childCount: count
                  )
              );
            }
          }
        }
    );
  }
}

class BlockedAccountContainer extends StatelessWidget {
  final BlockedAccount blockedAccount;
  const BlockedAccountContainer({Key? key, required this.blockedAccount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      height: 100,
      // child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 8, 5),
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
              NetworkImage(blockedAccount.avatar),
            ),
          ),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 3),
                    child: Text(blockedAccount.name, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 0, 0, 2),
                              child: FilledButton.tonal(
                                onPressed: () {
                                  removeBlockConfirmation(context);
                                },
                                child: Text('Bỏ chặn'),
                              )
                          )
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  void removeBlockConfirmation(BuildContext context) {
    void handleRemoveBlock() {
      BlocProvider.of<BlockBloc>(context).add(BlockedAccountRemove(blockedAccount: blockedAccount));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bỏ chặn?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  handleRemoveBlock();
                },
                child: Text('Xác nhận'),
              )

            ],
          );
        });
  }


}

