import requests 
import os
from twilio.rest import Client
import datetime

#https://api.openweathermap.org/data/2.5/weather?lat={-19.929209}&lon={-43.945317}&appid={5e7d66b395bdbc7601fbf014e96d12a9}
OWM_Endpoint = "https://api.openweathermap.org/data/2.5/forecast"
apy_key = "5e7d66b395bdbc7601fbf014e96d12a9"
# account_sid = os.environ["AC2501cb011675c698291deb2e37534b77"]
# auth_token = os.environ["21898776e8af1868da25b65728edd3e8"]
account_sid ="AC2501cb011675c698291deb2e37534b77"
auth_token = "21898776e8af1868da25b65728edd3e8"

client = Client(account_sid, auth_token)
clear_sky_day = "https://openweathermap.org/img/wn/01d@2x.png"
clear_sky_night ="https://openweathermap.org/img/wn/01n@2x.png"
few_clouds_day = "https://openweathermap.org/img/wn/02d@2x.png"
few_clouds_night = "https://openweathermap.org/img/wn/02n@2x.png"
scattered_clouds_day = "https://openweathermap.org/img/wn/03d@2x.png"
scattered_clouds_night = "https://openweathermap.org/img/wn/03d@2x.png"
broken_clouds_day = "https://openweathermap.org/img/wn/04d@2x.png"
broken_clouds_night = "https://openweathermap.org/img/wn/04d@2x.png"
shower_rain_day = "https://openweathermap.org/img/wn/09d@2x.png"
shower_rain_night = "https://openweathermap.org/img/wn/09d@2x.png"
rain_day = "https://openweathermap.org/img/wn/10d@2x.png"
rain_night = "https://openweathermap.org/img/wn/10n@2x.png"
thunderstorm_day = "https://openweathermap.org/img/wn/11d@2x.png"
thunderstorm_night = "https://openweathermap.org/img/wn/11d@2x.png"
snow_day = "https://openweathermap.org/img/wn/13d@2x.png"
snow_night = "https://openweathermap.org/img/wn/13d@2x.png"
mist_day = "https://openweathermap.org/img/wn/50d@2x.png"
mist_night = "https://openweathermap.org/img/wn/50d@2x.png"



weather_params = {
    "lat":-19.929209,
    "lon":-43.945317,
    "appid":apy_key,
    "cnt": 4,
}

response = requests.get(OWM_Endpoint, params=weather_params)
response.raise_for_status()
weather_data = response.json()
#print(weather_data["list"][0]["weather"][0]["id"])
#print(weather_data["list"][0]['dt_txt'])


for hour_data in weather_data["list"]:
    condition_code = hour_data["weather"][0]["id"]
    time_date = datetime.datetime.strptime(hour_data['dt_txt'], "%Y-%m-%d %H:%M:%S")
    time_of_day = datetime.datetime.strptime("17:00:00", "%H:%M:%S")
    client = Client(account_sid, auth_token)

    if int(condition_code) in range(200, 233):
        status = "Thunderstorm."
        if time_date < time_of_day:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {thunderstorm_day}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)
        else:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {thunderstorm_night}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)
    
    elif int(condition_code) in range(300, 322):
        status = "Drizzle."
        if time_date < time_of_day:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {shower_rain_day}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)
        else:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {shower_rain_night}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)


    elif int(condition_code) in range(500, 532):
        status = "Rain."
        if time_date < time_of_day:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {rain_day}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)
        else:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {rain_night}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)




    elif int(condition_code) in range(600, 623):
        status = "Snow."
        if time_date < time_of_day:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {snow_day}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)
        else:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {snow_night}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)




    elif int(condition_code) in range(701, 782):
        status = "Atmosphere."
        if time_date < time_of_day:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {mist_day}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)
        else:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {mist_night}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)
        

    elif int(condition_code) == 800:
        status = "Clear."
        if time_date < time_of_day:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {clear_sky_day}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)
        else:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {clear_sky_night}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)


    elif int(condition_code) in range(801, 805):
        status = "Clouds."
        if time_date < time_of_day:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {scattered_clouds_day}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)
        else:
            message = client.messages \
                        .create(
                            body=f" Today the weather status is {status}, {scattered_clouds_night}.",
                            from_='+15702993413',
                            to='+5531981204779')
            print(message.status)

    else :
        print("Error.")