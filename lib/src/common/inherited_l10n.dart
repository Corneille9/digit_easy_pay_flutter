import 'package:digit_easy_pay_flutter/src/common/chat_l10n.dart';
import 'package:flutter/widgets.dart';

class InheritedL10n extends InheritedWidget {
  /// Creates [InheritedWidget] from a provided [ChatL10n] class
  const InheritedL10n({
    Key? key,
    required this.l10n,
    required Widget child,
  }) : super(key: key, child: child);

  /// Represents localized copy
  final L10n l10n;

  static InheritedL10n of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedL10n>()!;
  }

  @override
  bool updateShouldNotify(InheritedL10n oldWidget) =>
      l10n.hashCode != oldWidget.l10n.hashCode;
}
