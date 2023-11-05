import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../helpers/snack_bar_helper.dart';
import '../models/channel.dart';
import '../providers/channel_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class CUChannelScreen extends StatefulWidget {
  static const routeName = "/CUChannelScreen";

  const CUChannelScreen({super.key});

  @override
  State<CUChannelScreen> createState() => _CUChannelScreenState();
}

class _CUChannelScreenState extends State<CUChannelScreen> {
  bool isLoading = false;
  bool checkType = false;

  Map<String, dynamic> args = {};

  Channel channel = const Channel(
    id: "id",
    title: "",
    imageUrl: "",
    videoUrl: "",
  );

  var titleController = TextEditingController();
  var videoUrlController = TextEditingController();
  var imageUrlController = TextEditingController();

  final titleNode = FocusNode();
  final videoUrlNode = FocusNode();
  final imageUrlNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    checkType = args["type"] == "Create";
    channel = args["channel"] as Channel;

    titleController = TextEditingController(text: channel.title);
    videoUrlController = TextEditingController(text: channel.videoUrl);
    imageUrlController = TextEditingController(text: channel.imageUrl);
  }

  @override
  void dispose() {
    super.dispose();

    titleController.dispose();
    videoUrlController.dispose();
    imageUrlController.dispose();

    titleNode.dispose();
    videoUrlNode.dispose();
    imageUrlNode.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          title: Text("${args["type"]} channel"),
          toolbarHeight: 50,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 2.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: titleController,
                          node: titleNode,
                          label: "Channel title",
                          textInputType: TextInputType.name,
                        ),
                        CustomTextField(
                          controller: imageUrlController,
                          node: imageUrlNode,
                          label: "Image url",
                          textInputType: TextInputType.url,
                        ),
                        CustomTextField(
                          controller: videoUrlController,
                          node: videoUrlNode,
                          label: "Video link",
                          textInputType: TextInputType.url,
                          inputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomButton(
                labelText: checkType ? "Create channel" : "Edit channel",
                function: checkType ? createChannel : updateChannel,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createChannel() async {
    var channelProvider = Provider.of<ChannelProvider>(context, listen: false);

    final isValid = _formKey.currentState!.validate();
    if (isValid == false) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });

      var response = await channelProvider.addChannel(
        Channel(
          id: "id",
          title: titleController.text.trim(),
          imageUrl: imageUrlController.text.trim(),
          videoUrl: videoUrlController.text.trim(),
        ),
      );

      if (response != true) {
        setState(() {
          isLoading = false;
        });

        CustomSnackBar.showCustomSnackBar(_scaffoldKey, response);
      } else {
        setState(() {
          isLoading = false;
        });

        titleController.clear();
        videoUrlController.clear();
        imageUrlController.clear();

        if (mounted) {
          CustomSnackBar.showCustomSnackBar(
            _scaffoldKey,
            "Channel created successfully",
            color: Colors.green,
          );
        }
      }
    }
  }

  void updateChannel() async {
    var channelProvider = Provider.of<ChannelProvider>(context, listen: false);

    final isValid = _formKey.currentState!.validate();
    if (isValid == false) {
      return;
    } else {
      setState(() {
        isLoading = true;
      });

      var response = await channelProvider.updateChannel(
        Channel(
          id: channel.id,
          title: titleController.text.trim(),
          imageUrl: imageUrlController.text.trim(),
          videoUrl: videoUrlController.text.trim(),
        ),
      );

      if (response != true) {
        setState(() {
          isLoading = false;
        });

        CustomSnackBar.showCustomSnackBar(_scaffoldKey, response);
      } else {
        setState(() {
          isLoading = false;
        });

        if (mounted) {
          CustomSnackBar.showCustomSnackBar(
            _scaffoldKey,
            "Channel updated successfully",
            color: Colors.green,
          );
        }
      }
    }
  }
}
