 #include "definitions.h"

#define POWER_LEVEL 0
#define SCANNING_TIME_MS 13000
#define TRANSMISSION_TIME_MS 7000
#define SCNANING_PERIOD_MS  60000
#define NETWORK_REPORT_CYCLES 1

void mac2char(char mac[17], Node * ptr)
{
  snprintf(mac,17,"%02X%02X%02X%02X%02X%02X%02X%02X",
                    ptr->SH[0],
                    ptr->SH[1],
                    ptr->SH[2],
                    ptr->SH[3],
                    ptr->SL[0],
                    ptr->SL[1],
                    ptr->SL[2],
                    ptr->SL[3]);
}


void sendRequest(char toMac[17]);
void receive(char fromMac[17]);
unsigned int scanNetwork(char**& detectedMACs);
void freeMACs(char** detectedMACs, const unsigned int nOfNodes);
void printMACs(char** detectedMACs, const unsigned int nOfNodes);
void scheduleEvents(const unsigned int& nOfEvents, const unsigned long& slotTime,  unsigned long eventTimes[], unsigned int eventIndices[]);
void printScheduleReport(const unsigned int& nOfEvents, const unsigned long eventTimes[], const unsigned int eventIndices[]);
void generateRequest(char *request);
void generateResponse(const char* request, char* response);
int getTemperature();
unsigned int getBatteryLevel();
void registerResponse(const char* response, const char* sourceMac, NodeEntry** networkNodes);
void printNetworkReport(NodeEntry* networkNodes);



void setup()
{
	int8_t err;
    
  // Activate the XBee radio.
  const uint8_t powerLevel(POWER_LEVEL);
  if (err = commInit(powerLevel))
  {
    USB.begin();
    USB.println("Radio failed. Exiting ...");
    exit(err);
  }
  
  USB.println("\nRadio initialized"); 
  
  // Get scanning time used for network discovery
  //uint8_t scanningTime[2] = {0x03, 0x00};
  //xbee868.setScanningTime(scanningTime);
  //  Check scanning time
  xbee868.getScanningTime();
  uint16_t regScanningTime((uint16_t)xbee868.scanTime[1]  | (uint16_t)xbee868.scanTime[0] << 8);
  USB.print("Scanning time (msec): ");
  USB.println(regScanningTime * 100, DEC);
}


void loop()
{
	static unsigned long int cycleIndex(0);
	static NodeEntry* networkNodes(NULL);
	
	//  Display report of scanned nodes
	if (!(cycleIndex % NETWORK_REPORT_CYCLES))
	{
		printNetworkReport(networkNodes);
	}

   //  Scan nearby radios.
    char** detectedMACs;
	USB.println("\n=> SCANNING NETWORK ...");
	const unsigned int nOfNodes(scanNetwork(detectedMACs));
	printMACs(detectedMACs, nOfNodes);
	USB.println("\n=> SCAN DONE.");
	
	// Schedule requests
	unsigned long triggerTimes[nOfNodes];
	unsigned int requestIndices[nOfNodes];
	scheduleEvents(nOfNodes, TRANSMISSION_TIME_MS, triggerTimes, requestIndices);
	printScheduleReport(nOfNodes, triggerTimes, requestIndices);

	//  Radio operations (send / receive packets).
	char  data[MAX_LENGTH];
	unsigned int timeIndx(0);
	const unsigned long refTime(millis());
	const unsigned long receptionTime(SCNANING_PERIOD_MS - SCANNING_TIME_MS);
	while(millis() - refTime < receptionTime)
	{
		if ((timeIndx < nOfNodes) && ((millis() - refTime) >= triggerTimes[timeIndx]))
			{
				const unsigned int requestIndx(requestIndices[timeIndx]);
				++timeIndx; 

				const char *destination(detectedMACs[requestIndx]);
				generateRequest(data);
			    sendPacket(destination, data);
			
			    USB.print(" t = "); USB.print(millis() - refTime); 
			    USB.print("\n=> SENDING REQUEST  "); USB.print(data);
				USB.print(" TO "); USB.println(destination);
		    }
			
		// USB.println("Listening ...");
		char source[17];
		strncpy(source, BROADCAST_MAC, 16); source[17] = '\0';
		const int nOfPackets(receivePacket(source, data, RECEIVER_TIMEOUT));
		if (nOfPackets > 0)
		{
			if (data[0] == 'D')
			{
			    USB.print("\n=> RECEIVING DATA  "); USB.print(data);
				USB.print(" FROM "); USB.println(source);
				registerResponse(data, source, &networkNodes);
			}
			else
			{
			    USB.print("\n=> RECEIVING REQUEST  "); USB.print(data);
				USB.print(" FROM "); USB.println(source);
			
				char response[MAX_LENGTH];
				generateResponse(data, response);
				sendPacket(source, response);
			    USB.print("\n=> SENDING DATA "); USB.print(response);
				USB.print(" TO "); USB.println(source);
			}
		}
	}
	
	freeMACs(detectedMACs, nOfNodes);
	++cycleIndex;
}

