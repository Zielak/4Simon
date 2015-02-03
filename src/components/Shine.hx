
package components;

import luxe.Component;
import luxe.Color;
import luxe.options.ComponentOptions;
import luxe.Visual;

class Shine extends Component
{

    public var color:Color;

    var shineTime:Float;
    var shineColor:Color;

    override public function new(_options:ShineOptions):Void
    {
        super(_options);

        shineTime = _options.time;
        if(_options.color != null)
        {
            shineColor = _options.color;
        }else{
            shineColor = new Color().rgb(0xCCCCCC);
        }
    }


    override function init():Void
    {
        color = shineColor;
    }

    override function update(dt:Float):Void
    {
        shineTime -= dt;

        if(shineTime <=0)
        {
            remove('shine');
        }
    }

}

typedef ShineOptions = {
    
    > ComponentOptions,

    var time:Float;
    @:optional var color:Color;
}
