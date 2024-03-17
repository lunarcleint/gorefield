//
import flixel.FlxObject;
import funkin.savedata.FunkinSave;
import funkin.backend.assets.AssetsLibraryList.AssetSource;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormat;
import flixel.text.FlxTextFormatMarkerPair;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.FlxInterpolateColor;
import Xml;
import StringTools;
import openfl.ui.Mouse;
import openfl.geom.Rectangle;
import funkin.backend.utils.DiscordUtil;
import openfl.desktop.Clipboard;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.MusicBeatState;
import funkin.backend.scripting.GlobalScript;
import funkin.menus.FreeplaySonglist;
import funkin.savedata.HighscoreEntry;
import Type;
import Date;

importScript("data/scripts/menuVars");

var canMove:Bool = true;

var menuOptions:Array<FlxSprite> = [];
var menuLocks:Array<FlxSprite> = [];
var selector:FlxSprite;

var curWeek:Int = curStoryMenuSelected;

var camBG:FlxCamera = null;
var bgSprite:FlxBackdrop;
var camText:FlxCamera = null;

var bloomShader:CustomShader = null;
var warpShader:CustomShader = null;

var weekText:FlxText;
var flavourText:FlxText;
var textBG:FlxSprite;
var vigentte:FunkinSprite;

var scoreText:FlxText;
var textInfoBG:FlxSprite;
var black:FlxSprite;
var bgShader:CustomShader;

var weeks:Array = [
	{name: "Principal Week...", songs: ["The Great Punishment", "Curious Cat", "Metamorphosis", "Hi Jon", "Terror in the Heights", "BIGotes"]},
	{name: "Lasagna Boy Week...", songs: ["Fast Delivery", "Health Inspection"]},
	{name: "Sansfield Week...", songs: ["Cat Patella", "Mondaylovania", "ULTRA FIELD"]},
	{name: "ULTRA Week...", songs: ["The Complement", "R0ses and Quartzs"]},
	{name: "Cryfield Week...", songs: ["Cryfield", "Nocturnal Meow"]},
	{name: "Godfield's Will...", songs: ["Cataclysm"]},
	{name: "Binky Circus...", songs: ["Laughter and Cries"]},
	{name: "Cartoon World...", songs: ["Balls of Yarn"]},
	{name: "Code Songs...", songs: FlxG.save.data.extrasSongs}
];

var weekColors:Array<Int> = [
	0xFFFF9500,
	0xFF1EA725,
	0xFF008DA9,
	0xFF727272,
	0xFFEB4108,
	0xFFFFFFFF,
	0xFFFFFFFF,
	0xFFFFFFFF,
	0xFF90D141
];

var weeksUnlocked:Array<Bool> = []; //week access
var weeksFinished:Array<Bool> = []; //freeplay access
var codesUnlocked:Bool = false;
var codeWeekUnlocked:Bool = false;
var weekDescs:Array<String> = [
	"Lasagna smells delicious...",
	"Midnight meal??? (yum)",
	"Purring Determination...",
	"A Big Little Problem.",
	"He Just Wants To Go Home...",
	"Enlightenment Awaits.",
	"Honk Honk...",
	"A Feline Meeting...",
	"Extra stuff..."
];

//cool shader
public var chromatic:CustomShader;
public var chromatic2:CustomShader;

// SPANISH - Jloor 
// hi jloor -lunar
// Buenos dias -EstoyAburridow
var weekDescsSPANISH:Array<String> = [
	"La Lasaña huele deliciosa...",
	"Comida de medianoche??? (yum)",
	"Un ronroneo de determinacion...",
	"Un pequeno gran problema...",
	"El solo quiere volver a casa...",
	"El Despertar Espera.",
	"Honk Honk!",
	"Una reunion Felina...",
	"Contenido extra..."
];

var lerpColors = [];
var colowTwn:FlxTween;

// SUB MENU
var subMenuOpen:Bool = false;
var curSubMenuSelected:Int = 0;
var subOptions:Array<FlxText> = [];
var subOptionsData:Array<Dynamic> = [];
var subMenuSelector:FlxSprite;
var selectorBloom:CustomShader;
var selectorCam:FlxCamera = null;

