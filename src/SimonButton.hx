
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

        overColor = _options.colorOver;
        downColor = _options.colorDown;
        outColor = _options.color;
    }

    override public function init():Void
    {

        add(clickable);


        Luxe.events.listen('buttons.disable', function(e){
            clickable.enabled = false;
        });
        Luxe.events.listen('buttons.enable', function(e){
            clickable.enabled = true;
        });


        Luxe.events.listen('simon.says', function(e:SimonButtonEvent){
            if(e.number == number){
                add(new components.Shine({
                    name: 'shine',
                    time: 0.3,
                }));
            }
        });
    }

    override function update(dt:Float):Void
    {
        if(clickable.isDown && clickable.enabled){
            color = downColor;
            Luxe.events.fire('player.clicked', this.number);
        }else if(clickable.isOver && clickable.enabled){
            color = overColor;
        }else{
            color = outColor;
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