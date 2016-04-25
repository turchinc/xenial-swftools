
package {
    import flash.display.MovieClip

    public class Main extends flash.display.MovieClip {

        var count:int = 1;
        var num:int = 18;

        function assert(b:Boolean) {
            if(b) {
                trace("ok "+count+"/"+num);
            } else {
                trace("error "+count+"/"+num);
            }
            count = count + 1
        }

        function Main() {
            var x:int = 0; 
            var y:int = 0;

            /* test that assignment expressions do indeed return the
               right value */
            x = (y=1);   assert(x==1 && y==1); //x=1;y=1;
            x = (y++);   assert(x==1 && y==2); //x=1;y=2;
            x = (y--);   assert(x==2 && y==1); //x=2;y=1;
            x = (++y);   assert(x==2 && y==2); //x=2;y=2;
            x = (--y);   assert(x==1 && y==1); //x=1;y=1;
            x = (y += 1);assert(x==2 && y==2); //x=2;y=2;
            x = (y -= 1);assert(x==1 && y==1); //x=1;y=1;
            x = y = 5;   assert(x==5 && y==5); //x=5;y=5;

            y = 5;
            x = (y*=5);  assert(x==25 && y==25);
            x = (y%=7);  assert(x==4 && y==4);
            x = (y<<=1);  assert(x==8 && y==8);
            x = (y>>=1);  assert(x==4 && y==4);
            x = (y>>>=1);  assert(x==2 && y==2);
            y = 2;
            x = (y/=2);  assert(x==1 && y==1);
            x = 0x55;
            x |= 0x0f;   assert(x==0x5f);

            x=3;y=3;
            x ^= 7;
            y = y^7;
            assert(x==y);

            x = 0x55;
            y = 0x0f;
            x &= y;
            assert(x==0x05);

            /* nested assignment expressions need different temporary
               registers- make sure they don't collide */
            var a:int = 1;
            var b:int = 2;
            var c:int = 3;
            var d:int = 4;
            a += b += c += d += 1
            assert(a==11 && b==10 && c==8 && d==5);

            trace("[exit]");
        }
    }
}

