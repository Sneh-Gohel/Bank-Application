import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool showSuffixIcon;
  final VoidCallback onSuffixTap;
  final bool showPassword;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.keyboardType,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.showSuffixIcon = false,
    required this.onSuffixTap,
    this.showPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        obscuringCharacter: '*',
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFFCEC7BF),
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon, color: const Color(0xFFCEC7BF)),
          suffixIcon: showSuffixIcon
              ? GestureDetector(
                  child: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFFCEC7BF),
                  ),
                  onTap: onSuffixTap,
                )
              : controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFFCEC7BF)),
                      onPressed: () {
                        controller.clear();
                      },
                    )
                  : null,
          filled: true,
          fillColor: const Color(0xFF07161B),
          enabledBorder: OutlineInputBorder(
            // borderSide: const BorderSide(color: Color(0xFFCEC7BF)),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFCEC7BF)),
            borderRadius: BorderRadius.circular(20),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFFCEC7BF).withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
