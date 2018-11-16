package
{
	import com.vungle.extensions.*;
	import com.vungle.extensions.events.VungleEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.text.TextField;

	/** Vungle Example App */
	public class VungleExample extends Sprite
	{
		private var initView:InitializationView;
		private var placementView1:PlacementView;
		private var placementView2:PlacementView;
		private var placementView3:PlacementView;
		private var statusText:TextField;

		private var platformIds:Object = {
			android: {
				/*appId: "592754a11cb660c05500000b",
				placements: ["DEFAULT62446", "PLACEME67081", "PLACEME06478"]*/
				
				appId: "5ae0db55e2d43668c97bd65e",
				placements: ["DEFAULT-6595425", "LEGACY_REWARDED-2115035", "DYNAMIC_TEMPLATE_INTERSTITIAL-6969365"]
				
				
			},
			ios: {
				appId: "592757da73883d212c00000b",
				placements: ["DEFAULT34708", "PLACEME99234", "PLACEME40182"] 
			}
		};

		private var ids:Object = Capabilities.version.substr(0, 3) == 'AND' ?
			platformIds.android : platformIds.ios;

		public function VungleExample()
		{
			createUI();
		}

		//
		// Button events
		//

		private function onInitClicked(event:Event):void
		{
			log("VungleIT - Initializing Vungle...");

			initView.initButton.enabled = false;

			try {
				Vungle.create(ids.appId); 
			} catch (error:Error) {
				log("VungleIT - " + error.toString());
				return;
			}

			log("VungleIT - Vungle Initialized: v." + Vungle.VERSION + "/s:" + Vungle.vungle.getSdkVersion());

			// you can enable internal logging for debug purposes (iOS only)
			//Vungle.vungle.setLoggingEnabled(true);

			// use global ad config to set default values
			VungleAdConfig.globalConfig.orientation = VungleOrientation.ANDROID_AUTOROTATE;

			// this event fires when SDK is initialized
			Vungle.vungle.addEventListener(VungleEvent.AD_INIT, onAdInit);

			// this event fires when an ad is ready to play
			Vungle.vungle.addEventListener(VungleEvent.AD_PLAYABLE, onAdPlayable);

			// this event always fires when ad is displayed
			Vungle.vungle.addEventListener(VungleEvent.AD_STARTED, onAdStarted);

			// this event always fires when an ad is dismissed
			Vungle.vungle.addEventListener(VungleEvent.AD_FINISHED, onAdFinished);

			// this event fires after playAd() when it is unable to play the ad
			Vungle.vungle.addEventListener(VungleEvent.AD_FAILED, onAdFailed);

			// this event fires when a log message is sent (iOS only)
			Vungle.vungle.addEventListener(VungleEvent.AD_LOG, onAdLog);
			
			//Set GDPR consent status
			//Vungle.vungle.updateConsentStatus(1,"Adobe Air consent v1.0"); //Opted_in
			//Vungle.vungle.updateConsentStatus(2,"Adobe Air consent v1.0"); //Opted_out
			
			 //var status:int = Vungle.vungle.getConsentStatus();            //Get consent status
			//log("VungleIT - " + status + ": displaying status...");
			
			//var version:String = Vungle.vungle.getConsentMessageVersion(); //Get consent version string
			//log("VungleIT - " + version + ": displaying version...");
			
		}

		private function onLoadAdClicked(event:Event):void
		{
			// select placement depending on the button clicked
			var placement:String;
			if (event.currentTarget == placementView2.loadButton) {
				placement = ids.placements[1];
				placementView2.loadButton.enabled = false;
			}
			else {
				placement = ids.placements[2];
				placementView3.loadButton.enabled = false;
			}

			// load ad for the placement
			log(placement + ": loading ad...");
			Vungle.vungle.loadAd(placement);
		}

		private function onPlayAd1Clicked(event:Event):void
		{
			
			
			var placement:String = ids.placements[0];

			// ensure an ad is available first
			if (!Vungle.vungle.isAdAvailable(placement)) {
				log("VungleIT - No ad available!");
				return;
			}

			// play ad with default options
			log("VungleIT - " + placement + ": displaying ad...");
			Vungle.vungle.playAd(placement);
			log("VungleIT - " + placement + ": waiting for ad...");
		}

		private function onPlayAd2Clicked(event:Event):void
		{
			var placement:String = ids.placements[1];

			// ensure an ad is available first
			if (!Vungle.vungle.isAdAvailable(placement)) {
				log("VungleIT - No ad available!");
				return;
			}

			// use VungleAdConfig to set custom ad options
			var adConfig:VungleAdConfig = new VungleAdConfig();
			
			adConfig.orientation = VungleOrientation.ANDROID_MATCH_VIDEO | VungleOrientation.IOS_PORTRAIT;
			adConfig.soundEnabled = false;

			android: {
				adConfig.backButtonImmediatelyEnabled = true;
				adConfig.immersiveMode = true;
			}
			
			adConfig.incentivizedUserId = "vungle_teset_user";
			adConfig.incentivizedCancelDialogBodyText = "Body";
			adConfig.incentivizedCancelDialogCloseButtonText = "CloseButton";
			adConfig.incentivizedCancelDialogKeepWatchingButtonText = "ContiniueButton";
			adConfig.incentivizedCancelDialogTitle = "Title";
			
			// play ad with options
			log("VungleIT - " + placement + ": displaying ad...");
			Vungle.vungle.playAd(placement, adConfig);
			log("VungleIT - " + placement + ": waiting for ad...");
		}

		private function onPlayAd3Clicked(event:Event):void
		{
			var placement:String = ids.placements[2]; 
			// ensure an ad is available first
			if (!Vungle.vungle.isAdAvailable(placement)) {
				log("VungleIT - No ad available!");
				return;
			}

			// use VungleAdConfig to set custom ad options
			var adConfig:VungleAdConfig = new VungleAdConfig();
			adConfig.incentivizedUserId = "vungle_test_user_id";
			adConfig.incentivizedCancelDialogBodyText = "Body";
			adConfig.incentivizedCancelDialogCloseButtonText = "CloseButton";
			adConfig.incentivizedCancelDialogKeepWatchingButtonText = "ContiniueButton";
			adConfig.incentivizedCancelDialogTitle = "Title";

			// play ad with options
			log("VungleIT - " + placement + ": displaying ad...");
			Vungle.vungle.playAd(placement, adConfig);
			log("VungleIT - " + placement + ": waiting for ad...");
		}

		//
		// Vungle events
		//

		// On Vungle SDK Initialized
		private function onAdInit(e:VungleEvent):void
		{
			// SDK is initialized
			// now you can call loadAd(), playAd() etc.
			log("VungleIT - Event: AdInit: " + e.isInitialized);
			if (e.isInitialized) {
				placementView2.loadButton.enabled = true;
				placementView3.loadButton.enabled = true;
			}
		}

		// On Ad Playable
		private function onAdPlayable(e:VungleEvent):void
		{
			// an ad is available - you can call playAd()
			log("VungleIT - Event: AdPlayable: " + e.isAdPlayable +
				", placement = " + e.placement);
			if (e.placement == ids.placements[0]) {
				placementView1.playButton.enabled = e.isAdPlayable;
			}
			else if (e.placement == ids.placements[1]) {
				placementView2.loadButton.enabled = !e.isAdPlayable;
				placementView2.playButton.enabled = e.isAdPlayable;
			}
			else if (e.placement == ids.placements[2]) {
				placementView3.loadButton.enabled = !e.isAdPlayable;
				placementView3.playButton.enabled = e.isAdPlayable;
			}
		}

		// On Ad Started
		private function onAdStarted(e:VungleEvent):void
		{
			// an ad has begun - you may wish to mute your game sounds, pause, etc.
			log("VungleIT - Event: AdStarted: placement = " + e.placement);
		}

		// On Ad Finished
		private function onAdFinished(e:VungleEvent):void
		{
			// the ad is done and you can return to your game, etc.
			// for incentivized ads, you can use the wasSuccessfulView
			// property to determine if a reward should be given.
			log("VungleIT - Event: AdFinished: placement = " + e.placement +
				", successful = " + e.wasSuccessfulView +
				", CTA = " + e.wasCallToActionClicked);
		}

		// On Ad Failed
		private function onAdFailed(e:VungleEvent):void
		{
			// for some reason playAd() failed
			log("VungleIT - Event: AdFailed: placement = " + e.placement +
				", message = " + e.message);
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
			var headerView:HeaderView = new HeaderView();
			addChild(headerView);

			initView = new InitializationView(ids.appId,
				onInitClicked);
			initView.y = 36;
			addChild(initView);

			placementView1 = new PlacementView('Placement 1',
				ids.placements[0], null, onPlayAd1Clicked);
			placementView1.y = initView.y + 72;
			addChild(placementView1);

			placementView2 = new PlacementView('Placement 2',
				ids.placements[1], onLoadAdClicked,
				onPlayAd2Clicked);
			placementView2.y = placementView1.y + 112;
			addChild(placementView2);

			placementView3 = new PlacementView('Placement 3',
				ids.placements[2], onLoadAdClicked,
				onPlayAd3Clicked);
			placementView3.y = placementView2.y + 112;
			addChild(placementView3);

			statusText = makeStatusTextField();
			statusText.y = placementView3.y + 112;
			addChild(statusText);

			disableButtons();
		}

		private function disableButtons():void
		{
			placementView1.playButton.enabled = false;
			placementView2.loadButton.enabled = false;
			placementView2.playButton.enabled = false;
			placementView3.loadButton.enabled = false;
			placementView3.playButton.enabled = false;
		}

		private function log(message:String):void
		{
			trace(message);
			statusText.text = message;
		}
	}
}

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class CustomButton extends SimpleButton
{
	protected var disabledState: DisplayObject;
	protected var enabledState: DisplayObject;

	public function CustomButton(text:String, width:Number = 144,
			color:Number = 0x3D8FC7)
	{
		enabledState = new ButtonDisplayState(text, width, color);
		upState = overState = hitTestState = enabledState;
		downState = new ButtonDisplayState(text, width, color, 1.0, 0.5);
		disabledState = new ButtonDisplayState(text, width, color, 0.5);
	}

	override public function set enabled(enabled:Boolean):void
	{
		super.enabled = enabled;
		mouseEnabled = enabled;
		upState = overState = hitTestState =
			enabled ? enabledState : disabledState;
	}
}

