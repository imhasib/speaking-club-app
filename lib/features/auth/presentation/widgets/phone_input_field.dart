import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Phone number input field with country code picker
class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final void Function(String fullNumber)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputAction textInputAction;
  final bool enabled;
  final FocusNode? focusNode;
  final String initialCountryCode;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.label = 'Mobile Number',
    this.hint,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.focusNode,
    this.initialCountryCode = 'BD',
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String _countryCode = '+880';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: (value) {
        widget.onChanged?.call('$_countryCode$value');
      },
      onFieldSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
      ],
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint ?? 'Enter your mobile number',
        prefixIcon: CountryCodePicker(
          onChanged: (country) {
            setState(() {
              _countryCode = country.dialCode ?? '+1';
            });
            final currentNumber = widget.controller.text;
            if (currentNumber.isNotEmpty) {
              widget.onChanged?.call('$_countryCode$currentNumber');
            }
          },
          initialSelection: widget.initialCountryCode,
          favorite: const ['US', 'GB', 'CA', 'AU', 'IN', 'BD'],
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
          padding: EdgeInsets.zero,
          textStyle: Theme.of(context).textTheme.bodyLarge,
          dialogTextStyle: Theme.of(context).textTheme.bodyMedium,
          searchStyle: Theme.of(context).textTheme.bodyMedium,
          dialogBackgroundColor: colorScheme.surface,
          barrierColor: Colors.black54,
          boxDecoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          flagWidth: 24,
          showFlag: true,
          showFlagMain: true,
          showFlagDialog: true,
        ),
      ),
    );
  }

  /// Get the full phone number including country code
  String get fullNumber => '$_countryCode${widget.controller.text}';
}
