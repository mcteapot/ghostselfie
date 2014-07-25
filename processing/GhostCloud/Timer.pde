class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  boolean stopTime;
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
    stopTime = false;
  }
  
  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
    stopTime = true; 
  }
  
  void stop() {
    stopTime = false;
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() {
   if(stopTime) { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      stopTime = false;
      return true;
    } else {
      return false;
    }
   }
   else {
     return false;
   }
  }
}
