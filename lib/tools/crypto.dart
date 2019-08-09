import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
class MD5Crypto {

  static generate(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

}
class AesCrypto {

  
  static final key = Key.fromUtf8('AR4cAR8aAxcSHhELGB0fBB4GEwcLGhUL');
  static final iv = IV.fromUtf8("0102030405060708");

  //加密
  static String encrypt(String target) {
    Encrypter en = getEncrypter();
    Encrypted result = en.encrypt(target,iv:iv);
    return result.base16;
  }

  //解密
  static String decrypted(String target) {
    Encrypter en = getEncrypter();
    String result = en.decrypt16(target,iv:iv);
    return result;
  }

  static Encrypter getEncrypter() {
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter;
  }

}
