@import Darwin;
@import Foundation;
#include "CTEvaluate.h"

extern CFStringRef kSecCodeInfoCodeDirectory;

int main(int argc, char** argv) {
  // https://github.com/qyang-nj/llios/blob/main/macho_parser/docs/LC_CODE_SIGNATURE.md
  // https://developer.apple.com/documentation/security/1395809-seccodecopysigninginformation?language=objc
  // https://source.chromium.org/chromium/chromium/src/+/main:chrome/browser/apps/app_shim/app_shim_manager_mac.cc;l=110;drc=d54e5200563bb88d95c70f1d3208d1ccb2137a40

  NSURL* target_url =
      [NSURL fileURLWithPath:argc >= 2 ? [NSString stringWithUTF8String:argv[1]] : @"littlemis"];
  // NSURL* target_url = [NSURL
  // fileURLWithPath:@"/Applications/Firefox.app/Contents/MacOS/firefox"];
  SecStaticCodeRef sec_code = nil;
  OSStatus status =
      SecStaticCodeCreateWithPath((__bridge CFURLRef)target_url, kSecCSDefaultFlags, &sec_code);
  if (status != errSecSuccess) {
    abort();
  }
  NSDictionary* out_dict = nil;
  status = SecCodeCopySigningInformation(
      sec_code, kSecCSDefaultFlags | kSecCSSigningInformation | kSecCSInternalInformation,
      (__bridge CFDictionaryRef*)&out_dict);
  if (status != errSecSuccess) {
    abort();
  }
  // NSLog(@"%@", out_dict);

  NSData* cms_data = out_dict[(__bridge NSString*)kSecCodeInfoCMS];
  // https://blog.umangis.me/a-deep-dive-into-ios-code-signing/
  NSData* code_directory_data = out_dict[(__bridge NSString*)kSecCodeInfoCodeDirectory];
  // TODO(zhuowei): lol
  //  [cms_data writeToFile:@"cmsblob.der" atomically:false];
  //  [code_directory_data writeToFile:@"cdblob.der" atomically:false];

  const uint8_t* leaf_certificate = nil;
  size_t leaf_certificate_length = 0;
  CoreTrustPolicyFlags policy_flags = 0;
  CoreTrustDigestType cms_digest_type = 0;
  CoreTrustDigestType hash_agility_digest_type = 0;
  const uint8_t* digest_data = nil;
  size_t digest_length = 0;

  CT_int result = CTEvaluateAMFICodeSignatureCMS(
      cms_data.bytes, cms_data.length, code_directory_data.bytes, code_directory_data.length,
      /*allow_test_hierarchy=*/true, &leaf_certificate, &leaf_certificate_length, &policy_flags,
      &cms_digest_type, &hash_agility_digest_type, &digest_data, &digest_length);
  NSLog(@"result = %d leaf_certificate = %p leaf_certificate_length = %lx policy_flags = %llx "
        @"cms_digest_type = %x hash_agility_digest_type = %x digest_data = %p digest_length = %lx",
        result, leaf_certificate, leaf_certificate_length, policy_flags, cms_digest_type,
        hash_agility_digest_type, digest_data, digest_length);
}
