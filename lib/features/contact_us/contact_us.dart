
import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
const ContactUsScreen({super.key});

@override
State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
Future<void> _launchUrl(String url) async {
final Uri uri = Uri.parse(url);

if (!await launchUrl(
uri,
mode: LaunchMode.externalApplication,
)) {
throw Exception('Could not launch $url');
}
}

@override
Widget build(BuildContext context) {
return AdaptiveScaffold(
//backgroundColor: const Color(0xFFF5F7FB),
body: CustomScrollView(
slivers: [
/// APPBAR
const CommonAppbar(
title: "Contact Us",
showNotification: false,
showBackButton: true,
),

/// BODY
SliverToBoxAdapter(
child: SafeArea(
child: Align(
alignment: Alignment.topCenter,
child: CommonSingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
/// HERO SECTION
Container(
width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [
AppColors.primary,
AppColors.primary.withOpacity(.8),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
borderRadius: BorderRadius.circular(28),
boxShadow: [
BoxShadow(
color: AppColors.primary.withOpacity(.25),
blurRadius: 20,
offset: const Offset(0, 10),
),
],
),
child: Column(
children: [
Container(
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: Colors.white.withOpacity(.15),
shape: BoxShape.circle,
),
child: const Icon(
Icons.support_agent_rounded,
color: Colors.white,
size: 50,
),
),
const SizedBox(height: 20),
CommonText(
"We're Here to Help",
textAlign: TextAlign.center,
style: TextStyleConstants.bold(
context,
fontSize: 28,
color: Colors.white,
),
),
const SizedBox(height: 10),
CommonText(
"Reach out to our support team anytime for assistance.",
textAlign: TextAlign.center,
style: TextStyleConstants.medium(
context,
fontSize: 16,
color: Colors.white.withOpacity(.9),
),
),
],
),
),

const SizedBox(height: 28),

/// VISIT US
buildSectionCard(
context,
title: "Visit Us",
icon: Icons.location_on_rounded,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
labelText(
context,
"Global Headquarters",
),

const SizedBox(height: 8),

bodyText(
context,
"Green Boulevard, Plot No. B-9/A,\n"
"6th Floor, Tower B,\n"
"Sector 62, Noida,\n"
"Uttar Pradesh - 201309, India",
),

const SizedBox(height: 20),

labelText(
context,
"Regional Offices for GCC & MENA",
),

const SizedBox(height: 8),

bodyText(
context,
"Unit No: 05-PF-CWC15,\n"
"Detached Retail 05,\n"
"Jumeirah Lakes Towers,\n"
"Dubai, United Arab Emirates",
),
],
),
),

const SizedBox(height: 22),

/// CALL US
buildSectionCard(
context,
title: "Call Us",
icon: Icons.call_rounded,
child: Column(
children: [
contactTile(
context,
icon: Icons.call,
title: "+91-120-4148742",
onTap: () {
_launchUrl("tel:+911204148742");
},
),

contactTile(
context,
icon: Icons.call,
title: "+91-120-4148743",
onTap: () {
_launchUrl("tel:+911204148743");
},
),

contactTile(
context,
icon: Icons.phone_android,
title: "+91-8595957412",
onTap: () {
_launchUrl("tel:+918595957412");
},
),

const SizedBox(height: 20),

/// WHATSAPP BUTTON
SizedBox(
width: double.infinity,
child: ElevatedButton(
onPressed: () {
_launchUrl(
"https://api.whatsapp.com/send?phone=+917303062414&text=Hi%2C%20I%27m%20looking%20to%20explore%20opportunities%20in%20the%20agro-commodities%20ecosystem.",
);
},
style: ElevatedButton.styleFrom(
backgroundColor:
const Color(0xFF25D366),
foregroundColor: Colors.white,
elevation: 0,
padding: const EdgeInsets.symmetric(
vertical: 16,
),
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(18),
),
),
child: Row(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
Image.asset(
ImgAssets.whatsappIcon,
height: 24,
width: 24,
),
const SizedBox(width: 12),
CommonText(
"Chat on WhatsApp",
style:
TextStyleConstants.semiBold(
context,
color: Colors.white,
fontSize: 16,
),
),
],
),
),
),
],
),
),

const SizedBox(height: 22),

/// EMAIL US
buildSectionCard(
context,
title: "Email Us",
icon: Icons.email_rounded,
child: Column(
children: [
contactTile(
context,
icon: Icons.mail_outline_rounded,
title: "info@tradologie.com",
onTap: () {
_launchUrl(
"mailto:info@tradologie.com",
);
},
),
],
),
),

const SizedBox(height: 40),
],
),
),
),
),
),
),
],
),
);
}

/// SECTION CARD
Widget buildSectionCard(
BuildContext context, {
required String title,
required IconData icon,
required Widget child,
}) {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(22),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(26),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(.05),
blurRadius: 24,
offset: const Offset(0, 10),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
/// TITLE ROW
Row(
children: [
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: AppColors.primary.withOpacity(.1),
borderRadius: BorderRadius.circular(14),
),
child: Icon(
icon,
color: AppColors.primary,
size: 24,
),
),

const SizedBox(width: 14),

CommonText(
title,
style: TextStyleConstants.bold(
context,
fontSize: 20,
),
),
],
),

const SizedBox(height: 22),

child,
],
),
);
}

/// CONTACT TILE
Widget contactTile(
BuildContext context, {
required IconData icon,
required String title,
required VoidCallback onTap,
}) {
return InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(18),
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 12),
child: Row(
children: [
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: AppColors.primary.withOpacity(.08),
borderRadius: BorderRadius.circular(14),
),
child: Icon(
icon,
color: AppColors.primary,
),
),

const SizedBox(width: 16),

Expanded(
child: CommonText(
title,
style: TextStyleConstants.medium(
context,
fontSize: 16,
),
),
),

Icon(
Icons.arrow_forward_ios_rounded,
size: 16,
color: Colors.grey.shade500,
),
],
),
),
);
}

/// LABEL TEXT
Widget labelText(BuildContext context, String text) {
return CommonText(
text,
style: TextStyleConstants.semiBold(
context,
fontSize: 16,
),
);
}

/// BODY TEXT
Widget bodyText(BuildContext context, String text) {
return CommonText(
text,
style: TextStyleConstants.medium(
context,
fontSize: 15,
color: Colors.black87,
),
);
}
}
