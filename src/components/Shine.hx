
package components;

import luxe.Component;
import luxe.Color;
import luxe.options.ComponentOptions;
import luxe.Visual;

class Shine extends Component
{

    var shineTime:Float;

    var lastColor:Color;
    var newColor:Color;

    override public function new(_options:ShineOptions):Void
    {
        super(_options);

        shineTime = _options.time;
        if(_options.color != null)
        {
            newColor = _options.color;
        }else{
            newColor = new Color().rgb(0xFFFFFF);
        }
    }


    override function init():Void
    {
        lastColor = cast(entity, Visual).color;
        cast(entity, Visual).color = newColor;
    }

    override function update(dt:Float):Void
    {
        shineTime -= dt;

        if(shineTime <=0)
        {
            cast(entity, Visual).color = lastColor;
            remove('shine');
        }
    }

}

typedef ShineOptions = {
    
    > ComponentOptions,

    var time:Float;
    @:optional var color:Color;
}
