import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/channel.dart';
import '../providers/channel_provider.dart';
import 'custom_progress_indicator.dart';

class ConfirmChannelDeleteDialog extends StatefulWidget {
  const ConfirmChannelDeleteDialog({
    super.key,
    required this.channel,
  });

  final Channel channel;

  @override
  State<ConfirmChannelDeleteDialog> createState() =>
      _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmChannelDeleteDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete channel?"),
      content: Text(
        "Before proceeding, would you like to confirm the deletion of the channel ${widget.channel.title}? This action is irreversible and will permanently remove all associated data.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        isLoading == true
            ? const CustomProgressIndicator()
            : TextButton(
                onPressed: deleteChannel,
                child: const Text("Confirm"),
              ),
      ],
    );
  }

  void deleteChannel() async {
    var channelProvider = Provider.of<ChannelProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    await channelProvider.deleteChannel(widget.channel).then(
          (value) => Navigator.pop(context),
        );
    setState(() {
      isLoading = false;
    });
  }
}
