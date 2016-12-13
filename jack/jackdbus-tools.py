#!/usr/bin/env python3
import dbus

# use dbus-send --session --print-reply --dest=org.jackaudio.service /org/jackaudio/... <interface> [Parameters]
# -> tab completion is your friend (except for parameters)

bus = dbus.SessionBus()
# TODO multiple jack sessions
jack_controller = bus.get_object('org.jackaudio.service',
                                 '/org/jackaudio/Controller')
jack_patchbay = dbus.Interface(jack_controller, 'org.jackaudio.JackPatchbay')

def getConnections():
    graph = jack_patchbay.GetGraph(0)
    ports = graph[1]
    conns = graph[2]
    #print(conns)
    def sourceName(conn):
        return (conn[1], conn[3])
    def destName(conn):
        return (conn[5], conn[7])
    def connID(conn):
        return conn[8x]
    return [(connID(c), sourceName(c), destName(c)) for c in conns]

for c in getConnections():
    print(c)
