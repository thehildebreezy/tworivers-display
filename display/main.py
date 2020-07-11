##
# Main.py
# tworivers-display
# Python wrapper toinvoke the QML window and provide an wrapper/interface to the system at large
# @author Tanner Hildebrand
# @version 1.0
##
from PySide2.QtWidgets import QApplication
from PySide2.QtQuick import QQuickView
from PySide2.QtCore import QUrl

# import slot manager
from source.ConnectSlots import Manager

# default set up and view
app = QApplication([])
view = QQuickView()


# Manager will handle communication between
# view and model
manager = Manager(None, view)
view.rootContext().setContextProperty("manager",manager)

# Load the primary window and show
url = QUrl('main.qml')
view.setSource(url)
view.showFullScreen()

# let the manager know our view is ready
# and request updates
manager.setup()
manager.slideshowUpdate()
manager.weatherUpdate()
manager.forecastUpdate()

# run application
app.exec_()