


import 'dart:io';

import 'package:contact_list_app/models/contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> with TickerProviderStateMixin{

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _addToFavorites = false;
  bool _addToBlackList = false;
  final _name = TextEditingController();
  final _mobileNumber = TextEditingController();

  Future getImage() async {
    var img = await _picker.pickImage(source: ImageSource.gallery);
    setState(() => _image = img);
  }

  @override
  void initState() {
    super.initState();
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    var contact = Contact(
        imagePath: _image != null ? _image!.path : '',
        name: _name.text,
        mobileNumber: _mobileNumber.text,
        isBlocked: _addToBlackList,
        isFavorite: _addToFavorites,
        isArchived: false
    );

    Contact.save(contact)
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
            title: const Text('New Contact'),
        ),
        body: Form(
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
                      child: _image != null ? Image.file(
                        File(_image!.path),
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
                            child: Text(_image != null ? 'Change Photo' : 'Upload Photo')
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
                              autofocus: true,
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
                              setState(() => _addToFavorites = !_addToFavorites);
                            },
                            icon: Icon(_addToFavorites ? Icons.star : Icons.star_border_outlined),
                            label: Text(_addToFavorites ? 'Remove from favorites' : 'Add to favorites')
                        ),
                        TextButton.icon(
                            onPressed: (){
                              setState(() => _addToBlackList = !_addToBlackList);
                            },
                            icon: Icon(_addToBlackList ? Icons.lock : Icons.lock_open_outlined),
                            label: Text(_addToBlackList ? 'Remove from blacklist' : 'Add to blocklist')
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
              label: Text(_isLoading ? 'Loading...' : 'Submit'),
            )
        )
    );
  }
}