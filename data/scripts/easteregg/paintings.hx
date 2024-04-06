import funkin.backend.utils.FunkinParentDisabler;
import funkin.backend.scripting.HScript;

// Pero Aburridow, por qué harias un map de int? Me estoy volviendo skibidi -EstoyAburridow
var positionMap:Map<String, Map<Int, {sprite:String, x:Int, y:Int, scale:Float}>> = [
    "punishment" => [
        0 => {sprite: "note3", x: 200, y: 370, scale: 0.4},
        1 => {sprite: "note3", x: 400, y: 360, scale: 0.4}
    ],
    "stage" => [2 => {sprite: "note1", x: 500, y: 200, scale: 0.5}],
    "hijon" => [2 => {sprite: "note1", x: 500, y: 200, scale: 0.5}],
    "pixelLasagna" => [
        3 => {sprite: "Note_Green", x: 40, y: 440, scale: 1.7}
        4 => {sprite: "Note_Green", x: 470, y: 430, scale: 1.7}
    ],
    "newPixelLasagna" => [
        5 => {sprite: "Note_Green", x: -280, y: -70, scale: 1.7}
        6 => {sprite: "Note_Green", x: 480, y: -70, scale: 1.7}
    ]
    "god" => [
        7 => {sprite: "note2", x: 0, y: 480, scale: 0.5}
        8 => {sprite: "note2", x: 210, y: 460, scale: 0.5}
        9 => {sprite: "note2", x: 0, y: -220, scale: 0.6}
        10 => {sprite: "note2", x: 520, y: -70, scale: 1}
    ]
    "patella" => [
        11 => {sprite: "note2", x: 180, y: 630, scale: 0.4}
    ]
    "cryfield" => [
        12 => {sprite: "note4", x: 800, y: 200, scale: 0.4}
    ]
];

public var note_sprite:FlxSprite;
public var note_data;

function create() {
    if (FlxG.save.data.arlenePhase < 0) {disableScript(); return;}
    if (FlxG.save.data.paintPosition == -1) {disableScript(); return;}
    if (!positionMap.exists(PlayState.SONG.stage)) {disableScript(); return;}
    var stagePositionMap = positionMap.get(PlayState.SONG.stage);
    if (!stagePositionMap.exists(FlxG.save.data.paintPosition)) {disableScript(); return;}
    note_data = stagePositionMap.get(FlxG.save.data.paintPosition);

    note_sprite = new FlxSprite(note_data.x, note_data.y);
    note_sprite.loadGraphic(Paths.image("easteregg/" + note_data.sprite));
    if (note_data.scale != null) {
        note_sprite.scale.set(note_data.scale, note_data.scale);
        note_sprite.updateHitbox();
        note_sprite.antialiasing = false;
    }
    insert(members.indexOf(dad), note_sprite);

    trace("Paintings Loaded");
}

function update(elapsed:Float) {
    if (!note_sprite.visible || !note_sprite.active) return;

    if (FlxG.mouse.overlaps(note_sprite) && FlxG.mouse.justReleased) {
        paused = persistentDraw = true;
        note_sprite.visible = note_sprite.active = persistentUpdate = false;

        openSubState(new ModSubState("gorefield/substates/FoundNote"));
    }
}