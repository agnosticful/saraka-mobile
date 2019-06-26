import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saraka/constants.dart';
import '../blocs/maintenance_check_bloc.dart';

class MaintenanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: SarakaColors.white),
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 128,
                height: 128,
                child: Image.asset('assets/images/development.png'),
              ),
              SizedBox(height: 32),
              Text(
                "Going to be improved...",
                style: SarakaTextStyles.heading.copyWith(
                  color: SarakaColors.lightRed,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Consumer<MaintenanceCheckBloc>(
                builder: (context, maintenanceCheckBloc, _) => StreamBuilder(
                      stream: maintenanceCheckBloc.maintenance,
                      builder: (context, snapshot) => snapshot.hasData
                          ? Text(
                              "The application is under a maintenance.\nWe are planning to reopen at ${DateFormat('MM/dd hh:mm a').format(snapshot.requireData.finishedAt)}.\nSorry for inconvinience.",
                              style: SarakaTextStyles.multilineBody2,
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "The application is under a maintenance.\nWe are planning to reopen soon.\nSorry for inconvinience.",
                              style: SarakaTextStyles.multilineBody2,
                              textAlign: TextAlign.center,
                            ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
