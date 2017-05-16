
const
   jackh = "<jack/jack.h>"

   JACK_DEFAULT_AUDIO_TYPE = "32 bit float mono audio"
   JACK_DEFAULT_MIDI_TYPE = "8 bit raw midi"
   JACK_MAX_FRAMES = (4294967295U)
   JACK_LOAD_INIT_LIMIT = 1024

type
   PJackClient {.importc: "jack_client_t", header: jackh.} = distinct pointer
   PJackPort {.importc: "jack_port_t", header: jackh.} = distinct pointer
   JackNativeThread {.importc: "jack_native_thread_t", header: jackh.} = distinct pointer

   JackNFrames = uint32
   JackTime = uint64

   Jack_uuid = uint64
   Jack_shmsize = int32

   JackErrorCallback = proc(msg: cstring) {.cdecl.}
   JackInfoCallback = proc(msg: cstring) {.cdecl.}

   Jack_intclient = uint64
   Jack_port_id = uint64
   Jack_port_type_id = uint64

   JackOptions {.importc: "jack_options_t".} = enum
      JackNullOption = 0x00,
      JackNoStartServer = 0x01,
      JackUseExactName = 0x02,
      JackServerName = 0x04,
      JackLoadName = 0x08,
      JackLoadInit = 0x10,
      JackSessionID = 0x20

   JackStatus {.importc: "jack_status_t".} = enum
      JackFailure = 0x01,
      JackInvalidOption = 0x02,
      JackNameNotUnique = 0x04,
      JackServerStarted = 0x08,
      JackServerFailed = 0x10,
      JackServerError = 0x20,
      JackNoSuchClient = 0x40,
      JackLoadFailure = 0x80,
      JackInitFailure = 0x100,
      JackShmFailure = 0x200,
      JackVersionError = 0x400,
      JackBackendError = 0x800,
      JackClientZombie = 0x1000

   JackLatencyCallbackMode = enum
      JackCaptureLatency,
      JackPlaybackLatency

   Jack_latency_range {.packed.} = object
       min, max: Jack_nframes

   JackLatencyCallback = proc(mode: Jack_latency_callback_mode, arg: ptr void)
   JackProcessCallback = proc(nframes: Jack_nframes, arg: ptr void): int
   JackThreadCallback = proc(arg: ptr void)
   JackThreadInitCallback = proc(arg: ptr void)
   JackGraphOrderCallback = proc(arg: ptr void): int 
   JackXRunCallback = proc(arg: ptr void): int 
   JackBufferSizeCallback = proc(nframes: Jack_nframes, arg: ptr void): int 
   JackSampleRateCallback = proc(nframes: Jack_nframes, arg: ptr void): int 
   JackPortRegistrationCallback = proc(port: Jack_port_id, r: int, arg: ptr void)
   JackClientRegistrationCallback = proc(name: cstring, r: int, arg: ptr void)
   JackPortConnectCallback = proc(a, b: Jack_port_id, connect: int, arg: ptr void)
   JackPortRenameCallback = proc(port: Jack_port_id, old_name, new_name: cstring, arg: ptr void)
   JackFreewheelCallback = proc(starting: int, arg: ptr void)
   JackShutdownCallback = proc(arg: ptr void)
   JackInfoShutdownCallback = proc(code: Jack_status, reason: cstring, arg: ptr void)

   Jack_default_audio_sample = float

   JackPortFlags = enum
      JackPortIsInput = 0x1,
      JackPortIsOutput = 0x2,
      JackPortIsPhysical = 0x4,
      JackPortCanMonitor = 0x8,
      JackPortIsTerminal = 0x10,

   JackTransportState = enum
      JackTransportStopped = 0,
      JackTransportRolling = 1,
      JackTransportLooping = 2,
      JackTransportStarting = 3
      JackTransportNetStarting = 4

   Jack_unique = uint64

   JackPositionBits = enum
      JackPositionBBT = 0x10,
      JackPositionTimecode = 0x20,
      JackBBTFrameOffset = 0x40,
      JackAudioVideoRatio = 0x80,
      JackVideoFrameOffset = 0x100

   Jack_position {.importc: "jack_position_t", packed.} = object
      unique_1: Jack_unique
      usecs: Jack_time
      frame_rate: Jack_nframes
      frame: Jack_nframes
      valid: Jack_position_bits
      bar: int32
      beat: int32
      tick: int32
      bar_start_tick: float64
      beats_per_bar: float
      beat_type: float
      ticks_per_beat: float64
      beats_per_minute: float64
      frame_time: float64
      next_time: float64
      bbt_offset: Jack_nframes
      audio_frames_per_video_frame: float
      video_offset: Jack_nframes
      padding1: int32
      padding2: int32
      padding3: int32
      padding4: int32
      padding5: int32
      padding6: int32
      padding7: int32
      unique_2: Jack_unique

   JackSyncCallback {.importc: "jack_sync_callback_t", header: jackh.} = proc (state: Jack_transport_state, pos: ptr Jack_position, arg: ptr void) 

   JackTimebaseCallback {.importc: "jack_timebase_callback_t", header: jackh.} = proc (state: Jack_transport_state, nframes: Jack_nframes, pos: ptr Jack_position, new_pos: int, arg: ptr void) 

