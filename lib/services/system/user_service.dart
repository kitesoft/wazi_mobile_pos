import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/system/user_model.dart';
import 'package:wazi_mobile_pos/services/system/firestore_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

class UserService extends Model {
  AppState state;

  UserService(AppState state);

  UserModel _activeUser;

  UserModel get activeUser {
    return _activeUser;
  }

  Future<bool> saveUser(UserModel user) async {
    if (null != user) {
      await FireStoreService().writeObject(
          collectionName: "users",
          item: user.toJson(),
          merge: false,
          timeout: 5);
      this._activeUser = user;
      return true;
    }

    return false;
  }

  Future<bool> updateUser(UserModel user) async {
    if (null != user) {
      await FireStoreService().writeObject(
          id: user.id,
          collectionName: "users",
          item: user.toJson(),
          merge: true,
          timeout: 5);
      return true;
    }

    return false;
  }

  Future<UserModel> loadActiveUser(String userId) async {
    if (null != userId) {
      var result = await FireStoreService()
          .getObject("users", {"field": "userId", "value": userId});

      if (result != null) {
        var thisUser = UserModel.fromJson(result);
        this._activeUser = thisUser;
        return activeUser;
      } else
        return null;
    }
    return null;
  }

  void setActiveUser(UserModel user) {
    if (user != null) this._activeUser = user;
  }
}