// FREE PLAY
var __firstFreePlayFrame:Bool = true;
var inFreeplayMenu:Bool = false;
var freePlayMenuID:Int = -1;
var freeplayMenuText:FunkinText;
var freeplaySelected:Array<Int> = [0,0,0,0,0,0];
var freeplaySongLists = [
	{
		songs: ["The Great Punishment", "Curious Cat", "Metamorphosis", "Hi Jon", "Terror in the Heights", "BIGotes"],
		icons: ["gorefield-phase-0", "garfield", "gorefield-phase-2", "gorefield-phase-3", "gorefield-phase-4", "bigotes"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Fast Delivery", "Health Inspection"],
		icons: ["lasagnaboy-pixel", "lasagnaboy-pixel"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Cat Patella", "Mondaylovania", "ULTRA FIELD"],
		icons: ["sansfield", "sansfield", "ultrafield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["The Complement", "R0ses and Quartzs"],
		icons: ["ultra-gorefield-centipede", "ultra-gayfield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Cryfield", "Nocturnal Meow"],
		icons: ["cryfield", "cryfield-monster"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Cataclysm"],
		icons: ["god-ultragodfield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Laughter and Cries"],
		icons: ["garfield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: ["Balls of Yarn"],
		icons: ["garfield"],
		songMenuObjs: [],
		iconMenuObjs: []
	},
	{
		songs: FlxG.save.data.extrasSongs,
		icons: FlxG.save.data.extrasSongsIcons,
		songMenuObjs: [],
		iconMenuObjs: []
	}
];

// Television
var blackBackground:FlxSprite;
var videos:Array<FlxVideoSprite> = [];
var videosChannel:Array<String> = ["CH1","CH2","CH3","CH4", "CH5"];
static var curVideo:Int = 0;
var isTVOn:Bool = false;
var television:FlxSprite;
var channelBar:FlxSprite;
var fastForwardIcon:FlxSprite;
var pauseIcon:FlxSprite;
var videosHitbox:FlxObject;
var powerHitbox:FlxObject;
var pauseHitbox:FlxObject;
var speedHitbox:FlxObject;
var change1Hitbox:FlxObject;
var change2Hitbox:FlxObject;
var televisionTween:FlxTween;

// CODES MENU
var codesPanel:FlxSprite;
var codeColorLerp:FlxInterpolateColor;
var codesOpenHitbox:FlxObject;
var codesTween:FlxTween;
var codesOpened:Bool = false;
var lastFrameRateMode:Int = 1;
var codesTextHitbox:FlxObject;
var codesButton:FlxSprite;
// TEXT
var codesPosition:Int = 0;
var codesText:FunkinText;
var caretSpr:FlxSprite;
var codesFocused:Bool = false;
var codesSound:FlxSound;

var alphabet:String = "abcdefghijklmnopqrstuvwxyz ";
var numbers:String = "1234567890";
var symbols:String = "*[]^_.,'!?";

//PROGRESSION PROMPT
var boxSprite:FlxSprite;
var isInProgPrompt:Bool = false;
var yesText:FlxText;
var noText:FlxText;
var okText:FlxText;
var progInfoText:FlxText;
var onYes:Bool = true;

public var finishedCallback:Void->Void;
public var acceptedCallback:Void->Void;


//CODES LIST
var codesList:FlxSprite;
var gottenCodes:Array<String> = [];
var gottenCodeText:FlxTypedGroup<FunkinText> = [];
var codeListOpenHitbox:FlxObject;
var tabSprite:FlxSprite;

function create() {
	FlxG.mouse.visible = FlxG.mouse.useSystemCursor = true;
	FlxG.cameras.remove(FlxG.camera, false);
	DiscordUtil.changePresence('Scrolling Through Menus...', "Story Menu");
	PlayState.deathCounter = 0;

	weeksFinished = FlxG.save.data.weeksFinished;
	weeksUnlocked = FlxG.save.data.weeksUnlocked;
	codesUnlocked = FlxG.save.data.dev ? true : FlxG.save.data.codesUnlocked;
	codeWeekUnlocked = FlxG.save.data.extrasSongs.length != 0; 
	gottenCodes = FlxG.save.data.codesList;

	camBG = new FlxCamera(0, 0);
	selectorCam = new FlxCamera(0,0);
	camText = new FlxCamera(0, 0);

	for (cam in [camBG, FlxG.camera, selectorCam, camText])
		{FlxG.cameras.add(cam, cam == FlxG.camera); cam.bgColor = 0x00000000; cam.antialiasing = true;}

	CoolUtil.playMenuSong();
	camBG.bgColor = FlxColor.fromRGB(17,5,33);

	warpShader = new CustomShader("warp");
	warpShader.distortion = 0;
	if (FlxG.save.data.warp) FlxG.camera.addShader(warpShader);

	chromatic = new CustomShader("chromaticWarp");
    chromatic.distortion = 0; 
    if (FlxG.save.data.warp && (weeksUnlocked[5] && !weeksFinished[5])) {camText.addShader(chromatic);}

	chromatic2 = new CustomShader("chromaticWarp");
    chromatic2.distortion = 0; 
    if (FlxG.save.data.warp && (weeksUnlocked[5] && !weeksFinished[5])) {FlxG.camera.addShader(chromatic2); camBG.addShader(chromatic2);}

	bgSprite = new FlxBackdrop(Paths.image("menus/WEA_ATRAS"), 0x11, 0, 0);
	bgSprite.cameras = [camBG]; bgSprite.colorTransform.color = 0xFFFFFFFF;
	bgSprite.velocity.set(100, 100);
	add(bgSprite);

	colowTwn = FlxTween.color(null, 5.4, 0xFF90D141, 0xFFF09431, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/, onUpdate: function () {
		bgSprite.colorTransform.color = colowTwn.color;
	}});

	bgShader = new CustomShader("warp");
	bgShader.distortion = 2;
	if (FlxG.save.data.warp) camBG.addShader(bgShader);

	bloomShader = new CustomShader("glow");
	bloomShader.size = 18.0;// trailBloom.quality = 8.0;
    bloomShader.dim = 1;// trailBloom.directions = 16.0;
	if (FlxG.save.data.bloom) bgSprite.shader = bloomShader;

	for (i in 0...9) {
		var sprite:FlxSprite = new FlxSprite();
		sprite.frames = Paths.getSparrowAtlas("menus/storymenu/STORY_MENU_ASSETS");
		sprite.animation.addByPrefix("_", "STORY MENU 0" + Std.string(i + 1));
		sprite.animation.play("_");

		sprite.updateHitbox();
		sprite.offset.set();

		//sprite.screenCenter("X");
		sprite.y = (sprite.height + 35) * i;

		sprite.ID = i;
		menuOptions.push(add(sprite));

		lerpColors[i * 2 + 0] = new FlxInterpolateColor(((i == 8) ? !codeWeekUnlocked : weeksUnlocked[i] == false) ? 0 : -1);

		var lock:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/storymenu/candado"));
		lock.scale.set(.7,.7);
		lock.color = 0xFF92A2FF;
		lock.updateHitbox();
		menuLocks.push(add(lock));

		lerpColors[i * 2 + 1] = new FlxInterpolateColor(((i == 8) ? !codeWeekUnlocked : weeksUnlocked[i] == false) ? 0 : -1);
	}

	selector = new FlxSprite();
	selector.frames = Paths.getSparrowAtlas("menus/storymenu/STORY_MENU_ASSETS");
	selector.animation.addByPrefix("_", "SELECT");
	selector.animation.play("_");

	subMenuSelector = new FlxSprite().loadGraphic(Paths.image("menus/storymenu/sub_selector"));
	subMenuSelector.visible = subMenuSelector.active = false;
	subMenuSelector.antialiasing = true;
	subMenuSelector.cameras = [selectorCam];

	selector.updateHitbox();

	selector.alpha = 0;
	selector.angle = 45;
	add(selector);

	codesPanel = new FlxSprite(-415).loadGraphic(Paths.image("menus/storymenu/MENU_CODE_STATIC"));
	codesPanel.scale.set(551/codesPanel.height, 551/codesPanel.height);
	codesPanel.visible = codesUnlocked;
	add(codesPanel);

	codeColorLerp = new FlxInterpolateColor(-1);

	codesText = new FunkinText(0, 0, 295 - (24), "TYPE CODE HERE!!!", 24, true);
	codesText.setFormat("fonts/pixelart.ttf", 24, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	codesText.borderSize = 3;
	codesText.cameras = [camText];
	codesText.alpha = 0.4;
	add(codesText);

	caretSpr = new FlxSprite().loadGraphic(Paths.image("menus/storymenu/carcet"));
	caretSpr.cameras = [camText];
	add(caretSpr);

	codesButton = new FlxSprite();
	codesButton.frames = Paths.getSparrowAtlas("menus/storymenu/enter");
	codesButton.animation.addByPrefix("idle", "enter0000", 24, false);
	codesButton.animation.addByPrefix("press", "enter press", 24, false);
	codesButton.animation.play("idle");
	codesButton.cameras = [camText];
	add(codesButton);

	codesOpenHitbox = new FlxObject(0, 0, 70, 124);
	add(codesOpenHitbox);

	codesTextHitbox = new FlxObject(0, 0, 295, 45);
	add(codesTextHitbox);

	FlxG.stage.window.onKeyDown.add(onKeyDown);
	FlxG.stage.window.onTextInput.add(onTextInput);

	codesSound = FlxG.sound.load(Paths.sound('menu/story/Code_Write_Song'));

	preloadFreeplayMenus();

	weekText = new FunkinText(32, 20, FlxG.width, "WEEK NAME", 42, true);
	weekText.setFormat("fonts/pixelart.ttf", 54, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	weekText.borderSize = 4;
	weekText.scrollFactor.set();
	weekText.cameras = [camText];

	flavourText = new FunkinText(weekText.x, weekText.y + weekText.height + 10, FlxG.width, "Current Story Menu Description\nAnd Larger...", 18, true);
	flavourText.setFormat(Paths.font("Harbinger_Caps.otf"), 18, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	flavourText.borderSize = 2;
	flavourText.scrollFactor.set();
	flavourText.cameras = [camText];

	textBG = new FlxSprite().makeSolid(1, 1, 0xFF000000);
	textBG.scale.set(FlxG.width, flavourText.y + flavourText.height + 22);
	textBG.updateHitbox();
	textBG.alpha = 0.4;
	textBG.scrollFactor.set();
	add(textBG);
	add(weekText);
	add(flavourText);

	scoreText = new FunkinText(weekText.x, 0, FlxG.width, "WEEK SCORE - 10000000,   4 SONGS,    UNLOCKED!", 18, true);
	scoreText.setFormat("fonts/pixelart.ttf", 18, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	scoreText.borderSize = 2;
	scoreText.scrollFactor.set();
	scoreText.cameras = [camText];

	scoreText.applyMarkup("WEEK SCORE - $" + "10000000" + "$,   4 SONGS,    #" + "UNLOCKED!#", [
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), "$"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF00FF00), "#"),
	]);

	freeplayMenuText = new FunkinText(weekText.x, 0, 0, "FREEPLAY MENU", 18, true);
	freeplayMenuText.setFormat("fonts/pixelart.ttf", 22, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	freeplayMenuText.borderSize = 2; freeplayMenuText.x = FlxG.width - 32 - freeplayMenuText.width;
	freeplayMenuText.scrollFactor.set(); freeplayMenuText.alpha = 0;
	freeplayMenuText.cameras = [camText];

	textInfoBG = new FlxSprite().makeSolid(1, 1, 0xFF000000);
	textInfoBG.scale.set(FlxG.width, flavourText.y + flavourText.height + 22);
	textInfoBG.updateHitbox();
	textInfoBG.alpha = 0.4;
	textInfoBG.scrollFactor.set();
	add(textInfoBG);
	add(freeplayMenuText);
	add(scoreText);

	black = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
    add(black); black.alpha = 0;

	vigentte = new FunkinSprite().loadGraphic(Paths.image("menus/black_vignette"));
	vigentte.scrollFactor.set();
	vigentte.zoomFactor = 0;

	vigentte.cameras = [camText];
	vigentte.alpha = 0.5;
	add(vigentte);
	
	FlxTween.tween(selector, {angle: -90, alpha: 1}, 0.2, {ease: FlxEase.circInOut});

	blackBackground = new FlxSprite();
	blackBackground.makeSolid(FlxG.width, FlxG.height, 0xFF000000);
	blackBackground.cameras = [camText];
	blackBackground.visible = false;
	add(blackBackground);

	prevAutoPause = FlxG.autoPause;
	FlxG.autoPause = false; // Así evitamos que se añada el "resume" al momento de volver al juego y lo añadimos nosotros mismos con una condición -EstoyAburridow
	for (path in ["Odivision_Channel", "Fat_Cat_TV", "Purrfect_Show", "Funny_Clown", "The_Unknow_World"]) {
		video = new FlxVideoSprite(555, 186);
		video.bitmap.onFormatSetup.add(function()
		{
			video.scale.set(0.6, 0.6);
			video.updateHitbox(); 
		});
		video.load(Assets.getPath(Paths.video(path)), [':input-repeat=65535']); // Lunar, actualiza la hxvlc lib porfis :sob: -EstoyAburridow
		video.visible = false;

		videos.push(video);
		add(video);
	}
	FlxG.autoPause = prevAutoPause;

	if (FlxG.autoPause) 
	{
		for (video in videos)
			if (!FlxG.signals.focusLost.has(video.pause))
				FlxG.signals.focusLost.add(video.pause);
	
		if (!FlxG.signals.focusGained.has(focusGained))
			FlxG.signals.focusGained.add(focusGained);
	}

	television = new FlxSprite(-800, 200);
	television.loadGraphic(Paths.image("menus/storymenu/TV_CODE0002+TV_CODE0002"), true, 450, 465);
	television.animation.add("OFF", [0], 0, false); // "OFF" el videojuego!!1!!!11!111!! -EstoyAburridow
	television.animation.add("ON", [1], 0, false);
	television.animation.play("OFF");
	add(television);


	var channelBarName = videosChannel[curVideo];
	channelBar = new FlxSprite(700, 300);
	channelBar.loadGraphic(Paths.image("menus/storymenu/" + channelBarName));
	channelBar.scale.set(0.2,0.2);
	channelBar.visible = false;
	channelBar.updateHitbox();
	add(channelBar);

	fastForwardIcon = new FlxSprite(1000, 510);
	fastForwardIcon.loadGraphic(Paths.image("menus/storymenu/FASTZ"));
	fastForwardIcon.scale.set(0.35,0.35);
	fastForwardIcon.visible = false;
	fastForwardIcon.updateHitbox();
	add(fastForwardIcon);

	pauseIcon = new FlxSprite(700,510);
	pauseIcon.frames = Paths.getSparrowAtlas("menus/storymenu/Pause");
	pauseIcon.animation.addByPrefix("idle", "Pause Animation", 12, true);
	pauseIcon.animation.play("idle");
	pauseIcon.scale.set(0.3,0.3);
	pauseIcon.visible = false;
	pauseIcon.updateHitbox();
	add(pauseIcon);

	videosHitbox = new FlxObject(692, 281, 376, 292);
	add(videosHitbox);

	powerHitbox = new FlxObject(693, 590, 52, 52);
	add(powerHitbox);

	pauseHitbox = new FlxObject(755, 590, 52, 52);
	add(pauseHitbox);

	speedHitbox = new FlxObject(820, 590, 52, 52);
	add(speedHitbox);

	change1Hitbox = new FlxObject(926, 599, 35, 35);
	add(change1Hitbox);

	change2Hitbox = new FlxObject(971, 590, 35, 35);
	add(change2Hitbox);

	for (hitbox in [videosHitbox, powerHitbox, pauseHitbox, speedHitbox, change1Hitbox, change2Hitbox])
		hitbox.x -= 1000;

	boxSprite = new FlxSprite(0,730).loadGraphic(Paths.image("menus/storymenu/TEXT_BOX"));
	boxSprite.scale.set(1.1,1.1);
	boxSprite.updateHitbox();
	boxSprite.screenCenter(FlxAxes.X);
	boxSprite.scrollFactor.set();
	boxSprite.cameras = [camText];
	add(boxSprite);

	yesText = new FlxText(0, 0, 0, FlxG.save.data.spanish ? "SI" : "YES");
	noText = new FlxText(0, 0, 0, "NO");
	okText = new FlxText(0, 0, 0, "OK");

	progInfoText = new FlxText(0, 0, 900, "");
	
	for (text in [yesText, noText, okText, progInfoText]) {
		text.setFormat(Paths.font("Harbinger_Caps.otf"), 50, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
		text.borderSize = 4;
		text.scrollFactor.set();
		text.cameras = [camText];
		add(text);
	}
	okText.screenCenter(FlxAxes.X);
	progInfoText.screenCenter(FlxAxes.X);

	codesList = new FlxSprite(800,870).loadGraphic(Paths.image("menus/storymenu/papel"));
	codesList.scrollFactor.set();
	add(codesList);

	codeListOpenHitbox = new FlxObject(codesList.x, 2000, 455, 50);
	add(codeListOpenHitbox);

	gottenCodeText = new FlxTypedGroup();
	add(gottenCodeText);

	tabSprite = new FlxSprite(0, 611);
	tabSprite.loadGraphic(Paths.image("menus/storymenu/TAB"));
	tabSprite.camera = camText;
	tabSprite.visible = FlxG.save.data.canVisitArlene;
	add(tabSprite);

	changeWeek(0);

	if (fromMovieCredits) {
		openProgressPrompt(true,function(){},
			function(){fromMovieCredits = false;},
		function(){});
		progInfoText.text = FlxG.save.data.spanish ? "Post Game desbloqueado" : "Post Game unlocked";
		yesText.visible = noText.visible = false;
		okText.visible = true;
	}

	if(FlxG.save.data.arlenePhase >= 4 && FlxG.save.data.canVisitArlene){
		generateSECRET();
		codes.set(secretCode, function() CodesFunctions.selectSong("Laughter and Cries", "Binky_icon"));
	}
}

function updateCodesList(){
	for (sprite in gottenCodeText.members)
		sprite.destroy();

	for (i=>code in gottenCodes){
		var codeText:FunkinText;

		codeText = new FunkinText(0, 2000, 0, code, 40);
		codeText.setFormat("fonts/papercuts-2.ttf", 70, i % 3==0 ? 0xFF2B5325 : i % 3==2 ? 0xFF172556 : 0xFF3D2F23, "center", FlxTextBorderStyle.OUTLINE, 0xFFFBF5F5);
		codeText.borderSize = 7;
		codeText.scale.set(0.35,0.35);
		codeText.updateHitbox();
		codeText.ID = i;
		add(codeText);

		gottenCodeText.add(codeText);
	}
}

var codesListOpen:Bool = false;
function openCodesList(entered:Bool, ?exit:Bool = false, ?forced:Bool = false){
	if(codesListOpen == entered && !forced) return;

	FlxTween.cancelTweensOf(codesList);
	FlxTween.tween(codesList, {y: entered ? 150 : (exit ? 870 : 670)}, entered ? 0.7 : 0.4, {ease: FlxEase.cubeOut});
	codesListOpen = entered;

	if(entered){
		updateCodesList();
		FlxG.sound.play(Paths.sound('showPaper'));
	}else{FlxG.sound.play(Paths.sound('hidePaper'));}
}

var cancelCallback:Void->Void;
function openProgressPrompt(entered:Bool, ?finishCallback, ?accepted, ?cancel){
	isInProgPrompt = entered;
	FlxTween.cancelTweensOf(boxSprite);
	FlxTween.tween(boxSprite, {y: entered ? 150 : 730}, entered ? 0.7 : 0.4, {ease: FlxEase.cubeOut});

	yesText.visible = noText.visible = progInfoText.visible = true;
	okText.visible = false;

	finishedCallback = entered ? finishCallback : null;
	acceptedCallback = entered ? accepted : null;
	if (cancel != null)
		cancelCallback = cancel;
}

function handleProgressPrompt(){
	var scales:Array<Float> = [0.75, 1];
	var alphas:Array<Float> = [0.6, 1];
	var confirmInt:Int = onYes ? 1 : 0;

	yesText.alpha = alphas[confirmInt];
	yesText.scale.set(scales[confirmInt], scales[confirmInt]);
	noText.alpha = alphas[1 - confirmInt];
	noText.scale.set(scales[1 - confirmInt], scales[1 - confirmInt]);
}

var __firstFrame = true;
var __totalTime:Float = 0;

var colorLerpSpeed:Float = 1;
var selectingWeek:Bool = false;
var bloomSine:Bool = true;
var dim:Float = 0; var size:Float = 0;
var lerpMenuSpeed:Float = 1;
var updateCodeMenu:Bool = true;
var updateFreePlay:Bool = false;
var songLargeName:String = "";
var cursor:String = null;
var cacheRect:Rectangle = new Rectangle();
var cachePoint:FlxPoint = FlxPoint.get(0,0);
var cachePoint2:FlxPoint = FlxPoint.get(0,0);
var carcetTime:Float = 0;
function update(elapsed:Float) {
	__totalTime += elapsed;

	if (canMove && FlxG.keys.justPressed.TAB && !codesOpened && FlxG.save.data.canVisitArlene){
		canMove = false;
		codesMenu(false, -100);

		FlxTween.tween(selector, {angle: 45, alpha: 0}, .8, {ease: FlxEase.circOut});
		FlxTween.tween(textInfoBG, {alpha: 0}, 0.8, {ease: FlxEase.circOut});

		FlxG.sound.music.fadeOut(0.5);
		FlxG.sound.play(Paths.sound("menu/story/arleneSFX"));

		FlxTween.cancelTweensOf(tabSprite);
		tabSprite.x -= 80;
		FlxTween.tween(tabSprite, {x: 0}, 1, {ease: FlxEase.cubeOut});


		new FlxTimer().start(3.5, function(tmr){
			FlxG.switchState(new ModState("gorefield/easteregg/ArlenesCage"));
		});
	}
	
	if (curVideoMeme != null && controls.ACCEPT)
		curVideoMeme.onEndReached.dispatch();

	if (canMove)
		handleMenu();

	for (i=>menuOption in menuOptions) {
		var y:Float = ((FlxG.height - menuOption.height) / 2) + ((menuOption.ID - curWeek) * menuOption.height);
		var x:Float = 50 - ((Math.abs(FlxMath.fastCos((menuOption.y + (menuOption.height / 2) - (FlxG.camera.scroll.y + (FlxG.height / 2))) / (FlxG.height * 1.25) * Math.PI)) * 150)) + Math.floor(15 * FlxMath.fastSin(__totalTime + (0.8*i)));
		x += codesOpened ? 1000 : 0;

		if (i == curWeek && selectingWeek) {
			menuOption.y = CoolUtil.fpsLerp(menuOption.y, (FlxG.height/2) - (menuOption.height/2), 0.075);
			menuOption.x = CoolUtil.fpsLerp(menuOption.x, (FlxG.width/2) - (menuOption.width/2), 0.075);
		} else {
			menuOption.y = __firstFrame ? y : CoolUtil.fpsLerp(menuOption.y, y, inFreeplayMenu ? 0.016 : 0.25 * lerpMenuSpeed);
			menuOption.x = __firstFrame ? x : CoolUtil.fpsLerp(menuOption.x, FlxG.width - menuOption.width + 50 + x + (inFreeplayMenu ? 2500+(200*(i+1)) : 0), inFreeplayMenu ? 0.016 : 0.25 * lerpMenuSpeed);
			if (__firstFrame) menuOption.x += 2000 + (i *800);
		}

		if (menuOption.ID == 8){
			lerpColors[i * 2 + 0].fpsLerpTo(subMenuOpen ? 0xFF343434 : codeWeekUnlocked ? ((codesOpened ? 0xFF626262 : 0xFFFFFFFF)) : ( 0xFF0E0E0E), ((1/75) * colorLerpSpeed) * (codesOpened ? 3 : 1));
		}
		else{
			lerpColors[i * 2 + 0].fpsLerpTo(subMenuOpen ? 0xFF343434 : weeksUnlocked[i] ? ((codesOpened ? 0xFF626262 : 0xFFFFFFFF)) : ( 0xFF0E0E0E), ((1/75) * colorLerpSpeed) * (codesOpened ? 3 : 1));
		}
		menuOption.color = lerpColors[i * 2 + 0].color;
		if(!selectingWeek){
			if (menuOption.ID == 8){
				menuOption.alpha = codeWeekUnlocked ? 1 : 0.75;
			}
			else{
				menuOption.alpha = weeksUnlocked[i] ? 1 : 0.75;
			}
		}

		lerpColors[i * 2 + 1].fpsLerpTo(subMenuOpen ? 0xFF343434 : 0xFF92A2FF, (1/75) * colorLerpSpeed);

		var lock = menuLocks[i];
		lock.visible = (i == 8) ? !codeWeekUnlocked : !weeksUnlocked[i];
		lock.x = (menuOption.x + (menuOption.width/2)) - (lock.width/2) + Math.floor(4 * FlxMath.fastSin(__totalTime));
		lock.y = (menuOption.y + (menuOption.height/2)) - (lock.height/2) + Math.floor(2 * FlxMath.fastCos(__totalTime));
		if(!selectingWeek) lock.color = lerpColors[i * 2 + 1].color;
	}
	__firstFrame = false;

	if (subMenuOpen && subOptions.length > 0) {
		for (i=>option in subOptions) {
			option.x = ((menuOptions[curWeek].x + (menuOptions[curWeek].width/2)) - option.width/2) + Math.floor(4 * FlxMath.fastSin(__totalTime + (12*i)));
			option.y = (menuOptions[curWeek].y + (menuOptions[curWeek].height/2) - (((option.height + 16) * subOptions.length)/2)) + ((option.height + 16) * i) + Math.floor(2 * FlxMath.fastCos(__totalTime));
			option.alpha = option.ID == 0 ? i == curSubMenuSelected ? 1 : 0.2 : option.alpha;

			option.y += 10; // offset cause sprite epmty space (ZERO WHY!!@!@)
		}
		subMenuSelector.setPosition(subOptions[curSubMenuSelected].x - subMenuSelector.width - (10 + (2 * Math.floor(FlxMath.fastSin(__totalTime*2)))), subOptions[curSubMenuSelected].y+4);
	}
			
	selector.color = menuOptions[curWeek].color;
	selector.setPosition((menuOptions[curWeek].x - selector.width - 36), menuOptions[curWeek].y + ((menuOptions[curWeek].height/2) - (selector.height/2)));

	if (bloomSine) {
		bloomShader.dim = dim = .8 + (.3 * FlxMath.fastSin(__totalTime));
		bloomShader.size = size = 18 + (8 * FlxMath.fastSin(__totalTime));
	}

	selectorCam.visible = subMenuSelector.visible;
	//selectorBloom.size = 4 + (1 * FlxMath.fastSin(__totalTime));

	// Lean, por qué no hiciste mejor un FlxTypedGroup o un FlxSpriteGroup :sob: -EstoyAburridow
	yesText.x = boxSprite.x * 4.8;
	yesText.y = boxSprite.y + 380;

	noText.x = boxSprite.x * 16.5;
	noText.y = boxSprite.y + 380;

	okText.y = boxSprite.y + 340;

	progInfoText.y = boxSprite.y + 190;

	codeListOpenHitbox.setPosition(codesList.x,codesList.y);

	for (sprite in gottenCodeText.members)
		sprite.setPosition(codesList.x + (sprite.ID % 2 == 1 ? 240 : 67),codesList.y + (15 * sprite.ID) + (sprite.ID%2 == 1 ? 35 : 54));

	cursor = null;
	if (updateCodeMenu) {
		codesPanel.updateHitbox();
		codesPanel.screenCenter(0x10);
		codesPanel.y += 65 + (8*FlxMath.fastSin(__totalTime));

		codeColorLerp.fpsLerpTo(0xFFFFFFFF, (1/75) * 2.25);
		codesPanel.color = codeColorLerp.color;
		
		codesOpenHitbox.x = codesPanel.x + 415;
		codesOpenHitbox.screenCenter(0x10);
		codesOpenHitbox.y += 50;

		codesTextHitbox.x = codesPanel.x + 24;
		codesTextHitbox.y = codesPanel.y + 258;

		codesText.x = codesPanel.x + 24 + 12;
		codesText.y = codesTextHitbox.y + (codesTextHitbox.height/2) - (codesText.height/2);

		codesButton.x = codesPanel.x + 103;
		codesButton.y = codesPanel.y + 330;
		codesButton.color = codesText.color = codesPanel.color;

		var lastOpened:Bool = codesOpened;
		if (canMove) {
			// Tal vez luego yo intente mejorar esto usando Typedefs -EstoyAburridow
			if (FlxG.mouse.overlaps(powerHitbox)) {
				cursor = "button";
				if (FlxG.mouse.justReleased) 
					turnTV(!isTVOn);
			}
			if (FlxG.mouse.overlaps(codeListOpenHitbox)) {
				cursor = "button";
				if (FlxG.mouse.justReleased) {
					openCodesList(codesListOpen == false ? true : false);
				}

			} else if (FlxG.mouse.overlaps(codesOpenHitbox)) {
				if(!codesUnlocked || isInProgPrompt) return;

				cursor = "button";
				if (FlxG.mouse.justReleased) {
					codesMenu(!codesOpened, 0);
					FlxG.sound.play(Paths.sound('menu/story/Open_and_Close_Secret_Menu'));
				}
			} else if (FlxG.mouse.overlaps(codesTextHitbox)) {
				cursor = "ibeam";
				if (FlxG.mouse.justReleased) 
				{
					if (codesText.alpha != 1)
					{
						codesText.text = "";
						codesText.alpha = 1;
					}

					codesFocused = true; carcetTime = 0;
					codesPosition = codesText.text.length;
		
					// Position from mouse
					cachePoint2.set(FlxG.mouse.screenX-codesText.x, FlxG.mouse.screenY-codesText.y);
					if (cachePoint2.x < 0)
						codesPosition = 0;
					else {
						var index = codesText.textField.getCharIndexAtPoint(cachePoint2.x, cachePoint2.y);
						if (index > -1) codesPosition = index;
					}
				}
					
			} else if (FlxG.mouse.overlaps(codesButton)) {
				cursor = "button";
				if (FlxG.mouse.justReleased) {
					codesButton.animation.play("press", true);
					if (codes.exists(codesText.text))
						selectCode();
					else incorrectCode();
				}
			} else if (isTVOn) {
				if (FlxG.mouse.overlaps(videosHitbox)) {
					cursor = "button";
					if (FlxG.mouse.justReleased)
						fullscreenVideo(true);
				} else if (FlxG.mouse.overlaps(pauseHitbox)) {
					cursor = "button";
					if (FlxG.mouse.justReleased)
					{
						videos[curVideo].togglePaused();
						videoWasPaused = !videoWasPaused;
						pauseIcon.visible = videoWasPaused;

						if(!videoWasPaused)
							openCodesList(false);
					}
				} else if (FlxG.mouse.overlaps(speedHitbox)) {
					cursor = "button";
					if (FlxG.mouse.justReleased){
						var thatBool = (videos[curVideo].bitmap.rate == 1);
						videos[curVideo].bitmap.rate = thatBool ? 2 : 1;
						fastForwardIcon.visible = thatBool ? true : false;
					}
				} else if (FlxG.mouse.overlaps(change1Hitbox)) {
					cursor = "button";
					if (FlxG.mouse.justReleased)
						changeChannel(-1);
				} else if (FlxG.mouse.overlaps(change2Hitbox)) {
					cursor = "button";
					if (FlxG.mouse.justReleased)
						changeChannel(1);
				}
			} else if (FlxG.mouse.justReleased)
				codesFocused = false;
		} else if (blackBackground.visible) {
			cursor = "button";

			if (FlxG.mouse.justReleased)
				fullscreenVideo(false);
		}

		if (codesButton.animation.name == "press" && codesButton.animation.finished)
			codesButton.animation.play("idle", true);
		if (codesButton.animation.name == "press") codesButton.x -= 5;

		switch(codesPosition) {
			default:
				if (codesPosition >= codesText.text.length) {
					codesText.textField.__getCharBoundaries(codesText.text.length-1, cacheRect);
					cachePoint.set(cacheRect.x + cacheRect.width, cacheRect.y);
				} else {
					codesText.textField.__getCharBoundaries(codesPosition, cacheRect);
					cachePoint.set(cacheRect.x, cacheRect.y);
				}
		};
		carcetTime += elapsed;
		caretSpr.alpha = Math.floor(((carcetTime+1.6)*2)%2);
		caretSpr.visible = codesFocused;

		caretSpr.x = codesText.x + (codesText.text.length == 0 ? 0 : cachePoint.x + 0);
		caretSpr.y = codesText.y + cachePoint.y;

		Framerate.offset.y = selectingWeek ? FlxMath.remapToRange(FlxMath.remapToRange(textBG.alpha, 0, 0.4, 0, 1), 0, 1, 0, textBG.height) : textBG.height;
		
		if (!lastOpened && codesOpened) lastFrameRateMode = Framerate.debugMode;
		if (lastOpened && !codesOpened) Framerate.debugMode = lastFrameRateMode;
		if (codesOpened) Framerate.debugMode = 0;

		textInfoBG.y = CoolUtil.fpsLerp(textInfoBG.y, codesOpened ? FlxG.height : FlxG.height - textInfoBG.height, 0.25);
		scoreText.y = CoolUtil.fpsLerp(scoreText.y, codesOpened ? FlxG.height : FlxG.height - scoreText.height - 22, 0.25);
	}
	Mouse.cursor = cursor ?? "arrow";

	if (!updateFreePlay) return;
	freeplayMenuText.alpha = lerp(freeplayMenuText.alpha, inFreeplayMenu ? (.6 + (.4*FlxMath.fastSin(__totalTime*1.5))) : 0, 0.15);
	if (freeplayMenuText.alpha < 0.01 && !inFreeplayMenu)
		updateFreePlay = false;
	for (menuID => data in freeplaySongLists) {
		if (menuID != freePlayMenuID && freePlayMenuID != -1) continue;
		for (i => song in data.songMenuObjs) {
			var scaledY = FlxMath.remapToRange((i-freeplaySelected[freePlayMenuID]), 0, 1, 0, 1.3);
			var y:Float = (scaledY * 120) + (FlxG.height * 0.48);
			var x:Float = ((i-freeplaySelected[freePlayMenuID]) * 30) + 90;
	
			song.y = __firstFreePlayFrame ? y + 0 : CoolUtil.fpsLerp(song.y, y, inFreeplayMenu ? 0.16 : 0.04);
			song.x = __firstFreePlayFrame ? x : CoolUtil.fpsLerp(song.x, menuID == freePlayMenuID ? x : -1500, inFreeplayMenu ? 0.16 : 0.08);
			if (menuID == freePlayMenuID && __firstFreePlayFrame) {song.x -= 500+(1500*i);}

			data.iconMenuObjs[i].alpha = song.alpha = lerp(song.alpha, menuID == freePlayMenuID ? (i == freeplaySelected[freePlayMenuID] ? 1 : 0.4) : 0, inFreeplayMenu ? 0.25 : 0.2);
	
			data.iconMenuObjs[i].updateHitbox();
			data.iconMenuObjs[i].x = song.x + song.width + 16;
			data.iconMenuObjs[i].y = song.y + (song.height/2) - (data.iconMenuObjs[i].height/2);
		}
	}
	__firstFreePlayFrame = false;
}

var videoWasPaused:Bool = false;
function focusGained()
{
	if (isTVOn && !videoWasPaused)
		videos[curVideo].resume();
}

function handleMenu() {
	if(isInProgPrompt){
		if (!fromMovieCredits && controls.BACK) {
			openProgressPrompt(false); 
			FlxG.sound.play(Paths.sound('menu/cancelMenu')); 
			if (cancelCallback == null) return;

			cancelCallback();
			cancelCallback == null;
		}
		if (!fromMovieCredits && (controls.LEFT_P || controls.RIGHT_P)) {FlxG.sound.play(Paths.sound("menu/scrollMenu")); onYes = !onYes;}
		if (controls.ACCEPT) {
			if(onYes){
				if(acceptedCallback != null)
					acceptedCallback();
			}
			else{
				if(finishedCallback != null)
					finishedCallback();
			}
			openProgressPrompt(false);
			FlxG.sound.play(Paths.sound("menu/confirmMenu"));
		}
		handleProgressPrompt();
		return;
	}

	if (codesOpened) {
		if (controls.BACK && !codesFocused) codesMenu(false, 0);
		return;
	}

	if (inFreeplayMenu) {
		if (controls.DOWN_P) changeSong(1);
		if (controls.UP_P) changeSong(-1);
		if (controls.ACCEPT) goToSong();
		if (controls.BACK) closeFreePlayMenu();
		return;
	}

	if (subMenuOpen) {
		if (controls.BACK) {closeSubMenu(); return;}
		var oldSubSelected:Int = curSubMenuSelected;

		var change = controls.DOWN_P ? 1 : controls.UP_P ? -1 : 0;
		curSubMenuSelected = FlxMath.bound(curSubMenuSelected + change, 0, subOptions.length-1);

		if (oldSubSelected != curSubMenuSelected) FlxG.sound.play(Paths.sound('menu/scrollMenu'));
		if (controls.ACCEPT) subOptionsData[curSubMenuSelected].callback();
	} else {
		if (controls.DOWN_P)
			changeWeek(1);
		else if (controls.UP_P)
			changeWeek(-1);
		else if (controls.ACCEPT)
			selectWeek();
		else if (controls.BACK) {
			canMove = false; 
			var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("menu/cancelMenu")); sound.volume = 1; sound.play();
			FlxG.switchState(new MainMenuState());
		}
	}
}

var pitchTween:Tween;
var chromaticDistortion1:Tween;
var chromaticDistortion2:Tween;
function changeWeek(change:Int) {
	if(selectingWeek) return;

	var oldWeek:Float = curWeek;
	curWeek = FlxMath.bound(curWeek + change, 0, menuOptions.length-1);

	if (oldWeek != curWeek) FlxG.sound.play(Paths.sound('menu/scrollMenu'));

	if (curWeek == 5){
		if (weeksUnlocked[curWeek] && !weeksFinished[curWeek]){
			for(tween in [pitchTween,chromaticDistortion1,chromaticDistortion2]){
				if(tween != null) 
					tween.cancel();
			}
			pitchTween = FlxTween.tween(FlxG.sound.music,{pitch: 0.6},0.65,{
				onComplete: function(twn){
					pitchTween = null;
				}
			});
			chromaticDistortion1 = FlxTween.num(0, 0.2, 0.55, {ease: FlxEase.cubeOut}, (val:Float) -> {chromatic.distortion = val;});
			chromaticDistortion2 = FlxTween.num(0, 1.3, 0.55, {ease: FlxEase.cubeOut}, (val:Float) -> {chromatic2.distortion = val;});
		}
	}
	else{
		if(FlxG.sound.music.pitch != 1){
			for(tween in [pitchTween,chromaticDistortion1,chromaticDistortion2]){
				if(tween != null) 
					tween.cancel();
			}
			pitchTween = FlxTween.tween(FlxG.sound.music,{pitch: 1},0.3,{
				onComplete: function(twn){
					pitchTween = null;
				}
			});
			chromaticDistortion1 = FlxTween.num(0.2, 0, 0.3, {ease: FlxEase.cubeOut}, (val:Float) -> {chromatic.distortion = val;});
			chromaticDistortion2 = FlxTween.num(1.3, 0, 0.3, {ease: FlxEase.cubeOut}, (val:Float) -> {chromatic2.distortion = val;});
		}
	}

	weekText.text = (curWeek == 8) ? codeWeekUnlocked ? weeks[curWeek].name : "?????" : weeksUnlocked[curWeek] ? weeks[curWeek].name : "?????";

	updateFlavourText();

	textBG.scale.set(FlxG.width, flavourText.y + flavourText.height + 22);
	textBG.updateHitbox();

	Framerate.offset.y = textBG.height;

	var score:Float = FunkinSave.getWeekHighscore(weeks[curWeek].name, "hard").score;
	if(curWeek == 8 && codeWeekUnlocked){
		scoreText.applyMarkup("WEEK SCORE - $" + Std.string(score) + "$,   " + (codeWeekUnlocked ? weeks[curWeek].songs.length : "?") + (weeks[curWeek].songs.length == 1 ? " SONG,    #" : " SONGS,    #") + (codeWeekUnlocked ? "UNLOCKED" : "LOCKED") + "!#", [
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), "$"),
			new FlxTextFormatMarkerPair(new FlxTextFormat(codeWeekUnlocked ? 0xFF00FF00 : 0xFFFF0000), "#"),
		]);
	}
	else{
		scoreText.applyMarkup("WEEK SCORE - $" + Std.string(score) + "$,   " + (weeksUnlocked[curWeek] ? weeks[curWeek].songs.length : "?") + (weeks[curWeek].songs.length == 1 ? " SONG,    #" : " SONGS,    #") + (weeksUnlocked[curWeek] ? "UNLOCKED" : "LOCKED") + "!#", [
			new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), "$"),
			new FlxTextFormatMarkerPair(new FlxTextFormat(weeksUnlocked[curWeek] ? 0xFF00FF00 : 0xFFFF0000), "#"),
		]);
	}

	textInfoBG.scale.set(FlxG.width, scoreText.height + 38);
	textInfoBG.updateHitbox();
	textInfoBG.y = FlxG.height - textInfoBG.height;

	freeplayMenuText.y = scoreText.y = FlxG.height - scoreText.height - 22;
}

function updateFlavourText()
{
	var descs:Array<String> = FlxG.save.data.spanish ? weekDescsSPANISH : weekDescs;

	if (curWeek == 6 && FlxG.save.data.beatWeekG6 && !FlxG.save.data.beatWeekG7) { flavourText.applyMarkup(FlxG.save.data.spanish ?
		"No Puedes Encontrarme?  ¡Bu! Hu!                           *T*ras *A*lcanzar *B*rillar..." : // Fue algo díficil traducir esto ._: -EstoyAburridow
		"Can't Find Me?   Boo Hoo!                           *T*ill *A* *B*reeze...",
		[new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF527F3A), "*")]);
		return;
	}
	if (curWeek == 8 && FlxG.save.data.beatWeekG6 && !codeWeekUnlocked) { flavourText.text = FlxG.save.data.spanish ?
		"Encuentra Los Codigos Escondidos." :
		"Find Hidden Codes." ;
		return; 
	}

	if (curWeek == 8 && FlxG.save.data.extrasSongs.length != 0 && !codeWeekUnlocked)	{ flavourText.text = FlxG.save.data.spanish ? 
		"Avanza a través de las semanas para desbloquear!" : 
		"Progress through the weeks to unlock!";
		return;
	}

	if (curWeek == 8 && FlxG.save.data.extrasSongs.length != 0 && codeWeekUnlocked)
		{
			flavourText.text = descs[8]; return;
		}

	if (weeksUnlocked[curWeek]) { flavourText.text = descs[curWeek]; return; }
	else{
		flavourText.text = FlxG.save.data.spanish ? 
		"Avanza a través de las semanas para desbloquear!" : 
		"Progress through the weeks to unlock!";
		return; 
	}
}

