function create() {
    if (stage == null || stage.stageXML == null) return;

    var countDowns:Array<String> = ["three", "two", "one", "go"];
    for (node in stage.stageXML.elements()) {
        if (node.nodeName != "countdown") continue;
        for (countDownNode in node.elements()) {
            if (countDownNode.exists("sprite")) introSprites[countDowns.indexOf(countDownNode.nodeName)] = countDownNode.get("sprite");
            if (countDownNode.exists("sound")) introSounds[countDowns.indexOf(countDownNode.nodeName)] = countDownNode.get("sound");
        }
    }

    PlayState.instance.scripts.remove(PlayState.instance.scripts.getByName("stage_countdown.hx"));
}