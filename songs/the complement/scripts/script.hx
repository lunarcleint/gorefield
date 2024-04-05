import funkin.backend.shaders.CustomShader;
var blackScreen:FlxSprite;

public var particleShader:CustomShader; // yes it is a shader

function create() {
    particleShader = new CustomShader("particles");
    particleShader.time = 0; particleShader.particlealpha = 1;
	particleShader.res = [FlxG.width, FlxG.height];
    particleShader.particleXY = [0, 0];
    particleShader.particleColor = [0.1,0.1,0.1];
    particleShader.particleDirection = [-1.2, -0.5];
    particleShader.particleZoom = 1;
    particleShader.layers = 10;
    particleShader.particlealpha = 0;
    if (FlxG.save.data.particles) FlxG.camera.addShader(particleShader);
    stage.stageSprites["BG1"].zoomFactor = 0.7;

    blackScreen = new FlxSprite().makeSolid(FlxG.width + 100, FlxG.height + 100, FlxColor.BLACK);
    blackScreen.alpha = 1;
    blackScreen.cameras = [camHUD];
}

function postCreate()
{
    controlHealthAlpha = false;
    for (i=>strumLine in strumLines.members){
        switch (i){
            case 0:
                strumLine.onHit.add(function(e:NoteHitEvent) {FlxG.camera.shake(0.004, 0.1);});
        }
    }

    lerpCam = false;
    FlxG.camera.zoom = 2;
    tweenHUD(0,0.001);

    insert(9999,blackScreen);
}

function stepHit(step:Int)
{
    switch(step)
    {
        case 0:
            camZoomingStrength = 2;
            FlxTween.tween(blackScreen, {alpha: 0}, (Conductor.stepCrochet / 1000) * 256);
            FlxTween.num(0, 3, (Conductor.stepCrochet / 1000) * 92, {}, (val:Float) -> {particleShader.particlealpha = val;});
            FlxTween.tween(FlxG.camera, {zoom: 0.6}, (Conductor.stepCrochet / 1000) * 256, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.25;
                FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
            }});
        case 240:
            tweenHUD(1,(Conductor.stepCrochet / 1000) * 10);
        case 256:
            controlHealthAlpha = true;
        case 768:
            FlxTween.tween(blackScreen, {alpha: 1}, (Conductor.stepCrochet / 1000) * 19);
        case 832:
            blackScreen.alpha = 0;
    }
}

function update(elapsed:Float) {
    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));

    particleShader.time = _curBeat * 2;
    particleShader.particleZoom = FlxG.camera.zoom*.6;
}

function onStrumCreation(_) _.__doAnimation = false;

function onPlayerHit(event) {event.showRating = false; songScore += event.score;}