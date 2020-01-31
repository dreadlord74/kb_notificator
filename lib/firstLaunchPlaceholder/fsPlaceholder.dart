import 'package:flutter/material.dart';
import 'package:kb_notificator/btns.dart';

// class FSPlaceholder extends StatelessWidget{
//   @override
//   Widget build(context){
//     return Container(
//       height: double.infinity,
//       padding: EdgeInsets.all(20.0),
//       child: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _getTitle(),
//             SizedBox(
//               height: 15.0,
//             ),
//             _getSubtitle(),
//             SizedBox(
//               height: 45.0,
//             ),
//             _getButton(context)
//           ],
//         ),
//       )
// 		);
//   }

//   Text _getTitle(){
//     return Text(
//       "Система оповещения водителей",
//       textAlign: TextAlign.center,
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 12,
//         fontWeight: FontWeight.w400,
//       ),
//     );
//   }

//   Text _getSubtitle(){
//     return Text(
//       "Для получения оповещений вы должны указать номер своего телефона",
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         height: 22 / 18,
//         color: Colors.white,
//       ),
//       textAlign: TextAlign.center,
//     );
//   }

//   RaisedButton _getButton(context){
//     return RaisedButton(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(5.0)
//         )
//       ),
//       child: Text(
//         "Указать телефон",
//         style: TextStyle(
//           fontSize: 12.0,
//           fontWeight: FontWeight.w400
//         ),
//       ),
//       elevation: 0.0,
//       padding: EdgeInsets.fromLTRB(18, 11, 19, 12),
//       onPressed: (){
//         Navigator.pushNamed(context, "/settings/");
//       },
      
//     );
//   }
// }

class FSPlaceholder extends StatelessWidget{
  @override
  Widget build(context){
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(21.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        )
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/fs-placeholder-img.png",
            ),
            SizedBox(
              height: 45.0,
            ),
            _getTitle(),
            SizedBox(
              height: 15.0,
            ),
            _getSubtitle(),
            SizedBox(
              height: 45.0,
            ),
            _getButton(context)
          ],
        ),
      )
		);
  }

  Text _getTitle(){
    return Text(
      "Система оповещения водителей",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFADAEB5),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Text _getSubtitle(){
    return Text(
      "Для получения оповещений вы должны указать номер своего телефона",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 22 / 18,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  BorderedBtn _getButton(context){
    return BorderedBtn(
      "Указать телефон", 
      (){
        Navigator.pushNamed(context, "/settings/");
      }
    );
  }
}