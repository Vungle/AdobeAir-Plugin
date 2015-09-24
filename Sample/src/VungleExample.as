package
{
	import com.vungle.extensions.*;
	import com.vungle.extensions.events.VungleEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/** Vungle Example App */
	public class VungleExample extends Sprite
	{
		private var playAdButton:CustomButton;
		private var playIncentivizedAdButton:CustomButton;
		private var playCustomAdButton:CustomButton;
		private var statusText:TextField;

		public function VungleExample()
		{
			createUI();

			log("Initializing Vungle...");

			// targeting a single platform (just just ios or just android)
			// Vungle.create(["your_app_id"]);
			// targeting both ios and android
			// Vungle.create(["ios_app_id", "android_app_id"]);
			try {
				Vungle.create(["com.vungle.anesampleios", "com.vungle.anesample"]);
			} catch (error:Error) {
				log(error.toString());
				disableButtons();
				return;
			}

			log("Vungle Initialized: v." + Vungle.VERSION + "/s:" + Vungle.vungle.getSdkVersion());

			// you can enable internal logging for debug purposes (iOS only)
			//Vungle.vungle.setLoggingEnabled(true);

			// use global ad config to set default values
			VungleAdConfig.globalConfig.orientation = VungleOrientation.ANDROID_AUTOROTATE;

			// this event fires when an ad is ready to play
			Vungle.vungle.addEventListener(VungleEvent.AD_PLAYABLE, onAdPlayable);

			// this event always fires when an ad is dismissed
			Vungle.vungle.addEventListener(VungleEvent.AD_FINISHED, onAdFinished);

			// this event always fires when ad is displayed
			Vungle.vungle.addEventListener(VungleEvent.AD_STARTED, onAdStarted);

			// Dispatched when an ad has been viewed. The watched and length properties of the event
			// will be populated with the amount of the video watched, in seconds, and the total length
			// of the video in seconds, respectively, which are useful for rewarding incentivized views.
			// This event may not be called in some cases, such as when there is a pre-roll HTML asset
			// in the advertisement and the user opts out of the ad before seeing the video. Listen for
			// VungleEvent.AD_FINISHED to capture an event whenever an ad has been dismissed.
			Vungle.vungle.addEventListener(VungleEvent.AD_VIEWED, onAdViewed);

			// this event fires when a log message is sent (iOS only)
			Vungle.vungle.addEventListener(VungleEvent.AD_LOG, onAdLog);
		}

		//
		// Button events
		//

		// Play Ad button clicked
		private function onPlayAdClicked(event:Event):void
		{
			// ensure an ad is available first
			if (!Vungle.vungle.isAdAvailable())
			{
				log("No Ad available!");
				return;
			}

			log("Displaying interstitial ad...");
			Vungle.vungle.playAd();
			log("Waiting for interstitial ad...");
		}

		// Play Incentivized Ad button clicked
		private function onPlayIncentivizedAdClicked(event:Event):void
		{
			// ensure an ad is available first
			if (!Vungle.vungle.isAdAvailable())
			{
				log("No Ad available!");
				return;
			}

			log("Display incentivized ad...");
			var adConfig:VungleAdConfig = new VungleAdConfig();
			adConfig.orientation = VungleOrientation.ANDROID_MATCH_VIDEO;
			adConfig.incentivized = true;
			adConfig.incentivizedUserId = "tagtest01";
			Vungle.vungle.playAd(adConfig);
			log("Waiting for incentivized ad...");
		}

		// Play Ad With Options button clicked
		private function onPlayCustomAdClicked(event:Event):void
		{
			// ensure an ad is available first
			if (!Vungle.vungle.isAdAvailable())
			{
				log("No Ad available!");
				return;
			}

			log("Display custom ad...");
			var adConfig:VungleAdConfig = new VungleAdConfig();
			adConfig.soundEnabled = false;
			Vungle.vungle.playAd(adConfig);
			log("Waiting for custom ad...");
		}

		//
		// Vungle events
		//

		// On Ad Playable
		private function onAdPlayable(e:VungleEvent):void
		{
			// an ad is available - you can call playAd()
			log("Event: AdPlayable: " + e.isAdPlayable);
		}

		// On Ad Finished
		private function onAdFinished(e:VungleEvent):void
		{
			// the ad is done and you can return to your game, etc.
			log("Event: AdFinished: CTA = " + e.wasCallToActionClicked);
		}

		// On Ad Started
		private function onAdStarted(e:VungleEvent):void
		{
			// an ad has begun - you may wish to mute your game sounds, pause, etc.
			log("Event: AdStarted");
		}

		// On Ad Viewed
		private function onAdViewed(e:VungleEvent):void
		{
			// ad view complete. for incentivized ads, you can use the watched/length
			// properties to determine if a reward should be given.
			log("Event: AdViewed: Time: (" + e.watched + "/" + e.length + ")");
		}

		// On Ad Log
		private function onAdLog(e:VungleEvent):void
		{
			// a log message is sent by the SDK (iOS only)
			log("Event: AdLog: " + e.message);
		}

		//
		// UI
		//

		private function createUI():void
		{
			playAdButton = new CustomButton('Play Ad', 'sfSky.jpg');

			playIncentivizedAdButton = new CustomButton('Play Incentivized Ad', 'berlinSky.jpg');
			playIncentivizedAdButton.y = 160;

			playCustomAdButton = new CustomButton('Play Ad With Options', 'londonSky.jpg');
			playCustomAdButton.y = 320;

			statusText = makeStatusTextField();

			addChild(playAdButton);
			addChild(playIncentivizedAdButton);
			addChild(playCustomAdButton);
			addChild(statusText);

			playAdButton.addEventListener(MouseEvent.CLICK, onPlayAdClicked);
			playIncentivizedAdButton.addEventListener(MouseEvent.CLICK, onPlayIncentivizedAdClicked);
			playCustomAdButton.addEventListener(MouseEvent.CLICK, onPlayCustomAdClicked);
		}

		private function disableButtons():void
		{
			playAdButton.enabled = false;
			playIncentivizedAdButton.enabled = false;
			playCustomAdButton.enabled = false;
		}

		private function log(message:String):void
		{
			trace(message);
			statusText.text = message;
		}
	}
}

