import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({super.key, required this.title, this.hintText, this.prefixIcon});

  final String title;
  final String? hintText;
  final IconData? prefixIcon;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: const Color(0xFF322170),
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: const Color(0xFFD4D1D1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: const Color(0xFFD4D1D1)),
              ),
              fillColor: const Color(0xFFE9E3E3),
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
              prefixIcon: Icon(
                prefixIcon,
                size: 18,
                color: Colors.grey,
              )),
        )
      ],
    );
  }
}
