** This doesn't work! **

The resigned Taurine launches but fails with "ERR_JAILBREAK".

--

Resigns Taurine.app with Linus Henze's CoreTrust bypass and packages it into a .deb.

The .deb can be installed while jailbroken, and will still work after a reboot, without expiring every 7 days.

There's no use for this unless you're on iOS 14.0-14.2, which has a jailbreak but no untether - and don't want to pay for an Enterprise certificate to bypass the 7-day limit.

Prepare:

- Import ../fakeiphonecert/dev_certificate.p12 (double-click it and enter `password` for password)
- `brew install dpkg`
- `./download_taurine.sh`

Package:

- `./resign_taurine.sh`
- transfer to your jailbroken phone
- `dpkg -i Taurine.deb`
- Reboot phone, and Taurine should show up in the homescreen
- You should be able to open it even when unjailbroken

Notes:

- Taurine gets a custom entitlement to force it not to be a `platform-application`
  - otherwise Taurine crashes on launch since it thinks it's already jailbroken
  - Taurine also checks that it's signed with at least 3 entitlements - I threw in two dummy ones
- This only works with a .deb, not an .ipa installed via AppSync Unified
  - SpringBoard validates apps installed via .ipa using `Security.framework`, which is not vulnerable.
