import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageDialog extends StatefulWidget {
  final Function(Locale) onConfirm;

  const LanguageDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<LanguageDialog> createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  Locale? _selectedLocale;

  final List<Map<String, dynamic>> _languages = [
    {'name': 'Русский', 'locale': const Locale('ru', 'RU')},
    {'name': 'Türkmençe', 'locale': const Locale('tm', 'TM')},
  ];

  @override
  void initState() {
    super.initState();
    _selectedLocale = Get.locale ?? const Locale('ru', 'RU');
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Text("choose_language".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((lang) {
              return RadioListTile<Locale>(
                title: Text(lang['name']),
                value: lang['locale'],
                groupValue: _selectedLocale,
                onChanged: (val) {
                  setState(() {
                    _selectedLocale = val;
                  });
                },
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: Text('cancel'.tr),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                if (_selectedLocale != null) {
                  widget.onConfirm(_selectedLocale!);
                }
                Navigator.pop(context);
              },
              child: Text('confirm'.tr),
            ),
          ],
        )
      ],
    );
  }
}
