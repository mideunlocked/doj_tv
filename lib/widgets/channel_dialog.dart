import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../models/channel.dart';
import 'channels_tile.dart';
import 'confirm_channel_delete_dialog.dart';

class ChannelDialog extends StatelessWidget {
  const ChannelDialog({
    super.key,
    required this.channel,
  });

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          ChannelsTile(
            channel: channel,
            color: Colors.white60,
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_rounded),
                  title: const Text("Edit channel"),
                  onTap: () => Navigator.pushNamed(context, "/CUChannelScreen",
                      arguments: {
                        "type": "Update",
                        "channel": channel,
                      }),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_rounded),
                  title: const Text("Delete channel"),
                  onTap: () => showConfirmDeleteDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showConfirmDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmChannelDeleteDialog(
        channel: channel,
      ),
    );
  }
}
