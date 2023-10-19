import 'package:flutter/material.dart';

@immutable
abstract class L10n {
  /// Creates a new chat l10n based on provided copy
  const L10n({
    required this.attachmentButtonAccessibilityLabel,
    required this.emptyChatPlaceholder,
    required this.fileButtonAccessibilityLabel,
    required this.inputPlaceholder,
    required this.sendButtonAccessibilityLabel,
  });

  /// Accessibility label (hint) for the attachment button
  final String attachmentButtonAccessibilityLabel;

  /// Placeholder when there are no messages
  final String emptyChatPlaceholder;

  /// Accessibility label (hint) for the tap action on file message
  final String fileButtonAccessibilityLabel;

  /// Placeholder for the text field
  final String inputPlaceholder;

  /// Accessibility label (hint) for the send button
  final String sendButtonAccessibilityLabel;
}

@immutable
class L10nEn extends L10n {
  const L10nEn({
    String attachmentButtonAccessibilityLabel = 'Send media',
    String emptyChatPlaceholder = 'No messages here yet',
    String fileButtonAccessibilityLabel = 'File',
    String inputPlaceholder = 'Message',
    String sendButtonAccessibilityLabel = 'Send',
  }) : super(
          attachmentButtonAccessibilityLabel:
              attachmentButtonAccessibilityLabel,
          emptyChatPlaceholder: emptyChatPlaceholder,
          fileButtonAccessibilityLabel: fileButtonAccessibilityLabel,
          inputPlaceholder: inputPlaceholder,
          sendButtonAccessibilityLabel: sendButtonAccessibilityLabel,
        );
}

@immutable
class L10nFr extends L10n {
  const L10nFr({
    String attachmentButtonAccessibilityLabel = 'Envoyer un media',
    String emptyChatPlaceholder = 'Aucun message',
    String fileButtonAccessibilityLabel = 'Fichier',
    String inputPlaceholder = 'Message',
    String sendButtonAccessibilityLabel = 'Envoyer',
  }) : super(
    attachmentButtonAccessibilityLabel:
    attachmentButtonAccessibilityLabel,
    emptyChatPlaceholder: emptyChatPlaceholder,
    fileButtonAccessibilityLabel: fileButtonAccessibilityLabel,
    inputPlaceholder: inputPlaceholder,
    sendButtonAccessibilityLabel: sendButtonAccessibilityLabel,
  );
}