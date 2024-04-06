import funkin.game.PlayState;
import flixel.addons.effects.FlxTrail;

importScript("data/scripts/VideoHandler");

var controlHealthAlpha:Bool = true;
var curHealthAlpha:Float = 1;

function postCreate() {
    snapCam();

    for (strum in strumLines)
		for (i=>strumLine in strumLines.members){
			switch (i){
				case 2 | 3 | 4 | 5:
					for (char in strumLine.characters)
						char.alpha = 0.0001;
			}
		}

    VideoHandler.load(["GODFIELD_INTRO", "CINEMATIC_LAYER", "GODFIELD_CINEMATIC_2"], false, function() {
        for (camera in FlxG.cameras.list)
            camera.flash(0xFFFFFFFF, (Conductor.stepCrochet / 1000) * 12);
    });
    camVideos.addShader(bloom);
    camVideos.addShader(chromatic);

    if (note_sprite != null) note_sprite.visible = note_sprite.active = false;
}

function onStartCountdown(event) {
    event.cancel(true); 

    new FlxTimer().start(0.001, function(_)
    {
        VideoHandler.playNext();
        startSong();
        
        //* Cuando cancelas el countdown, tienes que iniciar estas variables -EstoyAburridow
        startedCountdown = true;
        if (startTimer == null)
            startTimer = new FlxTimer();
    });
}

function onSongEnd()
    if (PlayState.isStoryMode) {
        FlxG.save.data.canVisitArlene = true;
        redirectStates.set(StoryMenuState, "gorefield/MovieCreditsScreen");
    }

var targetAlpha1 = 0.25;
var targetAlpha2 = 1; 

function update(elapsed:Float) {
    if (controlHealthAlpha) {
        curHealthAlpha = lerp(curHealthAlpha, curCameraTarget == 1 ? targetAlpha1 : targetAlpha2, 1/20);
        for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
            spr.alpha = curHealthAlpha;
    }
}