class ButtonDisplayState extends Sprite
{
	public function ButtonDisplayState(text:String, width:Number,
			color:Number, alpha:Number = 1.0,
			textAlpha:Number = 1.0)
	{
		var buttonHeight:Number = 32;

		// add background
		var s:Shape = new Shape();
		s.graphics.beginFill(color, alpha);
		s.graphics.drawRoundRect(0, 0, width, buttonHeight,
			buttonHeight);
		s.graphics.endFill();
		addChild(s);

		// add text label
		var textField:TextField = new TextField();
		textField.width = width;
		textField.autoSize = TextFieldAutoSize.CENTER;
		textField.defaultTextFormat = new TextFormat('Arial', 16,
			0xFFFFFF, true);
		textField.text = text;
		textField.y = (buttonHeight - textField.height) / 2;
		textField.alpha = textAlpha;
		addChild(textField);
	}
}

class Separator extends Shape
{
	public function Separator()
	{
		graphics.beginFill(0xDFE0E2);
		graphics.drawRect(0, 0, 320, 1);
		graphics.endFill();
	}
}

class HeaderView extends Sprite
{
	public function HeaderView()
	{
		// add image
		var loader:Loader = new Loader();
		var url:URLRequest = new URLRequest('VungleLogo.png');
		var loaderContext:LoaderContext = new LoaderContext(false,
			ApplicationDomain.currentDomain, null);
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
			onComplete);
		loader.load(url, loaderContext);

