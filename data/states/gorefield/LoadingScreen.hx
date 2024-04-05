//
import Xml;
import funkin.backend.utils.WindowUtils;
import funkin.backend.MusicBeatState;
import openfl.Lib;
import haxe.format.JsonPrinter;
import funkin.backend.utils.DiscordUtil;
import haxe.format.JsonParser;

var pizza:Character;
var black:FlxSprite;

var finishedLoading:Bool = false;
var pressedEnter:Bool = false;

var skipLoadingAllowed:Bool = FlxG.save.data.dev;

function create() {
	if (FlxG.sound.music != null) FlxG.sound.music.stop();
	
	var easterEggs:Array<String> = [
		"assets/data/loadingscreens/thuggin.json",
		"assets/data/loadingscreens/WAZAJON.json"
	];
	var path:String = "assets/songs/" + PlayState.SONG.meta.name.toLowerCase() + "/loadingscreen.json";
	if (FlxG.save.data.baby) path = "assets/data/loadingscreens/noob.json";

	if (FlxG.random.bool(1) && PlayState.SONG.meta.name.toLowerCase() != "cataclysm" ) path = easterEggs[FlxG.random.int(0, easterEggs.length-1)];
	var loadingData:Dynamic = {
		loadingbg: "loadingbg1",
		loadingimage: "rightloadingimage1",
		loadinganim: "BF 1",
		loadingpos: [561.46, -42.08],
		loadingscale: 0.68,
		loadingantialiasing: 1 // You gotta use 1 to true ._: -EstoyAburridow
	};

	if (Assets.exists(path)) loadingData = Json.parse(Assets.getText(path));
	else trace("LOADING SCREEN NOT FOUND!!!11 | PATH: " + path);

	var colorbg:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.fromRGB(15, 35, 52));
	colorbg.updateHitbox();
	colorbg.screenCenter();
	add(colorbg);

	var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loadingscreens/' +loadingData.loadingbg));
	if (loadingData.loadingbg != 'loadingbg1' && loadingData.loadingbg != 'pantalla_azul_2' && loadingData.loadingbg != 'loadingbg3')
		bg.scale.set(0.68, 0.68);
	bg.screenCenter();
	bg.antialiasing = true;
	add(bg);
	if (loadingData.bgOffset != null) bg.offset.set(loadingData.bgOffset[0], loadingData.bgOffset[1]);

	if (loadingData.loadingscale == null)
		loadingData.loadingscale = 0.68;

	if (loadingData.loadingantialiasing == null)
		loadingData.loadingantialiasing = 1;

	var portrait:FlxSprite = new FlxSprite();
	if (loadingData.loadinganim == null || loadingData.loadinganim == "")
		portrait.loadGraphic(Paths.image('loadingscreens/' + loadingData.loadingimage));
	else
	{
		portrait.frames = Paths.getSparrowAtlas('loadingscreens/' + loadingData.loadingimage);
		portrait.animation.addByPrefix('idle', loadingData.loadinganim, 24, true);
		portrait.animation.play('idle');
	}

	portrait.scale.set(loadingData.loadingscale, loadingData.loadingscale);
	portrait.updateHitbox();

	portrait.setPosition(loadingData.loadingpos[0], loadingData.loadingpos[1]);
	portrait.antialiasing = (loadingData.loadingantialiasing == 1);
	add(portrait);

	pizza = new Character(0,0, "loading");
	pizza.updateHitbox();
	pizza.x = 0 - (pizza.width / 3.5) + 1;
	pizza.y = FlxG.height - (pizza.height + (pizza.height / 2)) - 2;
	add(pizza);
	pizza.playAnim('idle');

	black = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
	add(black);

	if(PlayState.isStoryMode) {
		/*trace(PlayState.storyWeek);
		FlxG.save.data.gorePoint = {
			storyWeek: JsonParser.parse(JsonPrinter.print(PlayState.storyWeek)),
			storyPlaylist: JsonParser.parse(JsonPrinter.print(PlayState.storyPlaylist)),
			campaignScore: PlayState.campaignScore,
			campaignMisses: PlayState.campaignMisses,
			campaignAccuracyTotal: PlayState.campaignAccuracyTotal,
			campaignAccuracyCount: PlayState.campaignAccuracyCount,
			opponentMode: PlayState.opponentMode,
			coopMode: PlayState.coopMode,
			difficulty: PlayState.difficulty,
		}
		trace(FlxG.save.data.gorePoint);*/

		if(PlayState.storyWeek != null){
			if(weekProgress.get(PlayState.storyWeek.name) != null){
				if (weekProgress.get(PlayState.storyWeek.name).song.toLowerCase() != PlayState.SONG.meta.name.toLowerCase()){
					weekProgress.set(PlayState.storyWeek.name, {song: PlayState.SONG.meta.name.toLowerCase(), weekMisees: PlayState.campaignMisses, weekScore: PlayState.campaignScore, deaths: PlayState.deathCounter});
					trace("Saved Progress For " + PlayState.storyWeek.name + " in LoadingScreen");
				}
			}
		}
		FlxG.save.data.weekProgress = weekProgress;
		FlxG.save.flush();
	}

	FlxG.sound.play(Paths.sound(PlayState.SONG.meta.name.toLowerCase() == "cataclysm" ? "godloadingsound" : "loadingsound"));

	new FlxTimer().start(1.5, (tmr:FlxTimer) -> {
		FlxTween.tween(black, {alpha: 0}, 0.5, {onComplete: (tween:FlxTween) -> {loadAssets();}});
	});
	window.title = windowTitleGOREFIELD + " - Loading";
	MusicBeatState.skipTransOut = true;

	DiscordUtil.changePresence('Loading...', "");
}

function update(elapsed:Float) {
	if (FlxG.keys.justPressed.ESCAPE && skipLoadingAllowed)
		FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
	if (FlxG.keys.justPressed.ENTER && !pressedEnter && (skipLoadingAllowed == true ? true : finishedLoading)) {goToSong(); pressedEnter = true;}
}

function loadAssets() { // GET BAMBOOZLED LLLLL YOU THOUGHT IT WAS ACUTTALY LOADING
	var timeToLoadalldat = 0;

	for (sprite in 0...FlxG.random.int(8, 14)) {
		timeToLoadalldat += FlxG.random.float(0.1, 0.225);
	}

	new FlxTimer().start(timeToLoadalldat, (tmr:FlxTimer) -> {
		pizza.playAnim('enter');
		pizza.animation.finishCallback = (name:String) -> {if (name == 'enter') {pizza.playAnim('enterloop'); finishedLoading = true;}};
	});
}

function goToSong() {
	FlxTween.tween(black, {alpha: 1}, 0.75, {onComplete: (tween:FlxTween) -> {FlxG.switchState(new PlayState());}});
}