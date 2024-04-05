import funkin.backend.shaders.CustomShader;
import funkin.backend.utils.FlxInterpolateColor;

var ultraCam:FlxCamera;
var chromaticWarpShader:CustomShader;
var chromaticWarpShader2:CustomShader;
var chromatic:CustomShader;
var glowShader:CustomShader;
var glowShader2:CustomShader;

var overlay:FlxSprite;
var overlayColor:FlxInterpolateColor;

function create() {
    for (cam in [camGame, camHUD]) FlxG.cameras.remove(cam, false);

    ultraCam = new FlxCamera(0,FlxG.height/2 - FlxG.width/2, FlxG.width, FlxG.width);
    ultraCam.angle = 90; ultraCam.visible = false;

    chromaticWarpShader = new CustomShader("warp");
    chromaticWarpShader.distortion = 3;

    chromaticWarpShader2 = new CustomShader("warp");
    chromaticWarpShader2.distortion = 1.25;

    chromatic = new CustomShader("chromaticWarp");
    chromatic.distortion = 0; 

    glowShader = new CustomShader("glow");
    glowShader.size = 20.0;
    glowShader.dim = 0.6;

    glowShader2 = new CustomShader("glow");
    glowShader2.size = 0.0;
    glowShader2.dim = 2.2;

    if (FlxG.save.data.warp) {ultraCam.addShader(chromaticWarpShader); camGame.addShader(chromaticWarpShader2); camGame.addShader(chromatic);}
    if (FlxG.save.data.bloom) {ultraCam.addShader(glowShader); camGame.addShader(glowShader2); camHUD.addShader(glowShader2);}
    
    FlxG.cameras.add(ultraCam, false);
    for (cam in [camGame, camHUD]) {cam.bgColor = 0x00000000; FlxG.cameras.add(cam, cam == camGame);}

    overlay = stage.stageSprites["overlay"];
    overlayColor = new FlxInterpolateColor(0xFFFFFFFF);
}

function onStrumCreation(strumEvent) if (strumEvent.player == 0) strumEvent.__doAnimation = false;

function postCreate() {
    ultraNotes();
    camHUD.alpha = 0;
    dad.cameraOffset.y -= 100;
    boyfriend.cameraOffset.y += 100;
}

function ultraNotes() {
    ultraCam.visible = true;

    for (strum in cpuStrums) {
        strum.x = ((FlxG.width/2) - (Note.swagWidth * 2)) + (Note.swagWidth * cpuStrums.members.indexOf(strum)); 
        strum.y = 0;
        strum.cameras = [ultraCam];
    }
}

var doUltraFlashes:Bool = true;

var dimTween:FlxTween;
var sizeTween:FlxTween;
var distortTween:FlxTween;
var dimTween2:FlxTween;
var sizeTween2:FlxTween;
var abberationTween:FlxTween;
function measureHit() {
    if (!doUltraFlashes) return;

    for (tween in [dimTween, sizeTween, distortTween]) if (tween != null) tween.cancel();

    dimTween = FlxTween.num(0.2, 0.7, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {
        glowShader.dim = val;
    });

    sizeTween = FlxTween.num(40.0, 20.0, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.quadOut}, (val:Float) -> {
        glowShader.size = val;
    });

    distortTween = FlxTween.num(4.5, 3.0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {
        chromaticWarpShader.distortion = val;
    });
}
var glowThingy:Bool = false;
var abberationStuff:Bool = false;
function beatHit(beat:Int) {
    if(glowThingy){
        for (tween in [dimTween2, sizeTween2]) if (tween != null) tween.cancel();
        dimTween2 = FlxTween.num(1, 2.2, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {
            glowShader2.dim = val;
        });
    
        sizeTween2 = FlxTween.num(10.0, 0.0, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.quadOut}, (val:Float) -> {
            glowShader2.size = val;
        });
        FlxG.camera.shake(0.01, .12);
        camHUD.shake(0.008, .1);
    }

    if(abberationStuff){
        if(beat % 2 == 0){
            if(abberationTween != null) abberationTween.cancel();
            abberationTween = FlxTween.num((curStep >= 1152 && curStep < 1408) ? 1.4 : 1.2, 0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {
                chromatic.distortion = val;
            });
        }
    }
}

