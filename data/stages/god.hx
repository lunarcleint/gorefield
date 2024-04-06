import flixel.addons.effects.FlxTrail;
import funkin.backend.shaders.CustomShader;

importScript("data/scripts/easteregg/paintings");

public var jonTrail:FlxTrail;
public var jonFlying:Bool = true;

public var bloom:CustomShader;
public var drunk:CustomShader;
public var warpShader:CustomShader;
public var chromatic:CustomShader;
public var distort:CustomShader;
public var particleSprite:FunkinSprite;
public var particleShader:CustomShader;

public var pixel:CustomShader;

function create() {
    FlxG.camera.bgColor = 0xff000000;

    gameOverSong = "gameOvers/godfield/gameover_godfield_loop";
	retrySFX = "gameOvers/godfield/gameover_godfield_end";

    comboGroup.x += 300;
    comboGroup.y += 300;

    jonTrail = new FlxTrail(dad, null, 4, 10, 0.3, 0.0052);
    jonTrail.beforeCache = dad.beforeTrailCache;
    jonTrail.afterCache = () -> {
		dad.afterTrailCache();
        jonTrail.members[0].x += FlxG.random.float(-1, 4);
		jonTrail.members[0].y += FlxG.random.float(-1, 4);
	}
    jonTrail.color = 0xFFB3B1D8;
    if (FlxG.save.data.trails) insert(members.indexOf(dad), jonTrail);

    particleSprite = new FunkinSprite().makeGraphic(FlxG.width, FlxG.height, 0x00FFFFFF);
    particleSprite.scrollFactor.set(0, 0);
    particleSprite.zoomFactor = 0;
    insert(members.indexOf(stage.stageSprites["BG"])+1, particleSprite);

    particleShader = new CustomShader("particles");
    particleShader.time = 0; particleShader.particlealpha = 0.75;
	particleShader.res = [particleSprite.width, particleSprite.height];
    particleShader.particleXY = [0, 0];
    particleShader.particleColor = [.7,.7,.7];
    particleShader.particleDirection = [-1, 0];
    particleShader.particleZoom = .2; particleShader.layers = 6;
    if (FlxG.save.data.particles) particleSprite.shader = particleShader;

    pixel = new CustomShader("pixel");
    pixel.res = [FlxG.width, FlxG.height];
    pixel.uBlocksize = [10, 10];
    pixel.inner = .5;
    pixel.outer = 1.2;
    pixel.strength = .9;
    pixel.curvature = .5;

    bloom = new CustomShader("glow");
    bloom.size = 8.0; bloom.dim = 1.8;
    FlxG.camera.addShader(bloom);
    camHUD.addShader(bloom);

    drunk = new CustomShader("drunk");
    drunk.strength = .35; drunk.time = 0;
    FlxG.camera.addShader(drunk);

    chromatic = new CustomShader("chromaticWarp");
    chromatic.distortion = 0.2; 
    if (FlxG.save.data.warp) {
        FlxG.camera.addShader(chromatic);
        camHUD.addShader(chromatic);
    }

    warpShader = new CustomShader("warp");
    warpShader.distortion = 1;
    if (FlxG.save.data.warp) {
        FlxG.camera.addShader(warpShader);
    }

    distort = new CustomShader("distort");
    distort.shake = [0, 0];
    FlxG.camera.addShader(distort);
    camHUD.addShader(distort);
}

public var dadY:Float = 100;
public var punishmentDad:Bool = false;
var tottalTime:Float = 0;
var particleZoom:Float = .2;
var particleCamMulti:Float = 1;
function update(elapsed:Float){
    tottalTime += elapsed/1000;

    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));
    if(jonFlying)
        dad.y = dadY + (40 * FlxMath.fastSin(_curBeat*0.8));
    drunk.time = _curBeat/2;
    particleShader.time = _curBeat;

    if (punishmentDad) {
        dad.x = 0; dad.y = 282;

        dad.x += (Math.floor(FlxMath.fastSin((tottalTime*100) * 6) * 8) * 6);
        dad.y += (Math.floor(FlxMath.fastCos((tottalTime*140) * 6) * 8) * 2);

        dad.x += FlxG.random.float(-2.5, 2.5);
        dad.y += FlxG.random.float(-2.5, 2.5);
    }

    for (i=>trail in jonTrail.members) {
        var scale = FlxMath.bound(1.5 + Math.abs(.2 * FlxMath.fastSin((_curBeat/4) + (i * FlxG.random.float((Conductor.stepCrochet / 1000) * 0.5, (Conductor.stepCrochet / 1000) * 1.2)))), 0.9, 999);
        trail.scale.set(scale, scale);
    }
    particleShader.particleZoom = .2 * (3*(FlxG.camera.zoom*particleCamMulti));
}

function onPostStrumCreation(_) {
    _.strum.scale.set(_.strum.scale.x*.95, _.strum.scale.y*.95);
    _.strum.y += 8;
}

function onNoteCreation(_) _.noteScale = .7*.95;

function destroy() {FlxG.game.setFilters([]);}