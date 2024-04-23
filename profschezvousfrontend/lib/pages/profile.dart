import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profschezvousfrontend/api/parent/parent_api.dart';
import 'package:profschezvousfrontend/models/user_cubit.dart';
import 'package:profschezvousfrontend/models/user_models.dart';

class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? parentInfo;

  @override
  void initState() {
    super.initState();
    getParentInfo();
  }

  Future<void> getParentInfo() async {
    var info = await ParentAPI.getParentInfo(widget.token);
    setState(() {
      parentInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: parentInfo != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                        'http://10.0.2.2:8000${user.image_profil}'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${parentInfo!['nom']} ${parentInfo!['prenom']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(
                      'Email: ${user.email}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text(
                      'Ville: ${parentInfo!['ville']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text(
                      'Adresse: ${parentInfo!['adresse']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text(
                      'Date de Naissance: ${parentInfo!['date_naissance']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(
                      'Numéro de Téléphone: ${parentInfo!['numero_telephone']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_pin),
                    title: Text(
                      'Quartier de Résidence: ${parentInfo!['quartier_résidence']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
