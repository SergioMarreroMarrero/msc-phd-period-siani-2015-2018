#define ANALOG_PIN ANALOG1
#define BUFFER_LENGTH 256
#define FILENAME "testFile.txt"
#define HEADER_INFO "# data format:\n# time voltage\n# (msecs) (mvolts)"
#define CAPTURE_PERIOD_MS 100
#define CAPTURE_TIME_MS 30000
#define MAX_VOLTAGE_MV 3.3e3
#define MAX_AD_SAMPLE_VALUE 1023

char buffer[BUFFER_LENGTH + 1];
unsigned long startingTime;

unsigned long getTime_ms(const unsigned long& startingTime = 0);
void waitUntil(const unsigned long& time_ms);
unsigned long getVoltage_mV(const unsigned char analogPin);
void createFile(const char* filename, const char* header);
void registerSample(const unsigned char analogPin, const char* filename);
void writeSample(const char* filename, const unsigned long& time_ms, const unsigned long& voltage_mV);
void displaySample(const unsigned long& time_ms, const unsigned long& voltage_mV);
void printFile(const char* filename);

void
setup()
{
  // initialize USB module
  USB.begin();

  // initialize SD
  if (!SD.ON()) USB.println("Error in SD activatioon.");;
    
   // switch on 5V sensor output  
  PWR.setSensorPower(SENS_5V, SENS_ON);
}

void
loop ()
{
    createFile(FILENAME, HEADER_INFO);
	
	startingTime = getTime_ms();
	const unsigned long lastSampleTime(startingTime + CAPTURE_TIME_MS);
	for (unsigned long nextSampleTime(startingTime); 
	      nextSampleTime <= lastSampleTime; nextSampleTime += CAPTURE_PERIOD_MS)
	{
		waitUntil(nextSampleTime);
		registerSample(ANALOG_PIN, FILENAME);
	}
	USB.println("Capture done.");

	printFile(FILENAME);
	exit(0);
}

unsigned long
getTime_ms(const unsigned long& startingTime)
{
	const unsigned long time_ms(millis() - startingTime);
	return time_ms;
}

void
waitUntil(const unsigned long& time_ms)
{
	while(millis() < time_ms);	
}

unsigned long
getVoltage_mV(const unsigned char analogPin)
{
  const unsigned long sample(analogRead(analogPin));
  const unsigned long voltage_mV(sample * (MAX_VOLTAGE_MV  /  MAX_AD_SAMPLE_VALUE));
  return voltage_mV;
}

void
createFile(const char* filename, const char* header)
{
	if (SD.isFile(filename) == 1) SD.del(filename);
    SD.create(filename);
    SD.appendln(filename, header);
    snprintf(buffer, BUFFER_LENGTH , "File %s created.", filename);
	USB.println(buffer);
}

void
registerSample(const unsigned char analogPin, const char* filename)
{
	extern unsigned long startingTime;
	
	const unsigned long time_ms(getTime_ms(startingTime));
	const unsigned long voltage_mV(getVoltage_mV(analogPin));
	writeSample(filename, time_ms, voltage_mV);
	displaySample(time_ms, voltage_mV);	
}

void
writeSample(const char* filename, const unsigned long& time_ms, const unsigned long& voltage_mV)
{
	snprintf(buffer, BUFFER_LENGTH, "%lu %lu", time_ms, voltage_mV);
	if(!SD.appendln(filename, buffer)) USB.println("Error in line writting.");
}

void
displaySample(const unsigned long& time_ms, const unsigned long& voltage_mV)
{
	snprintf(buffer, BUFFER_LENGTH, "%lu ms => %lu mV", time_ms, voltage_mV);
	USB.println(buffer);
}

void
printFile(const char* filename)
{
	const int32_t numOfLines(SD.numln(filename));
	for (size_t lineIndx(0); lineIndx < numOfLines; ++lineIndx)
	{
		const char* lineBuffer(SD.catln(filename, lineIndx, 1));
		USB.print(lineBuffer);
	}
}
