// ------------------------------------------------------------
// Init function
// ------------------------------------------------------------
int8_t commInit(uint8_t power_level)
{
  int8_t err = 0;
  
  // Inits the XBee 868 radio
  xbee868.init(XBEE_868,FREQ868M,PRO);

  // Power on the radio
  xbee868.ON();  
  
  // Set transmit power
  err |= xbee868.setPowerLevel(power_level);
  
  // Set RSSI time
  err |= xbee868.setRSSItime(0x05);
  
  // Report
  #if defined(_DEBUG_COMM_)
    XBee.print("\nFree Memory after commInit: ");
    XBee.println(freeMemory(), DEC);
    XBee.println();
  #endif  
  
  return err;
}

// ------------------------------------------------------------
// Shutdown function
// ------------------------------------------------------------
void commShutdown()
{
  #if defined(_DEBUG_COMM_)
    XBee.println("Executing commShutdown()");
  #endif  
  
  xbee868.OFF();
}

// ------------------------------------------------------------
// Send a packet
// ------------------------------------------------------------
int8_t sendPacket(const char *destination, char *data)
{
  #if defined(_DEBUG_COMM_)
    XBee.println("Trying to send a comm packet");
  #endif
  
  packetXBee *packet =(packetXBee*) calloc(1,sizeof(packetXBee)); 
  if (packet == NULL)
  {   
    #if defined(_DEBUG_COMM_)
      XBee.println("Can't alloc packet");
    #endif
    return -1;
  }
  
  if (!strncmp(destination,BROADCAST_MAC,16))
    packet->mode = BROADCAST;
  else
    packet->mode = UNICAST;
  
  packet->packetID = 0x52; 
  xbee868.setOriginParams(packet, MY_MAC, MAC_TYPE);
  xbee868.setDestinationParams(packet, destination, data, MAC_TYPE, DATA_ABSOLUTE);

  xbee868.sendXBee(packet);
  free(packet);
  packet = NULL;
   
  if( !xbee868.error_TX )
  {
    #if defined(_DEBUG_COMM_)
      XBee.println();
      XBee.println("\tPacket sent ok");
    #endif
    blinkLED(GREEN_LED,100);
    return 0;
  }
  else 
  {
    XBee.println("\tTX Error"); 
    if (xbee868.error_RX)    XBee.println("\tRX Error");
    blinkLED(RED_LED,100);
    return -1;
  }  
}

// ------------------------------------------------------------
// Receive a packet
// maxWaitTimeMS in milliseconds
// ------------------------------------------------------------
int8_t receivePacket(char *from, char *data, unsigned long maxWaitTimeMS)
{
  int8_t packets_received = 0;
  
  unsigned long previous;
  #if defined(_DEBUG_COMM_)
//    XBee.println("Awaiting comm packet");
  #endif
  
  previous = millis();
  while(1)
  {
    if (millis() < previous) 
    {
      maxWaitTimeMS -= (0xFFFFFFFF - previous);
      previous = 0UL;
    }
    if ((millis() - previous) > maxWaitTimeMS ) break;
  
    // Check for available packets
    if( XBee.available() )
    {
      XBee.println("Packet received");
      
      xbee868.treatData();
      XBee.print("error_RX = ");
      XBee.print(xbee868.error_RX,DEC);
      XBee.println("");
      
      if( !xbee868.error_RX )
      {
        // Writing the parameters of the packet received
        while(xbee868.pos > 0)
        {
          uint16_t data_length = xbee868.packet_finished[xbee868.pos-1]->data_length;
          XBee.print("Packets pending: ");
          XBee.println(xbee868.pos, DEC);
          XBee.print("Data (");
          XBee.print(data_length, DEC);  
          XBee.print("): ");
          memcpy(data,
                 xbee868.packet_finished[xbee868.pos-1]->data,
                 data_length);
          
          data[data_length] = 0;
          XBee.print(data);
          XBee.println("");
                   
          XBee.print("PacketID: 0x");                    
          XBee.print(xbee868.packet_finished[xbee868.pos-1]->packetID, HEX);
          XBee.println("");      
          
          XBee.print("Type Source ID: 0x");                              
          XBee.print(xbee868.packet_finished[xbee868.pos-1]->typeSourceID, HEX);
          XBee.println("");
          
          if (!xbee868.packet_finished[xbee868.pos-1]->typeSourceID)
          {
            XBee.print("Network Identifier Origin: ");          
            for(int g=0;g<4;g++)
            {
              XBee.print(xbee868.packet_finished[xbee868.pos-1]->niO[g],BYTE);
            }
            XBee.println("");  
          }
          else 
          {
            snprintf(from,17,"%02X%02X%02X%02X%02X%02X%02X%02X",
                    xbee868.packet_finished[xbee868.pos-1]->macSH[0],
                    xbee868.packet_finished[xbee868.pos-1]->macSH[1],
                    xbee868.packet_finished[xbee868.pos-1]->macSH[2],
                    xbee868.packet_finished[xbee868.pos-1]->macSH[3],
                    xbee868.packet_finished[xbee868.pos-1]->macSL[0],
                    xbee868.packet_finished[xbee868.pos-1]->macSL[1],
                    xbee868.packet_finished[xbee868.pos-1]->macSL[2],
                    xbee868.packet_finished[xbee868.pos-1]->macSL[3]);
            XBee.print("MAC Address Origin: ");          
            XBee.println(from);
            XBee.println("");
          }
          free(xbee868.packet_finished[xbee868.pos-1]);
          xbee868.packet_finished[xbee868.pos-1] = NULL;
          xbee868.pos--;
          packets_received++;
          
        } // end while: packets pending
        
        // Packet received OK: don't wait any longer
        blinkLED(GREEN_LED, 150);
        return packets_received;
        
      } // end if: reception OK
      else 
      {
        // Packet was received with error
        blinkLED(RED_LED, 150);
        return -2;
      }
    } // end if: data available
  } // end while: awaiting loop
  return -1;
}

