import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/crud_service.dart';

class UserController extends GetxController {
  final users = <UserModel>[].obs;
  final loading = false.obs;

  late CrudService<UserModel> crudService;

  @override
  void onInit() {
    crudService = CrudService<UserModel>(
      endpoint: 'users', // 🔄 зөвхөн endpoint өгч байна
      fromJson: (json) => UserModel.fromJson(json),
    );
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    loading.value = true;
    try {
      final result = await crudService.getAll();
      users.assignAll(result);
    } catch (e) {
      Get.snackbar('Алдаа', e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> createUser(UserModel user) async {
    await crudService.create(user.toJson());
    fetchUsers();
  }

  Future<void> updateUser(String id, UserModel user) async {
    await crudService.update(id, user.toJson());
    fetchUsers();
  }

  Future<void> deleteUser(String id) async {
    await crudService.delete(id);
    fetchUsers();
  }
}
