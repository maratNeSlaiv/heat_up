from PyQt5.QtCore import QUrl
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget
from PyQt5.QtWebEngineWidgets import QWebEngineView
import sys

def open_youtube_video(youtube_url= 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'):
    class YouTubeViewer(QMainWindow):
        def __init__(self):
            super().__init__()
            self.setWindowTitle("YouTube Video Viewer")
            self.setGeometry(100, 100, 800, 600)
            
            # Set up the WebEngine view
            self.browser = QWebEngineView()
            self.browser.setUrl(QUrl(youtube_url))

            # Layout setup
            layout = QVBoxLayout()
            layout.addWidget(self.browser)
            
            # Central widget
            central_widget = QWidget()
            central_widget.setLayout(layout)
            self.setCentralWidget(central_widget)

    app = QApplication(sys.argv)
    viewer = YouTubeViewer()
    viewer.show()
    sys.exit(app.exec_())

# Example usage:
if __name__ == "__main__":
    open_youtube_video()
