
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
        playerTurn = 0;
        simonTurn = 0;
        addToMemory(4);

            // Timers for saying
        saying = 0;
        interval = 0.5;

        Luxe.events.listen('player.clicked', function(e:SimonButtonEvent){
            if(!simonSays){
                playerSaid(e.number);
            }
        });

        Luxe.events.listen('simon.turn', function(e){
            if(!simonSays){
                startTalking();
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
    function sayNext():Void
    {
        trace('simon.sayNext()');

        simonTurn++;

        if(simonTurn > memory.length)
        {
            Luxe.events.fire('simon.finished');
        }

        saying = interval;

        Luxe.events.fire('simon.says', {number: memory[simonTurn]});
    }





    function playerSaid(btn:Int):Void
    {
        if(memory[playerTurn] == btn)
        {
            Luxe.events.fire('player.said.good');
            playerTurn++;
        }
        else
        {
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
        Luxe.events.fire('player.passed');
        resetRound(true);
        addToMemory(1);
    }





    function resetRound(passed:Bool):Void
    {
        if(passed)
        {
            playerTurn = 0;
            addToMemory(1);
        }
        else
        {
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
    }






    function get_simonRound():Int
    {
        return memory.length;
    }

}

typedef SimonButtonEvent = {
    var number:Int;
}
