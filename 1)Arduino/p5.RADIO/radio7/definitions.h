#define RED_LED   LED0  
#define GREEN_LED LED1  

#define BROADCAST_MAC  "000000000000FFFF"
#define MY_MAC         "0013A20040795897"
#define HIS_MAC         "0013A20040795890"

#define MAX_LENGTH        110
#define RECEIVER_TIMEOUT  100UL

#define _DEBUG_COMM_

typedef struct sNodeEntry
{
	char mac[17];
	unsigned int batteryLevel;
	int temperature;
	unsigned long lastTime;
	sNodeEntry *nextNode;
}  NodeEntry;
