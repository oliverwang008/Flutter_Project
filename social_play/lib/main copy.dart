import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Player Registration',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/play',
      routes: {
        '/play': (context) => PlayScreen(),
        '/register': (context) => RegisterScreen(),
        '/manage': (context) => ManageScreen(),
      },
    );
  }
}

class PlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text(
          'Welcome to the Play Page!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _grade = 'A+';
  String _membership = 'Guest';

  Future<void> _registerPlayer() async {
    await FirebaseFirestore.instance.collection('players').add({
      'name': _nameController.text,
      'grade': _grade,
      'membership': _membership,
    });
    _nameController.clear();
    setState(() {
      _grade = 'A+';
      _membership = 'Guest';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Player Registered!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              DropdownButton<String>(
                value: _grade,
                items: ['A+', 'A', 'B', 'B-', 'C', 'C-']
                    .map((grade) => DropdownMenuItem(
                          value: grade,
                          child: Text(grade),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _grade = value!;
                  });
                },
              ),
              DropdownButton<String>(
                value: _membership,
                items: ['Guest', 'Member']
                    .map((membership) => DropdownMenuItem(
                          value: membership,
                          child: Text(membership),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _membership = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _registerPlayer,
                child: Text('Register Player'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Player> _players = [];
  List<Player> _filteredPlayers = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterPlayers();
    });
  }

  Future<void> _fetchPlayers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('players').get();
    setState(() {
      _players = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Player(
            id: doc.id,
            name: data['name'],
            grade: data['grade'],
            membership: data['membership']);
      }).toList();
      _filteredPlayers = _players;
    });
  }

  void _filterPlayers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlayers = _players
          .where((player) => player.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Players'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search by Name'),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _fetchPlayers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: _filteredPlayers.length,
                  itemBuilder: (context, index) {
                    final player = _filteredPlayers[index];
                    return ListTile(
                      title: Text(player.name),
                      subtitle: Text(
                          'Grade: ${player.grade}, Membership: ${player.membership}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.app_registration),
            title: Text('Register'),
            onTap: () => Navigator.pushReplacementNamed(context, '/register'),
          ),
          ListTile(
            leading: Icon(Icons.play_arrow),
            title: Text('Play'),
            onTap: () => Navigator.pushReplacementNamed(context, '/play'),
          ),
          ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text('Manage'),
            onTap: () => Navigator.pushReplacementNamed(context, '/manage'),
          ),
        ],
      ),
    );
  }
}

class Player {
  String id;
  String name;
  String grade;
  String membership;

  Player(
      {required this.id,
      required this.name,
      required this.grade,
      required this.membership});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'grade': grade,
      'membership': membership,
    };
  }

  static Player fromMap(Map<String, dynamic> map, String id) {
    return Player(
      id: id,
      name: map['name'],
      grade: map['grade'],
      membership: map['membership'],
    );
  }
}
