import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Tokens ───────────────────────────────────────────────────────────────────
//
// Philosophy: pure white canvas, one blue, two grays, hairline strokes.
// No shadows, no fills on cards — separation is done purely with spacing
// and a single 0.5px rule.

class T {
  // Color
  static const bg = Color(0xFFFFFFFF);
  static const blue = Color(0xFF007AFF);
  static const ink = Color(0xFF0A0A0A);
  static const muted = Color(0xFF8A8A8E);
  static const faint = Color(0xFFE8E8ED);

  // Status — all desaturated so they never shout
  static const statusNew = Color(0xFF34C759);
  static const statusReview = Color(0xFFFF9500);
  static const statusContacted = Color(0xFF8E8E93);

  // Type scale
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w300,
    color: ink,
    letterSpacing: -1.0,
    height: 1.05,
  );
  static const TextStyle title = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: ink,
    letterSpacing: -0.2,
  );
  static const TextStyle body = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: muted,
    letterSpacing: -0.1,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: muted,
    letterSpacing: 0.1,
  );
  static const TextStyle mono = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: blue,
    letterSpacing: -0.2,
    fontFamily: 'Courier',
  );
}

// ─── Data ─────────────────────────────────────────────────────────────────────

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeState();
// }

// class _HomeState extends State<HomeScreen> {
//   int _tab = 0; // 0=All 1=New 2=Review 3=Done
//   int? _open; // expanded row index
//   int _navIdx = 1; // bottom nav

//   List<Enquiry> get _visible {
//     switch (_tab) {
//       case 1:
//         return _data.where((e) => e.status == Status.newLead).toList();
//       case 2:
//         return _data.where((e) => e.status == Status.inReview).toList();
//       case 3:
//         return _data.where((e) => e.status == Status.contacted).toList();
//       default:
//         return _data;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: T.bg,
//       body: SafeArea(
//         bottom: false,
//         child: Column(children: [
//           _Header(total: _data.length),
//           const SizedBox(height: 20),
//           _Tabs(
//               selected: _tab,
//               onSelect: (i) => setState(() {
//                     _tab = i;
//                     _open = null;
//                   })),
//           const SizedBox(height: 4),
//           Expanded(
//               child: _List(
//             items: _visible,
//             open: _open,
//             onToggle: (i) => setState(() => _open = _open == i ? null : i),
//           )),
//         ]),
//       ),
//       bottomNavigationBar: _BottomNav(
//         selected: _navIdx,
//         onSelect: (i) => setState(() => _navIdx = i),
//       ),
//     );
//   }
// }

// // ─── Header ───────────────────────────────────────────────────────────────────

// class _Header extends StatelessWidget {
//   final int total;
//   const _Header({required this.total});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Distributorship', style: T.body),
//                 const SizedBox(height: 2),
//                 RichText(
//                   text: TextSpan(
//                     style: T.display,
//                     children: [
//                       const TextSpan(text: 'Enquiries'),
//                       TextSpan(
//                         text: '  $total',
//                         style: T.display.copyWith(
//                           color: T.blue,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Minimal icon button — no bg, no border
//           GestureDetector(
//             onTap: () {},
//             child: const Padding(
//               padding: EdgeInsets.all(4),
//               child: Icon(Icons.storefront_outlined, size: 22, color: T.muted),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Tab strip ────────────────────────────────────────────────────────────────
// // Just text — the active tab gets a thin blue underline, nothing else.

// class _Tabs extends StatelessWidget {
//   final int selected;
//   final void Function(int) onSelect;
//   const _Tabs({required this.selected, required this.onSelect});

//   static const _labels = ['All', 'New', 'In review', 'Contacted'];

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 36,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         itemCount: _labels.length,
//         itemBuilder: (_, i) => GestureDetector(
//           onTap: () => onSelect(i),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 180),
//             margin: const EdgeInsets.only(right: 24),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: i == selected ? T.blue : Colors.transparent,
//                   width: 1.5,
//                 ),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: Text(
//                 _labels[i],
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: i == selected ? FontWeight.w600 : FontWeight.w400,
//                   color: i == selected ? T.blue : T.muted,
//                   letterSpacing: -0.1,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── List ─────────────────────────────────────────────────────────────────────

// class _List extends StatelessWidget {
//   final List<Enquiry> items;
//   final int? open;
//   final void Function(int) onToggle;

//   const _List(
//       {required this.items, required this.open, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) {
//       return Center(
//         child: Text('Nothing here yet', style: T.body),
//       );
//     }
//     return ListView.separated(
//       padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
//       itemCount: items.length,
//       separatorBuilder: (_, __) => const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24),
//         child: Divider(height: 0, thickness: 0.5, color: T.faint),
//       ),
//       itemBuilder: (_, i) => _Row(
//         enquiry: items[i],
//         index: i,
//         isOpen: open == i,
//         onTap: () => onToggle(i),
//       ),
//     );
//   }
// }

// // ─── Row ──────────────────────────────────────────────────────────────────────

// class _Row extends StatelessWidget {
//   final Enquiry enquiry;
//   final int index;
//   final bool isOpen;
//   final VoidCallback onTap;

