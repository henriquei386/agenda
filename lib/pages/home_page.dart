import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agenda/helper/contact_helper.dart';
import 'package:agenda/pages/contact_page.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  // GetAllContacts
  _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list as List<Contact>;
      });
    });
  }

  // Show ContactPage
  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          contact: contact,
        ),
      ),
    );
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  // ShowOptions
  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          launch('tel:${contacts[index].phone}');
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Ligar',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                        child: Text(
                          'Editar',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          helper.deleteContact(contacts[index].id!);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'Excluir',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  // Contatos
  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contacts[index].image != null
                        ? FileImage(
                            File(contacts[index].image!),
                          )
                        : AssetImage('assets/images/user.png') as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email!,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      contacts[index].phone!,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        break;
      case OrderOptions.orderza:
        contacts.sort(
            (a, b) => b.name!.toLowerCase().compareTo(a.name!.toLowerCase()));
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            onSelected: _orderList,
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text(
                  'Ordernar de A-Z',
                ),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text(
                  'Ordernar de Z-A',
                ),
                value: OrderOptions.orderza,
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return _contactCard(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
