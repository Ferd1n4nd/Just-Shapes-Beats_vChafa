class arrow {
  float x, y, d1, d2, a, sz, mn, rot = PI, speed = 1;
  float oT = 0, oTV = 0;
  arrow(float x, float y, float d2, float sz, float mn){
    this.x = x;
    this.y = y;
    this.d2 = d2;
    this. sz = sz;
    this.mn = mn;
  }
  void spawn(){
    oTV = 1;
    oT++;
    oT = constrain(oT, 0, 255);
  }
  void despawn(){
    oTV = -1;
    oT--;
    oT = constrain(oT, 0, 255);
  }
  void update(){
    oT += oTV;
    oT = constrain(oT, 0, 255);
    rot += 0.05 * (60 / FPS);
    d1 = - mn - (sz) * (cos(rot) + 1);
    if(oT > 120 && dist(x + cos(a) * (d1 - 15), y + sin(a) * (d1 - 15), jugador.posX, jugador.posY) <= 30){
      preScore /= 2;
      noScoreTimer = 30;
      vida.death = true;
      for (int i = objs.size() - 1; i > -1; i--){
        objs.get(i).timer = 0;
      }
    }
  }
  void drawLine(){
    strokeWeight(2);
    stroke(255, oT);
    line(x + cos(a) * d1, y + sin(a) * d1, x + cos(a) * d2, y + sin(a) * d2);
  }
  void drawHead(PGraphics base, int sub){
    base.colorMode(RGB);
    base.strokeCap(ROUND);
    base.strokeWeight(5);
    base.stroke(255, 0, 0, oT - sub);
    base.line(
      x + cos(a) * d1,
      y + sin(a) * d1,
      x + cos(a) * d1 + cos(a + PI / 5) * 30,
      y + sin(a) * d1 + sin(a + PI / 5) * 30
    );
    base.line(
      x + cos(a) * d1,
      y + sin(a) * d1,
      x + cos(a) * d1 + cos(a - PI / 5) * 30,
      y + sin(a) * d1 + sin(a - PI / 5) * 30
    );
    base.strokeCap(PROJECT);
  }
}

class obj {
  float x, y, vx, vy;
  int timer;
  obj(float x, float y, float vx, float vy){
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    timer = 1;
  }
  boolean onScreen(){
    return (x > -10 && x < width + 10 && y > -10 && y < height + 10);
  }
  void move(){
    float speed = int(c * 14.5) / 6.25 + 0.1;
    x += vx * speed * (60 / FPS);
    y += vy * speed * (60 / FPS);
    if(timer == 3){
      score++;
      timer = 0;
    }
    if(timer == 2 && !onScreen()){
      timer = 3;
    }
    if(timer == 1 && onScreen()){
      timer = 2;
    }
    
    if(x > jugador.posX - 15 && x < jugador.posX + 15 && y > jugador.posY - 15 && y < jugador.posY + 15){
      score /= 2;
      vida.death = true;
      for (int i = objs.size() - 1; i > -1; i--){
        objs.get(i).timer = 0;
      }
    }
  }
  void draw(){
   back.noStroke();
   back.fill(255, 0, 0);
   back.ellipse(x, y, 20, 20);
  }
}