function checkWeekProgress() {
	if(weekProgress != null){
		if (weekProgress.exists(weeks[curWeek].name)){
			progInfoText.text = FlxG.save.data.spanish ? "Te Gustaria Continuar?" : "Would You Like To Continue?";

			openProgressPrompt(true,function(){
				isPlayingFromPreviousWeek = false;
				playWeek();	
			},function(){
				isPlayingFromPreviousWeek = true;
				playWeek();	
			},function() {selectingWeek = false;}
			);
		}
		else{
			isPlayingFromPreviousWeek = false;
			playWeek();	
		}
	}
	else{
		isPlayingFromPreviousWeek = false;
		playWeek();
	}
}

function selectWeek() {
	if(selectingWeek) return; 

	if (curWeek == 8)
	{ 
		if(!codeWeekUnlocked){
			FlxG.camera.stopFX();
			FlxG.camera.shake(0.005, .5);
			lerpColors[curWeek * 2 + 0].color = 0xFF6A0000;
			lerpColors[curWeek * 2 + 1].color = 0xFF6A0000;
			menuOptions[curWeek].color = menuLocks[curWeek].color = 0xFFFF0000;
	
			FlxG.sound.play(Paths.sound("menu/story/locked"));
			return;
		}
		else{
			openFreePlayMenu(); 
			FlxG.sound.play(Paths.sound("menu/confirmMenu"));
			return;
		}
	}
	else if (!weeksUnlocked[curWeek]) { // ! LOCKED
		FlxG.camera.stopFX();
		FlxG.camera.shake(0.005, .5);
		lerpColors[curWeek * 2 + 0].color = (curWeek == 5) ? 0xFF000000 : 0xFF6A0000;
		lerpColors[curWeek * 2 + 1].color = (curWeek == 5) ? 0xFF000000 : 0xFF6A0000;
		menuOptions[curWeek].color = menuLocks[curWeek].color = 0xFFFF0000;

		FlxG.sound.play(Paths.sound("menu/story/locked"));
		return;
	}

	if (!weeksFinished[curWeek]) {checkWeekProgress(); return;} // ! play week for first time

	if (subMenuOpen) return;
	FlxG.sound.play(Paths.sound("menu/confirmMenu"));
	openSubMenu(
		{name:"STORY MODE", callback: function () {
			selectingWeek = true; 
			closeSubMenu(); FlxG.sound.play(Paths.sound("menu/confirmMenu"));
			(new FlxTimer()).start(0.4, function () {
				checkWeekProgress();
			});
		}},
		{name:"FREEPLAY", callback: function () {closeSubMenu(); openFreePlayMenu(); FlxG.sound.play(Paths.sound("menu/confirmMenu"));}}
	);
}

