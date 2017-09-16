#define CMD_MAX_SZ  50
#define CMD_MAX_SZ_DATE  10

#include "WProgram.h"
void setup();
void loop();
void menu(void);
int8_t read_USB_command(char *term, size_t msz);
void consultasDeEstado(char *cmd);
void parseLedNameState(char* cmd, uint8_t whichLED, uint8_t whichSTATE);
boolean parseLEDName(char *cmd, uint8_t *whichLED);
boolean parseLEDState(char *cmd, uint8_t *whichSTATE);
void parseGetDate();
void parseGetTime();
void parseSetDateTime(char *input);
boolean
readPinLevel(const int waspPin, const int waspPinLevel);
boolean
updatePin(const int waspPin, const int waspPinLevel);
boolean
setPin(char *cmd);
boolean parseCMD(const char* cmd, int& pinId, boolean& level);

void setup()
{
  // Init USB module
  USB.begin();
  USB.println("\n USB OK");
  RTC.ON();
  USB.println("\n Fecha:");
  RTC.setTime("16:07:16:02:17:50:00");
  USB.println(RTC.getTime()); 
  pinMode(DIGITAL2, INPUT); // Configuramos DIGITAL2 como IMPUT
  menu();
  
}

void loop()
{
  char cmd[CMD_MAX_SZ];
  size_t sz;
 
  uint8_t whichLED;
  uint8_t whichSTATE;
  



  
// 2) Descarga del contenido del COM3
  sz = read_USB_command(cmd, CMD_MAX_SZ);
  // Lowercase
  strlwr(cmd);
  USB.print("Se recibio la siguiente instruccion: "); 
  USB.println(cmd);
  
// 1) Display el menu de opciones del minishell

  if (strstr(cmd, "disp_menu")!=NULL) menu();
  
// 3) Consultas del estado del WaspMote (bateria, memoria disponible, temperatura)
  consultasDeEstado(cmd);

// 4) Gestion de la Leds 
  if (strstr(cmd, "led")!=NULL) parseLedNameState(cmd, whichLED, whichSTATE);

// 5) Gestion de tiempo/fechas

  // 5.1) SET_DATE_TIME 
  if (strstr(cmd, "set_date_time")!=NULL) parseSetDateTime(cmd);
  
  // 5.2) GET_DATE_TIME 
  if (strstr(cmd, "get_date_time")!=NULL)
  {
  USB.print("Time [Day of week, YY/MM/DD, hh:mm:ss]: \n");
  USB.println(RTC.getTime());
  }
 
  // 5.3) GET_ONLY_DATE
  if (strstr(cmd, "get_only_date")!=NULL) parseGetDate();
  
  // 5.4) GET_ONLY_TIME
  if (strstr(cmd, "get_only_time")!=NULL) parseGetTime();
 
  // 6) PIN
  if (strstr(cmd, "pin")!=NULL) setPin(cmd);
 }

  /*parseCMD(cmd, pinId, level);
  USB.println(pinId,DEC);
  USB.println(level,DEC);
  if (strstr(cmd, "pin")!=NULL)  parseCMD(cmd, pinId, level);
  */


#define isBetween(A, L, U) ((A >= L) && (A <= U))
#define pinMax 9
#define pinMin 1

// 1) Despligue del menu
void menu(void){
	
	USB.println("\nLista de comandos posibles:\n");
	USB.println("\t 1) Consultar estado del WaspMote");
	USB.println("\t\tMemoria disponiple: memory");
	USB.println("\t\tNivel de bateria: battery");
	USB.println("\t\tTemperatura: temperature");
	
	USB.println("\n\t 2) Gestion de Leds propios:");
	USB.println("\t\tled red/green on/off");
	
	USB.println("\n\t 3) Gestion de Fecha/Hora: (Day of week, YY/MM/DD, hh:mm:ss)");
	USB.println("\t\t Set Fecha/Hora : set_date_time");
	USB.println("\t\t Get Fecha/Hora : get_date_time");	
	USB.println("\t\t Get Fecha: get_only_date");	
	USB.println("\t\t Get Hora: get_only_time");
	
	USB.println("\n\t 4) Configuracion de pines de salida ");
	USB.println("\t\tpin NUM_PIN L/H/?");	
	
	USB.println("\nEsperando algun comando...\n");
}

// 2) Descarga del contenido del COM3 sobre la variable cmd

int8_t read_USB_command(char *term, size_t msz)
{
  int8_t sz = 0;
  unsigned long init = millis();
  
  while(sz < msz)
  {    
    while ((USB.available() > 0) && (sz < msz))
    {
      term[sz++] = USB.read();
      init = millis();
    }
    if (sz && ((millis() - init) > 50UL)) break;
  }  
  term[sz] = 0;
 
  return sz;
}


