from PySide2.QtCore import QObject, Signal, Slot
from source.RequestManager import RequestManager

class Manager(QObject):
    updateConfig = Signal(str)
    updateSlideshow = Signal(str)

    updateWeather = Signal(str)
    updateForecast = Signal(str)

    toggleBrightness = Signal(str)

    view = None

    @Slot()
    def slideShowReady(self):
        # self.slideshowUpdate()
        return

    @Slot()
    def requestUpdatedWeather(self):
        self.weatherUpdate()
        return

    @Slot()
    def requestUpdatedForecast(self):
        self.forecastUpdate()
        return

    @Slot()
    def requestRefresh(self):
        self.weatherUpdate()
        self.forecastUpdate()
        return

    @Slot()
    def requestToggleBrightness(self):
        self.brightnessToggle()
        return
    
    def brightnessToggle(self):
        request = RequestManager()
        self.toggleBrightness.emit(str(request.requestToggleBrightness()))

    def slideshowUpdate(self):
        request = RequestManager()
        self.updateSlideshow.emit(str(request.requestSlides()))

    def weatherUpdate(self):
        request = RequestManager()
        self.updateWeather.emit( str(request.requestWeather()) )

    def forecastUpdate(self):
        request = RequestManager()
        self.updateForecast.emit( str(request.requestForecast()) )

    def setup(self):
        self.updateSlideshow.connect( self.view.rootObject().ssUpdate )
        self.updateWeather.connect( self.view.rootObject().currentUpdate )
        self.updateForecast.connect( self.view.rootObject().forecastUpdate )
        self.toggleBrightness.connect( self.view.rootObject().toggleBrightness )

    def __init__(self, parent=None, view=None):
        QObject.__init__(self, parent)
        self.view = view
        self.m_text = ""