function openSubMenu(option1:{name:String, callback:Void->Void}, option2:{name:String, callback:Void->Void}) {
	subOptionsData = [option1, option2]; curSubMenuSelected = 0;
	subMenuOpen = true; colorLerpSpeed = 8; if (cannedTuna != null) cannedTuna.cancel();

	for (option in subOptionsData) {
		var option:FlxText = new FunkinText(0, 0, 0, option.name, 42, true);
		option.setFormat("fonts/pixelart.ttf", 54, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		option.cameras = [FlxG.camera];
		option.borderSize = 4;
		option.alpha = option.ID = 0;
		option.cameras = [selectorCam];
		subOptions.push(add(option));
	}

	if (subMenuSelector.active) {FlxTween.cancelTweensOf(subMenuSelector); remove(subMenuSelector);}

	add(subMenuSelector);
	subMenuSelector.alpha = 0;
	subMenuSelector.visible = subMenuSelector.active = true;

	FlxTween.tween(subMenuSelector, {alpha: 1}, 0.2);
}

var cannedTuna:FlxTimer = null;
function closeSubMenu() {
	if (!subMenuOpen) return;

	subMenuOpen = false; subOptionsData = [];
	for (sub in subOptions) {
		FlxTween.cancelTweensOf(sub);
		sub.ID = -1;
		FlxTween.tween(sub, {alpha: 0}, 0.1, {onComplete: function (t) {
			subOptions.remove(sub); sub.destroy(); remove(sub);
		}});
	}

	FlxTween.cancelTweensOf(subMenuSelector);
	FlxTween.tween(subMenuSelector, {alpha: 0}, 0.1, {onComplete: function (t) {
		remove(subMenuSelector); subMenuSelector.visible = subMenuSelector.active = false;
	}});

	FlxTween.cancelTweensOf(bgSprite);
	FlxTween.tween(bgSprite, {alpha: 1}, 0.1);

	cannedTuna = (new FlxTimer()).start(0.8, function (t) {colorLerpSpeed = 1;});
}

var isPlayingFromPreviousWeek:Bool = false;
function playWeek() { // animation
	canMove = !(selectingWeek = true);
	FlxG.sound.music.fadeOut(0.25);

	FlxG.sound.play(Paths.sound("menu/story/weekenter")); // Sound
	codesMenu(false, -100);
	switch(curWeek){
		case 0: FlxG.sound.play(Paths.sound("menu/story/principalenter"));
		case 1: FlxG.sound.play(Paths.sound("menu/story/lasboyenter"));
		case 2: FlxG.sound.play(Paths.sound("menu/story/sansfieldenter"));
		case 3: FlxG.sound.play(Paths.sound("menu/story/ultragorefieldenter"));
		case 4: FlxG.sound.play(Paths.sound("menu/story/cryfieldenter"));
		case 5: FlxG.sound.play(Paths.sound("menu/story/godfieldenter"));
		case 6: FlxG.sound.play(Paths.sound("menu/story/Binky_Week_Enter"));
		case 7: FlxG.sound.play(Paths.sound("menu/story/Cartoon_Week_Enter"));
		case 8: FlxG.sound.play(Paths.sound("menu/story/Codes_Week_Enter"));
		default: FlxG.sound.play(Paths.sound("menu/story/principalenter"));
	}

	for (i=>menuOption in menuOptions) { // Fade Out rest...
		if(menuOption.ID != curWeek){
			FlxTween.tween(menuOption, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
			FlxTween.tween(menuLocks[menuOption.ID], {alpha: 0}, 0.8, {ease: FlxEase.circOut});
		}
	}
	FlxTween.tween(selector, {angle: 45, alpha: 0}, .8, {ease: FlxEase.circOut});
	FlxTween.tween(camText, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
	FlxTween.tween(textInfoBG, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
	FlxTween.tween(textBG, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
	
	colowTwn.cancel();
	colowTwn = FlxTween.color(null, 3, bgSprite.colorTransform.color, weekColors[curWeek], {ease: FlxEase.circOut, onUpdate: function () {
		bgSprite.colorTransform.color = colowTwn.color;
	}});

	bloomSine = false;
	FlxTween.num(dim, .5, 3, {ease: FlxEase.circOut}, (val:Float) -> {bloomShader.dim = val;});
	FlxTween.num(size, 26, 3, {ease: FlxEase.circOut}, (val:Float) -> {bloomShader.size = val;});

	FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.qaudOut, startDelay: .5});
	for (cam in [FlxG.camera, camBG])
		FlxTween.tween(cam, {zoom: 2.1}, 3, {ease: FlxEase.circInOut});
	FlxTween.num(0, 6, 3, {ease: FlxEase.circInOut}, (val:Float) -> {warpShader.distortion = val;});

	new FlxTimer().start(3, (tmr:FlxTimer) -> {
		if(isPlayingFromPreviousWeek){
			if (weekProgress.exists(weeks[curWeek].name)){
				trace("Loading the Previous Progress for " + weeks[curWeek].name);
				var resumeInfo = weekProgress.get(weeks[curWeek].name);
	
				var songArrayNames:Array<String> = [for (song in weeks[curWeek].songs) song.toLowerCase()]; //grab the name list
				songArrayNames = songArrayNames.slice(songArrayNames.indexOf(resumeInfo.song.toLowerCase()));
	
				var songArray:Array<WeekSong> = []; //convert to weeksong format
				for (song in songArrayNames){
					songArray.push({name: song, hide: false});
				}
				PlayState.loadWeek({
						name: weeks[curWeek].name,
						id: weeks[curWeek].name,
						sprite: null,
						chars: [null, null, null],
						songs: songArray,
						difficulties: ['hard']
					}, "hard");
				PlayState.campaignMisses = resumeInfo.weekMisees;
				PlayState.campaignScore = resumeInfo.weekScore;
				PlayState.deathCounter = resumeInfo.deaths;

				//trace(FlxG.save.data.weekProgress);
				//trace(PlayState.storyPlaylist);
			}	
			else{
				PlayState.loadWeek(__gen_week(), "hard");
			}
		}
		else{
			PlayState.loadWeek(__gen_week(), "hard");
		}
		FlxG.switchState(new ModState("gorefield/LoadingScreen"));
	});
}

function __gen_week() {
	return {
		name: weeks[curWeek].name,
		id: weeks[curWeek].name,
		sprite: null,
		chars: [null, null, null],
		songs: [for (song in weeks[curWeek].songs) {name: song, hide: false}],
		difficulties: ['hard']
	};
}

function preloadFreeplayMenus() {
	for (data in freeplaySongLists) {
		for (i => song in data.songs) {
			var newText:FunkinText = new FunkinText(0, 0, 0, song, 54, true);
			newText.setFormat("fonts/pixelart.ttf", 64, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			newText.borderSize = 4; newText.alpha = 0;
			data.songMenuObjs.push(add(newText));
		}

		for (i => icon in data.icons) {
			var charXML = null;
			var xmlPath = Paths.xml('characters/' + icon);
			if (Assets.exists(xmlPath))
				charXML = Xml.parse(Assets.getText(xmlPath)).firstElement();
		
			var path = 'icons/' + (charXML != null && charXML.exists("icon") ? charXML.get("icon") : icon);
			if (!Assets.exists(Paths.image(path))) path = 'icons/face';
			var icon = new FlxSprite(); icon.alpha = 0;
			if ((charXML != null && charXML.exists("animatedIcon")) ? (charXML.get("animatedIcon") == "true") : false) {
				icon.frames = Paths.getSparrowAtlas(path);
				icon.animation.addByPrefix("losing", "losing", 24, true);
				icon.animation.addByPrefix("idle", "idle", 24, true);
				icon.animation.play("idle");
			} else {
				icon.loadGraphic(Paths.image(path)); // load once to get the width and stuff
				icon.loadGraphic(icon.graphic, true, icon.graphic.width/2, icon.graphic.height);
				icon.animation.add("non-animated", [0,1], 0, false);
				icon.animation.play("non-animated");
			}
			data.iconMenuObjs.push(add(icon));
		}
	}
}

function openFreePlayMenu() {
	codesMenu(false, -100);
	FlxTween.cancelTweensOf(tabSprite);
	FlxTween.tween(tabSprite, {x: -300}, 0.5, {ease: FlxEase.circInOut});

	__firstFreePlayFrame = inFreeplayMenu = updateFreePlay = true;
	freePlayMenuID = curWeek; changeSong(0);

	colowTwn.cancel();
	colowTwn = FlxTween.color(null, 5, bgSprite.colorTransform.color, weekColors[curWeek], {ease: FlxEase.circOut, onUpdate: function () {
		bgSprite.colorTransform.color = colowTwn.color;
	}});
}

var lerpTimer:FlxTimer = null;
var updateTimer:FlxTimer = null;
function closeFreePlayMenu() {
	codesMenu(false, 0);
	FlxTween.cancelTweensOf(tabSprite);
	FlxTween.tween(tabSprite, {x: 0}, 0.5, {ease: FlxEase.circInOut});

	__firstFreePlayFrame = inFreeplayMenu = false;
	freePlayMenuID = -1; changeWeek(0);

	lerpMenuSpeed = 0.5; if (lerpTimer != null) lerpTimer.cancel();
	lerpTimer = (new FlxTimer()).start(0.5, function () {lerpMenuSpeed = 1;});

	if (updateTimer != null) updateTimer.cancel();
	//updateTimer = (new FlxTimer()).start(0.6, function () {});

	colowTwn.cancel();
	colowTwn = FlxTween.color(null, 5.4, 0xFF90D141, 0xFFF09431, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/, onUpdate: function () {
		bgSprite.colorTransform.color = colowTwn.color;
	}});
}

function changeSong(change:Int) {
	var oldFreeplaySelected = freeplaySelected[freePlayMenuID];
    freeplaySelected[freePlayMenuID] = FlxMath.wrap(
		freeplaySelected[freePlayMenuID] + change, 0, 
		freeplaySongLists[freePlayMenuID].songMenuObjs.length-1
	);

	if(oldFreeplaySelected != freeplaySelected[freePlayMenuID])
		FlxG.sound.play(Paths.sound("menu/scrollMenu"));

	var data = FunkinSave.getSongHighscore(freeplaySongLists[freePlayMenuID].songs[freeplaySelected[freePlayMenuID]], "hard", null);
	var dateStr = Std.string(data.date).split(" ")[0];
	if (dateStr == null || dateStr == "null") dateStr = "????,??,??";
	scoreText.applyMarkup("SCORE - $" + Std.string(data.score) + "$,  MISSES - #" + Std.string(data.misses) + "#,  ACCURACY - @" + Std.string(FlxMath.roundDecimal(data.accuracy * 100, 2)) + "@,  DATE - /" + StringTools.replace(dateStr, "-", ",") + "/", [
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFF3F315), "$"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFE13333), "#"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF1CDA1C), "@"),
		new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF10CCED), "/"),
	]);

	textInfoBG.scale.set(FlxG.width, scoreText.height + 38);
	textInfoBG.updateHitbox();
	textInfoBG.y = FlxG.height - textInfoBG.height;

	freeplayMenuText.y = scoreText.y = FlxG.height - scoreText.height - 22;
}

