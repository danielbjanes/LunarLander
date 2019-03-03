class Brain {
  
  int step = 0;
  int MAX_STEP;
  boolean thrustLog[];
  int rotateLog[];
  
  
  
 Brain(int size) {  
   MAX_STEP = size;
   
   thrustLog = new boolean[MAX_STEP];
   rotateLog = new int[MAX_STEP];
   randomize();
 }
 
 //-------------------------------------------------------------------------------------------------------------------
 
 void randomize() {
   //initalize brain movements
   for(int i = 0; i < MAX_STEP; i++) { 
     double ran = random(1);
     thrustLog[i] = ran > 0.5;
     if(ran < 0.33)
       rotateLog[i] = -1;
     else if(ran >= 0.33 && ran < 0.66)
       rotateLog[i] = 0;
     else 
       rotateLog[i] = 1;
   }
 }

  //-------------------------------------------------------------------------------------------------------------------

  Brain clone() {
    Brain clone = new Brain(MAX_STEP);
    for(int i = 0; i < MAX_STEP; i++) {
      clone.thrustLog[i] = thrustLog[i];
      clone.rotateLog[i] = rotateLog[i];
    }
    
    return clone; 
  }
  
  //-------------------------------------------------------------------------------------------------------------------

  void mutate() {
    float mutationRate = 0.1;
    for(int i = 0; i < MAX_STEP; i++) {
      float rand = random(1);
      if(rand < mutationRate) {
        float ranT = random(1);
        thrustLog[i] = ranT >= 0.5;
        
        float ranR = random(1);
        if(ranR < 0.33)
          rotateLog[i] = -1;
        else if(ranR >= 0.33 && ranR < 0.66)
          rotateLog[i] = 0;
        else 
          rotateLog[i] = 1;
      }
      
    }
    
    
  }

}
