##
# RequestManager.py
# tworivers-display
# Passes the requests for data or action to a locally hosted intermediary proxy
# Which itself (in my configuration) makes another request of a proxy
# It makes a RESTful request in order to asynchronously pass data back to the connected View
import urllib.request

class RequestManager:
    
    # sets the address to tlook for the local host
    LOCAL_HOST = 'http://127.0.0.1'
    # where to look for about data - placeholder
    SERVICE_ABOUT = '/about.json'

    # SERVICES #

    # where to look for slide paths
    SERVICE_SLIDESHOW = '/slideshow/request_slides.php'
    # where to look for weather data
    SERVICE_WEATHER = '/weather/request_weather.php'
    # where to look for forecast data
    SERVICE_FORECAST = '/weather/request_forecast.php'

    # ACTIONS #

    # where to look for brightness toggle action
    ACTION_BRIGHTNESS = '/actions/brightness/toggle.php'

    ## Initialize the RequestManager and set the service host to the LOCAL_HOST by default
    def __init__(self, serviceHost = LOCAL_HOST ):
        self.serviceType = self.SERVICE_ABOUT
        self.serviceHost = serviceHost

    ## 
    # Make a request for action using a RESTful interface
    # Currently identical to services
    def requestAction(self, action):
        print("Requesting action " + self.serviceHost + action )
        response = urllib.request.urlopen( self.serviceHost + action )
        return response.read().decode('utf-8')

    ##
    # Make a request for a service using a RESTful API
    def requestService(self, service):
        print("Requesting service " + self.serviceHost + service )
        response = urllib.request.urlopen( self.serviceHost + service )
        return response.read().decode('utf-8')

    ## Request slideshow information from the SLIDESHOW service
    def requestSlides(self):
        return self.requestService(self.SERVICE_SLIDESHOW)

    ## Request weather information from the SLIDESHOW service
    def requestWeather(self):
        return self.requestService(self.SERVICE_WEATHER)

    ## Request forecast information from the SLIDESHOW service
    def requestForecast(self):
        return self.requestService(self.SERVICE_FORECAST)

    ## Request the system toggle the backlight brightness
    def requestToggleBrightness(self):
        return self.requestAction(self.ACTION_BRIGHTNESS)