// 3) Consultas del estado del WaspMote (bateria, memoria disponible, temperatura)
void consultasDeEstado(char *cmd) {
// 2.1) Memory available

  if (strstr(cmd, "memory")!=NULL){
  
  USB.print(F("\tFree Memory:"));
  USB.println(freeMemory(),DEC);
  
  }
  
// 2.2) Battery level  
  if (strstr(cmd, "battery")!=NULL){
  
    // Show the remaining battery level
  USB.print("\tBattery Level: ");
  USB.print(PWR.getBatteryLevel(),DEC);
  USB.println(" %");
  }
  
// 2.3) Temperature   
  
  if (strstr(cmd, "temperature")!=NULL){
    RTC.ON();
  // Get temperature 
  USB.print("\tTemperature: "); 
  USB.print(RTC.getTemperature()); 
  USB.println(" C");

  }
}


//4)
// *********************************************************
// 							LED
// *********************************************************



void parseLedNameState(char* cmd, uint8_t whichLED, uint8_t whichSTATE)
{
	
	// Parse LED name
  if (!parseLEDName(cmd, &whichLED))
  {
     USB.println("Unrecognized LED name!");
     return;
  }
  
  // Parse LED state
  if (!parseLEDState(cmd, &whichSTATE))
  {
     USB.println("Unrecognized LED state!");
     return;
  }
  
  // Execute the LED command
  Utils.setLED(whichLED, whichSTATE);

}


boolean parseLEDName(char *cmd, uint8_t *whichLED)
{
  char * start = strstr(cmd, "red");
  
  if (start != NULL)
  {
     *whichLED = LED0;
     return true; 
  }
  
  start = strstr(cmd, "green");
  
  if (start != NULL)
  {
     *whichLED = LED1;
     return true; 
  }
  
  return false;
}

boolean parseLEDState(char *cmd, uint8_t *whichSTATE)
{
  char * start = strstr(cmd, "on");
  
  if (start != NULL)
  {
     *whichSTATE = LED_ON;
     return true; 
  }
  
  start = strstr(cmd, "off");
  
  if (start != NULL)
  {
     *whichSTATE = LED_OFF;
     return true; 
  }
  
  return false;
}





//5)
// *********************************************************
// 		GET_DATE
// *********************************************************
void parseGetDate()
{
   	uint8_t year,month,day,hour,minute,second,day_week;
	char* date_time;
	char buffer[100];

	date_time=RTC.getTime();
	USB.println(date_time);
	sscanf(date_time,"%*s%d/%d/%d - %d:%d.%d",&year,&month,&day,&hour,&minute,&second);
	sprintf(buffer, "%02u/%02u/%02u",year,month,day);
	USB.println("Fecha:(YY/MM/DD)");
	USB.println(buffer);

      
}

// *********************************************************
// 			GET_TIME
// *********************************************************
void parseGetTime()
{
   	uint8_t year,month,day,hour,minute,second,day_week;
	char* date_time;
	char buffer[100];
	
	date_time=RTC.getTime();
	USB.println(date_time);
	sscanf(date_time,"%*s%d/%d/%d - %d:%d.%d",&year,&month,&day,&hour,&minute,&second);
	sprintf(buffer, "%02u:%02u:%02u",hour,minute,second);
	USB.println("Hora:(hh/mm/ss)");
	USB.println(buffer);
}



