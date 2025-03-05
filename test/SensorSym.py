import requests
import time

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

if __name__ == "__main__":
    read_sensor_values = "https://api.thingspeak.com/channels/2667716/fields/1.json?results=1"
    write_sensor_values = "https://api.thingspeak.com/update?api_key=6AO4PYC5RM7D1KJX&field1="

    read_SM_decsion = "https://api.thingspeak.com/channels/2756308/fields/1.json?results=1"
    write_SM_decsion = "https://api.thingspeak.com/update?api_key=LEOTSB0DZBX02WH1&field1="

    while True:
        time.sleep(.5)
        choice = input('\n1. Write sensor value\n2. Read SM Decision\nEnter choice: ')
        if choice == '1':
            val = input('Enter floating point value: ')
            try:
                resp = write_ts(write_sensor_values, float(val))
                print(resp)
                if resp == 200:
                    print("Value written to ThingSpeak please wait 15 seconds before writting again\n")
            except ValueError:
                print("Value must be a float\n")
                continue
        elif choice == '2':
            data = read_ts(read_SM_decsion)
            print(f"StateMachine decision is {data['feeds'][0]['field1']}\n")