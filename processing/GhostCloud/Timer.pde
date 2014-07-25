class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  boolean captureTime;
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
    captureTime = false;
  }
  
  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    if(captureTime == false) {
      savedTime = millis();
      captureTime = true;
    } 
  }
  
  void stop() {
    captureTime = false;
  }
  
  boolean isActive() {
    return captureTime;
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() {
   if(captureTime) { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      //captureTime = false;
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
