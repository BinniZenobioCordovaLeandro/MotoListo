import 'package:url_launcher/url_launcher.dart';

openMap(latitud, longitud) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud';
  Uri uri = Uri.parse(googleUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not open the map.';
  }
}

openPhone(phone) async {
  String url = 'tel:$phone';
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not open the phone.';
  }
}

openWhatsApp(phone) async {
  String url = 'https://wa.me/$phone';
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not open WhatsApp.';
  }
}

openSettings() async {
  Uri uri = Uri.parse('app-settings:');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not open the settings.';
  }
}
