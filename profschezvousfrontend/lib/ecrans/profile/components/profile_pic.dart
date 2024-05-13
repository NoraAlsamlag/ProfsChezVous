import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:profschezvousfrontend/api/utilisateur/utilisateur_api.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';
import 'package:profschezvousfrontend/models/user_models.dart';

import '../../../constants.dart';

class ProfilePic extends StatelessWidget {
  ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    String? imageUrl = user.imageProfile ?? userDefaultImage;


    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('$domaine${imageUrl}'),
            backgroundColor: Colors.grey,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  pickAndUploadImage(user.id);
                },
                child: SvgPicture.asset(
                  "assets/icons/Camera Icon.svg",
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}