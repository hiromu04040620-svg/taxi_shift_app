import 'package:flutter/material.dart';

Future<void> showNumberInputDialog({
  required BuildContext context,
  required String title,
  required int initialValue,
  required String suffixText,
  required ValueChanged<int> onSaved,
  String? Function(int)? validator,
}) async {
  final controller = TextEditingController(text: initialValue.toString());
  final formKey = GlobalKey<FormState>();

  final result = await showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(suffixText: suffixText),
            validator: (value) {
              if (value == null || value.isEmpty) return '値を入力してください';
              final parsed = int.tryParse(value);
              if (parsed == null) return '数値を入力してください';
              if (parsed < 0) return '0以上の数値を入力してください';
              if (validator != null) {
                return validator(parsed);
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(int.parse(controller.text));
              }
            },
            child: const Text('保存'),
          ),
        ],
      );
    },
  );

  if (result != null) {
    onSaved(result);
  }
}
