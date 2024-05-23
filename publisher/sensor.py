import random
from enum import Enum

"""
sensor/sensor.py

This module contains class and functions for generating random sensor data.

`generate_random_value()`
This function takes a sensor type as an argument and returns a random value for that sensor type.
"""

class SensorStatus(Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"

class SensorType(Enum):
    DEVICE = "device"
    TEMPERATURE = "temperature"
    HUMIDITY = "humidity"
    DETECTION = "detection"

def generate_random_value(sensor: SensorType) -> str:
    if sensor == SensorType.DEVICE:
        return None
    elif sensor == SensorType.TEMPERATURE:
        return f"{round(random.uniform(20, 30), 2)} °C"
    elif sensor == SensorType.HUMIDITY:
        return f"{random.randint(40, 60)} %"
    elif sensor == SensorType.DETECTION:
        return str(random.choice([True, False]))
    else:
        raise ValueError("Unknown sensor type!")