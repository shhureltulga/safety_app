import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import 'user_form_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(title: const Text('Хэрэглэгчид')),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => controller.deleteUser(user.id),
              ),
              onTap: () {
                Get.to(() => UserFormScreen(user: user));
              },
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const UserFormScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
