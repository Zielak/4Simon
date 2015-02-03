
package ;

import luxe.Entity;

class Simon extends Entity
{

    public var simonSays:Bool;

    public var memory:Array<Int>;
    public var simonRound(get, null):Int;

        // Counts which button player pressed right now
    var playerTurn:Int;

        // Which button is Simon pressing right now
    var simonTurn:Int;



    var saying:Float;
    var interval:Float;

    override function init():Void
    {
        trace('simon.init()');
        simonSays = false;

        memory = new Array<Int>();
        addToMemory(3);

        playerTurn = 0;
        simonTurn = 0;

            // Timers for saying
        saying = 0;
        interval = 0.75;

        Luxe.events.listen('player.clicked', function(e:SimonButtonEvent){
            if(!simonSays){
                playerSaid(e.number);
            }
        });

        Luxe.events.listen('simon.turn', function(e){
            trace('simon.turn(e)');
            if(!simonSays){
                startTalking();
            }
        });

        Luxe.events.listen('simon.finished', function(e){
            if(simonSays){
                stopTalking();
            }
        });


    }

    override function update(dt:Float):Void
    {
        if(simonSays)
        {
            saying -= dt;

            if(saying < 0){
                sayNext();
            }
        }
    }



    function startTalking():Void
    {
        trace('simon.startTalking()');

        simonSays = true;
        sayNext();
    }
    function stopTalking():Void
    {
        simonSays = false;
    }
    function sayNext():Void
    {
        if(simonTurn >= memory.length)
        {
            trace('simon.sayNext() -> Stopped talking');
            Luxe.events.fire('simon.finished');
        }
        else
        {
            saying = interval;

            trace('simon.sayNext() -> ${memory[simonTurn]}');
            Luxe.events.fire('simon.says', {number: memory[simonTurn]});
        }

        simonTurn++;
    }





    function playerSaid(btn:Int):Void
    {
        trace('playerSaid(${btn})');
        if(memory[playerTurn] == btn)
        {
            trace('player.said.good');
            Luxe.events.fire('player.said.good');
            playerTurn++;
            if(playerTurn >= memory.length)
            {
                playerPassed();
            }
        }
        else
        {
            trace('player.said.bad -> memory[${playerTurn}] = ${memory[playerTurn]}');
            Luxe.events.fire('player.said.bad');
            playerFailed();
        }

    }






    function playerFailed():Void
    {
        Luxe.events.fire('player.failed');
        resetRound(false);
    }

    function playerPassed():Void
    {
        trace('player.passed');
        trace('####################################');
        Luxe.events.fire('player.passed');
        resetRound(true);
    }





    function resetRound(passed:Bool):Void
    {
        if(passed)
        {
            playerTurn = 0;
            simonTurn = 0;
            addToMemory(1);
        }
        else
        {
            simonTurn = 0;
            playerTurn = 0;
        }

        Luxe.events.fire('simon.turn');
    }


    function addToMemory(count:Int):Void
    {
        for(i in 0...count)
        {
            memory.push(Math.floor(Math.random()*4));
        }
        trace('addToMemory -> ${memory}');
    }






    function get_simonRound():Int
    {
        return memory.length;
    }

}

typedef SimonButtonEvent = {
    var number:Int;
}