import flash.display.Loader;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class CustomButton extends SimpleButton
{
	public function CustomButton(text:String, image:String)
	{
		upState = overState = hitTestState = new ButtonDisplayState(text, image);
		downState = new ButtonDisplayState(text, image, 0.5);
	}

	override public function set enabled(enabled:Boolean):void
	{
		super.enabled = enabled;
		super.mouseEnabled = enabled;
	}
}

class ButtonDisplayState extends Sprite
{
	public function ButtonDisplayState(text:String, image:String, alpha:Number = 1.0)
	{
		opaqueBackground = 0x000000;

		// add image
		var loader:Loader = new Loader();
		var url:URLRequest = new URLRequest(image);
		var loaderContext:LoaderContext = new LoaderContext(false,
			ApplicationDomain.currentDomain, null);
		loader.load(url, loaderContext);
		loader.alpha = alpha;
		addChild(loader);

		// add text label
		var textField:TextField = new TextField();
		textField.width = 320;
		textField.autoSize = TextFieldAutoSize.CENTER;
		textField.defaultTextFormat = new TextFormat('Arial', 24, 0xFFFFFF);
		textField.text = text;
		textField.y = (160 - textField.height) / 2;
		addChild(textField);
	}
}

function makeStatusTextField():TextField
{
	var textField:TextField = new TextField();
	textField.width = 320;
	textField.height = 50;
	textField.multiline = true;
	textField.wordWrap = true;
	textField.defaultTextFormat = new TextFormat('Arial', 10, 0xFFFFFF);
	return textField;
}
