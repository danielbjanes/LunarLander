//https://processing.org/reference/
//lines inntersecting formula

Population test = new Population(100);
PVector line = new PVector(0, 700);

boolean keys[] = new boolean[3];

void setup() {
  size(1200, 800);
  background(255);
  frameRate(120);
  smooth();
}

void draw() {
  background(0);
  
  if(test.allDotsDead()) {
    //Genetic algorithm
    test.calculateFitness();
    test.naturalSelection();
    test.mutate();
    
  }
  else { 
    test.update();
  }
  
  fill(255);
  line(line.x, line.y, line.x + 1200, line.y); 
  
  /*(if(keys[0]) player.thrust();
  if(keys[1]) player.turnLeft();
  if(keys[2]) player.turnRight();*/
  
}

void keyPressed() {
  if (keyCode == UP)  keys[0] = true;
  if (keyCode == LEFT)  keys[1] = true;
  if (keyCode == RIGHT)  keys[2] = true;
}

void keyReleased() {
  if (keyCode == UP)  keys[0] = false;
  if (keyCode == LEFT)  keys[1] = false;
  if (keyCode == RIGHT)  keys[2] = false;
}
