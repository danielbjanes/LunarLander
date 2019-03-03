class Population {
  Lander[] landers;
  
  float fitnessSum;
  int generation = 1;
  
  int minStep = 5000;
  int bestLander = 0;
  
  Population(int size) {
    landers = new Lander[size];
    for(int i = 0; i < size; i++) {
      landers[i] = new Lander(generation);
    }
  }
  
  //-------------------------------------------------------------------------------------------------------------------

  
  void show() {
    for(int i = 0; i < landers.length; i++) {
      landers[i].show();
    }
  }
  
  //-------------------------------------------------------------------------------------------------------------------

  
  void update() {
    for(int i = 1; i < landers.length; i++) {
      landers[i].update();
    }
    landers[0].update();
    landers[0].stats();
  }
  
  //-------------------------------------------------------------------------------------------------------------------

  boolean allDotsDead() {
    for (int i = 0; i< landers.length; i++) {
      if (!landers[i].dead) { 
        return false;
      }
    }
    return true;
  }
  
  //-------------------------------------------------------------------------------------------------------------------

  void calculateFitness() {
    for (int i = 0; i< landers.length; i++) {
      landers[i].calculateFitness();
    }
  }
  
  //-------------------------------------------------------------------------------------------------------------------

  void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< landers.length; i++) {
      fitnessSum += landers[i].fitness;
    }
  } 
  
  //-------------------------------------------------------------------------------------------------------------------

  Lander selectParent() {
    float rand = random(fitnessSum);
    float runningSum = 0;
    

    for (int i = 0; i< landers.length; i++) {
      runningSum+= landers[i].fitness;
      if (runningSum > rand) {
        return landers[i];
      }
    }
    //should never get to this point

    return null;
  }
  
  //-------------------------------------------------------------------------------------------------------------------

  void naturalSelection() {
    Lander[] newLanders = new Lander[landers.length]; //next generation
    setBestLander();
    calculateFitnessSum();
    
    newLanders[0] = landers[bestLander].createChild();
    newLanders[0].isBest = true;
    for(int i = 1; i < newLanders.length; i++) {
      Lander parent = selectParent();
      newLanders[i] = parent.createChild();
       
    }
    
    landers = newLanders.clone();
    
    for(int i = 0; i < landers.length; i++) {
      landers[i].generation++; 
    }
    generation++;
  }


  //-------------------------------------------------------------------------------------------------------------------

  void mutate() {
     for(int i = 1; i < landers.length; i++) {
       landers[i].brain.mutate();
     }
  }
  
  //-------------------------------------------------------------------------------------------------------------------

  void setBestLander() {
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i< landers.length; i++) {
      if (landers[i].fitness > max) {
        max = landers[i].fitness;
        maxIndex = i;
      }
    }

    bestLander = maxIndex;

    //if this dot reached the goal then reset the minimum number of steps it takes to get to the goal
    if (landers[bestLander].landed) {
      minStep = landers[bestLander].brain.step;
      println("step:", minStep);
    }
  }


}
