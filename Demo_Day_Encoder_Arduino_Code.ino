// Version date: May 24, 2021
const int pin = 7;
unsigned long PulseLength;
float StartTime;
float TotalErrSqrd = 0;
float AvgPulseLen = 0;
//float Rsquared;
float P = 1;
float Score;
unsigned long timeout = 100000000;
int Pulses = 0;
int flag = 0;
int flag1 = 0;
String student_name = "MrMoseby";
String group_number = "75";

int lastState = 1;
unsigned long startTime = 0;
unsigned long TotalTime = 0;
unsigned long LastTime = 0;

void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(115200);
  pinMode(pin, INPUT);
  Serial.println("~ Start your clocks!"); // Start your clocks!
  delay(1000);
}


// the loop routine runs over and over again forever:
void loop() {
  int State = digitalRead(pin);
  if (State != lastState) {
    if (State == HIGH) {
      if (flag == 0) {
        StartTime = micros();
      }
      flag = 1;

      if (flag1 == 1) {
      // Calculate pulse length
      PulseLength = micros() - LastTime;  

      //Calculate the moving average of the pulse lengths
      AvgPulseLen = ((float(PulseLength) / 1000000) + (Pulses * AvgPulseLen)) / (float(Pulses) + 1);

      //Increment the number of pulses
      Pulses++;

      //Calculate the Precision through a moving mean average deviation
      P = 1 - (1 - P) - (abs((float(PulseLength) / 1000000) - AvgPulseLen) / (float(Pulses)));

      //Calculate the moving total score given by NP, where N=seconds and P=Precision
      Score = ((micros() - StartTime) / 1000000) * P;

      //Print the results
      Serial.print(student_name);
      Serial.print(",");
      Serial.print(group_number);
      Serial.print(",");
      Serial.print(Pulses);
      Serial.print(",");
      Serial.print(PulseLength / 1000);
      Serial.print(",");
      Serial.print(int(AvgPulseLen * 1000));
      Serial.print(",");
      Serial.print(P);
      Serial.print(",");
      Serial.print(Score);
      Serial.print(",End");
      Serial.println();
      
      startTime = micros ();
      delay (100);    // debounce
      }
      else {
        flag1 = 1;
      }
    }  // end of state being HIGH
    
    lastState = State;
    LastTime = micros();
    
  }
}   // end of state change
