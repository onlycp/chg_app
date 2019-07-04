import 'package:chp_app/model/guns_model.dart';
import 'package:chp_app/model/recharge_model.dart';
import 'package:chp_app/model/station_model.dart';
import 'package:chp_app/pages/agreement.dart';
import 'package:chp_app/pages/charge/charging.dart';
import 'package:chp_app/pages/charge/charging_finish.dart';
import 'package:chp_app/pages/charge/charging_minitor.dart';
import 'package:chp_app/pages/charge/charging_ready.dart';
import 'package:chp_app/pages/charge/charging_station.dart';
import 'package:chp_app/pages/charge/charging_station_query.dart';
import 'package:chp_app/pages/city.dart';
import 'package:chp_app/pages/forget.dart';
import 'package:chp_app/pages/forget_finish.dart';
import 'package:chp_app/pages/login.dart';
import 'package:chp_app/pages/my/my.dart';
import 'package:chp_app/pages/my/myinfo.dart';
import 'package:chp_app/pages/my/trade.dart';
import 'package:chp_app/pages/my/orders.dart';
import 'package:chp_app/pages/pay.dart';
import 'package:chp_app/pages/pay_fail.dart';
import 'package:chp_app/pages/pay_succeed.dart';
import 'package:chp_app/pages/questions.dart';
import 'package:chp_app/pages/reg.dart';
import 'package:chp_app/pages/reg_finish.dart';
import 'package:chp_app/pages/ask.dart';
import 'package:flutter/material.dart';
import 'package:chp_app/events/LocationEvent.dart';
import 'package:chp_app/pages/my/changePassword.dart';
import 'package:chp_app/pages/my/ChangeChargingPWD.dart';


class RouteUtil {
  static route2StationDetail(BuildContext context, StationModel entry) {
    if (null == entry) {
      return;
    }
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new ChargingStation(entry);
    }));
//
//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new ChargingStation(entry);
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2ChargingReady(BuildContext context, String gunCode) {
    if (null == gunCode) {
      return;
    }
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new ChargingReady(gunCode);
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new ChargingReady(gunCode);
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2ChargingFinish(BuildContext context, RechargeModel rechargeModel) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new ChargingFinish(rechargeModel);
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new ChargingFinish(rechargeModel);
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2ChargingMonitor(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new ChargingMonitor();
    }));
//
//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new ChargingMonitor();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Home(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new ChargingScreen();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
////          return new HomePage();
//          return ChargingScreen();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Search(BuildContext context, LocationEvent event) {
    Navigator.push(context, PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return new ChargingSearch(event);
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new ChargingSearch();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2My(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new My();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new My();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Login(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new Login();
    }));


//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new Login();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2City(BuildContext context, String cityName) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new City(cityName);
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new City(cityName);
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Reg(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new Reg();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new Reg();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2RegFinish(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new RegFinish();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new RegFinish();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Agreement(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new Agreement();
    }));


//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new Agreement();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Forget(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new Forget();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new Forget();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2ForgetFinish(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new ForgetFinish();
    }));


//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new ForgetFinish();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2MyInfo(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new MyInfo();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new MyInfo();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2ChangePWD(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new ChangePassword();
    }));
  }

  static route2ChangeChargingPWD(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new ChangeChargingPWD();
    }));
  }

  static route2Trade(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new Trade();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new Trade();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Questions(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new Questions();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new Questions();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Pay(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new Pay();
    }));


//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new Pay();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2PaySucceed(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new PaySucceed();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new PaySucceed();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2PayFail(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new PayFail();
    }));
//
//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new PayFail();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Ask(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new Ask();
    }));

//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new Ask();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static route2Orders(BuildContext context) {
    Navigator.push(context, PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return new Orders();
    }));


//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: false,
//        pageBuilder: (BuildContext context, _, __) {
//          return new Orders();
//        },
//        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
//          return new FadeTransition(
//            opacity: animation,
//            child: new FadeTransition(
//              opacity:
//                  new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
//              child: child,
//            ),
//          );
//        }));
  }

  static showTips(BuildContext context, final content) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
              child: new Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new Text(content,
                      textAlign: TextAlign.center,
                      style:
                          new TextStyle(color: Colors.black, fontSize: 18.0))));
        });
  }

  static showAlertDialog(
      BuildContext context, final dismissible, final title, final content) {
    showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (_) => new AlertDialog(
                title: new Text(title),
                content: new Text(content),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("关闭", style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("好的", style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]));
  }

  static showCustomAlertDialog(BuildContext context, final dismissible,
      final title, final content, Widget okWidget) {
    showDialog(
        context: context,
        barrierDismissible: dismissible,
        builder: (_) => new AlertDialog(
                title: new Text(title),
                content: new Text(content),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("关闭", style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  okWidget
                ]));
  }
}