//   const _Row({
//     required this.enquiry,
//     required this.index,
//     required this.isOpen,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: onTap,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Collapsed row ────────────────────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//             child: Row(
//               children: [
//                 // Monogram — just text on white, framed by a very faint ring
//                 Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(color: T.faint, width: 1),
//                   ),
//                   child: Center(
//                     child: Text(
//                       enquiry.initials,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: T.ink,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 // Content
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(enquiry.brand,
//                                 style: T.title,
//                                 overflow: TextOverflow.ellipsis),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(enquiry.timeLabel, style: T.caption),
//                         ],
//                       ),
//                       const SizedBox(height: 3),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(enquiry.city,
//                                 style: T.body, overflow: TextOverflow.ellipsis),
//                           ),
//                           // Status: dot only — no pill, no bg
//                           Container(
//                             width: 5,
//                             height: 5,
//                             margin: const EdgeInsets.only(right: 5),
//                             decoration: BoxDecoration(
//                               color: enquiry.status.dot,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           Text(enquiry.status.label,
//                               style: T.caption.copyWith(
//                                 color: enquiry.status.dot,
//                               )),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 // Chevron
//                 AnimatedRotation(
//                   turns: isOpen ? 0.25 : 0,
//                   duration: const Duration(milliseconds: 200),
//                   child:
//                       const Icon(Icons.chevron_right, size: 16, color: T.muted),
//                 ),
//               ],
//             ),
//           ),

//           // ── Expanded detail ──────────────────────────────────────────────
//           AnimatedSize(
//             duration: const Duration(milliseconds: 220),
//             curve: Curves.easeInOut,
//             child: isOpen ? _Detail(enquiry: enquiry) : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Detail panel ─────────────────────────────────────────────────────────────

// class _Detail extends StatelessWidget {
//   final Enquiry enquiry;
//   const _Detail({required this.enquiry});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF9F9FB),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Contact fields ──────────────────────────────────────────────
//           if (enquiry.contact != null) ...[
//             _Field(
//               label: 'Contact',
//               value: enquiry.contact!,
//             ),
//             const SizedBox(height: 12),
//           ],
//           if (enquiry.phone != null) ...[
//             _Field(
//               label: 'Phone',
//               value: enquiry.phone!,
//               valueStyle: T.mono,
//             ),
//             const SizedBox(height: 12),
//           ],
//           if (enquiry.email != null) ...[
//             _Field(
//               label: 'Email',
//               value: enquiry.email!,
//               valueStyle: T.mono,
//             ),
//             const SizedBox(height: 12),
//           ],
//           _Field(label: 'Location', value: enquiry.city),
//           const SizedBox(height: 20),

//           // ── Actions — text buttons, no fill ────────────────────────────
//           Row(
//             children: [
//               if (enquiry.phone != null) ...[
//                 _GhostButton(
//                   icon: Icons.call_outlined,
//                   label: 'Call',
//                   onTap: () {},
//                 ),
//                 const SizedBox(width: 12),
//               ],
//               _GhostButton(
//                 icon: Icons.mail_outline_rounded,
//                 label: 'Email',
//                 onTap: () {},
//                 primary: false,
//               ),
//               const Spacer(),
//               // Mark as done — a single small solid pill
//               _PillButton(label: 'Mark done', onTap: () {}),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Field extends StatelessWidget {
//   final String label;
//   final String value;
//   final TextStyle? valueStyle;
//   const _Field({required this.label, required this.value, this.valueStyle});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 64,
//           child: Text(label, style: T.caption.copyWith(letterSpacing: 0)),
//         ),
//         Expanded(
//           child:
//               Text(value, style: valueStyle ?? T.body.copyWith(color: T.ink)),
//         ),
//       ],
//     );
//   }
// }

// class _GhostButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   final bool primary;
//   const _GhostButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//     this.primary = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = primary ? T.blue : T.muted;
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color),
//           const SizedBox(width: 5),
//           Text(label,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: color,
//                 letterSpacing: -0.1,
//               )),
//         ],
//       ),
//     );
//   }
// }

// class _PillButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//   const _PillButton({required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: T.ink,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           label,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//             letterSpacing: -0.1,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── Bottom nav ───────────────────────────────────────────────────────────────
// // Icons only. Active = blue. Inactive = muted. No labels, no bar bg color.

// class _BottomNav extends StatelessWidget {
//   final int selected;
//   final void Function(int) onSelect;

//   const _BottomNav({required this.selected, required this.onSelect});

//   static const _icons = [
//     (Icons.grid_view_outlined, Icons.grid_view_rounded),
//     (Icons.list_alt_outlined, Icons.list_alt_rounded),
//     (Icons.storefront_outlined, Icons.storefront_rounded),
//     (Icons.bar_chart_outlined, Icons.bar_chart_rounded),
//     (Icons.settings_outlined, Icons.settings_rounded),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: T.bg,
//         border: Border(top: BorderSide(color: T.faint, width: 0.5)),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: List.generate(_icons.length, (i) {
//               final active = i == selected;
//               return GestureDetector(
//                 onTap: () => onSelect(i),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 160),
//                   padding: const EdgeInsets.all(8),
//                   child: Icon(
//                     active ? _icons[i].$2 : _icons[i].$1,
//                     size: 22,
//                     color: active ? T.blue : T.muted,
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }
