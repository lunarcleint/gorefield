import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.DiscordUtil;
import flixel.math.FlxBasePoint;
import openfl.Lib;

static var camMoveOffset:Float = 15;
static var camFollowChars:Bool = true;

var movement = new FlxBasePoint();

function create() {
    camFollowChars = true; camMoveOffset = 15;
    updateDiscordPresence = function() {
        DiscordUtil.changeSongPresence(PlayState.detailsText, (PlayState.instance.paused ? "Paused - " : "") + PlayState.SONG.meta.name, PlayState.instance.inst, getIconRPC());
    };
}

function postCreate() {
    var cameraStart = strumLines.members[curCameraTarget].characters[0].getCameraPosition();
    cameraStart.y -= 100; FlxG.camera.focusOn(cameraStart);
    window.title = windowTitleGOREFIELD + " - " + PlayState.instance.SONG.meta.name;

    allowGitaroo = false;
}

function onCameraMove(camMoveEvent) {
    if (camFollowChars) {
        if (camMoveEvent.strumLine != null && camMoveEvent.strumLine?.characters[0] != null) {
            switch (camMoveEvent.strumLine.characters[0].animation.name) {
                case "singLEFT" | "singLEFT-alt": movement.set(-camMoveOffset, 0);
                case "singDOWN" | "singDOWN-alt": movement.set(0, camMoveOffset);
                case "singUP" | "singUP-alt": movement.set(0, -camMoveOffset);
                case "singRIGHT" | "singRIGHT-alt": movement.set(camMoveOffset, 0);
                default: movement.set(0,0);
            };
            camMoveEvent.position.x += movement.x;
			camMoveEvent.position.y += movement.y;
        }
    } else camMoveEvent.cancel();
}

function onSongEnd(){
    updateDiscordPresence = function() {};
}

function destroy() {camFollowChars = true; camMoveOffset = 15; updateDiscordPresence = function() {};}