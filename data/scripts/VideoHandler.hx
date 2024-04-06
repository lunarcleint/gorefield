import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;

function onSubstateOpen(event) if (VideoHandler.curVideo != null && paused) VideoHandler.curVideo.pause();
function onSubstateClose(event) if (VideoHandler.curVideo != null && paused) VideoHandler.curVideo.resume();
function focusGained() if (VideoHandler.curVideo != null && !paused) VideoHandler.curVideo.resume();

public var camVideos:FlxCamera;

public var VideoHandler:T = { // Donde están las clases? Donde están mis Skibidis Toilets?! -EstoyAburridow
    curVideo: null, //* FlxVideoSprite
    behindHUD: false,
    videosToPlay: [],
    camsVisibles: [],
    load: function(paths:Array<String>, behindHUD:Bool, ?onEndReached:Void->Void) {
        VideoHandler.behindHUD = behindHUD;
        var _onEndReached:String->Void = onEndReached; //* Por alguna razón, sin esto, no detecta la función -EstoyAburridow

        var cameras:Array<FlxCameras> = FlxG.cameras.list.copy();
        for (camera in cameras) FlxG.cameras.remove(camera, false);

        camVideos = new FlxCamera();
        camVideos.bgColor = 0x00000000;
        camVideos.visible = false;
        cameras.insert(cameras.indexOf(camHUD) + (behindHUD ? 0 : 1), camVideos);

        for (camera in cameras) FlxG.cameras.add(camera, camera == camGame);

        var prevAutoPause:Bool = FlxG.autoPause;
        FlxG.autoPause = false; //* Así evitamos que se añada el "resume" al momento de volver al juego y lo añadimos nosotros mismos con una condición -EstoyAburridow

        for (path in paths) {
            video = new FlxVideoSprite();
            video.load(Assets.getPath(Paths.video(path)));
            video.cameras = [camVideos];
            video.bitmap.onEndReached.add(function() {    
                VideoHandler.curVideo.bitmap.dispose();
                remove(VideoHandler.curVideo);

                VideoHandler.videosToPlay.shift();
                VideoHandler.curVideo = null;

                for (i => camera in FlxG.cameras.list)
                    camera.visible = VideoHandler.camsVisibles[i];

                if (_onEndReached != null)
                    _onEndReached();
            });
            video.bitmap.onFormatSetup.add(function() {
                VideoHandler.curVideo.setGraphicSize(FlxG.width, FlxG.height);
                VideoHandler.curVideo.screenCenter();
            });
            VideoHandler.videosToPlay.push(video);
        }

        FlxG.autoPause = prevAutoPause;
        if (FlxG.autoPause) 
        {
            for (video in VideoHandler.videosToPlay)
                if (!FlxG.signals.focusLost.has(video.pause))
                    FlxG.signals.focusLost.add(video.pause);
        
            if (!FlxG.signals.focusGained.has(focusGained))
                FlxG.signals.focusGained.add(focusGained);
        }
    },
    playNext: function() {
        VideoHandler.curVideo = VideoHandler.videosToPlay[0];
        VideoHandler.curVideo.play();

        if (!VideoHandler.behindHUD) {
            VideoHandler.camsVisibles = [for (camera in FlxG.cameras.list) camera.visible];
            for (camera in FlxG.cameras.list) camera.visible = camera == camVideos;
        }

        if (VideoHandler.behindHUD) insert(0, VideoHandler.curVideo); 
        else add(VideoHandler.curVideo);
    }
}