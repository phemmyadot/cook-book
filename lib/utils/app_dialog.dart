import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipiebook/utils/app_colors.dart';

enum AlertType {
  info,
  success,
  warning,
  error,
}

class RBDialog {
  static Widget getLoading(context, [String message = '']) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(
              color: RBColors.darkPrimary,
              size: 50.0,
            ),
            SizedBox(height: 10.0),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }

  static Future<void> showLoading(BuildContext context,
      [String message = '']) async {
    await Navigator.of(context).push(Loader(message));
  }

  static hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static Future showErrorDialog(BuildContext context, String error) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => ErrorAlertDialog(
        type: AlertType.error,
        confirmText: 'OK',
        message: error,
      ),
    );
  }

  static Future showSuccessDialog(BuildContext context, String message) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => ErrorAlertDialog(
        type: AlertType.success,
        confirmText: 'OK',
        message: message,
      ),
    );
  }

  static Future showConfirmDialog(BuildContext context,
      {String title, String message, Function onConfirm}) async {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => ErrorAlertDialog(
        title: title ?? 'Confirmation',
        type: AlertType.warning,
        message: message ?? 'Are you sure want to proceed?',
        showCancelButton: true,
        confirmText: 'Yes!',
        onConfirm: onConfirm,
      ),
    );
  }
}

class Loader extends ModalRoute<void> {
  final String message;
  Loader(this.message);
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFadingCircle(
            color: RBColors.darkPrimary,
            size: 50.0,
          ),
          SizedBox(height: 10.0),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class ErrorAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final AlertType type;
  final Function onConfirm;
  final Function onCancel;
  final bool showCancelButton;

  ErrorAlertDialog({
    this.title = '',
    this.message,
    this.confirmText = 'Ok',
    this.cancelText = 'Cancel',
    this.type = AlertType.info,
    this.onConfirm,
    this.onCancel,
    this.showCancelButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: RBColors.darkPrimary),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 5,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10.0),
          Icon(
            _getIcon(type),
            color: _getColor(type),
            size: 50,
          ),
          const SizedBox(height: 10.0),
          title.isNotEmpty
              ? Text(
                  title.isEmpty ? _getTitle(type) : title,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                )
              : Container(),
          Divider(),
          Flexible(
            child: Text(
              message ?? 'An error occured!',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    child: Text(
                      confirmText,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(5.0)),
                      elevation: MaterialStateProperty.all<double>(0.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (onConfirm != null) {
                        onConfirm();
                      }
                    },
                  ),
                ),
                if (showCancelButton)
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(5.0)),
                      ),
                      child: Text(cancelText),
                      onPressed: () {
                        Navigator.pop(context);
                        if (onCancel != null) {
                          onCancel();
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(AlertType type) {
    switch (type) {
      case AlertType.warning:
        return Colors.orange;
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.info:
      default:
        return Colors.blue;
    }
  }

  IconData _getIcon(AlertType type) {
    switch (type) {
      case AlertType.warning:
        return Icons.warning;
      case AlertType.success:
        return Icons.check_circle;
      case AlertType.error:
        return Icons.error;
      case AlertType.warning:
      default:
        return Icons.info_outline;
    }
  }

  String _getTitle(AlertType type) {
    switch (type) {
      case AlertType.warning:
        return 'Warning';
      case AlertType.success:
        return 'Success';
      case AlertType.error:
        return '';
      case AlertType.info:
      default:
        return '';
    }
  }
}
