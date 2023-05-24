package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class SelectGameState extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Float = 0;

	var bg:FlxSprite; // the background has been separated for more control
	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var optionShit:Array<String> = [''];
	var canSnap:Array<Float> = [];

	public static var inpurgatory:Bool = false;
	public static var memorizestate:String = 'select';
	public var playothermusiclol:Bool = false;
	var catagoryversion:FlxText;
	var mainBUTTON:FlxSprite;
	var purgatoryBUTTON:FlxSprite;

	// the create 'state'
	override function create()
	{
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if DISCORD_RPC
		Discord.changePresence('MENU SCREEN', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		// background
		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/select/bg'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		mainBUTTON = new FlxSprite();
		mainBUTTON.frames = Paths.getSparrowAtlas('menus/base/select/main');
		mainBUTTON.animation.addByPrefix('idle', 'idle', 24, true);
		mainBUTTON.animation.addByPrefix('select', 'select', 24, true);
		mainBUTTON.animation.play('select', true);
		mainBUTTON.x = 150;
		mainBUTTON.y = 200;
		mainBUTTON.scrollFactor.x = 0;
		mainBUTTON.scrollFactor.y = 0;
		mainBUTTON.setGraphicSize(Std.int(mainBUTTON.width * 0.7));
		mainBUTTON.updateHitbox();
		add(mainBUTTON);

		purgatoryBUTTON = new FlxSprite();
		purgatoryBUTTON.frames = Paths.getSparrowAtlas('menus/base/select/purgatory');
		purgatoryBUTTON.animation.addByPrefix('idle', 'idle', 24, true);
		purgatoryBUTTON.animation.addByPrefix('select', 'select', 24, true);
		purgatoryBUTTON.animation.play('select', true);
		purgatoryBUTTON.x = 900;
		purgatoryBUTTON.y = 200;
		purgatoryBUTTON.scrollFactor.x = 0;
		purgatoryBUTTON.scrollFactor.y = 0;
		purgatoryBUTTON.setGraphicSize(Std.int(purgatoryBUTTON.width * 0.7));
		purgatoryBUTTON.updateHitbox();
		add(purgatoryBUTTON);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Axolotl Engine v" + Main.axolotlVersion + " (FE v" + Main.gameVersion + ")", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('alex.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		catagoryversion = new FlxText(12, FlxG.height - 24, 0, "whats up guys quandale dingle here", 12);
		catagoryversion.screenCenter(X);
		catagoryversion.setFormat(Paths.font('alex.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		catagoryversion.scrollFactor.set();
		catagoryversion.y = 30;
		add(catagoryversion);

		// add the camera
		camFollow = new FlxObject(0, 0, 0, 0);
		add(camFollow);

		// set the camera to actually follow the camera object that was created before
		var camLerp = Main.framerateAdjust(0.10);
		FlxG.camera.follow(camFollow, null, camLerp);

		// from the base game lol

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Axolotl Engine v" + Main.axolotlVersion + " (FE v" + Main.gameVersion + ")", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('alex.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		//
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);

		var up = controls.UI_LEFT;
		var down = controls.UI_RIGHT;
		var up_p = controls.UI_LEFT_P;
		var down_p = controls.UI_RIGHT_P;
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if ((controlArray.contains(true)) && (!selectedSomethin))
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curSelected--;
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curSelected++;
			}
		}
		else
		{
			// reset variables
			counterControl = 0;
		}

		if (controls.BACK) {
			Main.switchState(this, new TitleState());
		}

		if ((controls.ACCEPT) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.sound.music.stop();

			switch (curSelected)
			{
			case 0:
				//	MusicBeatState.switchState(new OutdatedState());
				Main.switchState(this, new MainMenuState());
				memorizestate = 'main';
				FlxG.sound.playMusic(Paths.music('still'), 0.7);
			case 1:
			/*	Main.switchState(this, new PURFreeplayState());
				FlxG.sound.playMusic(Paths.music('purFreakyMenu'), 1);
				inpurgatory = true;
				memorizestate = 'purgatory';*/
			}
		}

		if (curSelected == 0) {
			mainBUTTON.animation.play('select', true);
			purgatoryBUTTON.animation.play('idle', true);
		}
		if (curSelected == 2) {
			mainBUTTON.animation.play('idle', true);
			purgatoryBUTTON.animation.play('select', true);
		}

		if (curSelected > 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 1;

		super.update(elapsed);
	}

	var lastCurSelected:Int = 0;
}
/*package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;
using StringTools;
// I pretty much stole the code from another mod that my friend made.
class SelectGameState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	public static var inpurgatory:Bool = false;
	public static var memorizestate:String = 'select';
	var optionShit:Array<String> = [
		'main',
		'purgatory'
	];
	var bg:FlxSprite; // the background has been separated for more control
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public var playothermusiclol:Bool = false;
	var camFollowPos:FlxObject;
	var catagoryversion:FlxText;
	var mainBUTTON:FlxSprite;
	var purgatoryBUTTON:FlxSprite;

	override function create()
	{
		#if DISCORD_RPC
		Discord.changePresence('SELECT GAME', 'Main Menu');
		#end
		inpurgatory = false;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/select/bg'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		mainBUTTON = new FlxSprite();
		mainBUTTON.frames = Paths.getSparrowAtlas('menus/base/select/main');
		mainBUTTON.animation.addByPrefix('idle', 'idle', 24, true);
		mainBUTTON.animation.addByPrefix('select', 'select', 24, true);
		mainBUTTON.animation.play('select', true);
		mainBUTTON.x = 150;
		mainBUTTON.y = 200;
		mainBUTTON.updateHitbox();
		add(mainBUTTON);

		purgatoryBUTTON = new FlxSprite();
		purgatoryBUTTON.frames = Paths.getSparrowAtlas('menus/base/select/purgatory');
		purgatoryBUTTON.animation.addByPrefix('idle', 'idle', 24, true);
		purgatoryBUTTON.animation.addByPrefix('select', 'select', 24, true);
		purgatoryBUTTON.animation.play('select', true);
		purgatoryBUTTON.x = 1000;
		purgatoryBUTTON.y = 200;
		purgatoryBUTTON.updateHitbox();
		add(purgatoryBUTTON);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Axolotl Engine v" + Main.axolotlVersion + " (FE v" + Main.gameVersion + ")", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('alex.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		catagoryversion = new FlxText(12, FlxG.height - 24, 0, "whats up guys quandale dingle here", 12);
		catagoryversion.screenCenter(X);
		catagoryversion.setFormat(Paths.font('alex.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		catagoryversion.scrollFactor.set();
		catagoryversion.y = 30;
		add(catagoryversion);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		catagoryversion.screenCenter(X);

		if (curSelected == 0) catagoryversion.text = 'v3.7\n(Released: March 30th, 2022)\n';
		else if (curSelected == 1) catagoryversion.text = 'Pre-Alpha\n(Released: June 30th, 2022)\n';
		else catagoryversion.text = 'CANCELED\n';

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.sound.music.stop();

				switch (optionShit[curSelected])
				{
					case 'main':
					//	MusicBeatState.switchState(new OutdatedState());
					Main.switchState(this, new MainMenuState());
					memorizestate = 'main';
					FlxG.sound.playMusic(Paths.music('still'), 0.7);
				case 'purgatory':
				/*	Main.switchState(this, new PURFreeplayState());
					FlxG.sound.playMusic(Paths.music('purFreakyMenu'), 1);
					inpurgatory = true;
					memorizestate = 'purgatory';
				}
			}
		}

		if (controls.BACK) {
			Main.switchState(this, new TitleState());
		}

		if (curSelected == 0) {
			mainBUTTON.animation.play('select', true);
			purgatoryBUTTON.animation.play('idle', true);
		}
		if (curSelected == 2) {
			mainBUTTON.animation.play('idle', true);
			purgatoryBUTTON.animation.play('select', true);
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		FlxG.sound.play(Paths.sound('scrollMenu'));

		if (curSelected > 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 1;

	/*	if (curSelected == 0)
			FlxG.sound.playMusic(Paths.music('Blind-Forest-Prototype'), 0.7);
		if (curSelected == 1)
			FlxG.sound.playMusic(Paths.music('purgatory'), 0.7);
		if (curSelected == 2)
			FlxG.sound.playMusic(Paths.music('ghost-of-ratman'), 0.7);
	}
}*/