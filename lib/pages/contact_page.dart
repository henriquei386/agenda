import 'dart:io';

import 'package:agenda/helper/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  late final Contact? contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact? _editedContact;
  bool? _userEdited = false;

  final TextEditingController? _nameController = TextEditingController();
  final TextEditingController? _emailController = TextEditingController();
  final TextEditingController? _phoneController = TextEditingController();

  final FocusNode? _nameFocus = FocusNode();
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

  Future<bool> _requestPop() {
    if (_userEdited!) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Descartar alterações?'),
            content: Text('Ao sair as modificações serão perdidas.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Sim'),
              )
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future getImage() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _editedContact!.image = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact!.name ?? 'Novo contato'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: _editedContact!.image != null
                          ? FileImage(
                              File(_editedContact!.image!),
                            )
                          : AssetImage('assets/images/user.png')
                              as ImageProvider,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
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
          onPressed: () {
            if (_editedContact!.name != null &&
                _editedContact!.name!.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}