proc jack_get_version(major_ptr: ptr int, minor_ptr: ptr int, micro_ptr: ptr int, proto_ptr: ptr int) {.importc: "jack_get_version", header: jackh.}

proc jack_get_version_string(): cstring {.importc: "jack_get_version_string", header: jackh.}

# Creating & manipulating clients

proc jack_client_close(client: PJackClient): int {.importc: "jack_client_close", header: jackh.}
proc jack_client_name_size(): int {.importc: "jack_client_name_size", header: jackh.}
proc jack_get_client_name(client: PJackClient): cstring {.importc: "jack_get_client_name", header: jackh.}
proc jack_get_uuid_for_client_name(client: PJackClient, client_name: cstring): cstring {.importc: "jack_get_uuid_for_client_name", header: jackh.}
proc jack_get_client_name_by_uuid(client: PJackClient, client_uuid: cstring): cstring {.importc: "jack_get_client_name_by_uuid", header: jackh.}
proc jack_activate(client: PJackClient): int {.importc: "jack_activate", header: jackh.}
proc jack_deactivate(client: PJackClient): int {.importc: "jack_deactivate", header: jackh.}
proc jack_get_client_pid(name: cstring): int {.importc: "jack_get_client_pid", header: jackh.}
proc jack_client_thread_id(client: PJackClient): JackNativeThread {.importc: "jack_client_thread_id", header: jackh.}
proc jack_is_realtime(client: PJackClient): int {.importc: "jack_is_realtime", header: jackh.}

# The non-callback API

proc jack_thread_wait(client: PJackClient, status: int): JackNFrames {.importc: "jack_thread_wait", header: jackh.}
proc jack_cycle_wait(client: PJackClient): JackNFrames {.importc: "jack_cycle_wait", header: jackh.}
proc jack_cycle_signal(client: PJackClient, status: int): void {.importc: "jack_cycle_signal", header: jackh.}
proc jack_set_process_thread(client: PJackClient, thread_callback: JackThreadCallback, arg: ptr void): int {.importc: "jack_set_process_thread", header: jackh.}

# Setting Client Callbacks

