package {
    import flash.display.MovieClip
    import flash.geom.Point

    public class Main extends flash.display.MovieClip {
        static public var ok:String = "ok";

        function test(x,y) 
        {
            trace("ok 1/5")
            x = msg(2, 5)
            y = msg(3, 5)
            trace(x);
            trace(y);

            function msg(nr,total):String {
                return ""+this.Main.ok+" "+nr+"/"+total
            }

            var x1 = "err";
            var x2 = "err";
            
            function setok() {
                x1 = "ok 4/5";
                x2 = "ok 5/5";
            }
            var s = setok;
            s();
            trace(x1);
            trace(x2);

            trace("[exit]");
        }

        public function Main() {
            test(3,4);
        }
    }
}
