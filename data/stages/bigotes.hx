//
import flixel.addons.effects.FlxTrail;
import funkin.game.ComboRating;
import funkin.backend.shaders.CustomShader;

public var jonTrail:FlxTrail;
var tornado:FlxSprite;
var overlay:FlxSprite;

public var scaleTrail:Bool = false;
public var bgFlashes:Bool = false;
public var sineSat:Bool = false;

public var controlHealthAlpha:Bool = true;
public var curHealthAlpha:Float = 1;

public var trailBloom:CustomShader;
public var particleShader:CustomShader; // yes it is a shader
public var warpShader:CustomShader;
public var drunkShader:CustomShader;

public var isLymanFlying:Bool = true;

public var camCharacters:FlxCamera;
public var camJonTrail:FlxCamera;

function create() {
    dad.zoomFactor = 0.9; 
    scaleTrail = bgFlashes = sineSat = !(controlHealthAlpha = isLymanFlying = true);
    for (cam in [camGame, camHUD]) FlxG.cameras.remove(cam, false);

    camCharacters = new FlxCamera(0, 0);
    for (strum in strumLines)
        for (char in strum.characters)
            char.cameras = [camCharacters];

    camJonTrail = new FlxCamera(0, 0);

    for (cam in [camGame, camJonTrail, camCharacters, camHUD]) {cam.bgColor = 0x00000000; FlxG.cameras.add(cam, cam == camGame);}

    jonTrail = new FlxTrail(dad, null, 4, 10, 0.3, 0.069);
    jonTrail.beforeCache = dad.beforeTrailCache;
    jonTrail.afterCache = () -> {
		dad.afterTrailCache();
        jonTrail.members[0].x += FlxG.random.float(-1, 4);
		jonTrail.members[0].y += FlxG.random.float(-1, 4);
	}
    jonTrail.color = 0xFFF200FF;
    jonTrail.cameras = [camJonTrail];
    if (FlxG.save.data.trails) insert(members.indexOf(dad), jonTrail);

    trailBloom = new CustomShader("jonTrail");
    trailBloom.size = 18.0;// trailBloom.quality = 8.0;
    trailBloom.dim = 0.9;// trailBloom.directions = 16.0;
    trailBloom.sat = 1;
    if (FlxG.save.data.bloom) camJonTrail.addShader(trailBloom);

    drunkShader = new CustomShader("drunk");
    drunkShader.time = 0; drunkShader.strength = 1;
    if (FlxG.save.data.drunk) camJonTrail.addShader(drunkShader);

    particleShader = new CustomShader("particles");
    particleShader.time = 0; particleShader.particlealpha = 0.0;
	particleShader.res = [FlxG.width, FlxG.height];
    particleShader.particleXY = [0, 0];
    particleShader.particleZoom = 1;
    particleShader.particleColor = [0.616,0.149,0.733];
    particleShader.particleDirection = [0.7, -1.0];
    particleShader.layers = 8;
    if (FlxG.save.data.particles) FlxG.camera.addShader(particleShader);

    warpShader = new CustomShader("warp");
    warpShader.distortion = 1;
    if (FlxG.save.data.warp) camGame.addShader(warpShader);

    tornado = stage.stageSprites["tornado"];
    tornado.skew.y = 40;

    stage.stageSprites["BIGOTESBG"].alpha = 0.7;

    comboRatings = [
		new ComboRating(0, "F", 0xFF941616),
		new ComboRating(0.5, "E", 0xFFCF1414),
		new ComboRating(0.7, "D", 0xFFFFAA44),
		new ComboRating(0.8, "C", 0xFFFFA02D),
		new ComboRating(0.85, "B", 0xFFFE8503),
		new ComboRating(0.9, "A", 0xFF933AB6),
		new ComboRating(0.95, "S", 0xFFB11EEA),
		new ComboRating(1, "S++", 0xFFC63BFD),
	];

    gameOverSong = "gameOvers/bigotes/bigotes_gameover_loop";
    retrySFX = "gameOvers/bigotes/bigotes_gameover_end";
}

var bgTween:FlxTween;

function measureHit(curMeasure:Int) {
    if (!bgFlashes) return;
    stage.stageSprites["BIGOTESBG"].alpha = 1;
    bgTween = FlxTween.tween(stage.stageSprites["BIGOTESBG"],{alpha: 0.7},Conductor.stepCrochet/100);
}

function postCreate() {
    for (strum in cpuStrums) strum.visible = false;
}

function update(elapsed:Float) {
    camJonTrail.visible = jonTrail.visible;
    for (cam in [camJonTrail, camCharacters]) {
        cam.scroll = FlxG.camera.scroll;
        cam.zoom = FlxG.camera.zoom;
    }

    if (controlHealthAlpha) {
        curHealthAlpha = lerp(curHealthAlpha, curCameraTarget == 1 ? 0.25 : 1, 1/20);
        for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
            spr.alpha = curHealthAlpha;
    }

    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));
    tornado.skew.x = tornado.skew.y = 3 * FlxMath.fastSin(_curBeat/4);
    tornado.offset.x = 10 * FlxMath.fastSin(_curBeat/2);
    tornado.offset.y = 10 * FlxMath.fastCos(_curBeat/2);
    
    particleShader.time = _curBeat;
    particleShader.particleXY = [(camFollow.x - 1664) * 2, (camFollow.y - 900) * -1.5];
    particleShader.particleZoom = FlxG.camera.zoom*.6;

    drunkShader.time = _curBeat;

    if(isLymanFlying) {
        dad.y = 200 + (20 * FlxMath.fastSin(_curBeat));
        dad.x = 1460 + (50 * FlxMath.fastSin(_curBeat/2));
        stage.stageSprites["BGAGUA"].x = dad.x + 10;
    }

    if (sineSat) trailBloom.sat = 1.2 + (.2 * FlxMath.fastSin(_curBeat + ((Conductor.stepCrochet / 1000) * 16) + ((Conductor.stepCrochet / 1000))));
    if (!scaleTrail) return;
    for (i=>trail in jonTrail.members) {
        var scale = FlxMath.bound(1 + (.11 * FlxMath.fastSin(_curBeat + (i * FlxG.random.float((Conductor.stepCrochet / 1000) * 0.5, (Conductor.stepCrochet / 1000) * 1.2)))), 0.9, 999);
        trail.scale.set(scale, scale);
    }
}

function onPlayerHit(event) {event.showRating = false; songScore += event.score;}
function onPostCountdown(event) {event?.sprite?.cameras = [camCharacters];}