import 'package:course_dilaundry/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userListStatusProvider = StateProvider.autoDispose((ref) => '');

setUserListStatusProvider(WidgetRef ref, String newStatus) {
  ref.read(userListStatusProvider.notifier).state = newStatus;
}

final dropdownRole = StateProvider.autoDispose((ref) => '');

setDropdownRole(WidgetRef ref, String newStatus) {
  ref.read(dropdownRole.notifier).state = newStatus;
}

final userListProvider =
    StateNotifierProvider.autoDispose<UserList, List<UserModel>>(
        (ref) => UserList([]));

class UserList extends StateNotifier<List<UserModel>> {
  UserList(super.state);

  setData(List<UserModel> newData) {
    state = newData;
  }
}
