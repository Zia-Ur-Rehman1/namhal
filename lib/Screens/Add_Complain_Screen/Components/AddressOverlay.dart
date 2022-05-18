import 'dart:async';

import 'package:namhal/providers/providers.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Address extends StatefulWidget {

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController addressController = TextEditingController();
  late OverlayEntry _overlayEntry;
  final List<String> _hostel = [];
  List<String> _filter = [];
  String serachText="";
  Timer? _debounce;
  final LayerLink _layerLink = LayerLink();


  @override
  void initState() {
    super.initState();
    //add to _hostel
    FirebaseFirestore.instance
        .collection('Address')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var f in snapshot.docs) {
        _hostel.add(f.get("address"));
      }
    });
    _filter = _hostel;
//removed listener from here

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
          Overlay.of(context)!.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy,
              bottom: offset.dy,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _filter.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Colors.grey.shade300,
                          title: Text(_filter[index].toString()),
                          onTap: () {
                            setState(() {
                              addressController.text = _filter[index];
                              Provider.of<add>(context, listen: false).address = _filter[index];
                              _focusNode.unfocus();
                            });
                          },
                        );
                      }),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        controller: addressController,
        focusNode: _focusNode,
        decoration: const InputDecoration(
          labelText: 'Address',

          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.home_outlined,size: 30,),
        ),
        onChanged: (value) {
          setState(() {
            if(_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer( const Duration(microseconds: 500), () {
            if(mounted) {
              setState(() {
                _filter = _hostel.where((hostel) =>
                    hostel.toLowerCase()
                        .replaceAll(RegExp(r'[^\w\\s]+'), '')
                        .contains(value.toLowerCase().replaceAll(
                        RegExp(r'[^\w\\s]+'), ''))).toList();
              });
            }
          });
          });
        },
      ),
    );
  }


  @override
  void dispose() {
    addressController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
