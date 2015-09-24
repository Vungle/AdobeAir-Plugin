package
{
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
import com.vungle.extensions.*;
import com.vungle.extensions.events.VungleEvent;
import flash.utils.setTimeout;

/** Vungle Example App */
public class VungleExample extends Sprite
{
	//
	// Definitions
	//

	//
	// Instance Variables
	//

	/** Status */
	private var txtStatus:TextField;

	/** Buttons */
	private var buttonContainer:Sprite;

	//
	// Public Methods
	//

	/** Create New VungleExample */
	public function VungleExample()
	{
		createUI();

		log("initializing Vungle...");

		// targeting a single platform (just just ios or just android)
		// Vungle.create(["your_app_id"]);
		// targeting both ios and android
		// Vungle.create(["ios_app_id", "android_app_id"]);

		// with ios and android targets, with optional parameters: prefer portrait ads, location-enabled, age, gender.
		try {
			Vungle.create(["com.vungle.anesampleios", "com.vungle.anesample"]);
		} catch (error:Error) {
			//log("Vungle is not supported on this platform (not android or ios!)");
			log(error.toString());
			return;
		}

		log("Vungle Initialized: v."+Vungle.VERSION+"/s:"+Vungle.vungle.getSdkVersion());

		// enable internal logging for debug purposes (iOS only)
		//Vungle.vungle.setLoggingEnabled(true);

		// use global ad config to set default values
		VungleAdConfig.globalConfig.orientation = VungleOrientation.ANDROID_AUTOROTATE;

		// this event fires when an ad is ready to play
		Vungle.vungle.addEventListener(VungleEvent.AD_PLAYABLE, onAdPlayable);
		// this event always fires when an ad is dismissed
		Vungle.vungle.addEventListener(VungleEvent.AD_FINISHED, onAdFinished);
		// this event always fires when ad is displayed
		Vungle.vungle.addEventListener(VungleEvent.AD_STARTED, onAdStarted);
		// Dispatched when an ad has been viewed.  The watched and length properties of the event
		// will be populated with the amount of the video watched, in seconds, and the total length
		// of the video in seconds, respectively, which are useful for rewarding incentivized views.
		// This event may not be called in some cases, such as when there is a pre-roll HTML asset
		// in the advertisement and the user opts out of the ad before seeing the video.  Listen for
		// VungleEvent.AD_FINISHED to capture an event whenever an ad has been dismissed.
		Vungle.vungle.addEventListener(VungleEvent.AD_VIEWED, onAdViewed);
		// this event fires when a log message is sent (iOS only)
		Vungle.vungle.addEventListener(VungleEvent.AD_LOG, onAdLog);
	}

	/** Display Ad */
	public function displayAd():void
	{
		// ensure an ad is available first.
		if (!Vungle.vungle.isAdAvailable())
		{
			log("No Ad available!");
			return;
		}

		log("Displaying interstitial ad...");
		Vungle.vungle.playAd();
		log("Waiting for interstitial ad...");
	}

	/** Display Incentivized Ad */
	public function displayIncentivizedAd():void
	{
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

	/** Enable Sound */
	public function enableSound():void
	{
		// turn video sound on
		VungleAdConfig.globalConfig.soundEnabled = true;
		log("Sound enabled.");
	}

	/** Disable Sound */
	public function disableSound():void
	{
		// mute video sound
		VungleAdConfig.globalConfig.soundEnabled = false;
		log("Sound disabled.");
	}

	//
	// Events
	//

	/** On Ad Playable */
	private function onAdPlayable(e:VungleEvent):void
	{
		// an ad is available - you can call playAd()
		log("Event: AdPlayable");
	}

	/** On Ad Finished */
	private function onAdFinished(e:VungleEvent):void
	{
		// the ad is done and you can return to your game, etc.
		log("Event: AdFinished: " + e.wasCallToActionClicked);
	}

	/** On Ad Started */
	private function onAdStarted(e:VungleEvent):void
	{
		// an ad has begun- you may wish to mute your game sounds, pause, etc.
		log("Event: AdStarted");
	}

	/** Ad Viewed */
	private function onAdViewed(e:VungleEvent):void
	{
		// ad view complete. for incentivized ads, you can use the watched/length
		// properties to determine if a reward should be given.
		log("Event: AdViewed: Time: ("+e.watched+"/"+e.length+")");
	}

	/** On Ad Log */
	private function onAdLog(e:VungleEvent):void
	{
		// a log message is sent by the SDK (iOS only)
		log("Event: AdLog: " + e.message);
	}

	//
	// Impelementation
	//
	// Code here sets up a basic UI for the plugin tester.
	//
	//

	/** Create UI */
	public function createUI():void
	{
		txtStatus=new TextField();
		txtStatus.defaultTextFormat=new flash.text.TextFormat("Arial",25,0xFFFFFF);
		txtStatus.width=stage.stageWidth;
		txtStatus.height=100;
		txtStatus.multiline=true;
		txtStatus.wordWrap=true;
		txtStatus.text="Ready";
		addChild(txtStatus);

		if (buttonContainer)
		{
			removeChild(buttonContainer);
			buttonContainer=null;
		}

		buttonContainer=new Sprite();
		buttonContainer.y=txtStatus.height;
		addChild(buttonContainer);

		var uiRect:Rectangle=new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
		var layout:ButtonLayout=new ButtonLayout(uiRect, 19);
		layout.addButton(new SimpleButton(new Command("Display Interstitial", displayAd)));
		layout.addButton(new SimpleButton(new Command("Display Incentivized Ad", displayIncentivizedAd)));
		layout.addButton(new SimpleButton(new Command("Sound ON", enableSound)));
		layout.addButton(new SimpleButton(new Command("Sound OFF", disableSound)));
		layout.attach(buttonContainer);
		layout.layout();
	}

	/** Log */
	private function log(msg:String):void
	{
		trace("[Vungle] "+msg);
		txtStatus.text=msg;
	}

}
}


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/** Simple Button */
class SimpleButton extends Sprite
{
	//
	// Instance Variables
	//

	/** Command */
	private var cmd:Command;

	/** Width */
	private var _width:Number;

	/** Label */
	private var txtLabel:TextField;

	//
	// Public Methods
	//

	/** Create New SimpleButton */
	public function SimpleButton(cmd:Command)
	{
		super();
		this.cmd=cmd;

		mouseChildren=false;
		mouseEnabled=buttonMode=useHandCursor=true;

		txtLabel=new TextField();
		txtLabel.defaultTextFormat=new TextFormat("Arial",44,0xFFFFFF);
		txtLabel.mouseEnabled=txtLabel.mouseEnabled=txtLabel.selectable=false;
		txtLabel.text=cmd.getLabel();
		txtLabel.autoSize=TextFieldAutoSize.LEFT;

		redraw();

		addEventListener(MouseEvent.CLICK,onSelect);
	}

	/** Set Width */
	override public function set width(val:Number):void
	{
		this._width=val;
		redraw();
	}


	/** Dispose */
	public function dispose():void
	{
		removeEventListener(MouseEvent.CLICK,onSelect);
	}

	//
	// Events
	//

	/** On Press */
	private function onSelect(e:MouseEvent):void
	{
		this.cmd.execute();
	}

	//
	// Implementation
	//

	/** Redraw */
	private function redraw():void
	{
		txtLabel.text=cmd.getLabel();
		_width=_width||txtLabel.width*1.1;

		graphics.clear();
		graphics.beginFill(0x444444);
		graphics.lineStyle(2,0);
		graphics.drawRoundRect(0,0,_width,txtLabel.height*1.1,txtLabel.height*.8);
		graphics.endFill();

		txtLabel.x=_width/2-(txtLabel.width/2);
		txtLabel.y=txtLabel.height*.05;
		addChild(txtLabel);
	}
}

/** Button Layout */
class ButtonLayout
{
	private var buttons:Array;
	private var rect:Rectangle;
	private var padding:Number;
	private var parent:DisplayObjectContainer;

	public function ButtonLayout(rect:Rectangle,padding:Number)
	{
		this.rect=rect;
		this.padding=padding;
		this.buttons=new Array();
	}

	public function addButton(btn:SimpleButton):uint
	{
		return buttons.push(btn);
	}

	public function attach(parent:DisplayObjectContainer):void
	{
		this.parent=parent;
		for each(var btn:SimpleButton in this.buttons)
		{
			parent.addChild(btn);
		}
	}

	public function layout():void
	{
		var btnX:Number=rect.x+padding;
		var btnY:Number=rect.y;
		for each( var btn:SimpleButton in this.buttons)
		{
			btn.width=rect.width-(padding*2);
			btnY+=this.padding;
			btn.x=btnX;
			btn.y=btnY;
			btnY+=btn.height;
		}
	}
}

/** Inline Command */
class Command
{
	/** Callback Method */
	private var fnCallback:Function;

	/** Label */
	private var label:String;

	//
	// Public Methods
	//

	/** Create New Command */
	public function Command(label:String,fnCallback:Function)
	{
		this.fnCallback=fnCallback;
		this.label=label;
	}

	//
	// Command Implementation
	//

	/** Get Label */
	public function getLabel():String
	{
		return label;
	}

	/** Execute */
	public function execute():void
	{
		fnCallback();
	}
}
