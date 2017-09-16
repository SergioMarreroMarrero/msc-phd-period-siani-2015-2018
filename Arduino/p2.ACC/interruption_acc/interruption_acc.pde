
void disp_constans(const char* title)
{
	  USB.println("-------------------------------------------------");
		USB.println(title);
	  USB.print("intConf "); USB.println(intConf, BIN);
	  USB.print("intFlag "); USB.println(intFlag, BIN);
	  USB.print("intCounter "); USB.println(intCounter, DEC);
	  USB.print("intArray : ");
	  
	  for (int k = 12; k >= 0; --k)
	  {
		  char valor[20];
		  sprintf(valor, "%i ", intArray[k]);
		 USB.print(valor);  
	  }
	  USB.println("");
	  USB.println("-------------------------------------------------");
}

   
void setup()
{
  // Init USB, needed for printing to the
  // serial monitor console
  USB.begin();
  USB.println("\nUSB OK");
  
  // Power up RTC and initialize I2C bus 
  USB.println("Init RTC"); 
  RTC.ON(); 
  
  // Set time and date
  // Format is yy:mm:dd:dw:hh:mm:ss
  // dw: day of the week. Sunday is equal to 1, 
  //                      Monday must be equal to 2.
  RTC.setTime("13:02:08:06:18:00:00");
  
  
  // Set up the accelerometers to interrupt on 
  // direction change detection
  ACC.ON();
 delay(2000); 
 ACC.setDD();
  USB.print( "ACC_INT "); USB.println(ACC_INT, BIN);
  USB.print("RTC_INT "); USB.println(RTC_INT, BIN);
  disp_constans("En el setup");
  // Clean the state (not necessary)
  USB.close();
  
}

void loop()
{

  static uint16_t cycle = 0;
  
  USB.begin(); 
  delay(2000);
  
  USB.println("");
  USB.println("");
  USB.println("");
  disp_time();
  disp_batterylevel();
  disp_temperature();
  USB.println("");
  USB.println("");
  USB.println("");
  cycle++;
  disp_cycle(cycle);

 
 
  disp_constans("Antes de dormir");
  USB.println("DURMIENDO ...");
  ACC.setDD();
  PWR.sleep(WTD_8S, ALL_OFF);
  ACC.unsetDD();
  disableInterrupts(WTD_INT);
  //disableInterrupts(WTD_INT | ACC_INT);
  
  USB.begin();
  USB.println("");
  USB.println("");

  disp_constans("DESPIERTO");
  
  if (intFlag & WTD_INT) 
  {
	  --intArray[WTD_POS];
      disp_constans("Sale por WTD.");
  }	  
  if (intFlag & ACC_INT) 
  {
	  --intArray[ACC_POS]; 
	  disp_constans("Sale por ACC.");
  }

  intFlag &= ~(ACC_INT | WTD_INT);
  disp_constans("Despues de borrar flags");
  //awoke();
  
}



void disp_cycle(int cycle){
	
  // Print cycle  
  USB.print("Cycle: ");
  USB.println(cycle,DEC);
	
}


void disp_time(){
  
  char timestr[31];
  int size(sizeof(timestr));
  strncpy(timestr,RTC.getTime(),size);
  USB.print("Current time: ");
  USB.println(timestr);	
}

void disp_batterylevel(void){
	
  // Show the remaining battery level
  USB.print("\tBattery Level: ");
  USB.print(PWR.getBatteryLevel(),DEC);
  USB.println(" %");
	
}

void disp_temperature(void){
	
  // Get temperature 
  USB.print("\tTemperature: "); 
  USB.print(RTC.getTemperature()); 
  USB.println(" C");
  
}  

  









