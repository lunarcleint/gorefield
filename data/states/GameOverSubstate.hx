import openfl.Lib;
import funkin.backend.utils.WindowUtils;

static var deathCounter:Int = 0;

var fakeCamFollow:FlxSprite;
var replaceCamera:Bool = false;
var daCharacter:Character;
var fakeCamZoom:Float;

var createNewCharacter:Bool = false;

function create()
{
    var position:Array<{x:Float,y:Float}> = [{x: 0, y: 0}];

    createNewCharacter = PlayState.instance.boyfriend.gameOverCharacter != characterName;

    PlayState.deathCounter++;

    daCharacter = new Character(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, PlayState.instance.boyfriend.gameOverCharacter, true);
    if (createNewCharacter)
    {
        daCharacter.danceOnBeat = false;
        daCharacter.playAnim('firstDeath');
        add(daCharacter);
    }

    fakeCamZoom = 1;
    switch (daCharacter.curCharacter)
    {
        case 'bf-apoc':
            fakeCamZoom = 0.6;
            position[0].x = 160 + daCharacter.x;
            position[0].y = 600 + daCharacter.y;  
        case 'alterbf':
            fakeCamZoom = 1.2;
            position[0].x = 60 + daCharacter.x;
            position[0].y = 200 + daCharacter.y; 
        case 'bf-ultra':
            position[0].x = 200 + daCharacter.x;
            position[0].y = 500 + daCharacter.y;  
        case 'nermal-dead-cry':
            fakeCamZoom = 0.5;
            position[0].x = 550 + daCharacter.x;
            position[0].y = 240 + daCharacter.y;  
        case 'bf-sky':
            fakeCamZoom = 1.5;
            position[0].x = 60 + daCharacter.x;
            position[0].y = 470 + daCharacter.y;  
        case 'bf-black' | 'bf-black2':
            var coolX = daCharacter.curCharacter == 'bf-black' ? 170 + daCharacter.x : 100 + daCharacter.x;
            var coolY = daCharacter.curCharacter == 'bf-black' ? 500 + daCharacter.y : 400 + daCharacter.y;
            position[0].x = coolX;
            position[0].y = coolY; 
            fakeCamZoom = 0.7;
            snapCam();
        case 'jesse-death':
            fakeCamZoom = 0.7;
            position[0].x = 430 + daCharacter.x;
            position[0].y = 600 + daCharacter.y;    
            snapCam();
        case 'godnermaldeath':
            fakeCamZoom = 0.75;
            position[0].x = 530 + daCharacter.x;
            position[0].y = 900 + daCharacter.y;    
            snapCam();
        case 'bf-dead-bw':
            position[0].x = 330 + daCharacter.x;
            position[0].y = 600 + daCharacter.y;    
            snapCam(); 
        case 'jon-player':
            position[0].x = 210 + daCharacter.x;
            position[0].y = 550 + daCharacter.y;
        case 'bf-pixel-dead-lasagna':
            fakeCamZoom = 0.85;
            position[0].x = 820 + daCharacter.x;
            position[0].y = 425 + daCharacter.y;
            FlxG.camera.bgColor = 0xFF527f3a;
            snapCam();
        case 'binky_game_over':
            position[0].x = 1030 + daCharacter.x;
            position[0].y = 1070 + daCharacter.y;
        case 'bf-dead-art':
            position[0].x = 200 + daCharacter.x;
            position[0].y = 500 + daCharacter.y;
        case "luna-dead-angry":
            position[0].x = 400 + daCharacter.x;
            position[0].y = 200 + daCharacter.y;
            fakeCamZoom = 0.8;
            snapCam();
        case 'garfield-dead':
            position[0].x = 600 + daCharacter.x;
            position[0].y = 500 + daCharacter.y;
            fakeCamZoom = 0.8;
            snapCam();
        default:
            var camPos = daCharacter.getCameraPosition();
            position[0].x = camPos.x + daCharacter.x;
            position[0].y = camPos.y + daCharacter.y; 
    }

    if (!FlxG.save.data.baby)
        deathCounter++;

    fakeCamFollow = new FlxSprite(position[0].x, position[0].y).makeSolid(1, 1, 0xFFFFFFFF);
    fakeCamFollow.visible = false;
    add(fakeCamFollow);
    replaceCamera = true;


    window.title = windowTitleGOREFIELD + " - " + PlayState.instance.SONG.meta.name + " - GAME OVER";
}

function postCreate()
{
    if (!createNewCharacter)
        return;

    for (member in members)
        if (Std.isOfType(member, Character))
        {
            if (member == daCharacter)
                continue;

            remove(member);
            break;
        }
}

function beatHit(curBeat:Int)
{
    if (!createNewCharacter)
        return;

    if (FlxG.sound.music != null && FlxG.sound.music.playing)
        daCharacter.playAnim("deathLoop", true);
}

function update(elapsed:Float)
{
    FlxG.camera.zoom = lerp(FlxG.camera.zoom, fakeCamZoom, 0.05);
    if(replaceCamera){
        FlxG.camera.target = fakeCamFollow;
        replaceCamera = false;
    }

    if (!FlxG.save.data.baby && deathCounter == 3 && controls.ACCEPT && !isEnding && !FlxG.save.data.dev)
    {
        isEnding = true;
        deathCounter = 0;
        FlxG.switchState(new ModState("gorefield/BebeRepeatAfterMem"));
    }

    if (createNewCharacter)
    {
        if (controls.ACCEPT && !isEnding)
            daCharacter.playAnim("deathConfirm", true);

        if (!isEnding && ((!lossSFX.playing) || (daCharacter.getAnimName() == "firstDeath" && daCharacter.isAnimFinished())) && (FlxG.sound.music == null || !FlxG.sound.music.playing)) 
        {
            CoolUtil.playMusic(Paths.music(gameOverSong), false, 1, true, 100);
            daCharacter.playAnim("deathLoop", true);
        }
    }

    if (controls.BACK)
        isEnding = true; //fix that one music bug that codename somehow neglected
}