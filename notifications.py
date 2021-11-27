#!/usr/bin/env python3
import sys
from gi.repository import GLib as glib
import dbus
from dbus.mainloop.glib import DBusGMainLoop

def notifications(bus, message):
    print (' - '.join([x for x in message.get_args_list()
                       if isinstance(x, dbus.String) and len(x) > 0]))
    sys.stdout.flush()

DBusGMainLoop(set_as_default=True)

bus = dbus.SessionBus()
bus.add_match_string_non_blocking("eavesdrop=true, interface='org.freedesktop.Notifications', member='Notify'")
bus.add_message_filter(notifications)

mainloop = glib.MainLoop()
mainloop.run()
