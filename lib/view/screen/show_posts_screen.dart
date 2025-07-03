import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:driving_school/controller/show_posts_controller.dart';
import 'package:driving_school/core/constant/appcolors.dart';

class ShowPostsScreen extends StatelessWidget {
  const ShowPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShowPostsController>(
      init: ShowPostsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          appBar: AppBar(
            title: const Text("المدونة", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: AppColors.primaryColor,
            elevation: 2,
            foregroundColor: Colors.white,
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // 🔍 الفلترة
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: ToggleButtons(
                        borderRadius: BorderRadius.circular(12),
                        borderColor: AppColors.primaryColor,
                        selectedBorderColor: AppColors.primaryColor,
                        fillColor: AppColors.primaryColor.withOpacity(0.15),
                        selectedColor: AppColors.primaryColor,
                        color: Colors.grey.shade600,
                        isSelected: List.generate(
                          controller.filterTypes.length,
                          (i) => i == controller.selectedFilterIndex,
                        ),
                        onPressed: (index) {
                          controller.setFilterByIndex(index);
                        },
                        children: controller.filterTypes
                            .map((label) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(label),
                                ))
                            .toList(),
                      ),
                    ),

                    // 📰 البوستات
                    Expanded(
                      child: controller.filteredPosts.isEmpty
                          ? const Center(child: Text("لا توجد منشورات"))
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: controller.filteredPosts.length,
                              itemBuilder: (context, index) {
                                final post = controller.filteredPosts[index];
                                final file = post['files'].isNotEmpty
                                    ? post['files'][0]
                                    : null;

                                final formattedDate =
                                    DateFormat('yyyy/MM/dd - HH:mm').format(
                                        DateTime.parse(post['created_at']));

                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  elevation: 5,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Header
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  AppColors.primaryColor,
                                              child: Icon(Icons.person,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    post['author']['name'] ??
                                                        '',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),

                                        // Title & Body
                                        Text(
                                          post['title'] ?? '',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          post['body'] ?? '',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 12),

                                        // File display
                                        if (file != null) ...[
                                          file['type'] == 'image'
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    file['url'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.picture_as_pdf,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                    file['name'],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () async {
                                                    await controller
                                                        .openPdfFile(
                                                            file['url'],
                                                            file['name']);
                                                  },
                                                ),
                                        ],

                                        const SizedBox(height: 10),

                                        // Likes
                                        GestureDetector(
                                          onTap: () => controller.toggleLike(
                                              post['id'], index),
                                          onLongPress: () => controller
                                              .showLikedStudentsDialog(
                                                  context, post['id']),
                                          child: Icon(
                                            post['liked_by_auth_user'] == true
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: post['liked_by_auth_user'] ==
                                                    true
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text("${post['likes_count']} إعجاب"),
                                      ],
                                    ),
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
