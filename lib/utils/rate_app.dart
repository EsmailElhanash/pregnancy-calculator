import 'package:flutter/widgets.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../constants.dart';

const title = 'تقييم التطبيق';
const message = 'إذا أعجبكِ التطبيق، يهمنا تقييمك';

void showRateMyApp(BuildContext context) {
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minLaunches: 7,
    remindDays: 5,
    remindLaunches: 10,
    googlePlayIdentifier: APP_ID,
  );
  rateMyApp.init().then((value) => {_showDialog(rateMyApp, context)});
}

void _showDialog(RateMyApp rateMyApp, context) {
  if (rateMyApp.shouldOpenDialog) {
    rateMyApp.showRateDialog(
      context,
      title: title,
      // The dialog title.
      message: message,
      // The dialog message.
      rateButton: 'التقييم',
      // The dialog "rate" button text.
      noButton: 'لا، شكراً',
      // The dialog "no" button text.
      laterButton: 'لاحقاً',
      // The dialog "later" button text.
      listener: (button) {
        // The button click listener (useful if you want to cancel the click event).
        switch (button) {
          case RateMyAppDialogButton.rate:
            print('Clicked on "Rate".');
            break;
          case RateMyAppDialogButton.later:
            print('Clicked on "Later".');
            break;
          case RateMyAppDialogButton.no:
            print('Clicked on "No".');
            break;
        }

        return true; // Return false if you want to cancel the click event.
      },
      // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
      dialogStyle: DialogStyle(),
      // Custom dialog styles.
      onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
          .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
      // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
      // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
    );
  }
}