function goToSong() {
	var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("menu/confirmMenu")); sound.volume = 1; sound.play();
    PlayState.loadSong(freeplaySongLists[freePlayMenuID].songs[freeplaySelected[freePlayMenuID]], "hard", false, false);
	PlayState.isStoryMode = PlayState.chartingMode = false; // Just incase cause people see cutscenes for some reason

    FlxG.switchState(new ModState("gorefield/LoadingScreen"));

	/*if(freePlayMenuID == 8){ //is codes menu
		PlayState.isStoryMode = true;
		PlayState.storyWeek = {
			name: weeks[8].name,
			id: weeks[8].name,
			sprite: null,
			chars: [null, null, null],
			songs: [],
			difficulties: ['hard']
		};
	}*/
}
var channelTimer:FlxTimer = null;
function turnTV(on:Bool) {
	if (isTVOn == on)
		return;

	if (channelTimer != null) channelTimer.cancel();
	isTVOn = on;
	var mode:String = isTVOn ? "ON" : "OFF";

	if (isTVOn) {
		FlxG.sound.music.fadeOut(0.5, 0);
		videos[curVideo].play();

		channelTimer = (new FlxTimer()).start(4, function (t) {channelBar.visible = false;});
		openCodesList(false);
	}
	else {
		FlxG.sound.music.fadeIn(0.5, 0.7);
		videos[curVideo].stop();

		blackBackground.visible = false;
	}
	new FlxTimer().start(isTVOn ? 0.1 : 0, function() television.animation.play(mode));
	videoWasPaused = false;

	videos[curVideo].visible = isTVOn;
	channelBar.visible = isTVOn;
	fastForwardIcon.visible = isTVOn ? (videos[curVideo].bitmap.rate == 2) : false;
	pauseIcon.visible = isTVOn ? videoWasPaused : false;

	FlxG.sound.play(Paths.sound("menu/story/television/Turn_" + mode + "_TV"));
}

var changeChannelCount:Int = 1;
function changeChannel(change:Int) {
	if (channelTimer != null) channelTimer.cancel();
	videos[curVideo].stop();
	videos[curVideo].visible = false;
	
	videoWasPaused = false;

	curVideo = FlxMath.wrap(curVideo + change, 0, videos.length - 1);
	changeChannelCount = FlxMath.wrap(changeChannelCount + 1, 1, 3);

	FlxG.sound.play(Paths.sound("menu/story/television/Change_channel_" + changeChannelCount));

	var channelBarName = videosChannel[curVideo];
	channelBar.loadGraphic(Paths.image('menus/storymenu/' + channelBarName));

	fastForwardIcon.visible = isTVOn ? (videos[curVideo].bitmap.rate == 2) : false;
	channelBar.visible = isTVOn;
	pauseIcon.visible = false;
	videos[curVideo].play();
	videos[curVideo].visible = true;

	channelTimer = (new FlxTimer()).start(4, function (t) {channelBar.visible = false;});
}
var previousOpen:Bool = false;
function codesMenu(open:Bool, offset:Float) {
	if (open == false) codesFocused = false;
	codesOpened = open;

	if(isInProgPrompt)
		openProgressPrompt(false);

	if (codesTween != null) codesTween.cancel();
	codesTween = FlxTween.tween(codesPanel, {x: (codesOpened ? 0 : -415) + offset}, .25, {ease: FlxEase.circInOut});

	if (televisionTween != null) televisionTween.cancel();
	televisionTween = FlxTween.tween(television, {x: codesOpened ? 650 : -1280}, 0.23, {ease: FlxEase.circInOut});

	for (hitbox in [videosHitbox, powerHitbox, pauseHitbox, speedHitbox, change1Hitbox, change2Hitbox])
		if(previousOpen != open){
			hitbox.x += open ? 1000 : -1000;
		}
	
	if (!codesOpened){
		turnTV(false);
	}
	openCodesList(false,codesOpened ? false : true, previousOpen != open ? true : false);

	if(previousOpen != open){
		FlxTween.cancelTweensOf(tabSprite);
		FlxTween.tween(tabSprite, {x: open ? -300 : 0}, 0.5, {ease: FlxEase.circInOut});
	}

	previousOpen = open;
}

