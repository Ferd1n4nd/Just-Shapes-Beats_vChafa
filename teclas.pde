boolean arriba, abajo, izquierda, derecha;
float JposX, JposY;

boolean Movimiento(int k, boolean v){
  switch (k) {
  case UP:
    return arriba = v;
  case DOWN:
    return abajo = v;
  case LEFT:
    return izquierda = v;
  case RIGHT:
    return derecha = v;
  default:
    return v;
  }
}

void keyPressed(){
  if(keyCode==UP){
    jugador.yMov = -jugador.velocidad;
  }
  if(keyCode==LEFT){
    jugador.xMov = -jugador.velocidad;
  }
  if(keyCode==DOWN){
    jugador.yMov = jugador.velocidad;
  }
  if(keyCode==RIGHT){
    jugador.xMov = jugador.velocidad;
  }
  
  Movimiento(keyCode, true);
  if(arriba && izquierda){
    jugador.frame = 3;
  } else{
    if(arriba){
      jugador.frame = 2;
    }
    if(izquierda){
      jugador.frame = 1;
    }
  }
  if(abajo && derecha){
    jugador.frame = 3;
  } else{
    if(derecha){
      jugador.frame = 1;
    }
    if(abajo){
      jugador.frame = 2;
    }
  }
  if(arriba && derecha){
    jugador.frame = 4;
  }
  if(abajo && izquierda){
    jugador.frame = 4;
  }
  if(key==' '){
    if (jugador.tiempoRestanteCooldown == 0 && jugador.tiempoRestanteDash == 0){
      song2.play(0);
      jugador.tiempoRestanteDash = jugador.tiempoDash;
      jugador.tiempoRestanteCooldown = jugador.tiempoCooldown;
      jugador.esDash = true;
      jugador.dashX = jugador.posX;
      jugador.ondaRadio = 5;
      jugador.ondaOpacidad = 255;
      JposX = jugador.posX;
      JposY = jugador.posY;
    }
  }
}

void keyReleased(){
  if(keyCode==UP || keyCode==DOWN){
    jugador.yMov = 0;
  }
  if(keyCode==RIGHT || keyCode==LEFT){
    jugador.xMov = 0;
  }
  
  Movimiento(keyCode, false);
  if(arriba==false || abajo==false){
    jugador.frame = 0;
  }
  if(derecha==false || izquierda==false){
    jugador.frame = 0;
  }
}
