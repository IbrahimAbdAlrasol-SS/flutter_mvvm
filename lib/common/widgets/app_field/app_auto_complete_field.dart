import 'package:flutter/material.dart';

/// A generic dropdown/autocomplete field that fetches options asynchronously.
///
/// [optionsLoader] is called with the current search query and must return a
/// list of [AppSelectOption].  Results are cached until the query changes.
/// Setting [initialValue] pre-fills the display; the id is surfaced via
/// [onChanged].
class AppSelectOption {
  const AppSelectOption({required this.id, required this.label});

  final dynamic id;
  final String label;

  @override
  String toString() => label;
}

class AppAutoCompleteField extends StatefulWidget {
  const AppAutoCompleteField({
    super.key,
    this.label,
    this.hint,
    required this.optionsLoader,
    this.onChanged,
    this.initialValue,
    this.validator,
    this.enabled = true,
  });

  final String? label;
  final String? hint;

  /// Called with the current typed query; return matching [AppSelectOption]s.
  final Future<List<AppSelectOption>> Function(String query) optionsLoader;

  final ValueChanged<dynamic>? onChanged;
  final AppSelectOption? initialValue;
  final String? Function(AppSelectOption?)? validator;
  final bool enabled;

  @override
  State<AppAutoCompleteField> createState() => _AppAutoCompleteFieldState();
}

class _AppAutoCompleteFieldState extends State<AppAutoCompleteField> {
  AppSelectOption? _selected;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  void didUpdateWidget(AppAutoCompleteField old) {
    super.didUpdateWidget(old);
    if (widget.initialValue != old.initialValue && widget.initialValue != _selected) {
      setState(() => _selected = widget.initialValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Autocomplete<AppSelectOption>(
          displayStringForOption: (o) => o.label,
          initialValue: _selected != null ? TextEditingValue(text: _selected!.label) : null,
          optionsBuilder: (textEditingValue) async {
            if (!widget.enabled) return const [];
            if (_selected != null && textEditingValue.text == _selected!.label) {
              return const [];
            }
            return widget.optionsLoader(textEditingValue.text);
          },
          onSelected: (opt) {
            setState(() {
              _selected = opt;
              _validationError = null;
            });
            widget.onChanged?.call(opt.id);
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              enabled: widget.enabled,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) => widget.validator?.call(_selected),
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint ?? widget.label,
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: AlignmentDirectional.topStart,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240, maxWidth: 400),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final opt = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        title: Text(opt.label),
                        onTap: () => onSelected(opt),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
