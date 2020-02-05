import 'package:flutter/material.dart';
import 'package:kb_notificator/appBar/AppBarType.dart';
import 'package:kb_notificator/appBar/customAppBar.dart';
import 'package:kb_notificator/detailPage/declineForm.dart';

class Decline extends StatefulWidget{
  final int _msgID;

  Decline(this._msgID);

  @override
  State<Decline> createState() {
    return _Decline(_msgID);
  }
}


class _Decline extends State<Decline>{
  int _msgID;

  _Decline(this._msgID);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE4DAD9),
                const Color(0xFFE5E4EE),
              ],
              stops: [
                0.0, 1.0
              ],
              tileMode: TileMode.clamp
            ),
            // color: Color(0xFFE4DAD9)
          ),
        ),
        Scaffold(
          appBar: CustomAppBar.getAppbar(
            context, 
            AppBarType.white,
            true,
            true,
           "Отказаться"
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 22),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Text(
                    "Причина отказа",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
                SizedBox(
                  height: 20,
                ),
                DeclineForm(_msgID)
              ],
            ),
          ),
        )
      ],
    );
  }
} 