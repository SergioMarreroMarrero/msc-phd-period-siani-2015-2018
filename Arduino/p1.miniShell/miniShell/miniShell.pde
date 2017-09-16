#define CMD_MAX_SZ  50
#define CMD_MAX_SZ_DATE  10

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

 


