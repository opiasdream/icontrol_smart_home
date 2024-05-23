import time
import json
import random
import threading
from paho.mqtt import publish, client as mqtt
from sensor import SensorStatus, SensorType, generate_random_value

"""
publisher/publisher.py
Each instance of the PublisherThread class
Represents a publisher that publishes sensor data to a specific topic on the MQTT broker. 
"""

# CONFIGURATION
# number of publisher threads
publisherCount = 12 
# delay between publisher threads
publisherRuntimeDelay = 0.25 
# delay between publishing messages (keep alive time)
publisherPublishDelay = 3

# mqtt broker
hosting = '127.0.0.1' # localhost
# mqtt port
port = 1883

class PublisherThread(threading.Thread):
    def __init__(self, id: str, type: SensorType):
        super().__init__()
        # publisher id
        self.id = id

        # sensor type
        self.type = type

        # initial topic
        self.topic = 'home/' + id

        # initial mqtt publish message
        self.message = None

        # sensor status data
        self.status = SensorStatus.ACTIVE.value

        # mqtt client
        self.client = mqtt.Client(client_id= id)
    
    # when client is connected to broker this function will be called.
    def _on_connect(self, client, userdata, flags, rc): return None
    #print(f"{self.id}: Connected with result code {rc}.")

    # when client publish message to broker this function will be called.
    def _on_publish(self, client, userdata, mid): return None
    #print(f"{self.id}: Message published.")

    # when client receive message from broker this function will be called.
    def _on_message(self, client, userdata, message):
        control_message = message.payload.decode().split(':')
        control = control_message[0]
        message = control_message[1]

        if control == "change status":
            self.status = message
        elif control == "change topic":
            self.topic = message

    def run(self):
        self.client.on_connect = self._on_connect
        self.client.on_publish = self._on_publish
        self.client.on_message = self._on_message
        # connect to broker
        self.client.connect(hosting, port)
        # subscribe to re/<publisher_id> topic for change `self.status` value.
        self.client.subscribe('re/' + self.id)

        while True:
            try:
                if self.status == SensorStatus.ACTIVE.value and self.type != SensorType.DEVICE:
                    data = generate_random_value(self.type)
                else:
                    data = self.status

                self.message = json.dumps({"status" : self.status, "data":  data})
                self.client.publish(self.topic, self.message)
                self.print_log(data)

            except Exception as e:
                print(f"{self.id}: Message is not published. Error: {e}")
                
            time.sleep(4)
            self.client.loop()
    
    def print_log(self, data:str):
        print("┌───────────────────────────────────────────────────────┐")
        print(f"| {self.id} | Status: {self.status} | Data: {data} \t\t|")
        print("└───────────────────────────────────────────────────────┘")

if __name__ == "__main__":
    publishers = []

    for i in range (publisherCount):
        publisher = PublisherThread(f"publisher{i+1}", random.choice(list(SensorType)))
        publishers.append(publisher)
        publisher.start()
        time.sleep(publisherRuntimeDelay)

    for publisher in publishers:
        publisher.join()



    
    
