import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motolisto/blocs/sesion/session_bloc.dart';
import 'package:motolisto/blocs/request/request_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true, min: 0.5, max: 1);
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MotoListo'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<SessionBloc>().add(SessionLoggedOut());
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          IconButton(
            icon: Icon(Icons.motorcycle_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/onboarding');
            },
          ),
        ],
      ),
      body: BlocBuilder<RequestBloc, RequestState>(
        builder: (context, state) {
          if (state is RequestInitial) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _animation!,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.local_taxi_outlined),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 100),
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      autofocus: true,
                      onPressed: () {
                        context.read<RequestBloc>().add(SubmitRequest());
                      },
                      label: Text(
                        'Solicitar\nmoto-taxi\na mi ubicación',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Divider(),
                  Text(
                    'Presiona el botón para solicitar una Moto-taxi',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'El conductor más cercano a tu ubicación actual te atenderá',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          } else if (state is RequestLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Cargando...',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            );
          } else if (state is RequestPending) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  label: Text('Cancelar solicitud'),
                  icon: Icon(Icons.cancel),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Manten presionado para CANCELAR la solicitud'))),
                  onLongPress: () =>
                      context.read<RequestBloc>().add(CancelRequest()),
                ),
                Divider(),
                Spacer(),
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  state.message ?? 'Esperando confirmación de un CONDUCTOR...',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
              ],
            );
          } else if (state is RequestAccepted) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 100, color: Colors.green),
                SizedBox(height: 20),
                Text(
                  'CONDUCTOR EN CAMINO',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else if (state is RequestArrived) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.taxi_alert_outlined, size: 100, color: Colors.green),
                SizedBox(height: 20),
                Text(
                  'TU CONDUCTOR ESTA ESPERANDO EN TU UBICACIÓN',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Apresúrate a abordar',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            );
          } else if (state is RequestGoing) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_taxi_outlined,
                      size: 100, color: Colors.green),
                  SizedBox(height: 20),
                  Text(
                    'ESTAMOS EN VIAJE',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Por favor abróchate el cinturón, y disfruta del viaje',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            );
          } else if (state is RequestCompleted) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 100, color: Colors.green),
                SizedBox(height: 20),
                Text(
                  'LLEGAMOS A TU DESTINO',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Gracias por usar MotoListo, gracias por confiar en nosotros',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Divider(),
                OutlinedButton.icon(
                  label: Text('Gracias por usar MotoListo'),
                  icon: Icon(Icons.star),
                  onPressed: () {
                    context.read<RequestBloc>().add(CloseRequest());
                  },
                ),
              ],
            );
          } else if (state is RequestTimeout) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Icon(Icons.timer_off, size: 100, color: Colors.orange),
                SizedBox(height: 20),
                Text(
                  'TIEMPO DE ESPERA AGOTADO',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'No se encontró un conductor disponible en tu zona, inténtalo de nuevo',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Divider(),
                OutlinedButton.icon(
                  label: Text('Volver al inicio'),
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    context.read<RequestBloc>().add(CloseRequest());
                  },
                ),
              ],
            );
          } else if (state is RequestCancelled) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Icon(Icons.cancel, size: 100, color: Colors.orange),
                SizedBox(height: 20),
                Text(
                  'SOLICITUD CANCELADA',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Divider(),
                ElevatedButton.icon(
                  label: Text('Volver al inicio'),
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    context.read<RequestBloc>().add(CloseRequest());
                  },
                ),
              ],
            );
          } else if (state is RequestError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }
}
