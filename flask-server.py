'''
This application uses Flask as a web server and jquery to trigger
pictures with SimpleCV

To use start the web server:
>>> python flask-server.py

Then to run the application:
>>> python webkit-gtk.py

*Note: You are not required to run the webkit-gtk.py, you can also
visit http://localhost:5555

'''

print __doc__


from flask import Flask, jsonify, render_template, request
from werkzeug import SharedDataMiddleware
import tempfile, os
import simplejson as json
import SimpleCV
from SimpleCV import *
import webbrowser
import time

app = Flask(__name__)
js = JpegStreamer('0.0.0.0:5555')
cam = SimpleCV.Camera()
cam.getImage().save(js)

while True:
    i=cam.getImage()
    i.save(js)
    time.sleep(1)


