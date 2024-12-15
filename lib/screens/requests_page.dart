import 'package:flutter/material.dart';

class ServiceRequest {
  final String serviceName;
  final double distance;

  ServiceRequest(this.serviceName, this.distance);
}

class RequestsPage extends StatelessWidget {
  final List<ServiceRequest> serviceRequests = [
    ServiceRequest('Delivery de comida', 1.2),
    ServiceRequest('Transporte de pasajeros', 3.5),
    ServiceRequest('Envío de documentos', 2.0),
    ServiceRequest('Compra de medicamentos', 4.1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios Cercanos'),
      ),
      body: ListView.builder(
        itemCount: serviceRequests.length,
        itemBuilder: (context, index) {
          final request = serviceRequests[index];
          return ListTile(
            title: Text(request.serviceName),
            subtitle:
                Text('Distancia: ${request.distance.toStringAsFixed(1)} km'),
            trailing: ElevatedButton(
              onPressed: () {
                // Lógica para aceptar el servicio
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Servicio "${request.serviceName}" aceptado')),
                );
              },
              child: Text('Aceptar'),
            ),
          );
        },
      ),
    );
  }
}
