import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'WEB_CLIENT_ID', obfuscate: true)
  static String googleWebClientId = _Env.googleWebClientId;
  @EnviedField(varName: 'IOS_CLIENT_ID', obfuscate: true)
  static String googleIosClientId = _Env.googleIosClientId;

  @EnviedField(varName: 'SUPA_URL', obfuscate: true)
  static String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPA_ANONKEY', obfuscate: true)
  static String supabaseAnonKey = _Env.supabaseAnonKey;
}
