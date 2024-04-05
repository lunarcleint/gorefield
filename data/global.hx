import funkin.game.GameOverSubstate;
import funkin.menus.PauseSubState;
import funkin.menus.BetaWarningState;

import funkin.backend.utils.WindowUtils;
import openfl.Lib;
import lime.graphics.Image;

import hxvlc.util.Handle;

static var curMainMenuSelected:Int = 0;
static var curStoryMenuSelected:Int = 0;
static var moustacheMode:Bool = false;
static var catbotEnabled:Bool = false;

static var seenMenuCutscene:Bool = false;

static var windowTitleGOREFIELD:String = "Friday Night Funkin': Gorefield V2";

public static var weekProgress:Map<String, {song:String, weekMisees:Int, weekScore:Int, deaths:Int}> = [];

static var redirectStates:Map<FlxState, String> = [
    TitleState => "gorefield/TitleScreen",
    MainMenuState => "gorefield/MainMenuScreen",
    FreeplayState => "gorefield/StoryMenuScreen"
    StoryMenuState => "gorefield/StoryMenuScreen",
    BetaWarningState => "gorefield/LaguageSelectorScreen",
];

function new() {
    Handle.init([]);

    // MECHANICS
    if (FlxG.save.data.baby == null) FlxG.save.data.baby = false;
    if (FlxG.save.data.ps_hard == null) FlxG.save.data.ps_hard = false;
    if (FlxG.save.data.scare_hard == null) FlxG.save.data.scare_hard = false;
    if (FlxG.save.data.blue_hard == null) FlxG.save.data.blue_hard = false;
    if (FlxG.save.data.orange_hard == null) FlxG.save.data.orange_hard = false;

    // VISUALS
    if (FlxG.save.data.bloom == null) FlxG.save.data.bloom = true;
    if (FlxG.save.data.glitch == null) FlxG.save.data.glitch = true;
    if (FlxG.save.data.warp == null) FlxG.save.data.warp = true;
    if (FlxG.save.data.wrath == null) FlxG.save.data.wrath = true;
    if (FlxG.save.data.heatwave == null) FlxG.save.data.heatwave = true;
    if (FlxG.save.data.static == null) FlxG.save.data.static = true;
    if (FlxG.save.data.drunk == null) FlxG.save.data.drunk = true;
    if (FlxG.save.data.vhs == null) FlxG.save.data.vhs = true;

    if (FlxG.save.data.drunk == null) FlxG.save.data.drunk = true;
    if (FlxG.save.data.saturation == null) FlxG.save.data.saturation = true;

    if (FlxG.save.data.trails == null) FlxG.save.data.trails = true;
    if (FlxG.save.data.particles == null) FlxG.save.data.particles = true;
    if (FlxG.save.data.flashing == null) FlxG.save.data.flashing = true;

    //PROGRESSION
    if (FlxG.save.data.weeksFinished == null) FlxG.save.data.weeksFinished = [false, false, false, false, false, false];
    if (FlxG.save.data.codesUnlocked == null) FlxG.save.data.codesUnlocked = false;
    if (FlxG.save.data.weeksUnlocked == null) FlxG.save.data.weeksUnlocked = [true, false, false, false, false, false, false, false];

    if (FlxG.save.data.beatWeekG1 == null) FlxG.save.data.beatWeekG1 = false;
    if (FlxG.save.data.beatWeekG2 == null) FlxG.save.data.beatWeekG2 = false;
    if (FlxG.save.data.beatWeekG3 == null) FlxG.save.data.beatWeekG3 = false;
    if (FlxG.save.data.beatWeekG4 == null) FlxG.save.data.beatWeekG4 = false;
    if (FlxG.save.data.beatWeekG5 == null) FlxG.save.data.beatWeekG5 = false;
    if (FlxG.save.data.beatWeekG6 == null) FlxG.save.data.beatWeekG6 = false;
    if (FlxG.save.data.beatWeekG7 == null) FlxG.save.data.beatWeekG7 = false;
    if (FlxG.save.data.beatWeekG8 == null) FlxG.save.data.beatWeekG8 = false;
    if (FlxG.save.data.firstTimeLanguage == null) FlxG.save.data.firstTimeLanguage = true;

    if(FlxG.save.data.weekProgress == null) FlxG.save.data.weekProgress = ["" => {}];
    weekProgress = FlxG.save.data.weekProgress;
    // CODES 
    if (FlxG.save.data.extrasSongs == null) FlxG.save.data.extrasSongs = [];
    if (FlxG.save.data.extrasSongsIcons == null) FlxG.save.data.extrasSongsIcons = [];
    if (FlxG.save.data.codesList == null) FlxG.save.data.codesList = ["HUMUNGOSAURIO", "PUEBLO MARRON", "ALTERCAT"];

    // EASTER EGG
    if (FlxG.save.data.canVisitArlene == null) FlxG.save.data.canVisitArlene = false;
    if (FlxG.save.data.hasVisitedPhase == null) FlxG.save.data.hasVisitedPhase = false;
    if (FlxG.save.data.paintPosition == null) FlxG.save.data.paintPosition = -1;
    if (FlxG.save.data.arlenePhase == null) FlxG.save.data.arlenePhase = 0;
    
    // CREDITS
    if (FlxG.save.data.alreadySeenCredits == null) FlxG.save.data.alreadySeenCredits = false;

    // OTHER
    if (FlxG.save.data.spanish == null) FlxG.save.data.spanish = false;
    if (FlxG.save.data.dev == null) FlxG.save.data.dev = false;

    Lib.application.onExit.add(function(i:Int) {
        FlxG.save.data.weekProgress = weekProgress;
        FlxG.save.flush();
        trace("Saving Week Progress...");
    });
}

function preStateSwitch() {
    WindowUtils.resetTitle();
    window.title = windowTitleGOREFIELD;
    #if !GOREFIELD_CUSTOM_BUILD
    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('iconOG'))));
    #end
    FlxG.camera.bgColor = 0xFF000000;

    if (Std.isOfType(FlxG.state, PlayState) && (FlxG.state.subState == null ? true : !Std.isOfType(FlxG.state.subState, GameOverSubstate) && !Std.isOfType(FlxG.state.subState, PauseSubState)) // ! CHECK IN GAME/NOT IN GAME OVER
        && Std.isOfType(FlxG.game._requestedState, PlayState) && PlayState.isStoryMode) // ! CHECK STORY MODE/ GOING TO OTHER SONG
        {FlxG.switchState(new ModState("gorefield/LoadingScreen")); return;} // LOADING SCREEN

    for (redirectState in redirectStates.keys()) 
        if (Std.isOfType(FlxG.game._requestedState, redirectState)) 
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

function destroy() FlxG.camera.bgColor = 0xFF000000;