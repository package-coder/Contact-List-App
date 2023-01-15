


import 'dart:io';

import 'package:contact_list_app/models/contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class ContactItemScreen extends StatefulWidget {
  const ContactItemScreen({Key? key}) : super(key: key);

  @override
  State<ContactItemScreen> createState() => _ContactItemScreenState();
}

class _ContactItemScreenState extends State<ContactItemScreen> with TickerProviderStateMixin{

  Contact? _contact;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFavorite = false;
  bool _isBlocked = false;
  bool  _isArchived = false;
  final _name = TextEditingController();
  final _mobileNumber = TextEditingController();

  Future getImage() async {
    var img = await _picker.pickImage(source: ImageSource.gallery);
    setState(() => _image = img);
  }

  @override
  void initState() {
    super.initState();
    var args = Modular.args;
    getData(int.parse(args.params['id']));
  }

  void getData(int id) {
    setState(() => _isLoading = true);
    Contact.getContactById(id)
      .then((value) => {
        setState(() {
          _contact = value;
          if(value != null) {
            _name.text = value.name;
            _mobileNumber.text = value.mobileNumber;
            _isFavorite = value.isFavorite;
            _isBlocked = value.isBlocked;
            _isArchived = value.isArchived;
          }
        })
      }).catchError((error) => print(error))
        .whenComplete(() => setState(() => _isLoading = false));
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    var contact = {
      'imagePath': _image != null
          ? _image!.path
          : _contact?.imagePath != ''
          ? _contact!.imagePath : '',
      'name': _name.text,
      'mobileNumber': _mobileNumber.text,
      'isBlocked': _isBlocked ? 1 : 0,
      'isFavorite': _isFavorite ? 1 : 0,
      'isArchived': _isArchived ? 1 : 0
    };

    Contact.findIdAndUpdate(_contact!.id, contact)
        .then((value) => Modular.to.pop(true))
        .catchError((error) => print(error))
        .whenComplete(() => setState(() => _isLoading = false));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => {
              Modular.to.pop()
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Update Contact'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _contact == null
            ? const Center(child: Text('Contact not found'))
            : Form(
            key: _formKey,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(height: 32.0),
                    Container(
                      decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                          border: Border.all(
                              color: Colors.grey.shade300
                          )
                      ),
                      clipBehavior: Clip.hardEdge,
                      height: 150,
                      child: (_contact != null && _contact?.imagePath != '')
                          || (_image != null && _image?.path != '') ? Image.file(
                        File(_image == null ? _contact!.imagePath : _image!.path),
                        fit: BoxFit.cover,
                      ) : null,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              getImage();
                            },
                            child: Text(_contact?.imagePath != '' || _image != null ? 'Change Photo' : 'Upload Photo')
                        ),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextFormField(
                              validator: (value) {
                                if (!(value == null || value.isEmpty)) {
                                  return null;
                                }
                                return 'This field is required';
                              },
                              keyboardType: TextInputType.name,
                              controller: _name,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextFormField(
                              validator:  (value) {
                                if(value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                if(value.length != 11){
                                  return 'Mobile number\'s length must exact 11';
                                }
                                if(!value.startsWith('09')){
                                  return 'Mobile number must start with 09';
                                }

                                return null;
                              },
                              controller: _mobileNumber,
                              keyboardType: TextInputType.number,
                              maxLength: 11,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                  hintText: '+63',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade300
                                  )
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                            onPressed: (){
                              setState(() => _isFavorite = !_isFavorite);
                            },
                            icon: Icon(_isFavorite ? Icons.star : Icons.star_border_outlined),
                            label: Text(_isFavorite ? 'Remove from favorites' : 'Add to favorites')
                        ),
                        TextButton.icon(
                            onPressed: (){
                              setState(() => _isBlocked = !_isBlocked);
                            },
                            icon: Icon(_isBlocked ? Icons.lock : Icons.lock_open_outlined),
                            label: Text(_isBlocked ? 'Remove from blacklist' : 'Add to blocklist')
                        ),
                        TextButton.icon(
                            onPressed: (){
                              setState(() => _isArchived = !_isArchived);
                            },
                            icon: Icon(_isArchived ? Icons.archive : Icons.archive_outlined),
                            label: Text(_isArchived ? 'Remove from archive' : 'Move to archive')
                        )
                      ],
                    )
                  ],
                )
            )
        ),
        bottomNavigationBar: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _onSubmit,
              icon: _isLoading
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
                  : const Icon(null, size: 0),
              label: Text(_isLoading ? 'Loading...' : 'Update'),
            )
        )
    );
  }
}