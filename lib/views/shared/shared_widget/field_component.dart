import 'package:flutter/material.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_color.dart';
import 'package:smart_home_application/views/shared/shared_theme/shared_fonts.dart';

enum Fieldtype {password,email,text}
   
 
class FieldModel {
 final String ?labelText;
 final String hinttext;
  final IconData? icons;
  final TextInputType?type;
  TextEditingController? controller;
   bool? isSecure ;
  final Fieldtype? fieldtype;
  bool ?  enabled;
  final Key? key;
  Function? onsubmit =  () {};


  FieldModel(
    {this.labelText ='' ,this.hinttext ='', this.icons,this.type,this.controller,
    this.isSecure= false,
    this.fieldtype = Fieldtype.text,
    this.enabled = true,
    this.key,
    this.onsubmit
    });
}



class customefield extends StatefulWidget {
  final FieldModel model;
  const customefield(this.model,{super.key});

  @override
  State<customefield> createState() => _customefieldState();
}

class _customefieldState extends State<customefield> {
  @override
  Widget build(BuildContext context) {
    // print(widget.model.fieldtype.toString().split('.')[1]== 'text');
    print(widget.model.fieldtype == Fieldtype.password);
    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        key: widget.model.key,
                        validator: (x) {
                          if(x!.isEmpty ) {
                            return 'this field required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border:filedborder(sharedcolors.whitecolor),
                          errorBorder: filedborder(sharedcolors.bluecolor),
                          focusedBorder: filedborder(sharedcolors.blackcolor),
                          focusedErrorBorder: filedborder(sharedcolors.bluecolor),
                          disabledBorder: filedborder(Colors.transparent),
                          prefixIcon: Icon(widget.model.icons,color: sharedcolors.blackcolor),
                          hintText: widget.model.hinttext,
                          labelStyle: sharedfonts.primarylime,
                          suffixIcon: widget.model.fieldtype ==Fieldtype.password?
                          IconButton(
                            icon: const Icon(Icons.remove_red_eye),
                            color: sharedcolors.bluecolor,
                            iconSize: 25,
                            onPressed: () {
                              setState(() {
                                widget.model.isSecure = !widget.model.isSecure!;
                              });
                            },
                          ): null
                          
                        ),
                        keyboardType: widget.model.type,
                      controller: widget.model.controller,
                        textInputAction: TextInputAction.done,
                        obscureText: widget.model.isSecure!,
                        enabled: widget.model.enabled,
                        onFieldSubmitted:
                        (x)
                        {
                          widget.model.onsubmit!();
                        },
                      ),
                    );
  }
}

OutlineInputBorder filedborder(Color color) {
 return OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: const BorderSide(color: sharedcolors.blackcolor,width:5)
 );
  }