import 'package:flutter/material.dart';

import '../util/extensions.dart';

typedef ToLabel = String Function(dynamic t);

class LabelledDropDown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final T? defaultValue;
  final List<T>? items;
  final bool withNull;
  final Function? onChanged;
  final bool disabled;
  final TextStyle? labelStyle;
  final ToLabel? toLabel;

  const LabelledDropDown(
      {super.key,
      this.value,
      this.defaultValue,
      this.items,
      this.onChanged,
      required this.label,
      this.labelStyle,
      this.disabled = false,
      this.withNull = false,
      this.toLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        if (label.isNotEmpty)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 8),
              child: Text(
                label,
                style: labelStyle,
              ),
            ),
          ),
        if (items != null)
          Expanded(
            flex: 3,
            child: Listener(
              onPointerDown: (_) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
              },
              child: DropdownButton<T>(
                key: key,
                focusNode: FocusNode(),
                value: value ?? defaultValue,
                icon: const Icon(
                  Icons.expand_more,
                ),
                iconSize: 16,
                elevation: 16,
                // style: TextStyle(color: Theme.of(context).indicatorColor),
                underline: Container(
                  height: 2,
                  color: Theme.of(context).indicatorColor,
                ),
                onChanged: disabled
                    ? null
                    : (T? newValue) {
                        if ((onChanged != null)) {
                          onChanged!(newValue);
                        }
                      },
                items: items!.map<DropdownMenuItem<T>>((T value) {
                  return DropdownMenuItem<T>(
                    value: value,
                    child: Text(
                        toLabel?.call(value) ?? enumName(value.toString())!,
                        overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
