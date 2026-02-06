// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradologie_app/config/routes/app_router.dart';

// import '../../core/utils/app_colors.dart';
// import '../../core/utils/app_strings.dart';
// import '../../core/utils/constants.dart';
// import '../../config/routes/navigation_service.dart';

// class NotificationsService {
//   final SetTokenNotificationUsecase? setTokenNotificationUsecase;
//   final MakeSeenUsecase? makeSeenUsecase;
//   final NavigationService? navigationService;
//   final Future<void> Function(RemoteMessage)? handler;

//   final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   final AndroidInitializationSettings _initializationSettingsAndroid =
//       const AndroidInitializationSettings('@mipmap/icon_notification');

//   late FirebaseMessaging _fcm;
//   late NotificationDetails _platformChannelSpecifics;
//   late InitializationSettings _initializationSettings;
//   late SharedPreferences _sharedPreferences;

//   //! Create a [AndroidNotificationChannel] for heads up notifications
//   late AndroidNotificationChannel channel;

//   NotificationsService({
//     this.setTokenNotificationUsecase,
//     this.navigationService,
//     this.makeSeenUsecase,
//     this.handler,
//   });

//   setUpNotifications(bool isForeground) async {
//     _sharedPreferences = await SharedPreferences.getInstance();
//     channel = const AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//     );

//     if (isForeground) {
//       _fcm = FirebaseMessaging.instance;
//       //! Create an Android Notification Channel.
//       //!
//       //! We use this channel in the `AndroidManifest.xml` file to override the
//       //! default FCM channel to enable heads up notifications.
//       await _flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);

//       await _fcm.requestPermission(
//         alert: true,
//         sound: true,
//         badge: true,
//         announcement: false,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//       );

//       //! for heads up notifications in ios
//       await _fcm.setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       _fcm.subscribeToTopic('all');
//       FirebaseMessaging.onMessage.listen(
//         (RemoteMessage message) {
//           showLocaleNotification(message, true);
//         },
//       );

//       if (handler != null) {
//         FirebaseMessaging.onBackgroundMessage(handler!);
//       }

//       FirebaseMessaging.onMessageOpenedApp.listen((message) {
//         debugPrint("Notification Data: ${jsonEncode(message.data)}");
//         navigate(
//             notification:
//                 notification_model.NotificationDataModel.fromJsonPayload(
//                     message.data));
//         message.data.clear();
//       });

//       updateTokenNotification();
//     }

//     _platformChannelSpecifics = NotificationDetails(
//       android: AndroidNotificationDetails(
//         channel.id,
//         channel.name,
//         channelDescription: channel.description,
//         color: AppColors.primary,
//       ),
//     );

//     _initializationSettings = InitializationSettings(
//       android: _initializationSettingsAndroid,
//       iOS: const DarwinInitializationSettings(),
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       _initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//     );
//   }

//   showLocaleNotification(RemoteMessage message, bool isForeground) async {
//     await _sharedPreferences.reload();
//     final stringData = jsonEncode(message.data);
//     debugPrint(stringData);
//     if (_sharedPreferences.getBool(AppStrings.isNotifications) != false) {
//       final isEnglish = _sharedPreferences.getString(AppStrings.locale) ==
//           AppStrings.englishCode;
//       final jsonData = message.data;
//       final title =
//           isEnglish ? jsonData["title_en"] ?? "" : jsonData["title_ar"] ?? "";
//       final description = isEnglish
//           ? jsonData["content_en"] ?? ""
//           : jsonData["content_ar"] ?? "";
//       await _flutterLocalNotificationsPlugin.show(
//         0,
//         title,
//         description,
//         _platformChannelSpecifics,
//         payload: jsonEncode(jsonData),
//       );
//       if (isForeground) {
//         Future.delayed(const Duration(seconds: 5),
//             () => _flutterLocalNotificationsPlugin.cancel(0));
//       }
//     }
//   }

//   void onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     debugPrint("Notification Data: $payload");
//     if (payload != null) {
//       navigate(
//         notification: notification_model.NotificationDataModel.fromJsonPayload(
//           jsonDecode(payload),
//         ),
//       );
//     }
//   }

//   void onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     debugPrint("Notification Data: $payload");
//     if (payload != null) {
//       navigate(
//         notification: notification_model.NotificationDataModel.fromJsonPayload(
//           jsonDecode(payload),
//         ),
//       );
//     }
//   }

//   updateTokenNotification() {
//     FirebaseMessaging.instance.onTokenRefresh.listen(
//       (event) {
//         if (Constants.isLogin && setTokenNotificationUsecase != null) {
//           setTokenNotificationUsecase!(
//               SetTokenNotificationParams(token: event));
//         }
//       },
//     );
//   }

//   Future<String?> getToken() async {
//     return await _fcm.getToken();
//   }

//   navigate({required notification.NotificationData notification}) async {
//     if (navigationService != null) {
//       if (notification.id != 0 && !notification.notificationIsSeen) {
//         var ctx = navigationService!.navigationKey.currentContext;
//         if (ctx != null) {
//           BlocProvider.of<NotificationCubit>(ctx)
//               .makeSeen(MakeSeenParams(id: notification.id));
//         }
//       }
//       if (notification.entityId != 0) {
//         navigationService!.navigateTo(Routes.notificationsRoute);
//       }
//     }
//   }
// }
