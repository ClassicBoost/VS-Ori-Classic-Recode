package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import flixel.util.FlxColor;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var treeeees:FNFSprite;
	var gang:FNFSprite;
	var skyboxnight:FNFSprite;
	var cloudsnight:FNFSprite;
	var wtfisthatlmaonight:FNFSprite;
	var mountainsnight:FNFSprite;
	var spirittreenight:FNFSprite;
	var backgroundtreesnight:FNFSprite;
	var grassnight:FNFSprite;
	var clouds:FNFSprite;
	var treeeeesnight:FNFSprite;

	var skybox:FNFSprite;
	var wtfisthatlmao:FNFSprite;
	var spirittree:FNFSprite;
	var mountains:FNFSprite;
	var backgroundtrees:FNFSprite;
	var grass:FNFSprite;

	private var darkshitlol:Float = 0; // used for spirit tree
	private var removelight:Float = 1;

	public static var time:String = '';
	public static var mood:String = '';

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'spirit-tree':
					curStage = 'forest';
					time = '';
					mood = '';
				case 'rtl','restoring-the-light':
					curStage = 'forest';
					time = '-dark';
					mood = '';
				case 'decay':
					curStage = 'niwen';
					time = '';
					mood = 'evil';
				case 'trirotation':
					curStage = 'forest';
					time = '-dark';
					mood = 'rain';
				case 'tutorial' | 'test':
					curStage = 'stage';
					time = '';
					mood = '';
				default:
					curStage = 'void';
					time = '';
					mood = '';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'forest':
				PlayState.defaultCamZoom = 0.6;
				curStage = 'forest';

				skybox = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/$curStage/bg' + time));
				skybox.antialiasing = true;
				skybox.setGraphicSize(Std.int(skybox.width * 3));
				skybox.scrollFactor.set(0.01, 0.01);

				clouds = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/$curStage/clouds' + time));
				clouds.antialiasing = true;
				clouds.setGraphicSize(Std.int(clouds.width * 2));
				clouds.scrollFactor.set(0.05, 0.05); // should I lower this?

				wtfisthatlmao = new FNFSprite(-100, -300).loadGraphic(Paths.image('backgrounds/$curStage/thingyintheback' + time));
				wtfisthatlmao.antialiasing = true;
				wtfisthatlmao.setGraphicSize(Std.int(wtfisthatlmao.width * 2));
				wtfisthatlmao.scrollFactor.set(0.07, 0.07);

				mountains = new FNFSprite(-100, -300).loadGraphic(Paths.image('backgrounds/$curStage/twomountains' + time));
				mountains.antialiasing = true;
				mountains.setGraphicSize(Std.int(mountains.width * 2));
				mountains.scrollFactor.set(0.07, 0.07);

				spirittree = new FNFSprite(100, -150).loadGraphic(Paths.image('backgrounds/$curStage/tree' + time));
				spirittree.antialiasing = true;
				spirittree.setGraphicSize(Std.int(spirittree.width * 2));
				spirittree.scrollFactor.set(0.3, 0.3);

				backgroundtrees = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/$curStage/twobushes' + time));
				backgroundtrees.antialiasing = true;
				backgroundtrees.setGraphicSize(Std.int(backgroundtrees.width * 2));
				backgroundtrees.scrollFactor.set(0.7, 0.7);

				grass = new FNFSprite(0, 100).loadGraphic(Paths.image('backgrounds/$curStage/gss' + time));
				grass.antialiasing = true;
				grass.setGraphicSize(Std.int(grass.width * 2));
				grass.scrollFactor.set(1, 1);

				// these are used for the night cycle.
				skyboxnight = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/$curStage/bg-dark'));
				skyboxnight.antialiasing = true;
				skyboxnight.setGraphicSize(Std.int(skyboxnight.width * 3));
				skyboxnight.scrollFactor.set(0.01, 0.01);

				cloudsnight = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/$curStage/clouds-dark'));
				cloudsnight.antialiasing = true;
				cloudsnight.setGraphicSize(Std.int(cloudsnight.width * 2));
				cloudsnight.scrollFactor.set(0.05, 0.05); // should I lower this?

				wtfisthatlmaonight = new FNFSprite(-100, -300).loadGraphic(Paths.image('backgrounds/$curStage/thingyintheback-dark'));
				wtfisthatlmaonight.antialiasing = true;
				wtfisthatlmaonight.setGraphicSize(Std.int(wtfisthatlmaonight.width * 2));
				wtfisthatlmaonight.scrollFactor.set(0.07, 0.07);

				mountainsnight = new FNFSprite(-100, -300).loadGraphic(Paths.image('backgrounds/$curStage/twomountains-dark'));
				mountainsnight.antialiasing = true;
				mountainsnight.setGraphicSize(Std.int(mountainsnight.width * 2));
				mountainsnight.scrollFactor.set(0.07, 0.07);

				spirittreenight = new FNFSprite(100, -150).loadGraphic(Paths.image('backgrounds/$curStage/tree-dark'));
				spirittreenight.antialiasing = true;
				spirittreenight.setGraphicSize(Std.int(spirittreenight.width * 2));
				spirittreenight.scrollFactor.set(0.3, 0.3);

				backgroundtreesnight = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/$curStage/twobushes-dark'));
				backgroundtreesnight.antialiasing = true;
				backgroundtreesnight.setGraphicSize(Std.int(backgroundtreesnight.width * 2));
				backgroundtreesnight.scrollFactor.set(0.7, 0.7);

				grassnight = new FNFSprite(0, 100).loadGraphic(Paths.image('backgrounds/$curStage/gss-dark'));
				grassnight.antialiasing = true;
				grassnight.setGraphicSize(Std.int(grassnight.width * 2));
				grassnight.scrollFactor.set(1, 1);

				gang = new FNFSprite(200, 400);
				gang.frames = Paths.getSparrowAtlas('backgrounds/$curStage/thegang');
				gang.animation.addByPrefix('bop', 'thegang idle0', 24, false);
				gang.antialiasing = true;
				gang.scrollFactor.set(0.9, 0.9);
				gang.setGraphicSize(Std.int(gang.width * 1));
				gang.updateHitbox();

				treeeees = new FNFSprite(100, 300).loadGraphic(Paths.image('backgrounds/$curStage/trees' + time));
				treeeees.antialiasing = true;
				treeeees.setGraphicSize(Std.int(treeeees.width * 2));
				treeeees.scrollFactor.set(1.2, 1.2);

				treeeeesnight = new FNFSprite(100, 300).loadGraphic(Paths.image('backgrounds/$curStage/trees-dark'));
				treeeeesnight.antialiasing = true;
				treeeeesnight.setGraphicSize(Std.int(treeeeesnight.width * 2));
				treeeeesnight.scrollFactor.set(1.2, 1.2);

				add(skybox);
				add(skyboxnight);
				add(clouds);
				add(cloudsnight);
				add(wtfisthatlmao);
				add(wtfisthatlmaonight);
				add(mountains);
				add(mountainsnight);
				add(spirittree);
				add(spirittreenight);
				add(backgroundtrees);
				add(backgroundtreesnight);
				add(grass);
				add(grassnight);
				add(treeeees);
				add(treeeeesnight);

				skyboxnight.alpha = 0;
				cloudsnight.alpha = 0;
				wtfisthatlmaonight.alpha = 0;
				mountainsnight.alpha = 0;
				backgroundtreesnight.alpha = 0;
				spirittreenight.alpha = 0;
				grassnight.alpha = 0;
				grassnight.alpha = 0;
				treeeeesnight.alpha = 0;

				add(gang);


				clouds.alpha = 1;

				if (time == '-dark')
					gang.color = 0xFF5B5E7D;

				if (mood == 'rain') {
					wtfisthatlmao.color = 0xFF2B2B2B;
					mountains.color = 0xFF2B2B2B;
					spirittree.color = 0xFF2B2B2B;
					backgroundtrees.color = 0xFF2B2B2B;
					grass.color = 0xFF2B2B2B;
					treeeees.color = 0xFF2B2B2B;
					gang.alpha = 0;
				}

			case 'niwen':
				PlayState.defaultCamZoom = 0.45;
				curStage = 'niwen';

				var skybox:FNFSprite = new FNFSprite(0, -100).loadGraphic(Paths.image('backgrounds/$curStage/withered sky'));
				skybox.antialiasing = true;
				skybox.setGraphicSize(Std.int(skybox.width * 5));
				skybox.scrollFactor.set(0.01, 0.01);

				var trees:FNFSprite = new FNFSprite(100, -1300).loadGraphic(Paths.image('backgrounds/$curStage/backgroundtreeslol'));
				trees.antialiasing = true;
				trees.setGraphicSize(Std.int(trees.width * 4.5));
				trees.scrollFactor.set(0.7, 0.7);

				var fuckyouforest:FNFSprite = new FNFSprite(100, -1500).loadGraphic(Paths.image('backgrounds/$curStage/dieforest'));
				fuckyouforest.antialiasing = true;
				fuckyouforest.setGraphicSize(Std.int(fuckyouforest.width * 4.5));
				fuckyouforest.scrollFactor.set(0.9, 0.9);

				var ground:FNFSprite = new FNFSprite(100, -1500).loadGraphic(Paths.image('backgrounds/$curStage/gound'));
				ground.antialiasing = true;
				ground.setGraphicSize(Std.int(ground.width * 4.5));
				ground.scrollFactor.set(1, 1);

				var cliff:FNFSprite = new FNFSprite(-200, -1100).loadGraphic(Paths.image('backgrounds/$curStage/cliff shit'));
				cliff.antialiasing = true;
				cliff.setGraphicSize(Std.int(cliff.width * 4.5));
				cliff.scrollFactor.set(1, 1);

				var sauce:FNFSprite = new FNFSprite(100, -1500).loadGraphic(Paths.image('backgrounds/$curStage/extradip'));
				sauce.antialiasing = true;
				sauce.setGraphicSize(Std.int(sauce.width * 6));
				sauce.scrollFactor.set(1.1, 1.1);

				add(skybox);
				add(trees);
				add(fuckyouforest);
				add(ground);
				add(cliff);
				add(sauce);
			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'highway':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray)
		{
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
					/*
						if (isStoryMode)
						{
							camPos.x += 600;
							tweenCamIn();
					}*/
					/*
						case 'spirit':
							var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
							evilTrail.changeValuesEnabled(false, false, false, false);
							add(evilTrail);
					 */
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'forest','forest-rain':
				boyfriend.x = 1110;
				boyfriend.y = 720;

				gf.x = 510;
				gf.y = 420;

				dad.x = 250;
				dad.y = 550;
			case 'niwen':
				boyfriend.x = 1410;
				boyfriend.y = -500;

				gf.x = 1810;
				gf.y = -700;

				dad.x = -700;
				dad.y = -1200;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function triggerEvent(type:String = '', ?timer:Float = 0.01) {
		switch (type) {
		case 'night':
			FlxTween.tween(skyboxnight, {alpha: 1}, timer, {ease: FlxEase.linear});
			FlxTween.tween(cloudsnight, {alpha: 1}, timer, {ease: FlxEase.linear});
			FlxTween.tween(wtfisthatlmaonight, {alpha: 1}, timer, {ease: FlxEase.linear});
			FlxTween.tween(mountainsnight, {alpha: 1}, timer, {ease: FlxEase.linear});
			FlxTween.tween(backgroundtreesnight, {alpha: 1}, timer, {ease: FlxEase.linear});
			FlxTween.tween(spirittreenight, {alpha: 1}, timer, {ease: FlxEase.linear});
			FlxTween.tween(grassnight, {alpha: 1}, timer, {ease: FlxEase.linear});
			FlxTween.tween(treeeeesnight, {alpha: 1}, timer, {ease: FlxEase.linear});
			FlxTween.tween(clouds, {alpha: 0}, timer, {ease: FlxEase.linear});
		//	FlxTween.color(gang, FlxColor.WHITE, 5B5E7D, time, {ease: FlxEase.linear}); // Haxeflixel you are fucking retarded
		case 'normal':
			wtfisthatlmao.color = 0xFFFFFFFF;
			mountains.color = 0xFFFFFFFF;
			spirittree.color = 0xFFFFFFFF;
			backgroundtrees.color = 0xFFFFFFFF;
			grass.color = 0xFFFFFFFF;
			treeeees.color = 0xFFFFFFFF;
		}
	}

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{

		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'forest':
				gang.animation.play('bop',true);
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
