import 'package:flutter/material.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profil'),
            subtitle: Text('Kelola informasi profil Anda'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifikasi'),
            subtitle: Text('Atur preferensi notifikasi'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Keamanan'),
            subtitle: Text('Ubah kata sandi atau pengaturan keamanan lainnya'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/security');
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Bahasa'),
            subtitle: Text('Pilih bahasa aplikasi'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/language');
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Bantuan'),
            subtitle: Text('Pusat bantuan dan FAQ'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Tentang Aplikasi'),
            subtitle: Text('Informasi tentang aplikasi'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
