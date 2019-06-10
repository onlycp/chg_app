import 'package:chp_app/model/user_model.dart';
import 'package:event_bus/event_bus.dart';

class Constants {
//  RSA公钥
  static final String PUBLIC_KEY =
      "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDOwmFtEk1oJxDU0NI4kVO0Jx0Xnt+Abx+JKGUzcRzPwjUkd5z9Ice5rh87CCmj0XjZ5pPac6TtA3f0v5FqiK/kjQY5XMLti4weJ4dcp1/q1O7PCYxRX8WgetGxwsjxGn+uoZOZkclN1PFS4wRnKEso6+G/e60QGB29cZoo4jZnZwIDAQAB";

  static final String appPrivateKey =
      'MIIEowIBAAKCAQEAqh6Nf++bX3FZAnFBpV4LoKDB/BIM+UBxgG0ecqew5fZ7/5ciHLl8g4eHLuBLDx8tzQNFL0P19rTnd/F2il7jw10g+yhAzzK34DZhlMx6+l53RoZlcmCv3isGqtwwExxhI3Fpie3AMaLodnKRMh+drIt/QrVguXprKDNZ/3CDal5h+wozGF7Onap8HWd7eFdUt2QlZn/KD6bRV7jEVS1KbOccr3pBbyPeL7ecPxzuVx4RZSrLO1v+wCwQnmL+ShEM1e7CY8C9JNuKtaJnPemojI462PGzNWnBsKs9BrHc95J/Y9lUEABDMDwE9Li5zT4dSpeGOvOKkq29wiCx+nZQqQIDAQABAoIBAALCYhssIMIIjaALhDwRbXDaiqrzBADa+bxSiMblT2o7eEFqCySaIZnkjd3Fx5HkOJL1tZ6RpKCuyH5ajUirR1h43zsTqRFzSiY525VVR71d4ONk9KpJRTD+U6pbze/RawXvJf4VvCNR+CFLtG0ytBUDYjoLxRjdEnXhd1k8UvVbscgNmjtc5owGd3OIfOn4wk2gCJXDjwEoHV7tRkx0lNcKpMmsUn03JPNIpOPP7TCNjIunqaDdLD3lQO9zYYQPcfPTjZLdgdnoAAMzLecBpioe56S+a8z3p/e8iM5QANnsmD73Ca3bencO0jmp5mo06qG05VNNnPvqYTachiWaVM0CgYEA0ZMDxexfP3MRvn56REZPCKbL9fKy2gebZpRVYXR8iOYf6vkgPlhCFHtvNGjKl3DE3U8WxqEeff/wIT1VJSfOM7KMHgRn3iYcwVQz8QNdnGHUwuawgwS9tTKg4eBdL2nK/7QgPA05wnPAem69UMbNkhk8CF/1mEPLid/2Qh4/SXcCgYEAz84LLKNqv9Tb0SC/WcOSOatdnRPqnX78HiuC4WCZUxPJZxmL0wkAku7m1BmOi8Q2vcpoevaGcsQ1eTQvFylBKMlvT0Jtpoqzumau+qOn8T/mj2QmkOjLnOT+bMRcGqqSPB6tI1rhZeAOYL5OPHJALR6vxg5Nl2OB1yq33HFpvt8CgYB7mFIvVZlOmBQs3fZJcZWGqqe6oqkrwDS7qFs6IDKZoe3M66NCYVaHMcyBghOIgG75fX0XI0oSUPBTChK+2NzYzEGqKjr/XkazFW+UgcGhSmjpkJckjZU72WHcFC+gmKmpZ5djEwGvVgh7q/dmPfhaYxtubPkwFTtiUnyuvZvhPQKBgQCDc7KL5UAU42C+FLoW3Wk1g9qvD7c9M+Pmbd3YFhRHgl/IEVfrAmnTiL6J8zTB4zhBrLWU+zenh8jPyBv1ycoHNA1ulPXqARmaU3Ri5n3JVYPStybSSgDrWcw8H6an07i3wSwDDm1A1ZAi0J+LCzbfk+bbIZchqferlcFC+JdM/wKBgCf/cJkk06gwM9dZlCob5p6j4kkWMn1A2tpYozHT6dtVr5tTQyyseo+OyI/daPjhGXE89AG36K/qr4etz3Xx/Bl29hqLGXJV0ATxOi/KyOjtOZFxOWlJQWb1krtdtiKOYMPgBU1WrMJQzW+kSVA9nl3tfXb7wgdoMv2f+lZXkSC2';
  static final String aliPublicKey =
      'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDIgHnOn7LLILlKETd6BFRJ0GqgS2Y3mn1wMQmyh9zEyWlz5p1zrahRahbXAfCfSqshSNfqOmAQzSHRVjCqjsAw1jyqrXaPdKBmr90DIpIxmIyKXv4GGAkPyJ/6FTFY99uhpiq0qadD/uSzQsefWo0aTvP/65zi3eof7TcZ32oWpwIDAQAB';
  static final String notifyUrl =
      'http://mr.chenpbh.date:8084/app/v1/wallet/alipayNotify';
  static final String appId = '2016092300576352';

//  事件通知
  static EventBus eventBus = new EventBus();
  static UserModel user;
  static String token;
  static String refreshToken;
}
