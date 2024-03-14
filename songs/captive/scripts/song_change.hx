var distortionShader:CustomShader = null;
var blackScreen:FlxSprite;

function create()
{
    distortionShader = new CustomShader("chromaticWarp");
    distortionShader.distortion = 0;
    if (FlxG.save.data.warp) camGame.addShader(distortionShader);

    blackScreen = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
    blackScreen.alpha = 1;
    blackScreen.cameras = [camHUD];
    add(blackScreen);

    stage.stageSprites["RedOverlay"].active = stage.stageSprites["RedOverlay"].visible = true;
    stage.stageSprites["RedOverlay"].alpha = 0;
    stage.stageSprites["RedOverlay"].cameras = [camHUD];

    stage.stageSprites["Warning"].active = stage.stageSprites["Warning"].visible = true;
    stage.stageSprites["Warning"].alpha = 0;
    stage.stageSprites["Warning"].cameras = [camHUD];
}

var boogie:Bool = false;
function stepHit(step:Int) 
{
    switch (step) {
        case 2:
            FlxTween.tween(blackScreen, {alpha: 0}, 1);
        case 432:
            FlxTween.tween(blackScreen, {alpha: 1}, 1);
        case 448:
            FlxTween.tween(blackScreen, {alpha: 0.35}, 1);
        case 704:
            FlxTween.tween(blackScreen, {alpha: 1}, 0.5);
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr, {alpha: 0}, 0.5);
        case 576 | 771 | 1283:
            blackScreen.alpha = 0;
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                spr.alpha = 1;
        case 1155:
            FlxTween.tween(blackScreen, {alpha: 1}, 0.5);
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr, {alpha: 0}, 0.5);
        case 770:
            stage.stageSprites["BG1"].alpha = 0;
            stage.stageSprites["Entrada"].alpha = 1;
            stage.stageSprites["Suelo"].alpha = 1;
            stage.stageSprites["Barriles"].alpha = 1;

            FlxTween.tween(stage.stageSprites["RedOverlay"], {alpha: 0.15}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.qaudInOut, type: 4});

            boyfriend.x -= 600;
            boyfriend.y -= 100;

            dad.scale.set(0.55, 0.55);
            dad.x += 100;
            dad.y -= 100;
            dad.color = 0x6B768E;

            gf.visible = true;
            cpuStrums.visible = false;
            for (playerStrum in playerStrums) playerStrum.x -= 640;
        case 772:
            boyfriend.cameraOffset.x += 450;
            boyfriend.cameraOffset.y += 150;
        case 1282:
            stage.stageSprites["RedOverlay"].visible = false;
            stage.stageSprites["Warning"].alpha = 1;

            camFollowChars = false;
            camFollow.setPosition(850, 550);

            boyfriend.x -= 400;
            boyfriend.y -= 100;
            gf.x -= 300;

            dad.visible = false;
            stage.stageSprites["Entrada"].alpha = 0;
            stage.stageSprites["Suelo"].alpha = 0;
            stage.stageSprites["Barriles"].alpha = 0;
            stage.stageSprites["BG3"].alpha = 1;
        case 1396:
            boogie = false;
        case 1412:
            boogie = true;
        case 1283:
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                spr.alpha = 0;
        case 1284:
            boogie = true;
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                spr.alpha = 0;
        case 1538:
            boogie = false;
        case 1539:
            FlxTween.tween(blackScreen, {alpha: 1}, 0.5);
            FlxTween.tween(FlxG.camera, {zoom: 2}, 1, {ease: FlxEase.quadOut});
            FlxTween.num(1, 0, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
    }

    if (boogie && step % 4 == 0) 
    {
        FlxTween.num(0, 1, 0.1, {}, (val:Float) -> {distortionShader.distortion = val;}); if (curStep > 1410) FlxTween.num(0, 2, 0.1, {}, (val:Float) -> {distortionShader.distortion = val;});
    }
}

function onDadHit(event) if (curStep > 770) FlxG.camera.shake(0.003, 0.1); if (curStep > 1282) FlxG.camera.shake(0.012, 0.1);