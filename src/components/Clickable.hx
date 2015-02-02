
package components;

import luxe.Component;
import luxe.Color;
import luxe.Input.MouseEvent;
import luxe.Rectangle;
import luxe.Vector;
import luxe.Visual;

import luxe.options.ComponentOptions;


class Clickable extends Component
{

    var bounds:Rectangle;
    var eventName:String;

    public var isOver:Bool = false;
    public var isDown:Bool = false;
    public var enabled:Bool = true;

    
    override public function new(options:ClickableComponentOptions):Void
    {
        super(options);

        bounds = options.bounds;
        eventName = options.eventName;
    }

    override function init():Void
    {
        // outColor = cast(entity, Visual).color;
        // overColor = cast(entity, Visual).overColor;
        // downColor = cast(entity, Visual).overColor;

    }

    override function onfixedupdate(rate:Float):Void
    {
        // bounds.x = entity.pos.x;
        // bounds.y = entity.pos.y;

        // if(entity.transform.parent != null)
        // {
        //     bounds.x += entity.transform.parent.local.pos.x;
        //     bounds.y += entity.transform.parent.local.pos.y;
        // }
    }

    override public function onmousemove(event:MouseEvent):Void
    {
        if( bounds.point_inside(event.pos) && !isOver )
        {
            onover();
        }
        if( !bounds.point_inside(event.pos) && isOver )
        {
            onout();
        }
    }

    override public function onmousedown(event:MouseEvent):Void
    {
        if(isOver)
        {
            Luxe.events.fire(eventName+'.mouseclick', entity);
            isDown = true;
        }
    }

    override public function onmouseup(event:MouseEvent):Void
    {
        if(isDown = true)
        {
            Luxe.events.fire(eventName+'.mouseup', entity);
            isDown = false;
        }
    }

    function onover():Void
    {
        isOver = true;
    }


    function onout():Void
    {
        isOver = false;
    }


}


typedef ClickableComponentOptions = {

    > ComponentOptions,

    var bounds:Rectangle;
    var eventName:String;
}