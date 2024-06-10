class  field {
  float size;
  float mn;
  field(float size){
    this.size = size;
  }
  void draw(){
    rectMode(CENTER);
    noFill();
    strokeWeight(10);
    stroke(255);
    rect(width / 2, height / 2, constrain(size, 5, width - 5), constrain(size, 5, height -5));
  }
  void update(){
    mn = size / 2 -10 -5;
    posX = constrain(posX, max(width / 2 - mn, 15), min(width / 2 + mn, width - 15));
    posY = constrain(posY, max(height / 2 - mn, 15), min(height / 2 + mn, height -15));
  }
}
