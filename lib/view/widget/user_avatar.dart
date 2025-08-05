import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = imageUrl.startsWith('http');

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: isNetworkImage && imageUrl.isNotEmpty
          ? NetworkImage(imageUrl)
          : const AssetImage('assets/images/default_user.png') as ImageProvider,
      onBackgroundImageError: (_, __) {
        debugPrint('خطأ في تحميل صورة المستخدم');
      },
    );
  }
}
