import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/channel.dart';

class ChannelProvider with ChangeNotifier {
  FirebaseFirestore cloudInstance = FirebaseFirestore.instance;

  final List<Channel> _channels = [];

  List<Channel> get channels {
    return [..._channels];
  }

  Future<dynamic> addChannel(Channel channel) async {
    try {
      var channelsCollection = cloudInstance.collection("channels");

      channelsCollection.add(channel.toJson()).then((value) {
        channelsCollection.doc(value.id).update(
          {
            "id": value.id,
          },
        );
      });

      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      print("Add channel error: $e");
      return Future.error(e);
    }
  }

  Stream<QuerySnapshot> getChannels() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
          cloudInstance.collection("channels").snapshots();

      return querySnapshot;
    } catch (e) {
      notifyListeners();
      print("Get channels error: $e");
      return Stream.error(e);
    }
  }

  Future<dynamic> updateChannel(Channel channel) async {
    try {
      var channelsCollection = cloudInstance.collection("channels");

      channelsCollection.doc(channel.id).update(channel.toJson());

      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      print("Update channel error: $e");
      return Future.error(e);
    }
  }

  Future<dynamic> deleteChannel(Channel channel) async {
    try {
      var channelsCollection = cloudInstance.collection("channels");

      channelsCollection.doc(channel.id).delete();

      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      print("Delete channel error: $e");
      return Future.error(e);
    }
  }
}
