import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../models/channel.dart';
import '../providers/channel_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/channels_tile.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAdmin = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getUserData();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var channelProvider = Provider.of<ChannelProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeDrawer(),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 14.h,
                width: 95.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      alignment: Alignment.bottomCenter,
                      icon: Image.asset(
                        "assets/icons/menu.png",
                        color: Colors.white,
                        fit: BoxFit.cover,
                        height: 6.h,
                        width: 6.w,
                      ),
                    ),
                    Visibility(
                      visible: isAdmin,
                      child: IconButton(
                        onPressed: () => Navigator.pushNamed(
                            context, "/CUChannelScreen",
                            arguments: {
                              "type": "Create",
                              "channel": const Channel(
                                id: "",
                                title: "",
                                imageUrl: "",
                                videoUrl: "",
                              ),
                            }),
                        icon: Image.asset(
                          "assets/icons/plus.png",
                          color: Colors.white,
                          height: 6.h,
                          width: 6.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset("assets/images/dojtv.png"),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: StreamBuilder<QuerySnapshot>(
                  stream: channelProvider.getChannels(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'Something went wrong. Please contact the developer or admin for help',
                        style: TextStyle(
                            color: Colors.white54,
                            fontStyle: FontStyle.italic,
                            fontSize: 10.sp),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CustomProgressIndicator());
                    }

                    return GridView(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 50.w,
                        mainAxisExtent: 20.h,
                        mainAxisSpacing: 2.h,
                        crossAxisSpacing: 3.w,
                      ),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        Channel channel = Channel.fromJson(data);

                        return ChannelsTile(
                          channel: Channel(
                            id: channel.id,
                            title: channel.title,
                            imageUrl: channel.imageUrl,
                            videoUrl: channel.videoUrl,
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void getUserData() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.getUserDetails();

    setState(() {
      isAdmin = userProvider.checkIsAdmin();
    });
  }
}
