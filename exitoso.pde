// Importamos las librerias
import ddf.minim.*;
import ddf.minim.analysis.*;

// Controladores del rendimiento y dificultad del juego
float FPS = 60;
float targetComplexity = 0.50;
float songComplexity = 0.3;

// Definimos las variables de la música
AudioPlayer song;
AudioPlayer song2;
AudioPlayer song3;
AudioPlayer song4;
Minim minim;
FFT fft;

// Llamamos a las clases
Jugador jugador = new Jugador();
Vidas vida = new Vidas();
field f;
arrow a;

// Definimos las variables del juego
float posX, posY, c, adv, count, objSpawnTimer, ang;
int score = 0;
boolean gameover = false;
ArrayList<obj> objs = new ArrayList();
PGraphics back, back2;

float noScoreTimer = 0;
int preScore;

void setup(){
  // Configuración de Minim
  minim = new Minim(this);
  song = minim.loadFile("song.mp3");
  song2 = minim.loadFile("dash.mp3");
  song3 = minim.loadFile("daño.mp3");
  song4 = minim.loadFile("muerte.mp3");
  song.setGain(0);
  song.play();
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  // Configuración de parametros del Canva
  fullScreen(P2D);
  frameRate(FPS);
  back = createGraphics(width, height, P2D);
  back2 = createGraphics(width, height, P2D);
  rectMode(CENTER);
  strokeCap(PROJECT);
  noCursor();
  
  
  // Configuracion de las clases
  f = new field(max(width, height));
  jugador.setup();
  vida.setup();
  a = new arrow(width / 2, height / 2, 0, 500, 1700);
  
  // Configuraciones adicionales
  resetToCenter();
  randomSeed(0);
}

void draw(){
  fft.forward(song.mix);
  float preCalcC = findComplexity(song.mix.toArray());
  c = preCalcC * (targetComplexity / songComplexity) * (0.65 + song.mix.level());
  
  preScore = score;
  noScoreTimer -= (60 / FPS);
  
  float pX = posX, pY = posY;
  
  f.size -= constrain(pow(15 * (c - 0.25), 3), -100, 25) * (60 / FPS);
  f.size = constrain(f.size, 500, max(width, height));
  f.update();
  
  color backColor;
  boolean H = false;
  
  if(f.size <= 505){
    H = true;
    colorMode(HSB);
    backColor = color((100 + (c * 500)) % 255, 255, (c - 0.25) * 200);
  } else {
    backColor = color(c * 200);
  }
  
  
  if(objSpawnTimer <= 0){
    Float[] loc = generateLoc(300);
    float TLX = lerp(random(width / 2 - f.size / 2, width / 2 + f.size / 2), posX, random(0, 1));
    float TLY = lerp(random(height / 2 - f.size / 2, height / 2 + f.size / 2), posX, random(0, 1));
    float a = atan2(TLY - loc[1], TLX - loc[0]);
    float speed = random(5, 15) * (1 + 5 * c);
    objs.add(new obj(loc[0], loc[1], speed * cos(a), speed * sin(a)));
    objSpawnTimer = 17.5;
  }
  
  // Dibujo de los cuadrados de colores
  objSpawnTimer -= c * 2 * (60 / FPS);
  back.beginDraw();
  back.noStroke();
  back.colorMode(H ? HSB : RGB);
  back.fill(backColor, 50 * (60 / FPS) + 1);
  back.rect(-5, -5, width + 10, height + 10);
  back.colorMode(RGB);
  
  // Remover enemigos basicos cuando toca a un enemigo basico
  for(int i = objs.size() - 1; i > -1; i--){
    obj cc = objs.get(i);
    cc.move();
    cc.draw();
    if(cc.timer <= 0){
      objs.remove(i);
    }
  }
  
  // Dibujo y funcionamiento de los enemigos basicos
  back.fill(255);
  back.stroke(255);
  back.strokeWeight(5);
  back.line(posX, posY, pX, pY);
  ang += 0.001 + constrain(c / 75, 0, 0.05);
  a.speed *= 1 + constrain((c - targetComplexity) / 100, -0.05, 0.05);
  a.speed = constrain(a.speed, 0.5, 1.75);
  float dfc = sqrt(sq(width) + sq(height));
  a.x = cos(ang) * dfc + width / 2;
  a.y = sin(ang) * dfc + height / 2;
  a.a = atan2(a.y - height / 2, a.x - width / 2);
  if(a.oT > 0){
    a.update();
  }
  if(f.size <= 700){
    a.spawn();
  } else {
    a.despawn();
  }
  
  // Dibujo del enemigo flecha
  a.drawHead(back, 128);
  back.endDraw();
  image(back, 0, 0);
  a.drawLine();
  stroke(255);
  back2.beginDraw();
  back2.clear();
  a.drawHead(back2, 0);
  back2.endDraw();
  image(back2, 0, 0);
  
  // Jugador
  noStroke();
  //fill(255);
  //rect(posX, posY, 20, 20);
  jugador.draw();
  
  //texto
  //mostrar vidas
  if(vida.numVida == 4){
    vida.mostrar(width/40,height/16);
    vida.mostrar(width/21,height/16);
    vida.mostrar(width/14,height/16);
    vida.mostrar(width/11,height/16);
  }
  if(vida.numVida == 3){
    vida.mostrar(width/40,height/16);
    vida.mostrar(width/21,height/16);
    vida.mostrar(width/14,height/16);
  }
  if(vida.numVida == 2){
    vida.mostrar(width/40,height/16);
    vida.mostrar(width/21,height/16);
  }
  if(vida.numVida == 1){
    vida.mostrar(width/40,height/16);
  }
  if(vida.numVida == 0){
    song.pause();
    song4.play();
    gameover = true;
  }
  vida.texto();
  
  
  // Movimiento de temblor
  pushMatrix();
  if (H){
    translate(random(10 * -c, 10 * c), random(10 * -c, 10 * c));
  }
  strokeWeight(10);
  stroke(255);
  f.draw();
  popMatrix();
  
  // Score
  if(noScoreTimer > 0){
    score = preScore;
  }
  //textSize(50);
  //colorMode(HSB);
  //fill(200, 255, 255);
  //text("Score: "+score, 15, 55);
  pantallaGO();
}


// FUNCIONES
// Regresa al jugador a una posición central
void resetToCenter(){
  posX = width / 2;
  posY = height / 2;
}

void pantallaGO(){
  if(gameover){
    jugador.xMov = 0;
    jugador.yMov = 0;
    fill(255);
    textSize(100);
    text("GAME OVER", width/4, height/2);
  }
}

// Ayuda a encontrar la complejidad de la Transformada de Furier
float findComplexity(float[] k){
  float adv = 0;
  for (int i = 0; i < k.length; i++){
    adv += k[i];
  }
  adv /= k.length;
  float complexity = 0;
  for (int i = 0; i < k.length; i++){
    complexity += abs(k[i] - adv);
  }
  complexity /= k.length;
  return complexity;
}

Float[] generateLoc(float d) {
  float largestAxisSize = max(width, height);
  float a = random(-PI, PI);
  float r = random(largestAxisSize + 12, largestAxisSize + d);
  float cosA = cos(a);
  float sinA = sin(a);
  float x = r / cosA * min(abs(cosA), abs(sinA));
  float y = r / sinA * min(abs(cosA), abs(sinA));
  
  return new Float[] {x, y};
}
