import funkin.game.ComboRating;
import funkin.backend.system.framerate.Framerate;

import flixel.util.FlxAxes;
import flixel.ui.FlxBarFillDirection;
import flixel.ui.FlxBar;

function create(){
	//scripts.getByName("ui_healthbar.hx").call("disableScript");
}

function postCreate() {
	Framerate.instance.visible = false;

	healthBar.visible = healthBarBG.visible = gorefieldhealthBarBG.visible = gorefieldhealthBar.visible = iconP1.visible = iconP2.visible = camFollowChars = canHudBeat = false;
	healthBardisabled = true;

	makeHealthBar();

	camFollow.setPosition(742,288 + (camHUD.downscroll ? 200 : 0));

	if (camHUD.downscroll){
		stage.stageSprites["status"].y += 550;
		stage.stageSprites["sombra"].y += 650;

		boyfriend.cameraOffset.y += 60;
		dad.cameraOffset.y += 60;
	}

	comboGroup.x += 640;
    comboGroup.y -= 10;
		
	snapCam();
}

function makeHealthBar(){
	gorefieldhealthBar = new FlxBar(40, stage.stageSprites["bgBar"].y + (camHUD.downscroll ? 28 : 72), FlxBarFillDirection.RIGHT_TO_LEFT, 658, 22, PlayState.instance, "health", 0, 2);
    gorefieldhealthBar.createImageBar(Paths.image("stages/altercat/barEmpty"), Paths.image("stages/altercat/bar"));
	gorefieldhealthBar.cameras = [camHUD];
	gorefieldhealthBar.scale.set(0.616,0.9);
	gorefieldhealthBar.updateHitbox();
	stage.stageSprites["bgBar"].cameras = [camHUD];
    insert(members.indexOf(stage.stageSprites["bgBar"])+1,gorefieldhealthBar);
}

function onStrumCreation(_) _.__doAnimation = false;

function destroy() Framerate.instance.visible = true;