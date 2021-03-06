from twisted.internet.protocol import Factory,Protocol
from twisted.internet import reactor
import sys
import socket
import serial
import struct


class IphoneChat(Protocol):
	VELOCITYVALUE = 200
	ROTATIONVALUE = 300
	def connectionMade(self):
		self.factory.clients.append(self)
		print "clints are",self.factory.clients
	def connectionLost(self,reason):
		self.factory.clients.remove(self)
	def dataReceived(self,data):
		print data
		if data == 'passive':
			print 'passive'
			ser.write(bytearray([0x80]))
		elif data == 'safe':
			print 'safe'
			ser.write(bytearray([0x83]))
		elif data == 'full':
			print 'full'
			ser.write(bytearray([0x84]))
		elif data == 'clean':
			print 'clean'
			ser.write(bytearray([0x87]))
		elif data == 'dock':
			print 'dock'
			ser.write(bytearray([0x8f]))
		elif data == 'beep':
			print 'beep'
			ser.write(bytearray([0x8c,0x03,0x01,0x40,0x10,0x8d,0x03]))
		elif data == 'upButtonDown':
			print 'upButtonDown'
			#[137] [Velocity high byte] [Velocity low byte] [Radius high byte] [Radius low byte]
			#[137 200->c8 0->0]
			#ser.write(bytearray([0x89,0x00,0xc8,0x00,0x00]))
			vl=self.VELOCITYVALUE
			vr=self.VELOCITYVALUE
			# create drive command
            		cmd = struct.pack(">Bhh", 145, vr, vl)
	    		print 'cmd: '.join([ str(ord(c)) for c in cmd ])
			ser.write(cmd)
		elif data == 'downButtonDown':
			print 'downButtonDown'
            		#ser.write(bytearray([0x91,0xFF,0x38,0xFF,0x38]))
			vl=-self.VELOCITYVALUE
			vr=-self.VELOCITYVALUE
			# create drive command
            		cmd = struct.pack(">Bhh", 145, vr, vl)
	    		print 'cmd: '.join([ str(ord(c)) for c in cmd ])
			ser.write(cmd)
		elif data == 'leftButtonDown':
			print 'leftButtonDown'
            		#ser.write(bytearray([0x91,0x00,0x96,0xFF,0x6A]))
			vl=(-self.ROTATIONVALUE/2)
			vr=(self.ROTATIONVALUE/2)
			# create drive command
            		cmd = struct.pack(">Bhh", 145, vr, vl)
			print 'cmd: '.join([ str(ord(c)) for c in cmd ])
			ser.write(cmd)
		elif data == 'rightButtonDown':
			print 'rightButtonDown'
            		#ser.write(bytearray([0x91,0xFF,0x6A,0x00,0x96]))
			vl=(self.ROTATIONVALUE/2)
			vr=(-self.ROTATIONVALUE/2)
			# create drive command
            		cmd = struct.pack(">Bhh", 145, vr, vl)
			print 'cmd: '.join([ str(ord(c)) for c in cmd ])
			ser.write(cmd)
        	elif data == 'stop':
            		print 'stop'
            		ser.write(bytearray([0x91,0x00,0x00,0x00,0x00]))
		elif data[0] == 'V':
			print 'set velocity'
			velocity=data[2:]
			self.VELOCITYVALUE=int(velocity)
			self.ROTATIONVALUE=self.VELOCITYVALUE+100
			print 'v:',self.VELOCITYVALUE
		elif data == 'power down':
			print 'power down'
			ser.write(bytearray([0x85]))
	def message(self,message):
		self.transport.write(message+'\n')

factory=Factory()
factory.clients=[]
factory.protocol=IphoneChat
port=9000
if len(sys.argv)>1:
    port=int(sys.argv[1])
print port
reactor.listenTCP(port,factory)
print "Iphone Chat Server started"
# Open a serial connection to Roomba.
ser = serial.Serial(port='/dev/ttyUSB0', baudrate=115200)
reactor.run()
