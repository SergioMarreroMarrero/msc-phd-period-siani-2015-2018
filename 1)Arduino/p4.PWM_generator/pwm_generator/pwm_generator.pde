// PWM generator setup.
#define PWM_PIN DIGITAL1
#define PWM_MIN_LEVEL  0
#define PWM_MAX_LEVEL 255
#define PWM_PERIOD 17
#define DUTY_CYCLE 0.8

//  Test probe setup.
#define PROBE_PIN ANALOG5
#define MAX_VOLTAGE_MV 3.3e3
#define MAX_AD_SAMPLE_VALUE 1023
#define CAPTURE_TIME_MS 6000
//#define CAPTURE_PERIOD_MS 70

// Log register.
#define LOG_SIZE 500
unsigned long logTime[LOG_SIZE];
unsigned long logVoltage[LOG_SIZE];
unsigned int nOfSamples(0);

// Log file setup.
#define FILENAME "testFile.txt"
#define HEADER_INFO "# data format:\n# time voltage\n# (msecs) (mvolts)"
#define BUFFER_LENGTH 256
char buffer[BUFFER_LENGTH + 1];
unsigned long startingTime;

unsigned long getTime_ms(const unsigned long& startingTime = 0);
void waitUntil(const unsigned long& time_ms);
unsigned long getVoltage_mV(const unsigned char analogPin);
void createFile(const char* filename, const char* header);
void registerSample(const unsigned char analogPin);
void writeSample(const char* filename, const unsigned long& time_ms, const unsigned long& voltage_mV);
void displaySample(const unsigned long& time_ms, const unsigned long& voltage_mV);
void printFile(const char* filename);
void exportSamples(const char* filename);

void
setup()
{
  // initialize USB module
  USB.begin();
  // initialize SD
  if (!SD.ON()) USB.println("Error in SD activation.");;
    
  // switch on 5V sensor output  
  PWR.setSensorPower(SENS_5V, SENS_ON);
  
  pinMode(DIGITAL1, OUTPUT);
  digitalWrite(DIGITAL1, LOW);
}

void
loop()
{
	USB.println("Sampling ...");
	startingTime = getTime_ms();
	const unsigned long finalTime(startingTime + CAPTURE_TIME_MS);
	const unsigned long timeOn(DUTY_CYCLE * PWM_PERIOD);
	for (unsigned long refTime(startingTime); refTime < finalTime; refTime += PWM_PERIOD)
	{
		analogWrite(PWM_PIN, PWM_MAX_LEVEL);
		while(getTime_ms(refTime) < timeOn) registerSample(PROBE_PIN);
		
		analogWrite(PWM_PIN, PWM_MIN_LEVEL);
		while(getTime_ms(refTime) < PWM_PERIOD) registerSample(PROBE_PIN);
	}

	USB.println("Exporting samples to file ...");
	createFile(FILENAME, HEADER_INFO);
	exportSamples(FILENAME);
	// printFile(FILENAME);

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
registerSample(const unsigned char analogPin)
{
	extern unsigned long startingTime;
	
	delay(1);	// To avoid samples at the same time tick.
	logTime[nOfSamples] = getTime_ms(startingTime);
	logVoltage[nOfSamples] = getVoltage_mV(analogPin);
	if (++nOfSamples == LOG_SIZE) --nOfSamples;
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

void
exportSamples(const char* filename)
{
	for (unsigned int indx(0); indx < nOfSamples; ++indx)
	{
		const unsigned long& time_ms(logTime[indx]);
		const unsigned long& voltage_mV(logVoltage[indx]);
		writeSample(filename, time_ms, voltage_mV);
		displaySample(time_ms, voltage_mV);
	}
}
