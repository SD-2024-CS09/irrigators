import requests

def write_ts(url, value):
    if not isinstance(value, (int, float)):
        print(f"{value} is not a float or int")
        return None
    try:
        response = requests.get(url + str(value))
        response.raise_for_status()
        return response.status_code
    except requests.exceptions.RequestException as e:
        print(f"Request error: {e}")
        return None
    
def read_ts(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Request error: {e}")
        return None
    except ValueError:
         print("Decoding JSON failed")
         return None

read_sensor_values = "https://api.thingspeak.com/channels/2667716/fields/1.json?results=1"
write_sensor_values = "https://api.thingspeak.com/update?api_key=6AO4PYC5RM7D1KJX&field1="

read_SM_decsion = "https://api.thingspeak.com/channels/2756308/fields/1.json?results=1"
write_SM_decsion = "https://api.thingspeak.com/update?api_key=LEOTSB0DZBX02WH1&field1="

resp = write_ts(write_sensor_values, .45)
data = read_ts(read_sensor_values)


for i in data['feeds']:
    print(i['field1'])
print(resp)
