import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../app_loclization.dart';

class WaitingToInputData extends StatelessWidget {
  const WaitingToInputData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(AppLocalizations.of(context)!.translate('wait')),
      ),
    );
  }
}
