import hxvlc.flixel.FlxVideo; //* VideoHandler no es realmente necesario aquí porque es un video de Game Over -EstoyAburridow 
import funkin.backend.MusicBeatState;

var vhs:CustomShader;

var video:FlxVideo;
var blackOverlay:FlxSprite;

function create() 
{
    blackOverlay = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xff231118);
	blackOverlay.updateHitbox();
	blackOverlay.screenCenter();
	blackOverlay.scrollFactor.set();
    blackOverlay.alpha = 1;
	insert(20, blackOverlay);
}

function postCreate()
{
    comboGroup.x -= 500;
    comboGroup.y += 300;

    gorefieldiconP2.visible = false;
    camHUD.alpha = 0.0001;

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar])
        spr.alpha = 0.35;

    video = new FlxVideo();
	video.load(Assets.getPath(Paths.video("takemejon")));
	video.onEndReached.add(
		function()
		{
            MusicBeatState.skipTransOut = true;
            FlxG.switchState(new PlayState());

            video.dispose();
		}
	); 

    if (FlxG.save.data.vhs)
    {
        vhs = new CustomShader("vhs");
        vhs.time = 0; 
        vhs.noiseIntensity = 0.002;
        vhs.colorOffsetIntensity = 0.5;
        FlxG.camera.addShader(vhs);
        camCharacters.addShader(vhs);
    }

    if (FlxG.save.data.static)
    {
        staticShader = new CustomShader("tvstatic");
        staticShader.time = 0; staticShader.strength = 0.3;
        staticShader.speed = 20;
        FlxG.camera.addShader(staticShader);
    }
}

function tweenCamera(in:Bool){
	boyfriend.cameraOffset.x -= in ? 430 : -430;
	FlxTween.cancelTweensOf(camCharacters);
	FlxTween.tween(camCharacters,{x: in ? 0 : -800},(Conductor.stepCrochet / 1000) * 5, {ease: FlxEase.quadInOut});
    
    FlxTween.num(0.3, 10, (Conductor.stepCrochet / 1000) * 3, {onComplete: function(){
        FlxTween.num(10, 0.3, (Conductor.stepCrochet / 1000) * 5, {}, (val:Float) -> {
            staticShader.strength = val;
            vhs.noiseIntensity = val - 0.298;
        });
    }
    }, (val:Float) -> {
        staticShader.strength = val;
        vhs.noiseIntensity = val - 0.298;
    });
}

var boogie:Bool = false;
var alphaControlIcon2:Bool = true;
function stepHit(step:Int) {
    switch (step) {
        case 0:
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.cubeInOut});
            FlxTween.tween(blackOverlay, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.cubeIn});
        case 238:
            tweenCamera(true);
            remove(blackOverlay);
            insert(11, blackOverlay);
        case 368:
            tweenCamera(false);

            stage.stageSprites["B2"].visible = stage.stageSprites["B2"].active = false;

            for (sprite in ["fondo2", "mesa"])
                stage.stageSprites[sprite].alpha = 1;

            snapCam();
        case 432:
            stage.stageSprites["fondo3"].alpha = 1;

            for (sprite in ["fondo2", "mesa"])
                stage.stageSprites[sprite].alpha = 0;

            snapCam();
        case 496:
            alphaControlIcon2 = false;
            FlxTween.tween(blackOverlay, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
            FlxTween.tween(gorefieldiconP2, {alpha: 0}, (Conductor.stepCrochet / 1000) * 8);
        case 528:
            stage.stageSprites["fondo3"].alpha = 0;
            FlxTween.tween(blackOverlay, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);
            stage.stageSprites["fondo4"].alpha = 1;

            snapCam();
            for (strum in strumLines){
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 0 | 2:
                            for (char in strumLine.characters)
                                char.visible = false;
                    }
                }
            }
        case 648:
            stage.stageSprites["fondo4"].alpha = 0;
            stage.stageSprites["fondoAnimation"].alpha = 1;
            stage.stageSprites["fondoAnimation"].animation.play('idle');
        case 656:
            defaultCamZoom -= 0.2;
            boogie = true;
        case 784:
            boogie = false;
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 5);
        case 788:
            remove(blackOverlay);
            insert(20, blackOverlay);
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: 0.1}, (Conductor.stepCrochet / 1000) * 60);
            FlxTween.tween(blackOverlay, {alpha: 1}, (Conductor.stepCrochet / 1000) * 60, {ease: FlxEase.cubeIn});
    }
    if (boogie && step%2==0) {
        noiseIntensity = 0.02;
        FlxG.camera.zoom += 0.1;
        camHUD.zoom += 0.03;
        colorOffsetIntensity = 1.5;

        if (step%4==0){
            FlxG.camera.angle = 8;
            camHUD.angle = 2;
        }
        else if (step%4 == 2){
            FlxG.camera.angle = -8;
            camHUD.angle = -2;
        }
    }
}

var totalTime:Float = 0;
var noiseIntensity:Float = 0; 
var colorOffsetIntensity:Float = 0;
function update(elapsed) {
    totalTime += elapsed;

    if (video.isPlaying && controls.ACCEPT)
    {
        video.onEndReached.dispatch();
        return;
    }

    FlxG.camera.angle = lerp(FlxG.camera.angle, 0, .1);
    camHUD.angle = lerp(camHUD.angle, 0, .1);

    for (spr in [gorefieldiconP1, gorefieldiconP2]){
        if (spr == gorefieldiconP2){
            if (alphaControlIcon2)
                spr.alpha = 0.35;
        }
        else{
            spr.alpha = 0.35;
        }
    }

    if (FlxG.save.data.static)
        staticShader.time = totalTime;
    
    if (!FlxG.save.data.vhs)
        return;
    vhs.time = totalTime;
    vhs.noiseIntensity = noiseIntensity = lerp(noiseIntensity, 0.002, .1);
    vhs.colorOffsetIntensity = colorOffsetIntensity = lerp(colorOffsetIntensity, 0.5, .1);
}

function onGameOver(event){
    event.cancel(true);

    FlxTween.globalManager.clear();

    persistentUpdate = false;
    persistentDraw = false;
    paused = true;
    canPause = false;

    vocals.stop();
    if (FlxG.sound.music != null)
        FlxG.sound.music.stop();

    camGame.visible = false;
    camHUD.visible = false;

    video.play();
} 