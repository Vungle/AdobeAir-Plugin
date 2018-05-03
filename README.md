# Vungle's AdobeAir-Plugin

## Getting Started
To get up and running with Vungle, you'll need to [Create an Account With Vungle](https://v.vungle.com/dashboard) and [Add an Application to the Vungle Dashboard](https://support.vungle.com/hc/en-us/articles/210468678)

Once you've created an account you can follow our [Getting Started for Adobe Air Guide](https://support.vungle.com/hc/en-us/articles/204755040-Get-Started-with-Vungle-Adobe-Air) to complete the integration. Remember to get the Vungle App ID from the Vungle dashboard.

### Requirements
* The Vungle Extension Requires Adobe AIR SDK 4.0 or higher

## Release Notes

## VERSION 6.2.0
* integrated iOS Publisher SDK v6.2.0
* integrated Android Publisher SDK v6.2.5

## VERSION 5.4.0
* integrated iOS Publisher SDK v5.4.0

## VERSION 5.3.2
* integrated Android Publisher SDK v5.3.2
* integrated iOS Publisher SDK v5.3.2

## VERSION 5.3.0
* integrated Android Publisher SDK v5.3.0
* integrated iOS Publisher SDK v5.3.0

## VERSION 5.2.0
* integrated iOS Publisher SDK v5.2.0

## VERSION 5.1.1
* integrated iOS Publisher SDK v5.1.1

## VERSION 5.1.0
* integrated Android Publisher SDK v5.1.0
* integrated iOS Publisher SDK v5.1.0

## VERSION 5.0.0
* integrated Android Publisher SDK v5.0.0
* integrated iOS Publisher SDK v5.0.0

## 3.1.*
* Integrated iOS Publisher SDK v4.1.0
* Integrated Android Publisher SDK v4.1.0

## Known issues

The linker bundled with Adobe AIR SDK 25 can not recognize some entries in
the static library that is included in the Vungle SDK 4.1.0. When you try to
build an AIR application for iOS, you get an error message that looks like
this:

```
ld: in /var/folders/41/c10lb6_n6dq3_6tld7vbcg5r0000gn/T/5e99c7f3-9ad4-43ba-a33c-7667fbae07c5/libcom.vungle.extensions.Vungle.a(VungleNetworkOperation.o), archive member 'VungleNetworkOperation.o' with length 75024 is not mach-o or llvm bitcode for architecture arm64
ld: in /var/folders/41/c10lb6_n6dq3_6tld7vbcg5r0000gn/T/5e99c7f3-9ad4-43ba-a33c-7667fbae07c5/libcom.vungle.extensions.Vungle.a(VungleNetworkOperation.o), archive member 'VungleNetworkOperation.o' with length 73152 is not mach-o or llvm bitcode for architecture armv7
Compilation failed while executing : ld64
```

As a workaround you can install Xcode and replace
`$FLEX_HOME/lib/aot/bin/ld64/ld64` with a symlink to `/usr/bin/ld` or
`/Applications/Xcode.app/Contents/Developer/usr/bin/ld`:

```bash
cd "$FLEX_HOME/lib/aot/bin/ld64"
mv ld64 ld64.orig
ln -s /usr/bin/ld ld64
```

## License
The Vungle Air Extension is available under a commercial license. See the LICENSE file for more info.
