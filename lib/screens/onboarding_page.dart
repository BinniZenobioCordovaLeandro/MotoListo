import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class OnboardingPage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  registerVehicle(Map<String, dynamic> data) async {
    FirebaseMessaging.instance.requestPermission();

    return FirebaseFirestore.instance
        .collection('vehicles')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'full_name': data['full_name'],
      'dni': data['dni'],
      'plate': data['plate'],
      'license_number': data['license_number'],
      'soat_end_date': data['soat_end_date'],
      'available': true,
      'position': GeoPoint(0, 0),
      'token': await FirebaseMessaging.instance.getToken(),
      'privacy_policy_accepted': false,
      'cost_accepeted': false,
      'admittance_reserve_accepted': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completa los datos para\nser MotoTaxista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              FormBuilderTextField(
                name: 'full_name',
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                name: 'dni',
                decoration: InputDecoration(
                  labelText: 'DNI',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
              ),
              FormBuilderTextField(
                name: 'plate',
                decoration: InputDecoration(
                  labelText: 'Placa',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderTextField(
                name: 'license_number',
                decoration: InputDecoration(
                  labelText: 'Número de Licencia',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderDateTimePicker(
                name: 'soat_end_date',
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: 'Fecha Final de SOAT',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              FormBuilderCheckbox(
                name: 'privacy_policy_accepted',
                title: Text('''Acepto la política de privacidad y los
términos de uso de la aplicación MotoListo.'''),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.equal(true),
                ]),
              ),
              FormBuilderCheckbox(
                name: 'cost_accepeted',
                title:
                    Text('''Acepto el costo del uso de la aplicación MotoListo
y de realizar el pago de la misma de forma puntual.
DE: 1 SOL POR CADA DÍA DE USO DE LA APLICACIÓN.
Cobrados al dia 7 de cada mes por yape.
      '''),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.equal(true),
                ]),
              ),
              FormBuilderCheckbox(
                name: 'admittance_reserve_accepted',
                title: Text('''Estoy de acuerdo en que la aplicación MotoListo
se RESERVA EL DERECHO DE ADMISIÓN Y PERMANENCIA
de mi usuario en la aplicación.
      '''),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.equal(true),
                ]),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    print(_formKey.currentState?.value);
                    registerVehicle(_formKey.currentState!.value).then((_) {
                      print('Vehicle registered');
                      Navigator.of(context).pushNamed('/driver_home');
                    });
                  } else {
                    print('Validation failed');
                  }
                },
                child: Text('Enviar registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
