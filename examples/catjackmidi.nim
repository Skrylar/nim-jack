#
# This example registers a new jack client with 8 midi_in ports
# and then for each input message, prints the midi message as both
# hex & seq[uint8]'s representation.
#
# Contributed by Robert Thomson
#
# MIT license, etc
#

import os
import jack
import strutils

var client: PJackClient
var event: JackMidiEvent
var midi_ports: seq[PJackPort]

proc echo(event: var JackMidiEvent, portnum: int=0) =
  var s = newSeq[uint8](event.size)
  copyMem(s[0].addr, event.buffer, event.size)
  stdout.write($portnum)
  stdout.write(": ")
  for i in s:
    stdout.write(toHex(i))
    stdout.write(" ")
  stdout.write("/ ")
  stdout.write($s)
  stdout.write("\n")
  stdout.flushFile()

proc process_cb*(nframes: JackNFrames, arg: pointer): int {.cdecl.} =
  var portnum = 0
  for port in midi_ports:
    portnum += 1
    let inbuf = jack_port_get_buffer(port, nframes)
    let count = jack_midi_get_event_count(inbuf)
    var res: int

    for i in 0..<count:
      res = jack_midi_event_get(event.addr, inbuf, i)
      if res == 0:
        echo(event, portnum)

proc main() =
  var status: JackStatus
  var options: Jack_options
  client = jack_client_open("catjackmidi", options, status.addr)
  if status != 0:
    quit "Failed to create jack client"

  var p1 = jack_port_register(client, "midi_in_1", JACK_DEFAULT_MIDI_TYPE, (uint64)JackPortIsInput, 0)
  var p2 = jack_port_register(client, "midi_in_2", JACK_DEFAULT_MIDI_TYPE, (uint64)JackPortIsInput, 0)
  var p3 = jack_port_register(client, "midi_in_3", JACK_DEFAULT_MIDI_TYPE, (uint64)JackPortIsInput, 0)
  var p4 = jack_port_register(client, "midi_in_4", JACK_DEFAULT_MIDI_TYPE, (uint64)JackPortIsInput, 0)
  var p5 = jack_port_register(client, "midi_in_5", JACK_DEFAULT_MIDI_TYPE, (uint64)JackPortIsInput, 0)
  var p6 = jack_port_register(client, "midi_in_6", JACK_DEFAULT_MIDI_TYPE, (uint64)JackPortIsInput, 0)
  var p7 = jack_port_register(client, "midi_in_7", JACK_DEFAULT_MIDI_TYPE, (uint64)JackPortIsInput, 0)
  var p8 = jack_port_register(client, "midi_in_8", JACK_DEFAULT_MIDI_TYPE, (uint64)JackPortIsInput, 0)
  midi_ports = @[p1, p2, p3, p4, p5, p6, p7, p8]

  status = jack_set_process_callback(client, JackProcessCallback(process_cb), nil)
  if status != 0:
    quit "Failed to configure process callback"

  status = jack_activate(client)
  if status != 0:
    quit "Failed to activate client"

  try:
    while true:
      sleep(60000)
  finally:
    discard jack_client_close(client)

when isMainModule:
  main()
