class Vidas {
  PImage []vidas = new PImage[4];
  int frameVida = 0;
  int tiempo = 0;
  PFont fuente1;
  int numVida = 4;
  boolean death = false;

  void setup(){
    vidas[0] = loadImage("sprite1.png");
    vidas[1] = loadImage("sprite2.png");
    vidas[2] = loadImage("sprite3.png");
    vidas[3] = loadImage("sprite4.png");
    fuente1 = createFont("Spacetron Personal Used.otf",20);
    textFont(fuente1);
  }
  
  void mostrar(int x, int y){
    image(vidas[frameVida], x, y);
    tiempo += 1;
    if(tiempo > 25){
      frameVida = (frameVida +1) % vidas.length;
      tiempo = 0;
    }
    if(death){
      numVida -= 1;
      song3.play(0);
      fill(#CE1717);
      rect(0,0,width*2,height*2);
      noFill();
      death = false;
    }
  }
  void texto(){
    fill(255);
    textSize(25);
    text("Vidas", width/30, height/20);
    fill(0);
  }
}
