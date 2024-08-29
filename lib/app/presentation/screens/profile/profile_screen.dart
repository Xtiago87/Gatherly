import 'package:flutter/material.dart';



class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'John Doe';
  String userEmail = 'john.doe@example.com';
  String userPhotoUrl = 'https://via.placeholder.com/150';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Lógica de logout
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildGradientBackground(),
          Column(
            children: [
              _buildProfileHeader(),
              Expanded(
                child: _buildProfileDetails(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blueAccent.shade700,
            Colors.lightBlueAccent.shade100,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(userPhotoUrl),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: InkWell(
                  onTap: () {
                    // Lógica para editar a foto de perfil
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.blueAccent.shade700,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            userName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileDetailTile(
            icon: Icons.person,
            title: 'Nome',
            value: userName,
            onTap: () {
              // Lógica para editar o nome
            },
          ),
          _buildProfileDetailTile(
            icon: Icons.email,
            title: 'Email',
            value: userEmail,
            onTap: () {
              // Lógica para editar o email
            },
          ),
          _buildProfileDetailTile(
            icon: Icons.settings,
            title: 'Preferências',
            value: '',
            onTap: () {
              // Lógica para editar preferências
            },
            isArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    bool isArrow = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blueAccent.shade100,
        child: Icon(
          icon,
          color: Colors.blueAccent.shade700,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: value.isNotEmpty ? Text(value) : null,
      trailing: isArrow ? Icon(Icons.arrow_forward_ios) : Icon(Icons.edit),
      onTap: onTap,
    );
  }
}
