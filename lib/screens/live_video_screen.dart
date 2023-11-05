import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';
import 'package:sizer/sizer.dart';

import '../models/channel.dart';
import '../widgets/live_screen_app_bar_icon.dart';

class LiveVideoScreen extends StatefulWidget {
  static const routeName = "/LiveVideoScreen";

  const LiveVideoScreen({
    super.key,
  });

  @override
  State<LiveVideoScreen> createState() => _LiveVideoScreenState();
}

class _LiveVideoScreenState extends State<LiveVideoScreen> {
  Channel channel = const Channel(
    id: "0",
    imageUrl: "",
    title: "",
    videoUrl: "",
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    channel = ModalRoute.of(context)?.settings.arguments as Channel;
  }

  @override
  Widget build(BuildContext context) {
    // getting the theme data
    var of = Theme.of(context); // theme context
    var primaryColor = of.primaryColor; // the theme primary color

    return Scaffold(
      body: SafeArea(
        // using orientation builder to determine whether the device is in
        //landscape mode or portraite mode and change the ui dynamically
        child: OrientationBuilder(builder: (context, orientation) {
          // checking the device orientation here
          bool checkOrientation = orientation == Orientation.landscape;

          return Stack(
            alignment: Alignment.topLeft,
            children: [
              // video player widget
              Center(
                child: YoYoPlayer(
                  aspectRatio: 16 / 9,
                  url: channel.videoUrl,
                  videoStyle: const VideoStyle(
                    showLiveDirectButton: true,
                    fullscreenIcon: Text(''),
                    forwardIcon: Text(''),
                    backwardIcon: Text(''),
                    playIcon: Icon(Icons.play_arrow_rounded),
                    pauseIcon: Icon(Icons.pause_rounded),
                    allowScrubbing: false,
                    liveDirectButtonColor: Colors.red,
                  ),
                  videoLoadingStyle: VideoLoadingStyle(
                    loadingIndicatorValueColor: primaryColor,
                    loadingIndicatorBgColor: primaryColor.withOpacity(0.3),
                    loadingBackgroundColor: Colors.white10,
                    loadingTextStyle: const TextStyle(color: Colors.white),
                  ),
                  onCacheFileFailed: (error) => const Icon(
                    Icons.error_rounded,
                    color: Colors.red,
                  ),
                ),
              ),

              // the screen app bar holding the back button and the orientation
              //changer icons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // custom back button
                    LiveScreenAppBarIcon(
                      icon: Icons.arrow_back_rounded,
                      function: () => Navigator.pop(context),
                    ),

                    // orientation chnager buttons
                    checkOrientation //checking the current orientation
                        ?
                        // change orientation to portraite button
                        LiveScreenAppBarIcon(
                            function: () {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown
                              ]);
                            },
                            iconUrl: "assets/icons/shrink.png",
                          )
                        :
                        // change orientation to landscape button
                        LiveScreenAppBarIcon(
                            function: () {
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.landscapeLeft,
                                DeviceOrientation.landscapeRight
                              ]);
                            },
                            iconUrl: "assets/icons/expand.png",
                          ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
