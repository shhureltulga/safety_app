import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final controller = Get.find<UserController>();

  @override
  void initState() {
    if (widget.user != null) {
      nameController.text = widget.user!.name;
      emailController.text = widget.user!.email;
    }
    super.initState();
  }

  void saveUser() {
    final user = UserModel(
      id: widget.user?.id ?? '',
      name: nameController.text,
      email: emailController.text,
    );

    if (widget.user == null) {
      controller.createUser(user);
    } else {
      controller.updateUser(user.id, user);
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user == null ? '
