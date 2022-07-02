@import Darwin;
@import Foundation;

// http://newosxbook.com/src.jl?tree=listings&file=Vol.III/mistool.c
extern int MISValidateSignatureAndCopyInfo(CFStringRef File, CFDictionaryRef Opts, CFDictionaryRef* Info);
extern CFStringRef kMISValidationOptionRespectUppTrustAndAuthorization;
extern CFStringRef kMISValidationOptionAllowAdHocSigning;
extern CFStringRef kMISValidationOptionLogResourceErrors;
extern CFStringRef kMISValidationOptionOnlineAuthorization;
extern CFStringRef kMISValidationOptionValidateSignatureOnly;

int main(int argc, char** argv) {
  NSDictionary* info = nil;
  NSDictionary* dict = @{
    //(__bridge NSString*)kMISValidationOptionRespectUppTrustAndAuthorization : @YES,
    // HACK
    //(__bridge NSString*)kMISValidationOptionAllowAdHocSigning : @NO,
    (__bridge NSString*)kMISValidationOptionLogResourceErrors : @YES,
    (__bridge NSString*)kMISValidationOptionOnlineAuthorization : @YES,
    (__bridge NSString*)kMISValidationOptionValidateSignatureOnly: @YES,
  };
  NSString* path = argc == 2? [NSString stringWithUTF8String:argv[1]]: @"/Applications/Firefox.app/Contents/MacOS/firefox";
  unsigned long long status = MISValidateSignatureAndCopyInfo(
      (__bridge CFStringRef) path,
      (__bridge CFDictionaryRef)dict, (__bridge CFDictionaryRef*)&info);
  NSLog(@"status = %llx info = %@", status, info);
}
