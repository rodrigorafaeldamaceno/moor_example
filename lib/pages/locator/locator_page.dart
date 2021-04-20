import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class LocatorPage extends StatefulWidget {
  @override
  _LocatorPageState createState() => _LocatorPageState();
}

class _LocatorPageState extends State<LocatorPage> {
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[onLocation] success: ${location.coords}');
    }, (bg.LocationError error) {
      print('[onLocation] ERROR: ${error.message}');
    });

    // // // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    // bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
    //   print('[motionchange] - ${location.coords}');
    // });

    // // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('[providerchange] - ${event.enabled}');

      setState(() {
        enabled = event.enabled;
      });
    });

    bg.BackgroundGeolocation.ready(
      bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 1.01,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      ),
    ).then((value) {
      print('enabled: ${value.enabled}');
      setState(() {
        enabled = value.enabled;
      });
      if (!value.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });

    ////
    // 2.  Configure the plugin
    //
  }

  Future _enabledLocator() async {
    bg.BackgroundGeolocation.ready(
      bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 0.0001,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        activityRecognitionInterval: 500,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      ),
    ).then((value) {
      if (!value.enabled)
        bg.BackgroundGeolocation.start().then((value) {
          setState(() {
            enabled = value.enabled;
          });
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Icon(
                enabled ? Icons.location_on : Icons.location_off,
                color: enabled ? Colors.green : Colors.grey,
                size: 100,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: _enabledLocator,
                child: Text('Iniciar'),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  bg.BackgroundGeolocation.stop().then((value) {
                    setState(() {
                      enabled = value.enabled;
                    });
                  });
                },
                child: Text('Finalizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
