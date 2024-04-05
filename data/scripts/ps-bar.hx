import flixel.addons.effects.FlxTrail;

public var psBar:FlxSprite = null;
public var startPsBarVisible = true;
public var psBarTrail:FlxTrail = null;

public var ps:Int = 4;

function postCreate()
{
    ps = FlxG.save.data.ps_hard ? 2 : 4; FlxG.sound.play(Paths.sound('mechanics/ps'), 0); // Preload sound

    psBar = new FlxSprite(1020, 600);
    psBar.frames = Paths.getFrames('mechanics/ps');
    psBar.animation.addByPrefix('4', 'LIVE 4 MAIN', 24, false);
    psBar.animation.addByPrefix('4 remove', 'LIVE 3 loose', 24, false);
    psBar.animation.addByPrefix('3 remove', 'LIVE 2 LOSE', 24, false);
    psBar.animation.addByPrefix('2 remove', 'LIVE 1 LOSE', 24, false);
    
    // Playing the animation reverse for some reason doesn't call "finishCallback" :sob:
    psBar.animation.addByIndices('4 appear', 'LIVE 3 loose', [for (i in 0...22) 21 - i] , "", 24, false);
    psBar.animation.addByIndices('3 appear', 'LIVE 2 LOSE', [for (i in 0...21) 20 - i], "", 24, false);
    psBar.animation.addByIndices('2 appear', 'LIVE 1 LOSE', [for (i in 0...22) 21 - i], "", 24, false);

    psBar.animation.finishCallback = function(name)
        {
            if (name == "4 appear" && ps >= 4)
                psBar.animation.play("4", true);
        }
    psBar.scale.set(0.6, 0.6); 
    psBar.animation.play(Std.string(ps), true);
    psBar.cameras = [camHUD];

    psBarTrail = new FlxTrail(psBar, null, 4, 80, 0.5, 0.069);
    psBarTrail.cameras = [camHUD];
    psBarTrail.color = 0xFFFF0000; psBarTrail.alpha = 0;
    psBarTrail.active = psBarTrail.visible = false;

    if (FlxG.save.data.trails) insert(members.indexOf(gorefieldhealthBarBG), psBarTrail);
    insert(members.indexOf(gorefieldhealthBarBG), psBar);
    psBar.alpha = startPsBarVisible ? 1 : 0.00001;
}

var fullTime:Float = 0;
function update(elapsed:Float) 
{
    if (ps > 2) 
        return;

    fullTime += elapsed;
    psBar.x = lerp(psBar.x, 1020 + (6*FlxMath.fastSin(fullTime)), 1/4) + FlxG.random.float(0, ps == 1 ? .5 : .4);
    psBar.y = lerp(psBar.y, 600 + (4*FlxMath.fastCos(fullTime)), 1/4) + FlxG.random.float(0, ps == 1 ? .5 : .4);
    psBar.color = FlxColor.interpolate(psBar.color, ps == 1 ?0x6CFF6A6A : 0xFFFFC8C8, 1/14);

    psBarTrail.active = psBarTrail.visible = psBar.alpha > 0.01;
    psBarTrail.alpha = lerp(psBarTrail.alpha, 0.4, 1/4);
}

public function removePS(change:Int)
{
    ps -= change;
    
    if (ps >= 1) 
    {
        psBar.animation.play(Std.string(ps + 1) + " remove", true);

        for (trail in psBarTrail.members)
            trail.animation.play(psBar.animation.name, true);
    } 
    else 
        health -= 9999;
}

public function addPS(change:Int)
{
    if (ps >= 4)
        return;

    ps += change;
    psBar.animation.play(Std.string(ps) + " appear", true);
}