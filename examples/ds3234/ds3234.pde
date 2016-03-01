// Date and time functions using a DS3234 RTC connected via SPI 

#include <SPI.h>
#include <Wire.h>  // not used here, but needed to prevent a RTClib compile error
#include <RTClib.h>


// Avoid spurious warnings
#undef PROGMEM
#define PROGMEM __attribute__(( section(".progmem.data") ))
#undef PSTR
#define PSTR(s) (__extension__({static prog_char __c[] PROGMEM = (s); &__c[0];}))

// Create an RTC instance, using the chip select pin it's connected to
RTC_DS3234 RTC(49);

byte a_day;
byte a_Hour;
byte a_Minute;
byte a_Second;
byte a_bits;
bool a_Dy;
bool a_h12;
bool a_PM;

void setup () {
    Serial.begin(9600);
    Serial.println("RTClib/examples/ds3234/");
    SPI.begin();
    RTC.begin();

  if (! RTC.isrunning()) {
    Serial.println("RTC is NOT running!");
    Serial.print("Setting time to... ");
    Serial.print(__DATE__);
    Serial.print(' ');
    Serial.println(__TIME__);
    // following line sets the RTC to the date & time this sketch was compiled
    //RTC.adjust(DateTime(__DATE__, __TIME__));
  }
  // Alarm functionality
  for ( uint8_t a = 1 ; a <= 2 ; a++ ) {
    Serial.print("Alarm "); Serial.print(a);
    if ( RTC.checkAlarmEnabled(a)) {
      Serial.println(" enabled"); 
    }
    else {
      Serial.println(" disabled");
    }
  }
  // Get alarm 
  RTC.getA1Time(a_day, a_Hour,a_Minute,a_Second, a_bits,a_Dy,a_h12,a_PM);
  Serial.println("Alarm 1 Settings:");
  Serial.print("  Day     "); Serial.println(a_day);
  Serial.print("  Hour    "); Serial.println(a_Hour);
  Serial.print("  Minute  "); Serial.println(a_Minute);
  Serial.print("  Second  "); Serial.println(a_Second);
  Serial.print("  Bits    "); Serial.println(a_bits);
  Serial.print("  Dy      "); Serial.println(a_Dy);
  Serial.print("  H12     "); Serial.println(a_h12);
  Serial.print("  PM      "); Serial.println(a_PM);
  // Set an alarm for 2 minutes from now
  DateTime now = RTC.now();
  DateTime future (now.unixtime() + (1 * 60));
  RTC.setA1Time(future.day(), future.hour(), future.minute(), future.second(), 
      a_bits, a_Dy, a_h12, a_PM);
  Serial.println("Enabling Alarm 1");
  RTC.turnOnAlarm(1);
  RTC.enableOscillator(false,
}

void loop () {
    const int len = 32;
    static char buf[len];

    DateTime now = RTC.now();

    Serial.println(now.toString(buf,len));
    
    Serial.print(" since midnight 1/1/1970 = ");
    Serial.print(now.unixtime());
    Serial.print("s = ");
    Serial.print(now.unixtime() / 86400L);
    Serial.println("d");
    
    // calculate a date which is 7 days and 30 seconds into the future
    DateTime future (now.unixtime() + 7 * 86400L + 30 );
    
    Serial.print(" now + 7d + 30s: ");
    Serial.println(future.toString(buf,len));
    
    
    Serial.print(" ");
    Serial.print(now.year(), DEC);
    Serial.print('/');
    Serial.print(now.month(), DEC);
    Serial.print('/');
    Serial.print(now.day(), DEC);
    Serial.print(' ');
    Serial.print(now.hour(), DEC);
    Serial.print(':');
    Serial.print(now.minute(), DEC);
    Serial.print(':');
    Serial.print(now.second(), DEC);
    Serial.println();
    
    //Check alarms
    for ( uint8_t a = 1 ; a <= 2 ; a++ ) {
      if ( RTC.checkIfAlarm(a)) {
        // THIS WILL ONLY HAPPEN ONCE PER ALARM. CHECKING RESETS IT.
        Serial.print("Alarm ");
        Serial.print(a);
        Serial.println(" activated----------------------------------------------------"); 
        delay(10000);
      }
    }
    
    Serial.println();
    delay(5000);
}