function fullscreenVideo(enabled:Bool) {
	videos[curVideo].cameras = [enabled ? camText : FlxG.camera];
	blackBackground.visible = enabled;
	canMove = !enabled;

	// Vaya, se me hace muy extraño colocar los {} así -EstoyAburridow
	if (enabled) {
		videos[curVideo].scale.set(1.5, 1.5);
		videos[curVideo].screenCenter();
	} else {
		videos[curVideo].scale.set(0.6, 0.6);
		videos[curVideo].setPosition(555, 186);
	}
}

var RIGHT = 0x4000004F;
var LEFT = 0x40000050;
var BACKSPACE = 0x08;
var HOME = 0x4000004A;
var END = 0x4000004D;
var V = 0x76;
var LEFT_CTRL = 0x0040;
var RIGHT_CTRL = 0x0080;
function onKeyDown(keyCode:Int, modifier:Int) {
	if (!codesFocused || !canMove) return;

	switch(keyCode) {
		case LEFT:
			codesPosition = FlxMath.bound(codesPosition-1, 0, codesText.text.length); carcetTime = 0;
		case RIGHT:
			codesPosition = FlxMath.bound(codesPosition+1, 0, codesText.text.length); carcetTime = 0;
		case BACKSPACE:
			if (codesPosition > 0) {
				codesText.text = codesText.text.substr(0, codesPosition-1) + codesText.text.substr(codesPosition);
				codesPosition = FlxMath.bound(codesPosition-1, 0, codesText.text.length); carcetTime = 0;
			}
		case HOME:
			codesPosition = 0;
		case END:
			codesPosition = codesText.text.length;
		case V:
			// paste
			if (modifier == LEFT_CTRL || modifier == RIGHT_CTRL) // Esto a mi no me funciona :sob: -EstoyAburridow
			{
				var data:String = Clipboard.generalClipboard.getData(2/**TEXTFORMAT**/);
				if (data != null) onTextInput(data);
			}
		default: // nothing
	}
}

function onTextInput(text:String):Void 
{
	if (!codesFocused || !canMove  || text.length < 1 || codesText.text.length >= 28)
		return;

	text = text.toLowerCase();

	var newText:String = "";

	for (char in 0...text.length) 
	{
		if (!StringTools.contains(alphabet + numbers + symbols, text.charAt(char))) 
			continue;

		newText += text.charAt(char).toUpperCase();
	}

	if (newText.length < 1)
		return;

	newText = newText.substr(0, 28 - codesText.text.length);

	codesText.text = codesText.text.substr(0, codesPosition) + newText + codesText.text.substr(codesPosition);

	codesPosition += newText.length; carcetTime = 0;
	codesSound.play(true);
}

