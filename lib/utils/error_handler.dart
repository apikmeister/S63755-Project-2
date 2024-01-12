import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandler({
  required http.Response res,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (res.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            errorSnackBar('Error ${jsonDecode(res.body)['message']}'));
      break;
    case 401:
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            errorSnackBar('Error ${jsonDecode(res.body)['message']}'));
      break;
    case 403:
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            errorSnackBar('Error ${jsonDecode(res.body)['message']}'));
      break;
    case 404:
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            errorSnackBar('Error ${jsonDecode(res.body)['message']}'));
      break;
    case 500:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error ${jsonDecode(res.body)['message']}'),
        ),
      );
      break;
    default:
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            errorSnackBar('Error ${jsonDecode(res.body)['message']}'));
  }
}

SnackBar errorSnackBar(String message) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Oh Snap!',
      message: message,
      contentType: ContentType.failure,
    ),
  );
}

SnackBar successSnackBar(String message) {
  return SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Success!',
      message: message,
      contentType: ContentType.success,
    ),
  );
}
