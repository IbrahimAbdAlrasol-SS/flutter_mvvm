import 'package:app/common/widgets/app_field/app_input_field.dart';
import 'package:app/data/models/multi_lang_value.dart';
import 'package:app/utils/extensions.dart';
import 'package:flutter/material.dart';

export 'package:app/data/models/multi_lang_value.dart';

/// Two [AppInputField]s side-by-side (Arabic + English) that together produce
/// a [MultiLangValue].  Notify the parent of changes via [onChanged].
class AppMultiLangField extends StatefulWidget {
  const AppMultiLangField({
    super.key,
    this.label,
    this.value,
    this.onChanged,
    this.validator,
  });

  final String? label;
  final MultiLangValue? value;
  final ValueChanged<MultiLangValue>? onChanged;
  final String? Function(MultiLangValue?)? validator;

  @override
  State<AppMultiLangField> createState() => _AppMultiLangFieldState();
}

class _AppMultiLangFieldState extends State<AppMultiLangField> {
  late final TextEditingController _arCtrl;
  late final TextEditingController _enCtrl;

  @override
  void initState() {
    super.initState();
    _arCtrl = TextEditingController(text: widget.value?.ar ?? '');
    _enCtrl = TextEditingController(text: widget.value?.en ?? '');
  }

  @override
  void didUpdateWidget(AppMultiLangField old) {
    super.didUpdateWidget(old);
    if (widget.value?.ar != old.value?.ar && widget.value?.ar != _arCtrl.text) {
      _arCtrl.setTextSafely(widget.value?.ar ?? '');
    }
    if (widget.value?.en != old.value?.en && widget.value?.en != _enCtrl.text) {
      _enCtrl.setTextSafely(widget.value?.en ?? '');
    }
  }

  @override
  void dispose() {
    _arCtrl.dispose();
    _enCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    widget.onChanged?.call(
      MultiLangValue(ar: _arCtrl.text, en: _enCtrl.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.label!,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        Row(
          children: [
            Expanded(
              child: AppInputField(
                controller: _arCtrl,
                label: 'العربية',
                onChanged: (_) => _notify(),
                textInputAction: TextInputAction.next,
                validator: widget.validator != null
                    ? (_) => widget.validator!(
                          MultiLangValue(ar: _arCtrl.text, en: _enCtrl.text),
                        )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppInputField(
                controller: _enCtrl,
                label: 'English',
                onChanged: (_) => _notify(),
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
