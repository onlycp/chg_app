class Apis {
  /************************************服务器接口地址 开始*******************************************/
//陈鹏电脑
  static final String HOST = "http://mr.chenpbh.date:8084";
//服务器
//  static final String HOST = "http://mr.chenpbh.date:8083";
  /************************************服务器接口地址 开始*******************************************/

  /************************************充电业务类 开始*******************************************/

//  充电桩状态
  static final String gunStatus = "/app/v1/charge/gunStatus";
//  充电实时状态
  static final String realInfo = "/app/v1/charge/realInfo";
//  最近一笔订单
  static final String lastest = "/app/v1/charge/lastest";
//充电订单(分页)
  static final String orders = "/app/v1/charge/orders";
//  开始充电
  static final String startCharge = "/app/v1/charge/startCharge";
//  停止充电
  static final String stopCharge = "/app/v1/charge/stopCharge";

  /************************************充电业务类 结束*******************************************/

  /************************************充电设施类 开始*******************************************/

//  站点充电桩信息
  static final String findPole = "/app/v1/device/findPole";
//  站点充电桩列表
  static final String guns = "/app/v1/device/guns";
//  运营城市列表
  static final String operCities = "/app/v1/device/operCities";
//  站点详细信息
  static final String stationDetail = "/app/v1/device/stationDetail";
//  站点列表
  static final String stationListQuery = "/app/v1/device/stationListQuery";
//  城市站点总览
  static final String stationOverview = "/app/v1/device/stationOverview";

  /************************************充电设施类 结束*******************************************/

  /************************************用户类接口 开始*******************************************/
//  找回密码-准备
  static final String forgetPasswordReady = "/app/v1/user/forgetPasswordReady";
//  获取找回密码验证码
  static final String forgetRandCode = "/app/v1/user/forgetRandCode";
//  找回密码-设置密码
  static final String forgetSetPassword = "/app/v1/user/forgetSetPassword";
//  个人信息
  static final String info = "/app/v1/user/info";
  static final String uploadPhoto = "/app/v1/user/uploadPhoto";
//  用户登入
  static final String login = "/app/v1/user/login";
//  刷新用户令牌
  static final String refreshToken = "/app/v1/user/refreshToken";
//  获取注册验证码
  static final String registerRandCode = "/app/v1/user/registerRandCode";
//   用户注册-准备
  static final String registerReady = "/app/v1/user/registerReady";
//  用户注册-设置密码
  static final String setPassword = "/app/v1/user/registerSetPassword";
//    更新个人资料
  static final String updateInfo = "/app/v1/user/updateInfo";
//  修改密码
  static final String updatePassword = "/app/v1/user/updatePassword";

  //  修改充电密码
  static final String updateChargePassword = "/app/v1/user/setChargePassword";
/************************************用户类接口 结束*******************************************/

/************************************辅助类 开始*******************************************/

  //  常见问题
  static final String questions = "/app/v1/aux/faqs";

  static final String submitFeeback = "/app/v1/aux/submitFeeback";

  static final String checkVersion = "/app/v1/aux/checkVersion";
  static final String agreement = HOST + "/page/agreement.html";

/************************************辅助类 结束*******************************************/

/************************************钱包类接口 开始*******************************************/
  //  支付宝回调
  static final String alipayNotify = "/app/v1/wallet/alipayNotify";
//  我的钱包
  static final String my = "/app/v1/wallet/my";
//  准备充值
  static final String readyRecharge = "/app/v1/wallet/readyRecharge";
//  交易明细
  static final String trades = "/app/v1/wallet/trades";
/************************************钱包类接口 结束*******************************************/

}
