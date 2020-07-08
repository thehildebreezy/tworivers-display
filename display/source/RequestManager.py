import urllib.request

class RequestManager:
    
    LOCAL_HOST = 'http://127.0.0.1'
    SERVICE_ABOUT = '/about.json'
    SERVICE_SLIDESHOW = '/slideshow/request_slides.php'
    SERVICE_WEATHER = '/weather/request_weather.php'
    SERVICE_FORECAST = '/weather/request_forecast.php'
    ACTION_BRIGHTNESS = '/actions/brightness/toggle.php'

    def __init__(self, serviceHost = LOCAL_HOST ):
        self.serviceType = self.SERVICE_ABOUT
        self.serviceHost = serviceHost

    def requestAction(self, action):
        print("Requesting action " + self.serviceHost + action )
        response = urllib.request.urlopen( self.serviceHost + action )
        return response.read().decode('utf-8')

    def requestService(self, service):
        print("Requesting service " + self.serviceHost + service )
        response = urllib.request.urlopen( self.serviceHost + service )
        return response.read().decode('utf-8')

    def requestSlides(self):
        return self.requestService(self.SERVICE_SLIDESHOW)

    def requestWeather(self):
        return self.requestService(self.SERVICE_WEATHER)

    def requestForecast(self):
        return self.requestService(self.SERVICE_FORECAST)

    def requestToggleBrightness(self):
        return self.requestAction(self.ACTION_BRIGHTNESS)