var lockCam:Bool = false;
var changeCallback = true;
function stepHit(step:Int) {
    if (step >= 4369){
        if(dad.animation.callback == null && changeCallback){
            dad.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int){
                if(frameNumber == 0 && name != 'idle')
                    FlxG.camera.shake(0.005, .15);
                switch(name){
                    case 'singUP':
                        switch(frameNumber){
                            case 0 | 1:
                                boyfriend.setPosition(dad.x - 15,dad.y + 971 + -15);
                            case 2 | 3:
                                boyfriend.setPosition(dad.x - 15,dad.y + 971 + -12);
                            case 4 | 5 | 6:
                                boyfriend.setPosition(dad.x - 15,dad.y + 971 + -11);
                        }
                    case 'singDOWN':
                        switch(frameNumber){
                            case 0 | 1:
                                boyfriend.setPosition(dad.x - 27,dad.y + 977 + -15);
                            case 2 | 3:
                                boyfriend.setPosition(dad.x - 27,dad.y + 977 + -10);
                            case 4 | 5 | 6:
                                boyfriend.setPosition(dad.x - 27,dad.y + 977 + -9);
                        }
                    case 'singLEFT':
                        switch(frameNumber){
                            case 0 | 1 | 2 | 3 | 4 | 5 | 6:
                                boyfriend.setPosition(dad.x - 29,dad.y + 981 + 4);
                        }
                    case 'singRIGHT':
                        switch(frameNumber){
                            case 0 | 1:
                                boyfriend.setPosition(dad.x - 21 + 2,dad.y + 977 + 4);
                            case 2 | 3:
                                boyfriend.setPosition(dad.x - 24 + 2,dad.y + 977 + 4);
                            case 4:
                                boyfriend.setPosition(dad.x - 25 + 2,dad.y + 977 + 4);
                        }
                    case 'idle':
                        switch(frameNumber){
                            case 0 | 1 | 2 | 3 | 25:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981);
                            case 4 | 5:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 4);
                            case 6 | 7:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 7);
                            case 8 | 9:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 9);
                            case 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 10);
                            case 19 | 20:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 7);
                            case 21 | 22:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 4);
                            case 23 | 24:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 2);
                        }
                }
            };
        }
    }

    switch (step) {
        case 32:
            stage.stageSprites["black"].alpha = 0;
            strumLineBfZoom = .28;
        case 800:
            targetAlpha1 = targetAlpha2 = 0;
            for (strum in strumLines){
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 0:
                            for (strumNote in strumLine.members)
                                FlxTween.tween(strumNote, {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});
                    }
                } 
            }
        case 912:
            for (strum in strumLines){
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 0:
                            for (strumNote in strumLine.members)
                                FlxTween.tween(strumNote, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});
                        case 1:
                            for (strumNote in strumLine.members)
                                FlxTween.tween(strumNote, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadInOut, startDelay: (Conductor.stepCrochet / 1000) * 16});
                    }
                } 
            }
        case 935:
            zoomDisabled = true;
            FlxTween.tween(FlxG.camera,{zoom: 0.65}, (Conductor.stepCrochet / 1000) * 120, {ease: FlxEase.quadIn});

            for (sprite in [stage.stageSprites["BG"],stage.stageSprites["BG2"],stage.stageSprites["ALO"],stage.stageSprites["ALO2"]])
                FlxTween.tween(sprite,{alpha: 0.15}, (Conductor.stepCrochet / 1000) * 120, {ease: FlxEase.quadInOut});
        case 1052:
            zoomDisabled = false;
            for (strum in strumLines){
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 1:
                            for (strumNote in strumLine.members)
                                FlxTween.tween(strumNote, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadInOut});
                    }
                } 
            }
            FlxTween.tween(camHUD, {alpha: 0}, 0.4);
        case 1056:
            lockCam = true;
        case 1058:
            FlxTween.num(dadY, 320, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.quadIn}, (val:Float) -> {dadY = val;});
        case 1059:
            remove(jonTrail);
            jonTrail = new FlxTrail(dad, null, 4, 10, 0.3, 0.0052);
            jonTrail.beforeCache = dad.beforeTrailCache;
            jonTrail.afterCache = () -> {
                dad.afterTrailCache();
                jonTrail.members[0].x += FlxG.random.float(-1, 4);
                jonTrail.members[0].y += FlxG.random.float(-1, 4);
            }
            jonTrail.color = 0xFFB3B1D8;
            if (FlxG.save.data.trails) insert(members.indexOf(dad), jonTrail);
        case 1062:
            lockCam = false;

            for (sprite in [stage.stageSprites["BG"],stage.stageSprites["BG2"],stage.stageSprites["ALO"],stage.stageSprites["ALO2"]])
                FlxTween.tween(sprite,{alpha: 1}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadIn, startDelay: (Conductor.stepCrochet / 1000) * 2});

            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
        case 1070:
            targetAlpha2 = 1;
            targetAlpha1 = 0.25;
            dad.cameraOffset.y -= 220;
        case 1587:
            VideoHandler.playNext();
        case 1584:
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadIn});
        case 1632:
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: 1.2}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.25;
            }});
            FlxTween.num(0.2, 6, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.num(1, 0.2, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {bloom.dim = val;});
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn});
        case 1648:
            FlxG.camera._fxShakeDuration = 0;
            jonTrail.visible = jonTrail.active = jonFlying = false;
            strumLineDadZoom = 0.9;
            strumLineBfZoom = 1.2;

            punishmentDad = true;
            for (name => char in preloadedCharacters)
                switch (name) {
                    case "god-gorefield-phase-0":
                        char.cameraOffset.y -= 200;
                    case "god-jon-player":
                        char.y -= 400;
                        char.cameraOffset.y += 300;
                }

            stage.stageSprites["BG"].visible = stage.stageSprites["BG2"].visible = stage.stageSprites["ALO"].visible = stage.stageSprites["ALO2"].visible = false;
            stage.stageSprites["PUNISH_BG1"].alpha = stage.stageSprites["PUNISH_TV"].alpha = 1;

            if (note_sprite != null && (FlxG.save.data.paintPosition == 8 || FlxG.save.data.paintPosition == 8))
                note_sprite.active = note_sprite.visible = true;

            snapCam();

            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});

            FlxTween.num(6, 0.2, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.num(0.2, 1.2, (Conductor.stepCrochet / 1000) * 5, {}, (val:Float) -> {bloom.dim = val;});
        case 2175:
            targetAlpha1 = targetAlpha2 = 1;
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: 1.4}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.25;
            }});
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn});

            FlxG.camera.shake(0.00001, 9999999);
            FlxTween.tween(FlxG.camera, {_fxShakeIntensity: 0.028}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.sineOut, startDelay: (Conductor.stepCrochet / 1000) * 8});
            FlxTween.num(0.2, 6, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.num(1, 0.2, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {bloom.dim = val;});
        case 2192:
            FlxG.camera._fxShakeDuration = -1;

            stage.stageSprites["PUNISH_BG1"].alpha = stage.stageSprites["PUNISH_TV"].alpha = 0;
            stage.stageSprites["LASAGNA_BG"].alpha = 1;
            strumLineBfZoom = .85;
            strumLineDadZoom = .78;

            punishmentDad = false;

            for (name => char in preloadedCharacters)
                switch (name) {
                    case "god-lasagnacat":
                        char.cameraOffset.y -= 200;
                    case "god-lasagnaboy":
                        char.cameraOffset.x += 10;
                        char.cameraOffset.y += 340;
                }

            if (note_sprite != null && (FlxG.save.data.paintPosition == 7 || FlxG.save.data.paintPosition == 8))
                note_sprite.active = note_sprite.visible = false;
            if (note_sprite != null && (FlxG.save.data.paintPosition == 9 || FlxG.save.data.paintPosition == 10))
                note_sprite.active = note_sprite.visible = true;
            
            snapCam();
            FlxG.camera.addShader(pixel);

            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});

            FlxTween.num(6, 0.2, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.num(0.2, 1, (Conductor.stepCrochet / 1000) * 5, {}, (val:Float) -> {bloom.dim = val;});
        case 2320:
            for (strum in strumLines){
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 1:
                            for (strumNote in strumLine.members)
                                FlxTween.tween(strumNote, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadInOut});
                    }
                } 
            }
        case 2448:
            targetAlpha1 = targetAlpha2 = 1;

            strumLineBfZoom = .7;
            strumLineDadZoom = .58;
        case 2720:
            targetAlpha1 = targetAlpha2 = 0;
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: 1.5}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.25;
            }});
            FlxTween.num(0.2, 6, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.num(1, 0.2, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {bloom.dim = val;});

            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadOut});
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadOut});
        case 2736:
            FlxG.camera.removeShader(pixel);
            stage.stageSprites["LASAGNA_BG"].alpha = 0;
            stage.stageSprites["MARCO_BG"].alpha = stage.stageSprites["BONES_SANS"].alpha = 1;
            strumLineBfZoom = -1;
            strumLineDadZoom = -1;
            defaultCamZoom = 0.6;

            particleCamMulti = .4;

            for (name => char in preloadedCharacters)
                switch (name) {
                    case "god-sansfield":
                        char.cameraOffset.y -= 200;
                    case "god-novio-negro":
                        char.y -= 80;
                        char.cameraOffset.y += 330;
                }

            if (note_sprite != null && (FlxG.save.data.paintPosition == 9 || FlxG.save.data.paintPosition == 10))
                note_sprite.active = note_sprite.visible = false;

            snapCam();

            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 30, {ease: FlxEase.quadOut});

            FlxTween.num(6, 0.2, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.num(0.2, 1, (Conductor.stepCrochet / 1000) * 5, {}, (val:Float) -> {bloom.dim = val;});
            zoomDisabled = true;

            camFollowChars = false; 
            camFollow.setPosition(600, 0);

            FlxG.camera.zoom = 1.4;
            FlxTween.tween(FlxG.camera,{zoom: 0.35}, (Conductor.stepCrochet / 1000) * 128.6, {ease: FlxEase.quadInOut, onComplete: function(twn){
                zoomDisabled = false;     
                camFollowChars = true;       
                FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.quadIn});
            }});
            strumLineBfZoom = 0.9;
            strumLineDadZoom = 0.6;
        case 2988:
            targetAlpha1 = targetAlpha2 = 1;
        case 3120:
            zoomDisabled = true;

            camFollowChars = false; 
            camFollow.setPosition(600, 0);
            FlxG.camera.zoom = 0.5;
            snapCam();
            targetAlpha1 = targetAlpha2 = 0.3;
            FlxTween.tween(FlxG.camera,{zoom: 0.35}, (Conductor.stepCrochet / 1000) * 112, {ease: FlxEase.quadInOut, onComplete: function(twn){
                zoomDisabled = false;     
                camFollowChars = true;   
                targetAlpha1 = targetAlpha2 = 1;    
            }});
        case 3504:
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 21, {ease: FlxEase.quadIn, onComplete: function(twn){
                strumLineBfZoom = -1;
                strumLineDadZoom = -1;
            }});
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 24, {ease: FlxEase.quadIn});
        case 3534:
            camVideos.removeShader(bloom);
            VideoHandler.playNext();
        case 3840:
            remove(particleSprite);
            for (name => char in preloadedCharacters)
                switch (name) {
                    case "god-ultragodfield-fall":
                        char.cameraOffset.y -= 200;
                    case "god-nermal-fall":
                        char.cameraOffset.y += 330;
                }
        case 3850:
            camFollowChars = false; 
            camFollow.setPosition(-50, -320);
        case 3856:
            boyfriend.playAnim("idle", true, "DANCE");

            stage.stageSprites["MARCO_BG"].alpha = stage.stageSprites["BONES_SANS"].alpha = 0;
            stage.stageSprites["RAYO_DIVISOR"].alpha = stage.stageSprites["viento"].alpha = 1;
            forceDefaultCamZoom = true;
            FlxG.camera.zoom = defaultCamZoom = 0.7;

            targetAlpha1 = targetAlpha2 = 0.2;

            snapCam();

            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadIn});
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadIn});
        case 4312:
            for (sprite in ["RAYO_DIVISOR", "viento"])
                FlxTween.tween(stage.stageSprites[sprite], {alpha: 0}, 0.4, {
                    onComplete: function() {
                        stage.stageSprites[sprite].active = false;
                    }
                });

            FlxTween.tween(dad, {y: dad.y + 600}, 0.7, {startDelay: 0.2});
            FlxTween.tween(boyfriend, {y: boyfriend.y + 240}, 0.7, {startDelay: 0.2});
        case 4322:
            camFollow.setPosition(0, -320);
        case 4369:
            camFollow.setPosition(-50, -320);
            snapCam();
            dad.y = -330;

            FlxG.camera.zoom = defaultCamZoom = 0.85;
            boyfriend.playAnim("idle", true, "DANCE");
        case 4868:
            for (strum in strumLines)
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 4:
                            for (char in strumLine.characters)
                                char.alpha = 1;
                    }
                }
        case 4872:
            for (strum in strumLines)
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 5:
                            for (char in strumLine.characters)
                                char.alpha = 1;
                    }
                }
        case 4876:
            for (strum in strumLines)
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 3:
                            for (char in strumLine.characters)
                                char.alpha = 1;
                    }
                }
        case 4880:
            targetAlpha1 = targetAlpha2 = 0;
            for (strum in strumLines){
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 0:
                            for (strumNote in strumLine.members)
                                FlxTween.tween(strumNote, {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});
                        case 1:
                            for (strumNote in strumLine.members)
                                FlxTween.tween(strumNote, {x: strumNote.x - 320}, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.quadInOut});
                    }
                } 
            }
            
            camFollow.setPosition(-50, -100);
            defaultCamZoom = 1.6;
            for (strum in strumLines)
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 2:
                            for (char in strumLine.characters)
                                char.alpha = 1;
                    }
                }
        case 5008:
            targetAlpha1 = targetAlpha2 = 0.2;
            camFollow.setPosition(-50, -320);
            defaultCamZoom = 0.85;
            for (strum in strumLines){
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 0:
                            for (strumNote in strumLine.members)
                                FlxTween.tween(strumNote, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});
                        case 1:
                            for (strumNote in strumLine.members)
                                FlxTween.tween(strumNote, {x: strumNote.x + 320}, (Conductor.stepCrochet / 1000) * 12, {ease: FlxEase.quadInOut});
                    }
                } 
            }
            for (strum in strumLines)
                for (i=>strumLine in strumLines.members){
                    switch (i){
                        case 3 | 2 | 4 | 5:
                            for (char in strumLine.characters)
                                FlxTween.tween(char, {y: char.y - 1000, x: char.x - ((i == 4 || i == 5) ? 300 : -300)}, (Conductor.stepCrochet / 1000) * 24, {ease: FlxEase.quadInOut, startDelay: 0.08 * i});
                    }
                } 
        case 5070:
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16);  
        case 5128:
            camFollow.setPosition(-50, -70);
            defaultCamZoom = 1.5;
        case 5136:
            changeCallback = false;
            dad.animation.callback = null;
            dad.visible = false;
        case 5137:
            boyfriend.animation.finishCallback = function(name){
                boyfriend.visible = false;
            };
    }
}

function onCameraMove(camMoveEvent) if (lockCam) camMoveEvent.cancel(true);