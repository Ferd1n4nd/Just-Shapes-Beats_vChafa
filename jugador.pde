ArrayList<Particula> particulas = new ArrayList<Particula>();

class Jugador {
  float posX;
  float posY;
  float xMov = 0;
  float yMov = 0;
  float velocidad = 4;
  
  PImage []cuadrado = new PImage[6];
  int frame = 0;
  
  float dashX, dashY;
  float dashVel = 7;
  float velocidadDash = 5;
  float ondaRadio = 0;
  boolean esDash = false;
  float ondaOpacidad = 255;
  
  float tiempoDash = 5;
  float tiempoRestanteDash = 0;
  float tiempoCooldown = 30;
  float tiempoRestanteCooldown = 0;
  
  
  
  void setup() {
    posX = width/2;
    posY = height*0.8;
    imageMode(CENTER);
    cuadrado[0] = loadImage("cuadrado1.png");
    cuadrado[1] = loadImage("cuadrado2.png");
    cuadrado[2] = loadImage("cuadrado3.png");
    cuadrado[3] = loadImage("cuadrado4.png");
    cuadrado[4] = loadImage("cuadrado5.png");
    cuadrado[5] = loadImage("cuadradoInvisible.png");
    imageMode(CORNER);
  }

  void draw(){
    imageMode(CENTER);
    image(cuadrado[5], posX, posY);
    image(cuadrado[frame], posX, posY);
    posX += xMov;
    posY += yMov;
    
    if (tiempoRestanteCooldown > 0) {
      tiempoRestanteCooldown--;
    }
    
    if(tiempoRestanteDash > 0){
      posX += xMov * velocidadDash;
      posY += yMov * velocidadDash;
      tiempoRestanteDash--;
    } else {
      posX += xMov;
      posY += yMov;
    }
    
    if(esDash){
      dashX += dashVel;
      if(dashX > width + ondaRadio){
        esDash = false;
        dashX = -ondaRadio;
        ondaRadio = 0;
        ondaOpacidad = 255;
      }
    }
    if(ondaRadio > 0){
      noFill();
      stroke(255);
      strokeWeight(6);
      ellipse(JposX, JposY, ondaRadio*2, ondaRadio*2);
      
      stroke(255, ondaOpacidad);
      float tamañoDestello = map(ondaOpacidad, 255, 0, ondaRadio*2.5, 0);
      ellipse(JposX, JposY, tamañoDestello, tamañoDestello);
      
      ondaRadio += 3.5;
      ondaOpacidad -= 15;
      
      if(ondaRadio > 50){
        ondaRadio = 0;
        ondaOpacidad = 255;
      }
    }
    
    posX = constrain(posX, max(width / 2 - f.mn, 15), min(width / 2 + f.mn, width - 15));
    posY = constrain(posY, max(height / 2 - f.mn, 15), min(height / 2 + f.mn, height -15));
    
    Particula nuevaParticula = jugador.generarParticula();
    if(nuevaParticula != null){
      particulas.add(nuevaParticula);
    }
    
    for (int i = particulas.size() - 1; i >= 0; i--) {
      Particula p = particulas.get(i);
      p.update();
      p.display();

      float distanciaConJugador = dist(p.pos.x, p.pos.y, jugador.posX, jugador.posY);
      if (distanciaConJugador > 45) { // Distancia corta para desaparecer
        p.tiempoDeVida = 0;
      }

      if (p.esTerminado()) {
        particulas.remove(i);
      }
    }
  }
  Particula generarParticula() {
    float particulaX = random(posX-10,posX+10);
    float particulaY = random(posY-10,posY+10);
  
    if (xMov > 0) {
      particulaX -= 10;
    } else if (xMov < 0) {
      particulaX += 10;
    }
  
    if (yMov > 0) {
      particulaY -= 10;
    } else if (yMov < 0) {
      particulaY += 10;
    }
    imageMode(CORNER);
    return new Particula(particulaX, particulaY);
  }
}

class Particula {
  PVector pos;
  PVector velocidad;
  int tiempoDeVida = 255;
  float tamaño = 4;

  Particula(float x, float y) {
    pos = new PVector(x, y);
    velocidad = PVector.random2D().mult(random(-1,1));
  }

  void update() {
    pos.add(velocidad);
    tiempoDeVida -= 4;
  }

  void display() {
    noStroke();
    fill(255, tiempoDeVida);
    rectMode(CENTER);
    rect(pos.x, pos.y, tamaño, tamaño);
  }

  boolean esTerminado() {
    return tiempoDeVida <= 0;
  }
}
