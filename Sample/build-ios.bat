if not exist build md build

call amxmlc -compiler.library-path=..\AirExtension\extensions\com.vungle.extensions.Vungle.ane ^
	-output build\sample.swf -swf-version=23 -default-size=320,480 ^
	-default-background-color=#ffffff -debug src\VungleExample.as

call adt -package -target ipa-test-interpreter -keystore keys\sample-ios.p12 ^
	-storetype pkcs12 -storepass 123456 ^
	-provisioning-profile keys\sample-ios.mobileprovision ^
	build\example.ipa app.xml -C build sample.swf ^
	-C src\assets VungleIcon.png VungleIcon@2x.png VungleLogo.png ^
	Default@2x.png Default-568h@2x.png ^
	-extdir ..\AirExtension\extensions
