import 'package:flutter/material.dart';

enum ValuePosition { center, right }

enum ProgressType { normal, valuable }

class ProgressDialog {
  /// [_progress] Listens to the value of progress.
  //  Not directly accessible.
  final ValueNotifier _progress = ValueNotifier(0);

  /// [_msg] Listens to the msg value.
  // Value assignment is done later.
  final ValueNotifier _msg = ValueNotifier('');

  /// [_dialogIsOpen] Shows whether the dialog is open.
  //  Not directly accessible.
  bool _dialogIsOpen = false;

  /// [_context] Required to show the alert.
  // Can only be accessed with the constructor.
  BuildContext _context;

  ProgressDialog({@required context}) {
    this._context = context;
  }

  //  Pass the new value to this method to update the status.
  //  Msg not required.
  void update({@required int value, String msg}) {
    _progress.value = value;
    if (msg != null) _msg.value = msg;
  }

  //  Closes the progress dialog.
  void close() {
    if (_dialogIsOpen) {
      Navigator.pop(_context);
      _dialogIsOpen = false;
    }
  }

  //  Returns whether the dialog box is open.
  bool isOpen() {
    return _dialogIsOpen;
  }

  _valueProgress({Color valueColor, Color bgColor, int value}) {
    return CircularProgressIndicator(
      backgroundColor: bgColor,
      valueColor: AlwaysStoppedAnimation<Color>(valueColor),
      value: value.toDouble() / 100,
    );
  }

  _normalProgress({Color valueColor, Color bgColor}) {
    return CircularProgressIndicator(
      backgroundColor: bgColor,
      valueColor: AlwaysStoppedAnimation<Color>(valueColor),
    );
  }

  /// [max] Assign the maximum value of the upload. @required
  //  Dialog closes automatically when its progress status equals the max value.

  /// [msg] Show a message @required

  /// [valuePosition] Location of progress value @not required
  // Center or right.  (Default: right)

  /// [progressType] Assign the progress bar type.
  // Normal or valuable.  (Default: normal)

  show({
    @required int max,
    @required String msg,
    ProgressType progressType: ProgressType.normal,
    ValuePosition valuePosition: ValuePosition.right,
    Color backgroundColor: Colors.white,
    Color barrierColor: Colors.transparent,
    Color progressValueColor: Colors.blueAccent,
    Color progressBgColor: Colors.blueGrey,
    Color valueColor: Colors.black87,
    Color msgColor: Colors.black87,
    FontWeight msqFontWeight: FontWeight.bold,
    FontWeight valueFontWeight: FontWeight.normal,
    double valueFontSize: 15.0,
    double msgFontSize: 17.0,
    double elevation: 5.0,
    bool barrierDismissible: false,
  }) {
    assert(max != null, 'max is null !');
    assert(msg != null, 'msg (message) is null !');

    _dialogIsOpen = true;
    _msg.value = msg;
    return showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      context: _context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        elevation: elevation,
        content: ValueListenableBuilder(
          valueListenable: _progress,
          builder: (BuildContext context, value, Widget child) {
            if (value == max) close();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 35.0,
                      height: 35.0,
                      child: progressType == ProgressType.normal
                          ? _normalProgress(
                              bgColor: progressBgColor,
                              valueColor: progressValueColor,
                            )
                          : value == 0
                              ? _normalProgress(
                                  bgColor: progressBgColor,
                                  valueColor: progressValueColor,
                                )
                              : _valueProgress(
                                  valueColor: progressValueColor,
                                  bgColor: progressBgColor,
                                  value: value,
                                ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: Text(
                        _msg.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: msgFontSize,
                            color: msgColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Align(
                  child: Text(
                    value <= 0 ? '' : '${_progress.value}/$max',
                    style: TextStyle(
                      fontSize: valueFontSize,
                      color: valueColor,
                      fontWeight: valueFontWeight,
                    ),
                  ),
                  alignment: valuePosition == ValuePosition.right
                      ? Alignment.bottomRight
                      : Alignment.bottomCenter,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