		// separator
		var s:Separator = new Separator();
		s.y = 35;
		addChild(s);
	}

	private function onComplete(event:Event):void
	{
		var b:Bitmap = event.target.content as Bitmap;
		b.x = 130;
		b.y = 4;
		b.width = 60;
		b.height = 27;
		addChild(b);
	}
}

class InitializationView extends Sprite
{
	public var initButton:CustomButton;

	public function InitializationView(appId:String, onInit:Function)
	{
		// background
		graphics.beginFill(0xF9FAFC);
		graphics.drawRect(0, 0, 320, 72);
		graphics.endFill();

		// appId
		var t:TextField = new TextField();
		t.width = 320;
		t.autoSize = TextFieldAutoSize.CENTER;
		t.defaultTextFormat = new TextFormat('Arial', 13, 0x0C2033);
		t.selectable = false;
		t.text = 'App ID: ' + appId;
		t.y = 7;
		addChild(t);

		// init button
		initButton = new CustomButton('Init SDK', 232, 0x1db17a);
		initButton.x = 44;
		initButton.y = 27;
		initButton.addEventListener(MouseEvent.CLICK, onInit);
		addChild(initButton);

		// separator
		var s:Separator = new Separator();
		s.y = 71;
		addChild(s);
	}
}

class PlacementView extends Sprite
{
	private var placement:String;

