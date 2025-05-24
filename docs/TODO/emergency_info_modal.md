🔄 Optional Enhancement
If you eventually want to wait for the modal to close before refreshing (e.g. to avoid jank if the modal takes time to open), then you can update showEmergencyInfoModal to return a Future:

In emergency_info_modal.dart:

Future<void> showEmergencyInfoModal(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog( ... ), // unchanged
  );
}

Then your original await showEmergencyInfoModal(context) would be valid again.

