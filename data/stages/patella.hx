import funkin.game.ComboRating;

importScript("data/scripts/easteregg/paintings");

function create() {
    stage.stageSprites["snowStorm"].cameras = [camHUD];

	gameOverSong = "gameOvers/sansfield/gameover_sansfield_loop";
	retrySFX = "gameOvers/sansfield/gameover_sansfield_end";

    comboGroup.x += 250;
    comboGroup.y += 250;

    comboRatings = [
		new ComboRating(0, "F", 0xFF941616),
		new ComboRating(0.5, "E", 0xFFCF1414),
		new ComboRating(0.7, "D", 0xFFFFAA44),
		new ComboRating(0.8, "C", 0xFFFFA02D),
		new ComboRating(0.85, "B", 0xFFFE8503),
		new ComboRating(0.9, "A", 0xFF95FBFF),
		new ComboRating(0.95, "S", 0xFF85FBFF),
		new ComboRating(1, "S++", 0xFF0FF7FF),
	];
}

var iceTween:FlxTween;

function beatHit() {
    /*if (iceTween != null && !iceTween?.finished) return;
    if (!FlxG.random.bool(10)) return;

    stage.stageSprites["ice"].setPosition(-700, 400); 
    FlxTween.tween(stage.stageSprites["ice"], {x: 2400}, 2.5);*/
}