int
getTemperature()
{
	const uint8_t temperatureC(RTC.getTemperature());
	return temperatureC;
}

unsigned int
getBatteryLevel()
{
	return PWR.getBatteryLevel();
}
  
void
generateRequest(char *request)
{
	const unsigned int randomSelection(rand() % 4);
	switch (randomSelection)
	{
		case 0:
			snprintf(request, MAX_LENGTH, "B");	
			break;
		case 1:
			snprintf(request, MAX_LENGTH, "T");	
			break;
		case 2:
			snprintf(request, MAX_LENGTH, "BT");	
			break;
		case 3:
			snprintf(request, MAX_LENGTH, "TB");	
			break;
	}
}

void
generateResponse(const char* request, char* response)
{
	if (strstr(request, "BT"))
	{
		snprintf(response, MAX_LENGTH, "DB%dT%d", getBatteryLevel(), getTemperature());	
	}
	else if (strstr(request, "TB"))
	{
		snprintf(response, MAX_LENGTH, "DT%dB%d", getTemperature(), getBatteryLevel());			
	}
	else if(strstr(request, "B"))
	{
		snprintf(response, MAX_LENGTH, "DB%d", getBatteryLevel());			
	}
	else if (strstr(request, "T"))
	{
		snprintf(response, MAX_LENGTH, "DT%d", getTemperature());					
	}	
}

void
scheduleEvents(const unsigned int& nOfEvents, const unsigned long& slotTime,  unsigned long eventTimes[], unsigned int eventIndices[])
{
	unsigned long scaledTime((rand() / (nOfEvents + 1)));
	for (unsigned int k(0); k < nOfEvents; ++k) 
	{
		eventTimes[k] = scaledTime;
		scaledTime += (rand() / (nOfEvents + 1));
	}
   for (unsigned int k(0); k < nOfEvents; ++k)
	   eventTimes[k] = double(eventTimes[k]) / (double)scaledTime * (double)slotTime; 

	for (unsigned int k(0); k < nOfEvents; ++k) eventIndices[k] = k;
	for (unsigned int remIndx(nOfEvents); remIndx > 0; --remIndx) 
	{
		const unsigned int randIndx(rand() % remIndx);
		const unsigned int tempElement(eventIndices[randIndx]);
		eventIndices[randIndx]  = eventIndices[remIndx - 1];
		eventIndices[remIndx - 1] = tempElement;
	}
}

void
printScheduleReport(const unsigned int& nOfEvents, const unsigned long eventTimes[], const unsigned int eventIndices[])
{
    if (nOfEvents > 0)
	{
		USB.println("\nSchedule:");
		for (unsigned int k(0); k < nOfEvents; ++k)
		{
			USB.print("Request " ); USB.print(eventIndices[k], DEC);
			USB.print(" t = " ); USB.println(eventTimes[k], DEC);		
		}
	}
	else
	{
		USB.println("No events to schedule.");
	}
}

void
printMACs(char** detectedMACs, const unsigned int nOfNodes)
{
	if (nOfNodes > 0)
	{
		USB.print("MACs report ("); USB.print(nOfNodes); USB.println("):");
		for (unsigned int nodeIndx(0); nodeIndx < nOfNodes; ++nodeIndx)
		{
			USB.print("MAC "); USB.print(nodeIndx, DEC);
			USB.print(": "); USB.println(detectedMACs[nodeIndx]);
		}
	}	
}

void
freeMACs(char** detectedMACs, const unsigned int nOfNodes)
{
	for (unsigned int nodeIndx(0); nodeIndx < nOfNodes; ++nodeIndx)
	{
		free(detectedMACs[nodeIndx]);
	}
	
	free(detectedMACs);
}

