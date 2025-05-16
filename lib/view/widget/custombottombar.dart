// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomBottomBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const CustomBottomBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   // ignore: library_private_types_in_public_api
//   final List<_BottomBarItem> items = const [
//     _BottomBarItem(icon: Icons.receipt_long, label: "الطلبات"),
//     _BottomBarItem(icon: Icons.home, label: "الرئيسية"),
//     _BottomBarItem(icon: Icons.search, label: "البحث"),
//     _BottomBarItem(icon: Icons.person, label: "الملف الشخصي"),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(14.w),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 5),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               offset: Offset(0, -1),
//               blurRadius: 6,
//             )
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: List.generate(items.length, (index) {
//             final isSelected = index == currentIndex;
//             final item = items[index];

//             return InkWell(
//               onTap: () => onTap(index),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isSelected
//                           ? Colors.green.withAlpha((0.15 * 255).toInt())
//                           : Colors.grey.shade200,
//                     ),
//                     child: Icon(
//                       item.icon,
//                       size: 24,
//                       color: isSelected ? Colors.green : Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     item.label,
//                     style: TextStyle(
//                       color: isSelected ? Colors.green : Colors.grey,
//                       fontWeight:
//                           isSelected ? FontWeight.bold : FontWeight.normal,
//                       fontSize: 8,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

// class _BottomBarItem {
//   final IconData icon;
//   final String label;

//   const _BottomBarItem({required this.icon, required this.label});
// }
