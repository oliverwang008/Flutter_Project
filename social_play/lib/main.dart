import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// In-memory list to hold registered players
//List<Player> playersList = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/play', // Set "Play" page as the initial route
      routes: {
        '/register': (context) => RegistrationScreen(),
        '/play': (context) => PlayScreen(),
        '/manage': (context) => ManageScreen(),
      },
    );
  }
}

// Model for Player
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

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedGrade;
  String? _selectedMembership;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('players').add({
        'name': _nameController.text,
        'grade': _selectedGrade,
        'membership': _selectedMembership,
      });
      _nameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Player registered successfully!')),
      );
      _nameController.clear();
      setState(() {
        _selectedGrade = null;
        _selectedMembership = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldWidth = screenWidth > 800 ? 600.0 : screenWidth * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register New Player'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Name',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                SizedBox(
                  width: fieldWidth,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: 'Enter your name'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter your name'
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                Text('Grade',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                SizedBox(
                  width: fieldWidth,
                  child: DropdownButtonFormField<String>(
                    value: _selectedGrade,
                    items: ['A+', 'A', 'B+', 'B', 'C+', 'C', 'C-'].map((grade) {
                      return DropdownMenuItem(value: grade, child: Text(grade));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedGrade = value),
                    validator: (value) =>
                        value == null ? 'Please select a grade' : null,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 20),
                Text('Membership',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                SizedBox(
                  width: fieldWidth,
                  child: DropdownButtonFormField<String>(
                    value: _selectedMembership,
                    items: ['Guest', 'Member'].map((membership) {
                      return DropdownMenuItem(
                          value: membership, child: Text(membership));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedMembership = value),
                    validator: (value) => value == null
                        ? 'Please select a membership type'
                        : null,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    minimumSize: Size(150, 50),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Register'),
                ),
              ],
            ),
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
  List<Player> _players = [];
  List<Player> _filteredPlayers = [];

  Player? _selectedPlayer;
  final _nameController = TextEditingController();
  String? _selectedGrade;
  String? _selectedMembership;
  String _searchQuery = '';
  Future? _playersFuture;

  @override
  void initState() {
    super.initState();
    _playersFuture = _fetchPlayers();
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

  void _editPlayer() {
    if (_selectedPlayer != null && _selectedPlayer!.name.isNotEmpty) {
      setState(() {
        _selectedPlayer!.name = _nameController.text;
        _selectedPlayer!.grade = _selectedGrade ?? _selectedPlayer!.grade;
        _selectedPlayer!.membership = _selectedMembership ?? _selectedPlayer!.membership;
        _updatePlayerInfo(_selectedPlayer!.id, toMap(_selectedPlayer!));
      });
    }
  }

  Map<String, dynamic> toMap(Player toMapPlayer) {
    return {
      'id': toMapPlayer.id,
      'name': toMapPlayer.name,
      'grade': toMapPlayer.grade,
      'membership': toMapPlayer.membership,
    };
  }

  Future<void> _updatePlayerInfo(
      String playerId, Map<String, dynamic> updatedData) async {
    try {
      // Reference to the player document in the 'players' collection
      await FirebaseFirestore.instance
          .collection('players')
          .doc(playerId)
          .update(updatedData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Player details updated')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update player in database')));
    }
  }

  void _selectPlayer(Player player) {
    setState(() {
      _selectedPlayer = player;
      _nameController.text = player.name;
      _selectedGrade = player.grade;
      _selectedMembership = player.membership;
    });
  }

  @override
  Widget build(BuildContext context) {
    _filteredPlayers = _players
        .where((player) =>
            player.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Players'),
      ),
      drawer: AppDrawer(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player List Section with Search Box
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Player by Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) => setState(() => _searchQuery = query),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: FutureBuilder(
                      future: _playersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            itemCount: _filteredPlayers.length,
                            itemBuilder: (context, index) {
                              final player = _filteredPlayers[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(player.name),
                                  subtitle: Text(
                                      'Grade: ${player.grade}, Membership: ${player.membership}'),
                                  onTap: () => _selectPlayer(player),
                                ),
                              );
                            },
                          );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(),
          // Player Edit Section
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _selectedPlayer == null
                  ? Center(
                      child: Text('Select a player to edit',
                          style: TextStyle(fontSize: 18)))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Edit Player Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedGrade,
                          items: ['A+', 'A', 'B+', 'B', 'C+', 'C', 'C-']
                              .map((grade) {
                            return DropdownMenuItem(
                                value: grade, child: Text(grade));
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedGrade = value),
                          decoration: InputDecoration(labelText: 'Grade'),
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedMembership,
                          items: ['Guest', 'Member'].map((membership) {
                            return DropdownMenuItem(
                                value: membership, child: Text(membership));
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => _selectedMembership = value),
                          decoration: InputDecoration(labelText: 'Membership'),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _editPlayer,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text('Save Changes'),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
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