	public var loadButton:CustomButton;
	public var playButton:CustomButton;

	public function PlacementView(title:String, placement:String,
			onLoad:Function, onPlay:Function)
	{
		var t:TextField;

		this.placement = placement;

		// title
		t = new TextField();
		t.width = 320;
		t.autoSize = TextFieldAutoSize.CENTER;
		t.defaultTextFormat = new TextFormat('Arial', 28, 0x0C2033);
		t.selectable = false;
		t.text = title;
		t.y = 8;
		addChild(t);

		// placement id
		t = new TextField();
		t.width = 320;
		t.autoSize = TextFieldAutoSize.CENTER;
		t.defaultTextFormat = new TextFormat('Arial', 13, 0x0C2033);
		t.selectable = false;
		t.text = 'PlacementID: ' + placement;
		t.y = 40;
		addChild(t);

		if (onLoad != null) {
			// load button
			loadButton = new CustomButton('Load');
			loadButton.addEventListener(MouseEvent.CLICK, onLoad);
			loadButton.x = 11;
			loadButton.y = 66;
			addChild(loadButton);

			// play button
			playButton = new CustomButton('Play');
			playButton.addEventListener(MouseEvent.CLICK, onPlay);
			playButton.x = 165;
			playButton.y = 66;
			addChild(playButton);
		}
		else {
			// "auto cache" label
			t = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.background = true;
			t.backgroundColor = 0xE01B4B;
			t.defaultTextFormat = new TextFormat('Arial', 10, 0xFFFFFF);
			t.selectable = false;
			t.text = 'AUTO CACHE';
			addChild(t);

			// play button
			playButton = new CustomButton('Play', 162);
			playButton.addEventListener(MouseEvent.CLICK, onPlay);
			playButton.x = 79;
			playButton.y = 66;
			addChild(playButton);
		}

		// separator
		var s:Separator = new Separator();
		s.y = 111;
		addChild(s);
	}
}

function makeStatusTextField():TextField
{
	var textField:TextField = new TextField();
	textField.width = 320;
	textField.height = 36;
	textField.multiline = true;
	textField.wordWrap = true;
	textField.defaultTextFormat = new TextFormat('Arial', 10, 0x0C2033);
	return textField;
}
