##
# ConnectSlots.py
# tworivers-display
# This Manager class will provide the QML view a means to send requests back to the Python script
# Best used to handle input, e.g. screen click sends a request to toggle the backlight brightness
# It also allwows the View to alert when its view is going stale
##
from PySide2.QtCore import QObject, Signal, Slot
from source.RequestManager import RequestManager

## 
# Class extends a QObject so it can be passed to QML and accessed via Javascript
##
class Manager(QObject):

    # SIGNALS #

    ## emit this signal when an updated configuration is ready
    updateConfig = Signal(str)
    ## emit this signal when an update to the slideshow is ready
    updateSlideshow = Signal(str)
    ## emit this signal when an update to the current weather data is ready
    updateWeather = Signal(str)
    ## emitthis signal when an update to the forecast weather data is ready
    updateForecast = Signal(str)
    ## emit this signal when  the brightness has been toggled
    toggleBrightness = Signal(str)

    # placeholder
    view = None

    # SLOTS #

    ## This slot is invoked fromt he QML when the slideshow is initialized
    @Slot()
    def slideShowReady(self):
        # placeholder
        return

    ## This slot is invoked if the view thinks it needs updated current weather
    # Not used - may be called if it detects bad data in the JSON and wants to try to recover
    @Slot()
    def requestUpdatedWeather(self):
        self.weatherUpdate()
        return

    ## This slot is invoked if the view thinks it needs updated forecast weather
    # Not used - may be called if it detects bad data in the JSON and wants to try to recover
    @Slot()
    def requestUpdatedForecast(self):
        self.forecastUpdate()
        return

    ## This slot is invoked from the QML view if it thinks its view data is stale
    # currently triggers from QML about ever 15 minutes
    @Slot()
    def requestRefresh(self):
        self.weatherUpdate()
        self.forecastUpdate()
        self.slideshowUpdate()
        return

    ## This slot is invoked if the QML view receives a tap on the screen
    @Slot()
    def requestToggleBrightness(self):
        self.brightnessToggle()
        return


    # METHODS #
    
    ## 
    # Initializes the RequestManager and sends a request to toggle Brightness
    # Passes the string response from the request manager to the signal
    # which is emitted for the QML view
    def brightnessToggle(self):
        request = RequestManager()
        self.toggleBrightness.emit(str(request.requestToggleBrightness()))

    ## Initializes the RequestManager and sends a request to update the slideshow
    # Passes the string response from the request manager to the signal
    # which is emitted for the QML view
    def slideshowUpdate(self):
        request = RequestManager()
        self.updateSlideshow.emit(str(request.requestSlides()))

    ## Initializes the RequestManager and sends a request to update weather
    # Passes the string response from the request manager to the signal
    # which is emitted for the QML view
    def weatherUpdate(self):
        request = RequestManager()
        self.updateWeather.emit( str(request.requestWeather()) )

    ## Initializes the RequestManager and sends a request to update forecast
    # Passes the string response from the request manager to the signal
    # which is emitted for the QML view
    def forecastUpdate(self):
        request = RequestManager()
        self.updateForecast.emit( str(request.requestForecast()) )

    ## 
    # Run on initial set up when the view is ready to connect all the signals
    # to the apprpriate slots in the QML views
    def setup(self):
        self.updateSlideshow.connect( self.view.rootObject().ssUpdate )
        self.updateWeather.connect( self.view.rootObject().currentUpdate )
        self.updateForecast.connect( self.view.rootObject().forecastUpdate )
        self.toggleBrightness.connect( self.view.rootObject().toggleBrightness )

    ## Initialize the manager class
    #  @param parent the parent context to initialize this QObject in to
    #  @param view the view context to inject ourselves into
    def __init__(self, parent=None, view=None):
        QObject.__init__(self, parent)
        self.view = view
        self.m_text = ""
