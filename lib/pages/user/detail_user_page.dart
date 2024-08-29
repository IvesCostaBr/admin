import 'dart:convert';
import 'package:core_dashboard/controllers/user.dart';
import 'package:core_dashboard/dtos/user.dart';
import 'package:core_dashboard/dtos/user/document.dart';
import 'package:core_dashboard/pages/user/sections/documents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserDetailController extends GetxController {
  // Define the current selected page
  var selectedPage = 'Payments'.obs;

  // Method to change the selected page
  void changePage(String page) {
    selectedPage.value = page;
  }
}



class UserDetailPage extends StatefulWidget {
  final UserDTO? userId = UserDTO.fromJson(Get.arguments["user"]);
  UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  // Initialize the controller
  final userService = Get.find<UserService>();
  final UserDetailController controller = Get.put(UserDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text("User Dashboard")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Expanded(
                flex: 2,
                child: Obx(() => Column(
                    children: [
                      Row(
                        children: [
                          if(widget.userId!.avatar != null)...[
                            CircleAvatar(
                              backgroundImage: MemoryImage(base64Decode(widget.userId!.avatar!)),
                            )
                          ]else...[
                            const CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.person, color: Colors.white, size: 40),
                            )
                          ],
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.userId!.name ?? '#', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(widget.userId!.email ?? '#', style: TextStyle(color: Colors.grey[700])),
                              const SizedBox(height: 8),
                              const SizedBox(
                                height: 8,
                              ),
                              const Text("EM ANALISE", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                              ElevatedButton(onPressed: () async {
                                await userService.changeUserStaus(widget.userId!.id, 2);
                                setState(() {
                                  
                                });
                              }, child: Text('Liberar'), style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.green)
                              ),)
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SidebarItem(
                        title: "Atividade",
                        icon: Icons.trending_up,
                        selected: controller.selectedPage.value == "Activity",
                        onTap: () => controller.changePage("Activity"),
                      ),
                      SidebarItem(
                        title: "Transações",
                        icon: Icons.bar_chart,
                        selected: controller.selectedPage.value == "Statistics",
                        onTap: () => controller.changePage("Statistics"),
                      ),
                      SidebarItem(
                        title: "Documentos",
                        icon: Icons.payment,
                        selected: controller.selectedPage.value == "Documents",
                        onTap: () => controller.changePage("Documents"),
                      ),
                      SidebarItem(
                        title: "Accessos",
                        icon: Icons.leaderboard,
                        selected: controller.selectedPage.value == "Leaderboard",
                        onTap: () => controller.changePage("Leaderboard"),
                      ),
                      SidebarItem(
                        title: "Anotações",
                        icon: Icons.campaign,
                        selected: controller.selectedPage.value == "Marketing",
                        onTap: () => controller.changePage("Marketing"),
                      ),
                      SidebarItem(
                        title: "Configurações",
                        icon: Icons.settings,
                        selected: controller.selectedPage.value == "Settings",
                        onTap: () => controller.changePage("Settings"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Main Content
            Expanded(
              flex: 6,
              child: Obx(() {
                switch (controller.selectedPage.value) {
                  case 'Activity':
                    return ActivitySection();
                  case 'Statistics':
                    return Text('');
                  case 'Documents':
                    return DocumentSection(userId: widget.userId!.id);
                  case 'Leaderboard':
                    return Text('');
                  case 'Marketing':
                    return Text('');
                  case 'Settings':
                    return Text('');
                  case 'Logout':
                    return Text('');
                  default:
                    return Text('');
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}



class ActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("Activity Section Content"),
    );
  }
}


class ConfigContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("Activity Section Content"),
    );
  }
}


class DocumentsConent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("documents Section Content"),
    );
  }
}


class TransactionsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text("Activity Section Content"),
    );
  }
}



class SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  SidebarItem({required this.title, required this.icon, this.selected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple[50] : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.deepPurple : Colors.grey[700]),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.deepPurple : Colors.grey[700],
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


