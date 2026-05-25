import 'package:flutter/material.dart';

/// Tracks when another route covers an admin chat screen (e.g. push notification).
final RouteObserver<ModalRoute<void>> adminChatRouteObserver =
    RouteObserver<ModalRoute<void>>();