proc jack_set_thread_init_callback(client: PJackClient, thread_init_callback: JackThreadInitCallback, arg: ptr void): int {.importc: "jack_set_thread_init_callback", header: jackh.}
proc jack_on_shutdown(client: PJackClient, shutdown_callback: JackShutdownCallback, arg: ptr void): void {.importc: "jack_on_shutdown", header: jackh.}
proc jack_on_info_shutdown(client: PJackClient, shutdown_callback: JackInfoShutdownCallback, arg: ptr void): void {.importc: "jack_on_info_shutdown", header: jackh.}
proc jack_set_process_callback(client: PJackClient, process_callback: JackProcessCallback, arg: ptr void): int {.importc: "jack_set_process_callback", header: jackh.}
proc jack_set_freewheel_callback(client: PJackClient, freewheel_callback: JackFreewheelCallback, arg: ptr void): int {.importc: "jack_set_freewheel_callback", header: jackh.}
proc jack_set_buffer_size_callback(client: PJackClient, bufsize_callback: JackBufferSizeCallback, arg: ptr void): int {.importc: "jack_set_buffer_size_callback", header: jackh.}
proc jack_set_sample_rate_callback(client: PJackClient, srate_callback: JackSampleRateCallback, arg: ptr void): int {.importc: "jack_set_sample_rate_callback", header: jackh.}
proc jack_set_client_registration_callback(client: PJackClient, registration_callback: JackClientRegistrationCallback, arg: ptr void): int {.importc: "jack_set_client_registration_callback", header: jackh.}
proc jack_set_port_registration_callback(client: PJackClient, registration_callback: JackPortRegistrationCallback, arg: ptr void): int {.importc: "jack_set_port_registration_callback", header: jackh.}
proc jack_set_port_connect_callback(client: PJackClient, connect_callback: JackPortConnectCallback, arg: ptr void): int {.importc: "jack_set_port_connect_callback", header: jackh.}
proc jack_set_port_rename_callback(client: PJackClient, rename_callback: JackPortRenameCallback, arg: ptr void): int {.importc: "jack_set_port_rename_callback", header: jackh.}
proc jack_set_graph_order_callback(client: PJackClient, graph_callback: JackGraphOrderCallback, arg: ptr void): int {.importc: "jack_set_graph_order_callback", header: jackh.}
proc jack_set_xrun_callback(client: PJackClient, xrun_callback: JackXRunCallback, arg: ptr void): int {.importc: "jack_set_xrun_callback", header: jackh.}
proc jack_set_latency_callback(client: PJackClient, latency_callback: JackLatencyCallback, arg: ptr void): int {.importc: "jack_set_latency_callback", header: jackh.}

# Controlling & querying JACK server operation

proc jack_set_freewheel(client: PJackClient, onoff: int): int {.importc: "jack_set_freewheel", header: jackh.}
proc jack_set_buffer_size(client: PJackClient, nframes: JackNFrames): int {.importc: "jack_set_buffer_size", header: jackh.}
proc jack_get_sample_rate(client: PJackClient): JackNFrames {.importc: "jack_get_sample_rate", header: jackh.}
proc jack_get_buffer_size(client: PJackClient): JackNFrames {.importc: "jack_get_buffer_size", header: jackh.}
proc jack_cpu_load(client: PJackClient): float {.importc: "jack_cpu_load", header: jackh.}

# Creating & manipulating ports

proc jack_port_register(client: PJackClient, port_name: cstring, port_type: cstring, flags: uint64, buffer_size: uint64): PJackPort {.importc: "jack_port_register", header: jackh.}
proc jack_port_unregister(client: PJackClient, port: PJackPort): int {.importc: "jack_port_unregister", header: jackh.}
proc jack_port_get_buffer(port: PJackPort, frames: JackNFrames): ptr void {.importc: "jack_port_get_buffer", header: jackh.}
proc jack_port_uuid(port: PJackPort): Jack_uuid {.importc: "jack_port_uuid", header: jackh.}
proc jack_port_name(port: PJackPort): cstring {.importc: "jack_port_name", header: jackh.}
proc jack_port_short_name(port: PJackPort): cstring {.importc: "jack_port_short_name", header: jackh.}
proc jack_port_flags(port: PJackPort): int {.importc: "jack_port_flags", header: jackh.}
proc jack_port_type(port: PJackPort): cstring {.importc: "jack_port_type", header: jackh.}
proc jack_port_type_id(port: PJackPort): Jack_port_type_id {.importc: "jack_port_type_id", header: jackh.}
proc jack_port_is_mine(client: PJackClient, port: PJackPort): int {.importc: "jack_port_is_mine", header: jackh.}
proc jack_port_connected(port: PJackPort): int {.importc: "jack_port_connected", header: jackh.}
proc jack_port_connected_to(port: PJackPort, port_name: cstring): int {.importc: "jack_port_connected_to", header: jackh.}
proc jack_port_get_connections(port: PJackPort): ptr cstring {.importc: "jack_port_get_connections", header: jackh.}
proc jack_port_get_all_connections(client: PJackClient,  port: PJackPort): ptr cstring {.importc: "jack_port_get_all_connections", header: jackh.}
proc jack_port_set_name(port: PJackPort, port_name: cstring): int {.importc: "jack_port_set_name", header: jackh.}
proc jack_port_set_alias(port: PJackPort, alias: cstring): int {.importc: "jack_port_set_alias", header: jackh.}
proc jack_port_unset_alias(port: PJackPort, alias: cstring): int {.importc: "jack_port_unset_alias", header: jackh.}
#TODO
#proc jack_port_get_aliases(port: PJackPort, char* aliases[2]): int
proc jack_port_request_monitor(port: PJackPort, onoff: int): int {.importc: "jack_port_request_monitor", header: jackh.}
proc jack_port_request_monitor_by_name(client: PJackClient, port_name: cstring, onoff: int): int {.importc: "jack_port_request_monitor_by_name", header: jackh.}
proc jack_port_ensure_monitor(port: PJackPort, onoff: int): int {.importc: "jack_port_ensure_monitor", header: jackh.}
proc jack_port_monitoring_input(port: PJackPort): int {.importc: "jack_port_monitoring_input", header: jackh.}
proc jack_connect(client: PJackClient,  source_port: cstring, destination_port: cstring): int {.importc: "jack_connect", header: jackh.}
proc jack_disconnect(client: PJackClient,  source_port: cstring, destination_port: cstring): int {.importc: "jack_disconnect", header: jackh.}
proc jack_port_disconnect(client: PJackClient, port: PJackPort): int {.importc: "jack_port_disconnect", header: jackh.}
proc jack_port_name_size(): int {.importc: "jack_port_name_size", header: jackh.}
proc jack_port_type_size(): int {.importc: "jack_port_type_size", header: jackh.}
proc jack_port_type_get_buffer_size(client: PJackClient, port_type: cstring): csize {.importc: "jack_port_type_get_buffer_size", header: jackh.}

