
import luxe.Input;
import luxe.Scene;
import luxe.Vector;
import luxe.Color;
import luxe.Rectangle;
import luxe.Visual;

import luxe.Text;



class Main extends luxe.Game
{

    var playing:Bool = false;

    var score:Int;

    var welcomeText:Text;
    var scoreText:Text;


    var playScene:Scene;
    var menuScene:Scene;

    var simonOne:SimonButton;
    var simonTwo:SimonButton;
    var simonThree:SimonButton;
    var simonFour:SimonButton;

    var simonColors:Array<Array<Color>>;

    var background:Visual;
    var turnColorYou:Color;
    var turnColorSimon:Color;

    var simon:Simon;

    override function config(config:luxe.AppConfig):luxe.AppConfig
    {

        if(config.runtime.window != null) {
            if(config.runtime.window.width != null) {
                config.window.width = Std.int(config.runtime.window.width);
            }
            if(config.runtime.window.height != null) {
                config.window.height = Std.int(config.runtime.window.height);
            }
        }
        config.window.resizable = false;

        if(config.runtime.colors != null) {
            simonColors = new Array<Array<Color>>();

            for(i in 0...4){
                simonColors[i] = new Array<Color>();
                for(j in 0...3){
                    simonColors[i][j] = new Color().rgb( Std.parseInt(config.runtime.colors[i][j]) );
                }
            }
        }

        if(config.runtime.turnColorYou != null) {
            turnColorYou = new Color().rgb(config.runtime.turnColorYou);
        }else{
            turnColorYou = new Color().rgb(0xFFFFFF);
        }

            // Another way to write the same thing as above:
        turnColorSimon = (config.runtime.turnColorSimon != null) ? new Color().rgb(config.runtime.turnColorSimon) : new Color().rgb(0x000000);

                
        return config;
    }

    override function ready()
    {

        initGame();

    } //ready

    override function onkeyup( e:KeyEvent )
    {

        if(e.keycode == Key.escape)
        {
            Luxe.shutdown();
        }

        if(e.keycode == Key.enter && !playing)
        {
            playGame();
        }

    } //onkeyup

    override function update(dt:Float)
    {
        
    } //update



    function initGame():Void
    {
        playing = false;

        playScene = new Scene('play');
        menuScene = new Scene('menu');

        addBackground();
        addText();

        addSimon();


    }

        // background changes as turns
    function addBackground():Void
    {
        background = new Visual({
            name: 'background',
            geometry: Luxe.draw.box({
                x:0,
                y:0,
                w: Luxe.screen.w,
                h: Luxe.screen.h,
            }),
            color: turnColorSimon,
        });

        Luxe.events.listen('simon.finished', function(e){
            background.color = turnColorYou;
        });
        Luxe.events.listen('simon.turn', function(e){
            background.color = turnColorSimon;
        });
    }

    function addText():Void
    {
        welcomeText = new Text({
            bounds: new Rectangle(0,50,Luxe.screen.w, 100),
            align: center,
            point_size: 16,
            text: 'Press [ENTER] to let Simon talk...',
            batcher: Luxe.renderer.batcher
        });
        
        scoreText = new Text({
            bounds: new Rectangle(10, 10, Luxe.screen.w-10, 30),
            align: left,
            point_size: 24,
            text: 'SCORE: 0',
        });
        scoreText.visible = false;
        score = 0;
    }

        // Adds clickable buttons of Simon
    function addSimon():Void
    {
        var halfx:Float = Luxe.screen.w/2;
        var halfy:Float = Luxe.screen.h/2;
        var bsize:Float = SimonButton.SIZE;

        var space:Int = 5;

        simonOne = new SimonButton({
            name: 'simonone',
            number: 0,
            color: simonColors[0][0],
            colorOver: simonColors[0][1],
            colorDown: simonColors[0][2],
            start_angle: 0,
            end_angle: 90,
            bounds: new Rectangle(halfx + space, halfy-bsize - space, bsize, bsize),
            pos: new Vector(halfx + space, halfy - space),
        });
        playScene.add( simonOne );

        simonTwo = new SimonButton({
            name: 'simontwo',
            number: 1,
            color: simonColors[1][0],
            colorOver: simonColors[1][1],
            colorDown: simonColors[1][2],
            start_angle: 90,
            end_angle: 180,
            bounds: new Rectangle(halfx + space, halfy + space, bsize, bsize),
            pos: new Vector(halfx + space, halfy + space),
        });
        playScene.add( simonTwo );

        simonThree = new SimonButton({
            name: 'simonthree',
            number: 2,
            color: simonColors[2][0],
            colorOver: simonColors[2][1],
            colorDown: simonColors[2][2],
            start_angle: 180,
            end_angle: 270,
            bounds: new Rectangle(halfx-bsize - space, halfy + space, bsize, bsize),
            pos: new Vector(halfx - space, halfy + space),
        });
        playScene.add( simonThree );

        simonFour = new SimonButton({
            name: 'simonfour',
            number: 3,
            color: simonColors[3][0],
            colorOver: simonColors[3][1],
            colorDown: simonColors[3][2],
            start_angle: 270,
            end_angle: 360,
            bounds: new Rectangle(halfx-bsize - space, halfy-bsize - space, bsize, bsize),
            pos: new Vector(halfx - space, halfy - space),
        });
        playScene.add( simonFour );


        simon = new Simon({
            name: 'simon'
        });
    }

    function playGame():Void
    {
        playing = true;
        welcomeText.visible = false;
        Luxe.events.fire('simon.turn');
    }

    function restartGame():Void
    {
        
    }



} //Main
