
package ;

import luxe.Visual;
import luxe.Rectangle;
import luxe.Color;
import luxe.options.VisualOptions;

import Simon.SimonButtonEvent;
import components.Clickable;

class SimonButton extends Visual
{

    public static inline var SIZE:Int = 100;

    // var _options:SimonButtonOptions;

    var clickable:Clickable;
    var bounds:Rectangle;

    var number:Int;

    var overColor:Color;
    var downColor:Color;
    var outColor:Color;


    override public function new(_options:SimonButtonOptions):Void
    {
        super(_options);

        number = _options.number;

        geometry = Luxe.draw.circle({
            x : 0,
            y : 0,
            r : SIZE,
            start_angle: _options.start_angle,
            end_angle: _options.end_angle,
            color : _options.color
        });

        bounds = _options.bounds;

        clickable = new Clickable({
            bounds: bounds,
            name: 'clickable',
            eventName: 'simon',
        });
        clickable.enabled = false;

        overColor = _options.colorOver;
        downColor = _options.colorDown;
        outColor = _options.color;
    }

    override public function init():Void
    {

        add(clickable);


        Luxe.events.listen('simon.turn', function(e){
            clickable.enabled = false;
            color = downColor;
        });
        Luxe.events.listen('simon.finished', function(e){
            clickable.enabled = true;
            color = outColor;
        });



        Luxe.events.listen('simon.says', function(e:SimonButtonEvent){
            if(e.number == number){
                trace('simon.says ${number} THATS ME!');
                add(new components.Shine({
                    name: 'shine',
                    time: 0.5,
                }));
            }
        });
    }

    override function update(dt:Float):Void
    {
        if(clickable.enabled)
        {
            if(clickable.justClicked && clickable.isDown)
            {
                trace('BTN : clickable.justClicked number: ${this.number}');
                Luxe.events.fire('player.clicked', {number:this.number});
                color = downColor;
            }

            if (clickable.isOver && !clickable.isDown)
            {
                color = overColor;
            }
            else if (clickable.isDown)
            {
                color = downColor;
            }
            else
            {
                color = outColor;
            }
        }else{
            color = outColor;
        }


        // Change color when shining
        if(has('shine')){
            color = get('shine').color;
        }
    }



}



typedef SimonButtonOptions = {

    > VisualOptions,

        // Which button am I?
    var number:Int;

    var start_angle:Float;
    var end_angle:Float;
    var bounds:Rectangle;
    var colorOver:Color;
    var colorDown:Color;
}