# Managing and determining latency

proc jack_port_get_latency_range(port: PJackPort, mode: Jack_latency_callback_mode, range: ptr Jack_latency_range): void {.importc: "jack_port_get_latency_range", header: jackh.}
proc jack_port_set_latency_range(port: PJackPort, mode: Jack_latency_callback_mode, range: ptr Jack_latency_range): void {.importc: "jack_port_set_latency_range", header: jackh.}
proc jack_recompute_total_latencies(client: PJackClient): int {.importc: "jack_recompute_total_latencies", header: jackh.}

# Looking up ports

proc jack_get_ports(client: PJackClient, port_name_pattern: cstring, type_name_pattern: cstring, flags: uint64): ptr cstring {.importc: "jack_get_ports", header: jackh.}
proc jack_port_by_name(client: PJackClient, port_name: cstring): PJackPort {.importc: "jack_port_by_name", header: jackh.}
proc jack_port_by_id(client: PJackClient, port_id: Jack_port_id): PJackPort {.importc: "jack_port_by_id", header: jackh.}

# Handling time

proc jack_frames_since_cycle_start( client: PJackClient ): JackNFrames {.importc: "jack_frames_since_cycle_start", header: jackh.}
proc jack_frame_time( client: PJackClient ): JackNFrames {.importc: "jack_frame_time", header: jackh.}
proc jack_last_frame_time( client: PJackClient ): JackNFrames {.importc: "jack_last_frame_time", header: jackh.}
proc jack_get_cycle_times(client: PJackClient, current_frames: ptr JackNFrames, current_usecs: ptr JackTime, next_usecs: ptr JackTime, period_usecs: ptr float): int {.importc: "jack_get_cycle_times", header: jackh.}
proc jack_frames_to_time(client: PJackClient, frames: JackNFrames): JackTime {.importc: "jack_frames_to_time", header: jackh.}
proc jack_time_to_frames(client: PJackClient, time: JackTime): JackNFrames {.importc: "jack_time_to_frames", header: jackh.}
proc jack_get_time: JackTime {.importc: "jack_get_time", header: jackh.}

# Controlling error/information output

proc jack_set_error_function(fn: JackErrorCallback) {.importc: "jack_set_error_function", header: jackh.}
proc jack_set_info_function(fn: JackInfoCallback) {.importc: "jack_set_info_function", header: jackh.}
proc jack_free(pntr: ptr void) {.importc: "jack_free", header: jackh.}

