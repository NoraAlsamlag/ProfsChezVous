import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/models/user_models.dart';

class UserCubit extends Cubit<User> {
  UserCubit(User initialState) : super(initialState);

  void updateUser(User user) {
    emit(user);
  }

  void updateUserDetails(UserDetails userDetails) {
    User updatedUser = state.copyWith(userDetails: userDetails);
    emit(updatedUser);
  }

  void updateUserImage(String imageUrl) {
    User updatedUser = state.copyWith(imageProfile: imageUrl);
    emit(updatedUser);
  }
}