var curVideoMeme:FlxVideo;
var CodesFunctions:{} = {
	penk: function() {
		new FlxTimer().start(0.7, function(tween) {
			var penkProgress:Int = tween.loops - tween.loopsLeft;

			CodesFunctions.image("penkarue (" + Std.string(penkProgress) + ")");
			FlxG.sound.music.volume -= 0.25;
		
			if (penkProgress != 4) return;
			(new FlxTimer()).start(.3, function (_) {
				for (camera in FlxG.cameras.list)
					FlxTween.tween(camera, {zoom: 3, alpha:0, angle: -800}, 2, {ease: FlxEase.circInOut});

				new FlxTimer().start(2, function(_) {
					MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
					FlxG.switchState(new ModState("gorefield/easteregg/Penkaru"));
				});
			});
		}, 4);
	},
	image: function(path:String) {
		FlxG.sound.play(Paths.sound("vineboom"));

		var newSprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menus/storymenu/wow i love easter what about you/" + path));
		newSprite.updateHitbox(); newSprite.antialiasing = true; newSprite.alpha = 0; newSprite.angle = FlxG.random.float(-900, 900);
		newSprite.setPosition(FlxG.random.float(0, FlxG.width-newSprite.width), FlxG.random.float(0, FlxG.height-newSprite.height));
		newSprite.cameras = [camText];
		add(newSprite); newSprite.scale.set(1.2, 1.2);

		for (camera in FlxG.cameras.list) 
			camera.shake(0.002, 0.3);
		
		FlxTween.tween(newSprite, {"scale.x": 1, "scale.y": 1, alpha: 1, angle: 0}, 0.3, {ease: FlxEase.qaudInOut});
		FlxTween.tween(newSprite, {alpha: 0}, 2, {
			startDelay: 3.3,
			onComplete: function(_)
			{
				canMove = true;

				newSprite.kill();
				remove(newSprite);
				newSprite.destroy();
			}
		});

		if (videos[curVideo].bitmap.isPlaying){
			videos[curVideo].togglePaused();
			videoWasPaused = !videoWasPaused;
			pauseIcon.visible = videoWasPaused;
		}
	},
	meme: function(path:String) {
		var prevMusicVolume:Float = FlxG.sound.music.volume;
		FlxG.sound.music.volume = 0;

		video = new FlxVideo();
		video.load(Assets.getPath(Paths.video(path)));
		video.onEndReached.add(function() {
			video.dispose(); 
			
			FlxG.sound.music.volume = prevMusicVolume;
			canMove = true;

			curVideoMeme = null;
		});
		video.play();
		curVideoMeme = video;

		if (videos[curVideo].bitmap.isPlaying){
			videos[curVideo].togglePaused();
			videoWasPaused = !videoWasPaused;
			pauseIcon.visible = videoWasPaused;
		}
	},
	estoyCodeWarning: function() { // Por qué nadie me dijo que tenia copyright :sob:
		progInfoText.text = FlxG.save.data.spanish ? 
		"Este Video Tiene Musica Con Copyright Quieres Continuar?" : 
		"The Music in This Video is Copyrighted. Continue?";

		canMove = true;
		codesFocused = false;
		updateCodeMenu = false;

		openProgressPrompt(true,
			function() {
				updateCodeMenu = true;
			},
			function() {
				CodesFunctions.meme("Test");
				updateCodeMenu = true;
			},
			function() {updateCodeMenu = true;}
		);
	},
	selectSong: function(songName:String, icon:String) {
		if (videos[curVideo].bitmap.isPlaying){
			videos[curVideo].togglePaused();
			videoWasPaused = !videoWasPaused;
			pauseIcon.visible = videoWasPaused;
		}

		FlxTween.tween(vigentte, {alpha:1}, 1.2);
		FlxG.sound.play(Paths.sound("menu/story/secretsong"));
		FlxG.sound.music.fadeOut(0.4, 0);
		FlxTween.tween(camText, {zoom: 1.6}, 3.1, {ease: FlxEase.circInOut});
		FlxTween.tween(FlxG.camera, {zoom: 1.6}, 3.1, {ease: FlxEase.circInOut, 
			onComplete: function () {
				PlayState.loadSong(songName, "hard", false, false);
				PlayState.chartingMode = false;
				PlayState.isStoryMode = true;

				PlayState.storyWeek = {
					name: weeks[8].name,
					id: weeks[8].name,
					sprite: null,
					chars: [null, null, null],
					songs: [],
					difficulties: ['hard']
				};


				if (!FlxG.save.data.extrasSongs.contains(songName) && songName.toLowerCase() != 'laughter and cries') {
					FlxG.save.data.extrasSongs.push(songName);
					FlxG.save.data.extrasSongsIcons.push(icon);
					FlxG.save.flush();
				}
			
				FlxG.switchState(new ModState("gorefield/LoadingScreen"));
			}
		});

		for (cam in [FlxG.camera, camText, camBG]) {
			FlxTween.tween(cam.scroll, {x: -50, y: 50}, 2, {ease: FlxEase.qaudInOut});
			FlxTween.tween(cam, {alpha: 0}, 2);
		}	
	},
	unlockAll: function() {
		FlxG.save.data.canVisitArlene = true;
		//FlxG.save.data.extrasSongs = ["Take Me Jon", "Captive", "Breaking Cat"];
		//FlxG.save.data.extrasSongsIcons = ["icon-garsad", "lyman", "walter"];

		FlxG.save.data.weeksFinished = [true, true, true, true, true, true];
		FlxG.save.data.weeksUnlocked = [true, true, true, true, true, true, true, true];
		FlxG.save.data.codesUnlocked = true;
		
		FlxG.save.data.beatWeekG1 = FlxG.save.data.beatWeekG2 = FlxG.save.data.beatWeekG3 = FlxG.save.data.beatWeekG4 = FlxG.save.data.beatWeekG5 = FlxG.save.data.beatWeekG6 = FlxG.save.data.beatWeekG7 = FlxG.save.data.beatWeekG8 = true;

		FlxG.save.flush();

		FlxG.switchState(new ModState("gorefield/StoryMenuScreen"));
	},
	resetAll: function() {
		if(!FlxG.save.data.dev){
			codesMenu(false, 0);
			canMove = true;
			return;
		}
		
		FlxG.save.data.arlenePhase = 0;
		FlxG.save.data.canVisitArlene = false;
		FlxG.save.data.hasVisitedPhase = false;
		FlxG.save.data.paintPosition = -1;

		FlxG.save.data.alreadySeenCredits = false;
		FlxG.save.data.firstTimeLanguage = true;
		FlxG.save.data.extrasSongs = [];
		FlxG.save.data.extrasSongsIcons = [];

		FlxG.save.data.weeksFinished = [false, false, false, false, false, false];
		FlxG.save.data.codesUnlocked = false;
		FlxG.save.data.weeksUnlocked = [true, false, false, false, false, false, false, false];
		FlxG.save.data.codesList = ["HUMUNGOSAURIO", "PUEBLO MARRON"];

		FlxG.save.data.weekProgress = weekProgress = ["" => {}];
		
		FlxG.save.data.beatWeekG1 = FlxG.save.data.beatWeekG2 = FlxG.save.data.beatWeekG3 = FlxG.save.data.beatWeekG4 = FlxG.save.data.beatWeekG5 = FlxG.save.data.beatWeekG6 = FlxG.save.data.beatWeekG7 = FlxG.save.data.beatWeekG8 = false;

		/*for(week in weeks){
			FunkinSave.setWeekHighscore(week.name, "hard", {
				score: 0,
				misses: 0,
				accuracy: 0,
				hits: [],
				date: "???"
			});
		}idk how to do this properly lol -lean */

		FlxG.save.flush();

		FlxG.switchState(new ModState("gorefield/StoryMenuScreen"));
	},
	catbot: function() {
		progInfoText.text = FlxG.save.data.spanish ? 
		"Te Gustaria Activar Botplay Al Presionar 6 En Una Cancion?" : 
		"Enable Activating Botplay When Pressing 6 Mid Song?";

		canMove = true;
		codesFocused = false;
		updateCodeMenu = false;

		openProgressPrompt(true,
			function() {
				catbotEnabled = false;
				updateCodeMenu = true;
			},
			function() {
				catbotEnabled = true;
				updateCodeMenu = true;
			},
			function() {updateCodeMenu = true;}
		);
	}
}

var codes:Map<String, Void -> Void> = [
	// Songs codes
	"TAKE ME" => function() CodesFunctions.selectSong("Take Me Jon", "garfield-sad"), 
	"LYMAN" => function() CodesFunctions.selectSong("Captive", "lyman-prision"), 
	"CATNIP" => function() CodesFunctions.selectSong("Breaking Cat", "walter-monster"), 

	// Youtubers spanish codes
	"TANUKI" => function() CodesFunctions.meme("irl"),
	"CABROS" => function() CodesFunctions.meme("LOOOOL"),
	"CANDEL" => function() CodesFunctions.meme("idk what call this one"),
	"MAGO" => function() CodesFunctions.meme("Pepe_el_Magin_Video"),
	"SOY NOCHE" => function() CodesFunctions.meme("IM_NIGHT_Video"),
	"DASITO" => function() CodesFunctions.meme("Dasito_Code"),
	"PEDAZO" => function() CodesFunctions.meme("pedazo gato tremendo")

	// Youtubers english codes
	"PENKARU" => CodesFunctions.penk,
	"TAEYAI" => function() CodesFunctions.meme("t"),
	"NIFFIRG" => function() CodesFunctions.meme("niffirgflumbo"),

	// Dev codes
	"CASSETTE" => function() CodesFunctions.meme("RAP_PARA_POBRES"),
	"ESTOY" => CodesFunctions.estoyCodeWarning,
	"PIJURRO" => function() CodesFunctions.image("PIJURRO"),
	"RECIPE" => function() CodesFunctions.meme("SDFSDF"),
	"GOKU BLACK" => function() CodesFunctions.meme("GOKU_NEGRO"),
	"CHART" => function() CodesFunctions.meme("Gorefield_lore"),
	"RETURN" => function() CodesFunctions.meme("gorefield_code_video"),
	"BUFFIELD" => function() CodesFunctions.image("SPOILER_queacabodehacer_20240130060334"),
	"HUMUNGOSAURIO" => function() CodesFunctions.image("Dibujo_humungosaurio"),
	"MANIAS" => function() CodesFunctions.meme("Manias"),
	"FREE DIAMOND" => function() CodesFunctions.meme("urisus_in_gorefield_brooo.mp4"),

	// Cheat codes
	"FULLCAT" => CodesFunctions.unlockAll,
	"RESET" => CodesFunctions.resetAll,
	"CATBOT" => CodesFunctions.catbot,

	// Extras codes
	"SPIDERS" => function() CodesFunctions.meme("cry")
	"MOUSTACHE" => function(){FlxG.switchState(new ModState("gorefield/CreditsScreen")); moustacheMode = true;}
	"SANS" => function() CodesFunctions.meme("SANS")
	"JLOOR" => function() CodesFunctions.meme("JLOOR")
	"FNF" => function() CodesFunctions.meme("FNF")
	"TOP 5" => function() CodesFunctions.meme("top 5")
	"PUEBLO MARRON" => function() CodesFunctions.meme("Pueblo_Marron")
	"PERUFIELD" => function() CodesFunctions.image("cuy"),
];

function selectCode():Void {
	canMove = codesFocused = false;
	FlxG.sound.play(Paths.sound("menu/story/Enter_Code_Sound"));
	openCodesList(false);

	if (!gottenCodes.contains(codesText.text) && codesText.text != "RESET" && codesText.text != secretCode){
		gottenCodes.push(codesText.text);

		FlxG.save.data.codesList = gottenCodes;
		FlxG.save.flush();
	}

	codes[codesText.text]();
}

function incorrectCode():Void {
	for (cam in [FlxG.camera, camText]) {
		cam.stopFX();
		cam.shake(0.005, .5);
	}
	codeColorLerp.color = 0xFFFF0000;

	FlxG.sound.play(Paths.sound("menu/story/locked"));
}

function destroy() {
	FlxG.camera.bgColor = FlxColor.fromRGB(0,0,0); 
	FlxG.sound.music.pitch = 1;
	FlxG.sound.music.volume = 1;
	curStoryMenuSelected = curWeek; 
	Framerate.offset.y = 0; Framerate.debugMode = lastFrameRateMode;

	for (video in videos)
		video.stop();

	if (FlxG.signals.focusGained.has(focusGained))
		FlxG.signals.focusGained.remove(focusGained);

	FlxG.stage.window.onKeyDown.remove(onKeyDown);
	FlxG.stage.window.onTextInput.remove(onTextInput);
}

var secretCode:String = "";

function generateSECRET() {
	var songsList:Array<String> = [for (song in Paths.getFolderDirectories('songs', false, false)) song.toLowerCase()];
	var highScores:Array<{name:String, score:Float}> = [];
	
	for (song => highscore in FunkinSave.highscores) {
		var enumParams:Array<Dynamic> = Type.enumParameters(song);
		if (enumParams.length > 2 && songsList.contains((enumParams[0]))) 
			highScores.push({name: enumParams[0], score: highscore.score});
	}

	highScores.sort((a, b) -> {return Std.int(b.score-a.score);});
	var precent:Float = FunkinSave.getSongHighscore(highScores[0].name, "hard").accuracy * 100;

	// CODE GENERATION!!!
	var date:Date = Date.now();
    var stringminutes:String = Std.string(date.getMinutes());
    if (stringminutes.length == 1) stringminutes = "0" + stringminutes;

    var firstMinute:Int = Math.floor(Std.parseFloat(stringminutes.charAt(0)));

	var codes:Array<Float> = [
		date.getDate() % 10, // Last digit of day in month (like 4/17/24, would be 7) 
		Math.floor(precent) % 10, // Second digit of precentage of highest highscore (94% would be 4)
		3, // Number of songs that start with C - Number of songs that start with M (i counted, its 3)
		1 + Math.floor(firstMinute) // Songs you face off a god (1) + First digit of minutes (like 3:29PM would be 2)
	];
	// codes.sort((a, b) -> {return Std.int(b - a);}); // scrapped -lunar
	secretCode = codes.join("");

	#if debug
	trace(secretCode);
	#end
}