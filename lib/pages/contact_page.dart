import 'dart:io';

import 'package:agenda/helper/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  late final Contact? contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact? _editedContact;
  bool _userEdited = false;

  final TextEditingController? _nameController = TextEditingController();
  final TextEditingController? _emailController = TextEditingController();
  final TextEditingController? _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      _nameController!.text = _editedContact!.name!;
      _emailController!.text = _editedContact!.email!;
      _phoneController!.text = _editedContact!.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedContact!.name ?? 'Novo contato'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editedContact!.image != null
                        ? FileImage(
                            File(_editedContact!.image!),
                          )
                        : AssetImage('assets/images/user.png') as ImageProvider,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
              ),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editedContact!.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'E-mail',
              ),
              onChanged: (text) {
                _userEdited = true;
                _editedContact!.email = text;
              },
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
              onChanged: (text) {
                _userEdited = true;
                _editedContact!.phone = text;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.save),
      ),
    );
  }
}
