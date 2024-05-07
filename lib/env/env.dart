import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'WEB_CLIENT_ID', obfuscate: true)
  static String googleWebClientId = _Env.googleWebClientId;
  @EnviedField(varName: 'IOS_CLIENT_ID', obfuscate: true)
  static String googleIosClientId = _Env.googleIosClientId;
}
