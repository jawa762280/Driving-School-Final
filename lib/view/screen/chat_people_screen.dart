// lib/view/screen/chat_people_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/chat_people_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';
import 'package:driving_school/core/constant/approuts.dart';

class ChatPeopleScreen extends StatelessWidget {
  const ChatPeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatPeopleController>(
      init: ChatPeopleController(),
      builder: (ctl) {
        return Scaffold(
         appBar: AppBar(
  backgroundColor: AppColors.primaryColor,
  foregroundColor: Colors.white,
  title: Row(
    children: [
      const Text(
        "المحادثات",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const Spacer(),
      // هنا الحقل الجديد
      Obx(() {
        final total = ctl.totalUnread.value;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.message, size: 28, color: Colors.white),
              if (total > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'تحديث',
        onPressed: () async {
          await ctl.fetchTotalUnread();
          await ctl.getPeoples();
        },
      ),
    ],
  ),
),

          body: Column(
            children: [
              // شريط البحث
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: ctl.search,
                  onChanged: (_) => ctl.onSearch(),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "ابحث عن مستخدم أو رسالة...",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // قائمة المحادثات
              Expanded(
                child: ctl.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.green,
                      ))
                    : ctl.searchList.isEmpty
                        ? const Center(child: Text("لا توجد محادثات"))
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              indent: 80,
                            ),
                            itemCount: ctl.searchList.length,
                            itemBuilder: (_, i) {
                              final chat = ctl.searchList[i];
                              final other = ctl.getOtherUser(chat);
                              final lastMsg = ctl.getLastMessage(chat);
                              final unread = ctl.unreadCount(chat);

                              return ListTile(
                                onTap: () {
                                  final pplCtl =
                                      Get.find<ChatPeopleController>();

                                  Get.toNamed(AppRouts.chatScreen, arguments: {
                                    'conversation_id': chat['id'],
                                    'to_id': other['id'].toString(),
                                    'name': other['name'],
                                  })?.then((_) async {
                                    // المستخدم رجع من شاشة ChatScreen
                                    await pplCtl.fetchTotalUnread();
                                    await pplCtl.fetchUnreadByConversation();
                                    pplCtl.markConversationRead(chat['id']);

                                    // (هنا ليس ضرورياً مناداة update() لأن داخل fetchUnreadByConversation فعلنا update())
                                  });
                                },
                                leading: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                        other['image'] ??
                                            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                                      ),
                                    ),
                                    if (other['online'] == true)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                title: Text(
                                  other['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  lastMsg,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (ctl.isLastMessageMine(chat)) ...[
                                      Icon(Icons.done,
                                          size: 20,
                                          color: AppColors.primaryColor),
                                      const SizedBox(height: 4),
                                    ],
                                    Text(
                                      ctl.formatTime(
                                          ctl.getLastMessageTime(chat)),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                    ),
                                    if (unread > 0)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          unread.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}
