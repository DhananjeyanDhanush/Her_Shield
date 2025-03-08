import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisteredContactsPage extends StatefulWidget {
  @override
  _RegisteredContactsPageState createState() => _RegisteredContactsPageState();
}

class _RegisteredContactsPageState extends State<RegisteredContactsPage> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  void _addOrEditContact({String? docId, String initialName = '', String initialPhone = ''}) {
    String name = initialName;
    String phone = initialPhone;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(docId == null ? "Add Emergency Contact" : "Edit Contact"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Name"),
                controller: TextEditingController(text: initialName),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: TextEditingController(text: initialPhone),
                onChanged: (value) => phone = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (name.isEmpty || phone.isEmpty || phone.length < 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid name and phone number")),
                  );
                  return;
                }

                var existingContacts = await _firestore.collection('contacts')
                    .where('phone', isEqualTo: phone)
                    .get();

                if (existingContacts.docs.isNotEmpty && docId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("This contact is already registered!")),
                  );
                  return;
                }

                if (docId == null) {
                  _firestore.collection('contacts').add({'name': name, 'phone': phone});
                } else {
                  _firestore.collection('contacts').doc(docId).update({'name': name, 'phone': phone});
                }
                Navigator.pop(context);
              },
              child: Text(docId == null ? "Save" : "Update"),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Contact"),
          content: Text("Are you sure you want to delete this contact?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _firestore.collection('contacts').doc(docId).delete();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.jpg', height: 40, width: 40, fit: BoxFit.cover),
            SizedBox(width: 10),
            Text("Registered Contacts"),
          ],
        ),
        backgroundColor: Colors.purple,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('contacts').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var contacts = snapshot.data!.docs;
            if (contacts.isEmpty) {
              return Center(
                child: Text("No emergency contacts added yet.", style: TextStyle(fontSize: 16)),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                var contact = contacts[index];
                var name = contact['name'];
                var phone = contact['phone'];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(Icons.contact_phone, color: Colors.purple),
                    title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(phone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _addOrEditContact(docId: contact.id, initialName: name, initialPhone: phone),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteContact(contact.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _addOrEditContact(),
        child: Icon(Icons.add, color: Colors.purple),
      ),
    );
  }
}
