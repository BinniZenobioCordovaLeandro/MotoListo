import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:motolisto/blocs/service/service_bloc.dart';
import 'package:motolisto/blocs/location/location_bloc.dart';
import 'package:motolisto/hooks/use_client.dart';
import 'package:motolisto/hooks/use_position.dart';
import 'package:motolisto/hooks/use_url.dart';

class DriverHomePage extends StatefulWidget {
  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool isVehicleAvailable = false;

  List clients = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationTracking) {
          final position = state.position;
          debugPrint('Location: ${position.latitude}, ${position.longitude}');
          getNearClients(position, 50).then((result) {
            setState(() {
              clients = result;
            });
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('MotoTaxista'),
          actions: [
            Switch(
              value: isVehicleAvailable,
              onChanged: (value) {
                setState(() {
                  isVehicleAvailable = value;
                });
                context.read<LocationBloc>().add(
                      isVehicleAvailable
                          ? StartLocationTracking()
                          : StopLocationTracking(),
                    );
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                isVehicleAvailable
                    ? 'Disponible para viajes'
                    : 'No disponible para viajes',
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              Spacer(),
              if (isVehicleAvailable)
                BlocBuilder<ServiceBloc, ServiceState>(
                  builder: (context, state) {
                    if (state is ServiceError) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'Oh no!, El servicio ya esta ocupado por otro conductor',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(state.message),
                            OutlinedButton.icon(
                              label: Text("Cerrar"),
                              icon: Icon(Icons.close),
                              onPressed: () {
                                context.read<ServiceBloc>().add(CloseService());
                              },
                            ),
                          ],
                        ),
                      );
                    } else if (state is ServiceAccepted) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'Servicio Aceptado',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                                'Primero, comunícate con el cliente para confirmar el servicio'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    label: Text('Llamar'),
                                    icon: Icon(Icons.phone),
                                    onPressed: () {
                                      openPhone(state.data['phone']);
                                    },
                                  ),
                                  ElevatedButton.icon(
                                    label: Text('WhatsApp'),
                                    icon: Icon(Icons.message),
                                    onPressed: () {
                                      openWhatsApp(state.data['phone']);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                                'Luego dirígete al punto de recogida usando el mapa'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    label: Text('Abrir Mapa'),
                                    icon: Icon(Icons.directions),
                                    onPressed: () {
                                      GeoPoint position =
                                          state.data['position'];
                                      openMap(position.latitude,
                                          position.longitude);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Text('¿Ya llegaste al punto de recogida?'),
                            OutlinedButton.icon(
                                label: Text("Llegué"),
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  context
                                      .read<ServiceBloc>()
                                      .add(UpdateService('arrived'));
                                }),
                          ],
                        ),
                      );
                    } else if (state is ServiceArrived) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'Espere al cliente',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text('El cliente está en camino'),
                            Divider(),
                            Text('¿El cliente subió a tu vehículo?'),
                            OutlinedButton.icon(
                                label: Text("Iniciar viaje"),
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  context
                                      .read<ServiceBloc>()
                                      .add(UpdateService('going'));
                                }),
                          ],
                        ),
                      );
                    } else if (state is ServiceGoing) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'En camino',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text('Dirígete al destino indicado por el cliente'),
                            Divider(),
                            Text('¿Llegaste al destino?'),
                            OutlinedButton.icon(
                                label: Text("Finalizar viaje"),
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  context
                                      .read<ServiceBloc>()
                                      .add(UpdateService('completed'));
                                }),
                          ],
                        ),
                      );
                    } else if (state is ServiceCompleted) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'Viaje completado',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                                'Gracias por brindar tu servicio en MotoListo'),
                            Divider(),
                            Text('¿Desea aceptar otro viaje?'),
                            OutlinedButton.icon(
                                label: Text(
                                    "Estar disponible para realizar otro viaje"),
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  context
                                      .read<ServiceBloc>()
                                      .add(CloseService());
                                }),
                          ],
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (context, index) {
                          final client = clients[index];
                          Position vehiclePosition = (context
                                  .read<LocationBloc>()
                                  .state as LocationTracking)
                              .position;
                          GeoPoint clientPosition = client['position'];
                          final distanceInBlocs = distanceInBlocks(
                              vehiclePosition.latitude,
                              vehiclePosition.longitude,
                              clientPosition.latitude,
                              clientPosition.longitude);
                          return ListTile(
                            title: Text(
                                "Cliente ${client['user'].substring(0, 9)}"),
                            subtitle: Text('Está a $distanceInBlocs de ti'),
                            trailing: OutlinedButton.icon(
                              icon: Icon(Icons.directions),
                              onPressed: () {
                                context
                                    .read<ServiceBloc>()
                                    .add(AcceptService(client['user']));
                              },
                              label: Text('Aceptar'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
