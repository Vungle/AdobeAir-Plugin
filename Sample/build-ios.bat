if not exist build md build

call amxmlc -compiler.library-path=..\AirExtension\extensions\com.vungle.extensions.Vungle.ane ^
	-output build\sample.swf -swf-version=23 -default-size=320,480 ^
	-default-background-color=#ffffff -debug src\VungleExample.as

call adt -package -target ipa-test-interpreter -keystore keys\sample-ios.p12 ^
	-storetype pkcs12 -storepass 123456 ^
	-provisioning-profile keys\sample-ios.mobileprovision ^
	build\example.ipa app.xml -C build sample.swf ^
	-C src\assets VungleIcon60x60@2x.png VungleIcon60x60@3x.png ^
	VungleIcon76x76.png VungleIcon76x76@2x.png ^
	VungleIcon83.5x83.5@2x.png VungleLogo.png ^
	Assets.car Default@2x~iphone.png Default-568h@2x~iphone.png ^
	-extdir ..\AirExtension\extensions
