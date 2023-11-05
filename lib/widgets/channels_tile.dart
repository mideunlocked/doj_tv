import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../models/channel.dart';
import '../providers/user_provider.dart';
import 'channel_dialog.dart';
import 'custom_progress_indicator.dart';

class ChannelsTile extends StatelessWidget {
  const ChannelsTile({
    super.key,
    required this.channel,
    this.color = Colors.white12,
  });

  final Channel channel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var height = 12.h;
    var width = 100.w;

    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      return InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          "/LiveVideoScreen",
          arguments: channel,
        ),
        onLongPress: () =>
            userProvider.checkIsAdmin() ? showChannelDialog(context) : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 1.h,
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  channel.imageUrl,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: height,
                      width: width,
                      child: const CustomProgressIndicator(),
                    );
                  },
                  errorBuilder: (ctx, _, stacktrace) {
                    return Image.asset(
                      "assets/images/dojtv.png",
                      height: height,
                      width: width,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                channel.title,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  void showChannelDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => ChannelDialog(
        channel: channel,
      ),
    );
  }
}
