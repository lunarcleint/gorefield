import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
import funkin.backend.utils.WindowUtils;

importScript("data/scripts/VideoHandler");

var dadBackdrop:FlxBackdrop;

function create() 
{
    devControlBotplay = !(player.cpu = false);

    VideoHandler.load(["inicio_payaso_god", "BinkyLaugh"], false);

    dadBackdrop = new FlxBackdrop(null, FlxAxes.X);
    dadBackdrop.setPosition(dad.x, dad.y + 120);
    dadBackdrop.frames = Paths.getSparrowAtlas("characters/Binky_alt");
    dadBackdrop.scale.set(0.65, 0.65);
    dadBackdrop.velocity.x -= 500;
    dadBackdrop.visible = dadBackdrop.active = false;
    dadBackdrop.alpha = 0;
    insert(members.indexOf(boyfriend), dadBackdrop);

    blackOverlay = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xff000000);
	blackOverlay.updateHitbox();
	blackOverlay.screenCenter();
	blackOverlay.scrollFactor.set();
    blackOverlay.cameras = [camGame];
	add(blackOverlay);
}

function postCreate() 
{
    defaultCamZoom = 1.4;
    FlxG.camera.zoom = 1.4;

    boyfriend.cameraOffset.x += 300;
    boyfriend.cameraOffset.y += 120;

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
        spr.alpha = 0;

    camHUD.alpha = 0;
    cpuStrums.visible = false;

    FlxG.save.data.canVisitArlene = false;
    FlxG.save.data.arlenePhase = 0;
    FlxG.save.data.beatWeekG7 = true;
    FlxG.save.data.weeksUnlocked = [true, true, true, true, true, true, true, true];
}

function onSongStart() {
    VideoHandler.playNext();
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 124:
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
        case 128:
            FlxTween.tween(blackOverlay, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16);

            for (sprite in ["floor", "background"])
                stage.stageSprites[sprite].alpha = 0.35;
        
            snapCam();
        case 256:
            cpuStrums.visible = true;

            defaultCamZoom = 0.65;
            FlxG.camera.zoom = 0.65;

            for (sprite in ["floor", "background"])
                stage.stageSprites[sprite].alpha = 1;

            targetAlpha1 = 1;

            camFollowChars = false; camFollow.setPosition(155, 200);
            snapCam();
        case 257:
            boyfriend.cameraOffset.x -= 300;
            boyfriend.cameraOffset.y -= 120;
        case 752:
            devControlBotplay = !(player.cpu = true);
            VideoHandler.playNext();
        case 760:
            cpuStrums.visible = false;

            for (sprite in ["floor", "background", "light"])
                stage.stageSprites[sprite].visible = stage.stageSprites[sprite].active = sprite == "light";

            snapCam();
        case 761:
            targetAlpha1 = 0.3;

            dad.alpha = 0;
        case 768:
            (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 8, function () {
                devControlBotplay = !(player.cpu = false);
            });
        case 896:
            dadBackdrop.visible = dadBackdrop.active = true;
            FlxTween.tween(dadBackdrop, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
        case 1152:
            FlxTween.tween(dadBackdrop, {alpha: 0}, (Conductor.stepCrochet / 1000) * 41);
            FlxTween.tween(boyfriend, {alpha: 0}, (Conductor.stepCrochet / 1000) * 41);
        case 1197:
            boyfriend.alpha = 0;
        case 1200:
            FlxTween.tween(boyfriend, {alpha: 1}, (Conductor.stepCrochet / 1000) * 12);
        case 1270:
            devControlBotplay = !(player.cpu = true);
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);
        case 1286:
            blackOverlay.alpha = 1;
            devControlBotplay = !(player.cpu = false);
    }
}
var targetAlpha1 = 0;
var controlHealthAlpha:Bool = true;
var curHealthAlpha:Float = 1;
function update(elapsed:Float)
{
    if (controlHealthAlpha) {
        curHealthAlpha = lerp(curHealthAlpha, targetAlpha1, 1/30);
        for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
            spr.alpha = curHealthAlpha;
    }

    if (dadBackdrop == null || !dadBackdrop.active)
        return;

    dadBackdrop.animation.addByPrefix("b", dad.animation.frameName, 1, true);
    dadBackdrop.animation.play("b", true);
    
    //dadBackdrop.frameOffset = dad.frameOffset;
}