// *********************************************************
// 		      SET_DATE_TIME
// *********************************************************
void parseSetDateTime(char *input)
{
	
	int year,month,day,hour,minute,second,day_week;
	// buffer to set the date and time
	char buffer[100];

	// Iniciamos RTC
	RTC.ON();	
	
	/////////////////////////////////
	//  YEAR
	/////////////////////////////////
	
	USB.print("Insertar anno [yy]:");    
	read_USB_command(input,CMD_MAX_SZ_DATE);
	year=atoi(input);
	USB.println(year);
	
	/////////////////////////////////
	//  MONTH
	/////////////////////////////////
	
	USB.print("Insert Month [mm]:");    
	read_USB_command(input,CMD_MAX_SZ_DATE);
	month=atoi(input);
	USB.println(month);
	
	/////////////////////////////////
	//  DAY
	/////////////////////////////////
	
	USB.print("Insert day [dd]:");    
	read_USB_command(input,CMD_MAX_SZ_DATE);
	day=atoi(input);
	USB.println(day);
	
	/////////////////////////////////
	//  DAY OF WEEK SATURDAY=7,SUNDAY=1
	/////////////////////////////////
	
	USB.print("Insert day_week [dd] (Saturday = 7, Sunday = 1):");    
	read_USB_command(input,CMD_MAX_SZ_DATE);
	day_week=atoi(input);
	USB.println(day_week);
	
	/////////////////////////////////
	//  HOUR
	/////////////////////////////////
	
	USB.print("Insert hora [HH]:");    
	read_USB_command(input,CMD_MAX_SZ_DATE);
	hour=atoi(input);
	USB.println(hour);
	/////////////////////////////////
	//  MINUTE
	/////////////////////////////////
	
	USB.print("Insert minute [MM]:");  
	read_USB_command(input,CMD_MAX_SZ_DATE);
	minute=atoi(input);
	USB.println(minute);
	
	/////////////////////////////////
	//  SECOND
	/////////////////////////////////
	
	USB.print("Insert second [SS]:");  
	read_USB_command(input,CMD_MAX_SZ_DATE);
	second=atoi(input);
	USB.println(second);
	
	/////////////////////////////////
	//  create buffer
	/////////////////////////////////
	sprintf(buffer, "%02u:%02u:%02u:%02u:%02u:%02u:%02u",year,month,day,day_week,hour,minute,second);
	USB.println(buffer);

	// Setting time [yy:mm:dd:dow:hh:mm:ss]
	RTC.setTime(buffer);
  
    // Reading time
	USB.print(F("Time [Day of week, YY/MM/DD, hh:mm:ss]: "));
	USB.println(RTC.getTime());	
}



//6)
// *********************************************************
// 		                PIN
// *********************************************************

boolean
readPinLevel(const int waspPin, const int waspPinLevel)
{
  pinMode(waspPin, INPUT);
  USB.println(digitalRead(waspPin));
}



boolean convertPinLevel(const char clevel, boolean& level)
{
  if (clevel == 'l')
    {
      level = false;
      return true;
    }
    
  if (clevel == 'h')
    {
      level = true;
      return true;
    }
	
    
  return false;
  
}


boolean parseCMD(const char* cmd, int& pinId, boolean& level, boolean& isRead)
{

 	char clevel;
	const int nOfItemsRead(sscanf(cmd, "%*s%i %c", &pinId, &clevel));

	if (nOfItemsRead < 2){
		
		 USB.println("NO LEE BIEN EN PIN ...");
		 return false;
	}	
		
	
	if (!isBetween(pinId, pinMin, pinMax)){
		
		USB.println("PIN FUERA DE RANGO ...");
		return false;	
	}
	
	if (clevel == '?')
	{
		isRead = true;		
		return true;
	}
	else
	{
	isRead = false;
	return convertPinLevel(clevel, level);	
	}
}


boolean
getWaspPin(const int pinId, int& waspPin)
{
  const int WASP_PIN[9] = {DIGITAL1, DIGITAL2, DIGITAL3, DIGITAL4, DIGITAL5, DIGITAL6, DIGITAL7, DIGITAL8, DIGITAL9};
  waspPin = WASP_PIN[pinId - 1];
  return true;
}

boolean
getWaspPinLevel(const boolean pinLevel, int& waspPinLevel)
{
  waspPinLevel = (pinLevel) ? HIGH : LOW;
  return true;
}


boolean
updatePin(const int waspPin, const int waspPinLevel)
{
  pinMode(waspPin, OUTPUT);
  digitalWrite(waspPin, waspPinLevel);
  return true;
}



boolean
setPin(char *cmd)
{
  int  pinId;
  boolean level;
  int waspPinLevel, waspPin;
  boolean isRead;
  
  
  if (!parseCMD(cmd, pinId, level, isRead))
  {
	  
	  USB.print("Problemas en el parse");
	  return false;	
	  
  } 
  
  
  if (!getWaspPin(pinId, waspPin))
  {
	  USB.print("Problemas en getWaspPin");
	  return false;
  } 
  
  if (isRead)
  {
	// getPinLevel(const int waspPin, const int waspPinLevel)
	readPinLevel(waspPin, waspPinLevel);
	return 	true;
  }
  
  
    if (!getWaspPinLevel(level, waspPinLevel))
  {
	  USB.print("Problemas en getWaspPinLevel");
	  return false;
  }
  // boolean updatePin(const int waspPin, const int waspPinLevel)
  
  if (!updatePin(waspPin, waspPinLevel)) 
  {
	  USB.print("Problemas en updatePin");
	  return false;	  
  };
  
  USB.print("Hecho!! El nivel del pin: ");
  USB.print(pinId);
  USB.print(" es ... ");
  USB.println(waspPinLevel);
  

  return true;

}






int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

