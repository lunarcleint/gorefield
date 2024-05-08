var distortionShader:CustomShader = null;
var glitchShader:CustomShader = null;

var screamerCam:FlxCamera = null;


function postCreate(){
    screamerCam = new FlxCamera();
    screamerCam.bgColor = FlxColor.TRANSPERENT;
    FlxG.cameras.add(screamerCam, false);
    screamerCam.zoom -= 0.9;
//1.1 0.8 30
    distortionShader = new CustomShader("chromaticWarp");
    distortionShader.distortion = 1;
    if (FlxG.save.data.warp) screamerCam.addShader(distortionShader);

    glitchShader = new CustomShader("glitch");
    glitchShader.glitchAmount = glitchAmount = 1;
    if (FlxG.save.data.glitch) stage.stageSprites["jumpscare"].shader = glitchShader;

    stage.stageSprites["jumpscare"].cameras = [screamerCam];

    stage.stageSprites["blackHUD"].cameras = [camHUD];
    remove(stage.stageSprites["blackHUD"]);
    insert(9999999,stage.stageSprites["blackHUD"]);
}

function stepHit(step:Int){
    switch(step){
        case 0:
            FlxTween.tween(stage.stageSprites["blackHUD"], {alpha: 0}, (Conductor.stepCrochet / 1000) * (step == 320 ? 8 : 30), {startDelay: step == 320 ? 0 : (Conductor.stepCrochet / 1000) * 10});
        case 298:
            camFollow.setPosition(442,418 + (camHUD.downscroll ? 200 : 0));
            defaultCamZoom += 0.5;
        case 320:
            defaultCamZoom -= 0.3;
            camFollowChars = true;
        case 696:
            stage.stageSprites["status"].animation.play('danger',true);
        case 928:
            defaultCamZoom -= 0.1;
            camFollowChars = false;
            camFollow.setPosition(742,288 + (camHUD.downscroll ? 200 : 0));
        case 964:
            camGame.alpha = 0;
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 7, {startDelay: (Conductor.stepCrochet / 1000) * 6});
        case 1002:
            doJumpscare();
    }
}

function doJumpscare(){
    stage.stageSprites["jumpscare"].alpha = 1;
    FlxTween.tween(stage.stageSprites["jumpscare"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 7, {startDelay: (Conductor.stepCrochet / 1000) * 16});

    glitchAmount = 20; fadeTimer = 1.1 * (FlxG.save.data.scare_hard ? 3 : 1); shakeAmount = 3;

    FlxG.sound.play(Paths.sound('mechanics/hyperscream'), 7);
}

var glitchAmount = 1;
var shakeAmount = 1;

var fadeTimer:Float = 0;
var fullTimer:Float = 0;
function update(elapsed) {
    glitchShader.time = fullTimer -= elapsed;
    distortionShader.distortion = FlxG.random.float(0.5, 6);
    
    glitchShader.glitchAmount = glitchAmount = lerp(glitchAmount, 2, 1/5);
    shakeAmount = lerp(shakeAmount, 1, 1/20);

    stage.stageSprites["jumpscare"].x = FlxG.random.float(0.5, 20) * shakeAmount - 310; 
    stage.stageSprites["jumpscare"].y = FlxG.random.float(0.5, 20) * shakeAmount - 200;
}
