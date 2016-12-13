#!/usr/bin/env python3
import dbus
from functools import reduce

# use dbus-send --session --print-reply --dest=org.jackaudio.service /org/jackaudio/... <interface> [Parameters]
# -> tab completion is your friend (except for parameters)

bus = dbus.SessionBus()
# TODO multiple jack sessions
jack_controller = bus.get_object('org.jackaudio.service',
                                 '/org/jackaudio/Controller')
jack_patchbay = dbus.Interface(jack_controller, 'org.jackaudio.JackPatchbay')

class JackPort():
    def __init__(self, client, port, clientID, portID, ptype, flags):
        # TODO? ids
        #if isinstance(client, dbus.String):
        #    self.client = client.
        self.client = client
        self.port = port
        self.portID = portID
        self.clientID = clientID
        self.type = ptype
        self.flags = flags
    def getType(self):
        """get string representation of port type
        reference: common/JackPortType.h"""
        if self.type == 0:
            return "audio"
        elif self.type == 1:
            return "midi"
        else:
            return "unknown"
    # reference for flags: common/jack/types.h -> JackPortFlags
    def isInput(self):
        return self.flags & 0x1 != 0
    def isOutput(self):
        return self.flags & 0x2 != 0
    def isPhysical(self):
        return self.flags & 0x4 != 0
    # missing: canMonitor (0x8), isTerminal(0x10)
    def __str__(self):
        return "{}:{}".format(self.client, self.port)
    def __repr__(self):
        return self.__str__()
    def __eq__(self, other):
        return self.client == other.client and self.port == other.port
    def isID(self, clientID, portID):
        return clientID == self.clientID and portID == self.portID
    def isPort(self, client, port):
        return client == self.client and port == self.port

class JackConnection():
    def __init__(self, dbus_data, ports):
        self.source = [p for p in ports if p.lookupPortByName(dbus_data[1], dbus_data[3]) is not None][0]
        self.dest = [p for p in ports if p.lookupPortByName(dbus_data[5], dbus_data[7]) is not None][0]
        self.id = dbus_data[8]
    def __str__(self):
        return "{} -> {}".format(self.source, self.dest)

class JackClient():
    def __init__(self, dbus_data):
        self.id = dbus_data[0]
        self.name = dbus_data[1]
        self.ports = [JackPort(self.name, d[1], self.id, d[0], d[3], d[2]) for d in dbus_data[2]]
    def lookupPort(self, clientID, portID):
        for p in self.ports:
            if p.isID(clientID, portID):
                return port
        return None
    def lookupPortByName(self, client, port):
        for p in self.ports:
            if p.isPort(client, port):
                return port
        return None
    def __str__(self):
        return "{}: {}\n\t{}".format(self.name, self.id, self.ports)
class JackGraph():
    def __init__(self, dbus_data):
        self.version = dbus_data[0]
        self.clients = [JackClient(d) for d in dbus_data[1]]
        for c in self.clients:
            print(c)
        self.connections = [JackConnection(d, self.clients) for d in dbus_data[2]]
    def lookupPort(self, clientID, portID):
        return self.clients.lookupPort(clientID, portID)
    def lookupPortByName(self, client, port):
        return self.clients.lookupPortByName(client, port)
    def ports(self):
        return reduce(lambda a,b: a+b, [c.ports for c in self.clients], [])
    
def getPorts():
    graph = JackGraph(jack_patchbay.GetGraph(0))
    return graph.ports()

def getConnections():
    graph = JackGraph(jack_patchbay.GetGraph(0))
    return graph.connections

def connect(sPort, dPort):
    jack_patchbay.ConnectPortsByName(dbus.String(sPort.client), dbus.String(sPort.port),
                                     dbus.String(dPort.client), dbus.String(dPort.port))
#for c in getPorts():
#    print(c)
