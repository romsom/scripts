2split = FloatingKeySplit('c2', 'c4', Channel(2), Channel(3))
3split = FloatingKeySplit('c2', 'c3', Channel(2), Channel(1)) >> FloatingKeySplit('g3', 'g4', Channel(1), Channel(3))

config(
    backend='alsa', # maybe ok, for live purposes, jack/jack_rt uses alsa, too, as backend
    out_ports = [('out', 'Ploytec USB MIDI Junction II:.*')],
    in_ports = [('in', 'ebus_bridge:.*')])

run(2split)
