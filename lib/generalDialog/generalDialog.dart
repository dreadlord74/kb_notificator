import 'package:flutter/material.dart';
import 'package:kb_notificator/btns.dart';

class PopupDialog extends ModalRoute<void>{
  BuildContext context;
  String title;
  String subtitle;
  String btnText;
  Function btnOnPressed;
  PopupDialog(
    this.context,
    this.title,
    this.subtitle,
    this.btnText,
    this.btnOnPressed
  );

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: _buildOverlayContent(context),
    );
  }


  Widget _buildOverlayContent(BuildContext context) {
    return 
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(21.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFADAEB5)
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  height: 22 / 18,
                ),
              ),
              SizedBox(
                height: 45,
              ),
              BorderedBtn(
                btnText,
                btnOnPressed
              )
            ],
          ),          
        )
      );
  }


  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    
    Animation<Offset> custom = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0 + 1.0 / 18)
    ).animate(animation);

    return SlideTransition(
      position: custom,
      child: child,
    );
    // return FadeTransition(
    //   opacity: animation,
    //   child: ScaleTransition(
    //     scale: animation,
    //     child: child,
    //   ),
    // );
  }
}