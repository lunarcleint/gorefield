var saturationShader:CustomShader = null;
var saturation:Float = 0;
var newSaturation:Float = 0;

function create()
{
    stage.stageSprites["sansFieldHUD"].drawComplex(FlxG.camera);
    stage.stageSprites["sansFieldBones"].drawComplex(FlxG.camera);
 
    gf.active = gf.visible = false;

    saturationShader = new CustomShader("saturation");
    saturationShader.sat = saturation = newSaturation = 1;
    if (FlxG.save.data.saturation) camGame.addShader(saturationShader);
    if (FlxG.save.data.saturation) camHUD.addShader(saturationShader);
}

function postCreate(){
	if(!PlayState.isStoryMode) snapCam();

    zoomDisabled = true;
    FlxG.camera.zoom += 0.6;
    stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
    camHUD.alpha = 0.0001;
    stage.stageSprites["overlay"].alpha = 0;
    tweenHealthBar(0,0.001);

    strumLineBfZoom = 0.7;

    for (strum in strumLines)
        for (strumNotes in strum.members)
            strumNotes.y += camHUD.downscroll ? -200 : 700;
}

function onStartCountdown(event){
    if(PlayState.isStoryMode) snapCam();

    FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, 1.5, {startDelay: 0.4, onComplete: (tmr:FlxTween) -> {
        stage.stageSprites["black"].visible = false;
        stage.stageSprites["black"].alpha = 1;
    }});
    FlxTween.tween(camHUD, {alpha: 1}, .5, {startDelay: 0.4});
    FlxTween.tween(stage.stageSprites["overlay"], {alpha: 1}, .3, {startDelay: 0.4});
    FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2, {ease: FlxEase.cubeOut, startDelay: 0.4, onComplete: (tmr:FlxTween) -> {
        zoomDisabled = false;
    }});
}

function update(elapsed:Float)
    saturationShader.sat = saturation = lerp(saturation, newSaturation, 1/30);

function set_sat(sat:String)
    newSaturation = Std.parseFloat(sat);

var shakeAmount:Float = 1;
function stepHit(step:Int) 
{
    // No heart flicker? :sob:
    switch (step) 
    {
        case 120:
            tweenHealthBar(1,(Conductor.stepCrochet / 1000) * 2);

            for (strum in strumLines)
                for (i => strumNote in strum.members){
                    strumNote.angle -= camHUD.downscroll ? -180 : 180;
                    FlxTween.tween(strumNote, {y: strumNote.y - (camHUD.downscroll ? -200 : 700), angle: 0}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.cubeOut, startDelay: 0.1 * i});
                }
        case 637 | 638 | 639 | 640: // * Black screen flickering
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = stage.stageSprites["overlay"].visible = !stage.stageSprites["black"].visible;
            tweenHealthBar(stage.stageSprites["black"].visible ? 0 : 1,0.001);

            if (step != 640) return; // * Stage Change

            for (name => sprite in stage.stageSprites) 
                sprite.active = sprite.visible = name == "sansFieldHUD" || name == "sansFieldBones";

            boyfriend.setPosition(830, -130);
            dad.setPosition(440, -520);

            camFollow.setPosition(802, 295);
            camGame.snapToTarget();

            comboGroup.x -= 330;
            comboGroup.y -= 275;
        case 655: dad.cameraOffset.x = -250;
        case 694 | 696 | 698 | 700 | 702 | 704:
            vocals.volume = 1; // ! UH OH!!!!

            FlxG.camera.shake(0.02 * Math.max(shakeAmount, 0.05), ((Conductor.crochet / 4) / 1000)/2);
            shakeAmount -= 0.15;

            if (step == 694) {
                gf.active = gf.visible = true;
                FlxTween.tween(camHUD, {alpha: 0}, (Conductor.crochet/2) / 1000);
            }
                
        case 733: FlxG.camera.zoom += 0.13; camZoomingStrength = 0; 
        case 748: FlxG.camera.zoom += 0.04;
        case 760: FlxG.camera.zoom += 0.02;
        case 768: FlxTween.tween(camHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000);
        case 816:
            strumLineGfZoom += 0.2;
        case 832:  
            strumLineGfZoom -= 0.2;
        case 944: 
            strumLineGfZoom += 0.4;
            gf.cameraOffset.x -= 200;
            gf.cameraOffset.y += 50;
            tweenHealthBar(0,(Conductor.stepCrochet / 1000) * 3);
        case 960: 
            strumLineGfZoom -= 0.4;
            FlxG.camera.shake(0.05, ((Conductor.crochet / 4) / 1000));
            tweenHealthBar(1,(Conductor.stepCrochet / 1000) * 4);
        case 965: gf.active = gf.visible = false; camZoomingStrength = 1;
        case 1136:
            strumLineBfZoom += 0.4;
            boyfriend.cameraOffset.x += 350;
            boyfriend.cameraOffset.y += 50;
            tweenHealthBar(0,(Conductor.stepCrochet / 1000) * 6);
        case 1152: 
            stage.stageSprites["black"].alpha = 0;
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.crochet * 4) / 1000);
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.crochet * 4) / 1000);
    }
}

function onStrumCreation(_) _.__doAnimation = false;