import funkin.game.ComboRating;
import funkin.backend.system.framerate.Framerate;

public var breakingHeart:FunkinSprite = null;
public var breakingPS:Int = 4;

function create(){
	scripts.getByName("ui_healthbar.hx").call("disableScript");
	//camHUD.downscroll = false; //doesnt work with downscroll sorry downscroll players :sob: - lean : shut up buzz ill kill you - lean
}

function postCreate() {
	Framerate.instance.visible = false;

	healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = camFollowChars = canHudBeat = false;
	healthBardisabled = true;

	camFollow.setPosition(642,358);

	for (strum in strumLines)
        for (i=>strumNotes in strum.members)
            strumNotes.x -= 78 * i; //scale arrows 1.5 hud position: 0.91,72

	breakingHeart = new FunkinSprite(90, 100);
    breakingHeart.frames = Paths.getFrames('stages/breaking/BREAKING_LIFES');
    breakingHeart.animation.addByPrefix('4', 'LIFES 4', 24, false);
    breakingHeart.animation.addByPrefix('4 remove', 'LIFES MINUS 3', 24, false);
    breakingHeart.animation.addByPrefix('3 remove', 'LIFES MINUS 2', 24, false);
    breakingHeart.animation.addByPrefix('2 remove', 'LIFES MINUS 1', 24, false);
	breakingHeart.animation.play('4');
	breakingHeart.zoomFactor = 0;
	add(breakingHeart);

	remove(stage.stageSprites["black"]);
	insert(99,stage.stageSprites["black"]);
	stage.stageSprites["black"].cameras = [camHUD];

	if (camHUD.downscroll){
		stage.stageSprites["breakingHUD2"].alpha = 1;
		stage.stageSprites["breakingHUD"].alpha = 0;
		stage.stageSprites["danger"].y += 490;
		breakingHeart.y += 490;

		var moveBy = 65;

		dad.y -= moveBy;
		boyfriend.y -= moveBy;
		for (sprite in [stage.stageSprites["walterBG"],stage.stageSprites["walterLegs"],stage.stageSprites["jesseBG"],stage.stageSprites["jesseBG2"]]){
			if(sprite == stage.stageSprites["jesseBG2"]){
				sprite.y -= moveBy + 50;
			}
			else{
				sprite.y -= moveBy;
			}
		}
	}

		
	snapCam();
}

public static function losePS(psLost){
	breakingPS -= psLost;

	if(breakingPS < 1){
		health -= 99999999;
		return;
	}
	else{
		breakingHeart.animation.play(Std.string(breakingPS + 1) + " remove", true);
	}
	
}

function onStrumCreation(_) _.__doAnimation = false;

function destroy() Framerate.instance.visible = true;