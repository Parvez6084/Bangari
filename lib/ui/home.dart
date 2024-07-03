
import 'package:bhangari/data/application_model.dart';
import 'package:bhangari/service/background_services.dart';
import 'package:bhangari/service/location_service.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import '../data/firebaseDB_model.dart';
import '../utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  bool isTicketAssign = false;
  FirebaseDBModel firebaseDB = FirebaseDBModel();
  List<String> latLongList = [];

  @override
  void initState(){
    super.initState();
    context.read<HomeBloc>().add(GetApplicationList());
    firebaseListener();
  }


  void firebaseListener()async {
    await backgroundServiceRegister();
    DatabaseReference fireData = FirebaseDatabase.instance.ref("/FieldForce/AssignTicket");
    fireData.child('L3T2167').onValue.listen((DatabaseEvent event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic> values = dataSnapshot.value as Map;
      firebaseDB = FirebaseDBModel.fromJson(values);
      setState(() {
        isTicketAssign = firebaseDB.isTicketAssign!;
      });

      if (firebaseDB.isTicketAssign == true) {
        FlutterBackgroundService().startService();
      } else {
        FlutterBackgroundService().invoke('stopService');
      }

    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1EF),
      appBar:AppBar(
        backgroundColor: const Color(0xFFF1F1EF),
        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isTicketAssign == true
                    ? const Icon(Icons.location_on_rounded, size: 40, color: Colors.green)
                    : const Icon(Icons.location_disabled, size: 40, color: Colors.red),
                const SizedBox(height: 10),
                Center(
                  child: Text("Location Service is ${isTicketAssign ? 'ON' : 'OFF'}",
                      style: const TextStyle(fontSize: 20,color: Colors.black)),
                )
              ],
            );
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 60, left: 20, bottom: 20),
                    child: Text('Applications',style: TextStyle(fontSize: 32,color: Colors.black, fontWeight: FontWeight.w400)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: TextFormField(
                      controller: TextEditingController(),
                      decoration: const InputDecoration(
                        hintText: 'Search applications',
                        hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Color(0xFF4a4a4a)),
                        prefixIcon: Icon(Icons.search_rounded),
                        contentPadding: EdgeInsets.all(4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xFFe6e6e4),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemCount: state.applicationList.length,
                    itemBuilder: (context, index) {
                    ApplicationModel application = state.applicationList[index];
                    ApplicationWithIcon appIcon = application.app as ApplicationWithIcon;
                    return ListTile(
                      leading: Container(
                        width: 34,
                        height: 34,
                        foregroundDecoration: application.lockStatus == true ? const BoxDecoration(
                          color: Color(0xFF474747),
                          backgroundBlendMode: BlendMode.saturation,
                        ) : null ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: MemoryImage(appIcon.icon),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      title: Text(application.app.appName, style: const TextStyle(fontSize: 20)),
                      subtitle: Text(Utils.timeConverter(application.app.updateTimeMillis),style: const TextStyle(fontSize: 14,color: Colors.black54)),
                      trailing: CupertinoSwitch(
                        activeColor: const Color(0xFF5e5e5e),
                        trackColor: const Color(0xFF6a6a6a),
                        thumbColor: application.lockStatus == true ? const Color(0xFFe3e2e2) : const Color(0xFFababab),
                        value: application.lockStatus,
                        onChanged: (bool value) {
                          var apps = ApplicationModel(app: application.app, lockStatus: value);
                          context.read<HomeBloc>().add(AppLockUnlockListener(application: apps));
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