unsigned int
scanNetwork(char**& detectedMACs)
{
	unsigned int  nOfNodes(0);

	uint8_t err;
	err = xbee868.scanNetwork();

   if (err)
   {
     USB.print("\nscanNetwork failed with error ");
     USB.println(err, DEC);
   }
   else 
   {
	  nOfNodes = xbee868.totalScannedBrothers;
      USB.print("\n\nTotal radios detected: ");
	  USB.println(nOfNodes, DEC);
     
	 detectedMACs = (char**) malloc(nOfNodes * sizeof(char *));
     for (unsigned int n(0); n < nOfNodes; n++)
     {
       USB.print("Node ");
       USB.print(n, DEC);
       USB.print(": ");
       USB.println(xbee868.scannedBrothers[n].NI);

       // Printing the MAC address
       char* mac((char *) malloc(17));
	   detectedMACs[n] = mac;
       mac2char(mac, &xbee868.scannedBrothers[n]);
       USB.print("\n\tMAC: ");
       USB.print(mac);
	   
       USB.print("\n\tDevice type: ");
       USB.print(xbee868.scannedBrothers[n].DT, DEC); 
      
       USB.print("\n\tRSSI: ");
       USB.print(-xbee868.scannedBrothers[n].RSSI, DEC); 
       USB.println(" dBi");	   
     }
  }
   return nOfNodes;
}

void
sendRequest(char toMac[17])
{
  // Prepare data
  char data[MAX_LENGTH  + 1];
  strncpy(data, "BT", MAX_LENGTH);
  uint8_t length = strlen("BT");
 
  // Send packet
  XBee.print("\n=> SENDING REQUEST (");
  XBee.print(length, DEC);
  XBee.print("): ");
  XBee.println(data);
  XBee.print(" TO "); XBee.println(toMac);
 
  int8_t err;
  err = sendPacket(toMac, data);
  if (err)
  {
	  USB.println("Error in sendRequest.");
  }
}

void
receive(char fromMac[17])
{
	int8_t err;
  char data[MAX_LENGTH];
  char from[17];
  static int8_t np = 0;
  
  err = receivePacket(fromMac, data, RECEIVER_TIMEOUT);
  if (err > 0) 
  {
    np += err;
    USB.print(np);
    USB.println(" packets received correctly");
  }
  else
  {
	  USB.print("RECEIVING DATA (");
	  USB.print(strlen(data), DEC);
	  USB.print("): ");
	  USB.println(data);
	  XBee.print(" FROM "); USB.println(fromMac);	  
  }
}

void
registerResponse(const char* response, const char* sourceMac, NodeEntry** networkNodes)
{
	//  Search if node already exist.
	bool isFound(false);
	NodeEntry** listEntry(networkNodes);
	while (*listEntry)
	{
		if (strcmp(sourceMac, (*listEntry)->mac))
		{
			listEntry = &((*listEntry)->nextNode);
		}
		else
		{
			isFound = true;
			break;
		}
	}
	
	//  Update / create node entry.
	NodeEntry* sourceNode;
	if (isFound)
	{
		sourceNode = *listEntry;
	}
	else
	{
		sourceNode = (NodeEntry*) malloc(sizeof(NodeEntry));
		strncpy(sourceNode->mac, sourceMac, 17);
		sourceNode->nextNode = NULL;
		*listEntry = sourceNode;
	}
	
	//  Register node data (battery level, temperature and last time).
	char *pData;
	if (pData = strstr(response, "B"))
	{
		unsigned int batteryLevel;
		sscanf(pData, "B%u", &batteryLevel);
		sourceNode->batteryLevel = batteryLevel;
	}
	if (pData = strstr(response, "T"))
	{
		int temperature;
		sscanf(pData, "T%i", &temperature);
		sourceNode->temperature = temperature;
	}
	sourceNode->lastTime = millis();

	USB.print("Register "); USB.print(response);	USB.print(" from "); USB.println(sourceMac);
}


void
printNetworkReport(NodeEntry* networkNodes)
{
	USB.println("Network report");
	if (!networkNodes)
	{
		USB.println("No one node detected.");
	}
	
	for (NodeEntry* node(networkNodes); node; node = node->nextNode)
	{
		USB.print("Node "); USB.println(node->mac);
		USB.print("  Battery level:  "); USB.print(node->batteryLevel, DEC); USB.println("%");
		USB.print("  Temperature:  "); USB.print(node->temperature, DEC); USB.println(" C");
		USB.print("  Last entry time:  "); USB.println(node->lastTime, DEC);
	}	
}
