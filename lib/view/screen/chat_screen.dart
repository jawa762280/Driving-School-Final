import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driving_school/controller/chat_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(),
      builder: (ctl) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(ctl.otherUser['image'] ??
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ctl.name ?? '',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                // أيقونة فيديو أو مكالمة صوتية مثلاً
              ],
            ),
          ),
          body: Stack(
            children: [
              // الخلفية بزخارف
              Positioned.fill(
                child: Image.asset(
                  'assets/images/chat_bg.png.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // الرسائل
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: ctl.scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: ctl.chatMessages.length,
                      itemBuilder: (_, i) {
                        final msg = ctl.chatMessages[i];
                        final isMe = ctl.isMe(msg);
                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: isMe
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.primaryColor,
                                          Color(0xFF6CA8F1)
                                        ],
                                      )
                                    : const LinearGradient(
                                        colors: [Colors.white, Colors.white70],
                                      ),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: Radius.circular(isMe ? 18 : 0),
                                  bottomRight: Radius.circular(isMe ? 0 : 18),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // محتوى الرسالة
                                  Text(
                                    msg['content'] ?? '',
                                    style: TextStyle(
                                      color:
                                          isMe ? Colors.white : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),

                                  // مسافة صغيرة  
                                  const SizedBox(height: 4),

                                  // توقيت الرسالة بخط صغير
                                  Text(
                                    ctl.formatTime(msg['created_at']?.toString()),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isMe
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),

                                  // علامة القراءة (فقط إذا الرسالة مني)
                                  if (isMe && msg['is_read'] == true)
                                    const Icon(
                                      Icons.done_all,
                                      size: 12,
                                      color: Colors.white70,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // حقل الإدخال
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.white,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: AppColors.primaryColor,
                          onPressed: ctl.openFiles,
                        ),
                        Expanded(
                          child: TextField(
                            controller: ctl.textController,
                            onTap: () {
                              ctl.bottomMargin = 0;
                              ctl.update();
                              Future.delayed(const Duration(milliseconds: 300),
                                  ctl.scrollToBottom);
                            },
                            decoration: InputDecoration(
                              hintText: 'اكتب رسالة...',
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Obx(() {
                          // إذا isSending true فالأيقونة معطّلة
                          return IconButton(
                            icon: ctl.isSending.value
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.green, strokeWidth: 2))
                                : const Icon(Icons.send),
                            color: AppColors.primaryColor,
                            onPressed: ctl.isSending.value
                                ? null
                                : () => ctl.sendMessage(),
                          );
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
