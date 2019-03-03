class Lander {

  PVector line = new PVector(0, 700);
  Brain brain;
  
  float fitness = 0;
  boolean isBest = false;
  
  // cordinates
  float x = 100;
  float y = 100;

  // shape attributes
  int angle = -90;
  int height = 40;
  int width = 20;

  // movement variables
  float verticalAcceleration = 0;
  float horizontalAcceleration = 3;
  double verticalVelocity = 0;
  double horizontalVelocity = 0;

  // state markers
  boolean isThrusting;
  boolean dead = false;
  boolean groundTouched = false;
  boolean landed = false;

  // constants
  final float GRAVITY = 0.005;
  final float THRUST_RATE = 0.015;
  
  float fuelUsed = 0;
  
  int generation;

  Lander(int gen) {
    generation = gen;
    int stepScale = generation * 10;
    brain = new Brain(2000);
  }
  
  //-------------------------------------------------------------------------------------------------------------------
  
  void update() {
    if(!dead && !landed) {
      movement(); 
      if(groundTouched && angle == 0 && horizontalVelocity < 0.2 && verticalVelocity < 0.2) {
        landed = true;
      }
    }
    
    show();
    
    isThrusting = false;
  }
  
  //-------------------------------------------------------------------------------------------------------------------
  
  void calculateFitness() {
    /**
    * Error =  
    * how far away the angle is from 0
    * how far away the horizontal velocity is from zero
    * how far away the vertical velocity is from zero
    */
    //lands correctly
    if(landed) {
      fitness = 1.0/16.0 + 10000.0/(float)(brain.step * brain.step);
    } else {
      float angleError = 0;
      float horizError = 0;
      float vertError = 0;
      float distError = 0;
      float fuelError = 0;
      float notTouchedGroundPenalty = 0;
      
      if(groundTouched) {
        angleError = (0 - angle);
        horizError = abs(sq(0 - (float)horizontalVelocity));
        vertError = abs(sq(0 - (float)verticalVelocity));
        
      } else {
        notTouchedGroundPenalty = 100;
        
        if(x < 300 || x > 900) {
          distError = abs(dist(x, y, 600, line.y)); 
        } else {
          distError = abs(dist(x, y, x, line.y)); 
        } 
      }
      
      //fuelError = abs(fuelUsed/20);
      
      fitness = 1.0/( sq(angleError + horizError + vertError + distError + notTouchedGroundPenalty + fuelError) );
    }
  }
  
  //-------------------------------------------------------------------------------------------------------------------
  
  Lander createChild() {
    Lander child = new Lander(generation);
    child.brain = brain.clone();
    return child;
  }
  
  //-------------------------------------------------------------------------------------------------------------------

  
  //Movement input
  void turnRight() { if (angle < 90) angle++; }
  void turnLeft() { if (angle > -90) angle--; }
  void thrust() { isThrusting = true; }
  
  //-------------------------------------------------------------------------------------------------------------------
  
  void movement() {
    
    if(brain.step >= brain.MAX_STEP){
      dead = true;
      return ;
    }
    
    if(brain.rotateLog[brain.step] == -1) turnLeft();
    if(brain.rotateLog[brain.step] == 1) turnRight();
    
    
    //sets thrusting based on brain
    isThrusting = brain.thrustLog[brain.step];
    
    if (isThrusting) {
      verticalAcceleration += GRAVITY + -(THRUST_RATE * cos(radians(angle)));
      horizontalAcceleration += (THRUST_RATE * sin(radians(angle)));
      fuelUsed++;
    } else {
      verticalAcceleration += GRAVITY;
    }
    
    /* COLLISION!!! AHHHH */
    int i = 0;
    while (i < 1200) {
      if(rectangleToPoint(width + 14, height + 3, radians(angle), x, y, line.x + i, line.y)){
        groundTouched = true;
         dead = true;
      }
      i += 5; 
    }
    
    verticalVelocity = verticalAcceleration;
    y += verticalVelocity;

    horizontalVelocity = horizontalAcceleration;
    x += horizontalVelocity;
    
    brain.step++;
  }
  
  //-------------------------------------------------------------------------------------------------------------------
  
  /** Rectangle To Point. */
  boolean rectangleToPoint(double rectWidth, double rectHeight, double rectRotation, double rectCenterX, double rectCenterY, double pointX, double pointY) {
    if(rectRotation == 0)   // Higher Efficiency for Rectangles with 0 rotation.
      return Math.abs(rectCenterX-pointX) < rectWidth/2 && Math.abs(rectCenterY-pointY) < rectHeight/2;

    double tx = Math.cos(rectRotation)*pointX - Math.sin(rectRotation)*pointY;
    double ty = Math.cos(rectRotation)*pointY + Math.sin(rectRotation)*pointX;

    double cx = Math.cos(rectRotation)*rectCenterX - Math.sin(rectRotation)*rectCenterY;
    double cy = Math.cos(rectRotation)*rectCenterY + Math.sin(rectRotation)*rectCenterX;

    return Math.abs(cx-tx) < rectWidth/2 && Math.abs(cy-ty) < rectHeight/2;
  }
  
  //-------------------------------------------------------------------------------------------------------------------
  
  void show() {
    translate(x, y); // sets (0, 0) to (x, y)
    rotate(radians(angle)); 

    if(isBest) {
      stroke(0, 255, 0);
      /*rectMode(CENTER);
      fill(255, 0 ,0);
      rect(0, 0, width + 14, height + 3);*/
      
    }
    else
      stroke(255);
    noFill();

    /* draws landing gear! */
    //Center bar
    rect(0, height/2 - 6, width + 16, 4);
    rectMode(CORNER);
    //left leg
    rect(-width/2 - 8, height/2 - 12, 1, 16);
    rect(-width/2 - 8 - 3, (height/2 - 6 + 10), 7, 1);
    //right leg
    rect(width/2 + 8 -1, height/2 - 12, 1, 16);
    rect(width/2 + 8 - 4, (height/2 - 6 + 10), 7, 1);

    /* thrusting!!!! */
    if (isThrusting) {
      /* draws random length triangle thrust shape */
      float randH = random(25);
      beginShape(TRIANGLES);
        vertex(- 8, height/2 -3);
        vertex(8, height/2 -3);
        vertex(0, height/2 + randH);
      endShape();
    }
    
    /* draws main rect */
    fill(0);
    rectMode(CENTER);
    rect(0, 0, width, height);
    
    rotate(-radians(angle));
    translate(-x, -y);
    
    
  }
  
  //-------------------------------------------------------------------------------------------------------------------
  
  void stats() {
    fill(255);
    textFont(createFont("Courier", 14));

    /* text information */
    String sStep = "Step: " + brain.step;
    text(sStep, 10, 20);
    String sGen = "Generation: " + generation;
    text(sGen, 10, 40);
    String sAngle = "Angle: " + (angle);
    text(sAngle, 10, 60);
    String sHorVel = "Horizontal Velocity: " + ((int)(horizontalVelocity * 10));
    text(sHorVel, 10, 80);
    String sVerVel = "Vertical Velocity: " + ((int)(verticalVelocity * 10));
    text(sVerVel, 10, 100);
  }
  
}