var tottalTime:Float = 0;
var coolSineMulti:Float = 0.8;
var coolSineX:Bool = false;
var coolSineY:Bool = false;
function update(elapsed:Float){
    tottalTime += elapsed;
    camHUD.angle = lerp(camHUD.angle, coolSineY ? (3* coolSineMulti)*FlxMath.fastSin(tottalTime*2) : 0, 0.25);
    camHUD.y = lerp(camHUD.y, coolSineY ? FlxMath.fastSin(tottalTime*1.6 + Math.PI*2)*(9*coolSineMulti) : 0, 0.25);
    camHUD.x = lerp(camHUD.x, coolSineX ? FlxMath.fastCos(tottalTime*2 + Math.PI*2)*(12*coolSineMulti) : 0, 0.25);

    overlayColor.fpsLerpTo(switch (dad.animation.name) {
        case "singLEFT": 0xFFF122A9;
        case "singDOWN": 0xFF00FFFF;
        case "singUP": 0xFF12FA05;
        case "singRIGHT": 0xFFF9393F;
        default: 0xFFFFFFFF;
    }, 1/4);
    overlay.color = overlayColor.color;

    overlay.alpha = lerp(overlay.alpha, switch (dad.animation.name) {
        case "singLEFT" | "singDOWN" | "singUP" | "singRIGHT" : (curStep >= 1152) ? 1 : 0.6;
        default: 0;
    }, 
        switch (dad.animation.name) { //LERP SPEED
            case "singLEFT" | "singDOWN" | "singUP" | "singRIGHT" : 1/4;
            default: 1/22;
    } * elapsed * 32);
}

function stepHit(step:Int){
    switch(step){
        case 0:
            lerpCam = false;
            FlxG.camera.zoom += 0.9;
            FlxTween.tween(FlxG.camera,{zoom: FlxG.camera.zoom - 0.9}, (Conductor.stepCrochet / 1000) * 248);
            FlxTween.tween(stage.stageSprites["black"],{alpha: 0}, (Conductor.stepCrochet / 1000) * 298);
        case 252:
            lerpCam = true;
            dad.cameraOffset.y += 100;
            boyfriend.cameraOffset.y -= 100;
            FlxTween.tween(camHUD,{alpha: 1},(Conductor.stepCrochet / 1000) * 4);
        case 384 | 1024:
            abberationStuff = true;
            if (step == 1024){
                coolSineX = coolSineY = true;
            }
        case 768 | 1681:
            abberationStuff = false;
            if(step == 1681){
                coolSineX = coolSineY = glowThingy = false;
                defaultHudZoom += 0.3;
            }
        case 896:
            camFollowChars = false;
            camFollow.y = -100;
            tweenHealthBar(0,(Conductor.stepCrochet / 1000) * 8);
            defaultCamZoom -= 0.25;
        case 906:
            FlxTween.tween(FlxG.camera,{zoom: FlxG.camera.zoom - 0.2}, (Conductor.stepCrochet / 1000) * 109);
            FlxTween.num(defaultHudZoom, .85, (Conductor.stepCrochet / 1000) * 109, {ease: FlxEase.circOut}, (val:Float) -> {defaultHudZoom = val;});
        case 1016:
            camFollowChars = true;
            tweenHealthBar(1,(Conductor.stepCrochet / 1000) * 8);
            defaultCamZoom += 0.25;
            defaultHudZoom = 1;
        case 1152 | 1552: 
            glowThingy = true;
        case 1408:
            camHUD.alpha = 0;
            tweenHealthBar(0.3,(Conductor.stepCrochet / 1000) * 2);
            glowThingy = false;
        case 1420: FlxTween.tween(camHUD,{alpha: 1},(Conductor.stepCrochet / 1000) * 4);
        case 1424:
            coolSineMulti = 1.3;
            defaultHudZoom -= 0.3;
        case 1648:
            defaultCamZoom += 0.4;
            boyfriend.cameraOffset.y += 120;
        case 1692:
            defaultCamZoom -= 0.4;
            boyfriend.cameraOffset.y -= 120;
        case 1696:
            camFollowChars = false;
            zoomDisabled = true;
            camFollow.y = -100;
            FlxTween.tween(camHUD,{alpha: 0},(Conductor.stepCrochet / 1000) * 4);
            FlxTween.tween(FlxG.camera,{zoom: FlxG.camera.zoom - 0.6}, (Conductor.stepCrochet / 1000) * 128);
        case 1824:
            camGame.visible = camHUD.visible = ultraCam.visible = false;
    }
}