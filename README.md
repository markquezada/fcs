# FCS: FreeSWITCH Command Socket

FCS is a lightweight api wrapper for [FreeSWITCH's event socket][event_socket].

## Installation

Add this line to your application's Gemfile:

    gem 'fcs'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fcs

## Usage

Using FCS is easy and intuitive. After initializing, dispatch commands to
FreeSWITCH using the `.dispatch!` method. See the examples below.

### Initializing

    fs = FCS.new(
      remote_host: 'localhost',
      remote_port: '8021'
    )

### Authorizing

    fs.auth('ClueCon').dispatch!

### Examples

FCS is basically a naive command builder for freeSWITCH. You build commands by
chaining method calls that match FreeSWITCH's [mod_commands][mod_commands] like
so:

    request = fs.api.originate 'sofia/mydomain.com 1000'
    response = request.dispatch!

This is equivalent:

    response = fs.api.originate('sofia/mydomain.com', '1000').dispatch!

Both these commands result in this api command being sent to FreeSWITCH:

    api originate sofia/mydomain.com 1000

These two commands are also equivalent:

    fs.api.uuid_getvar('fs_id', 'varname').dispatch!
    fs.api.uuid_getvar('fs_id').varname.dispatch!

This flexible syntax allows you to build commands in a very natural way that
mimics FreeSWITCH's command syntax.

A more complex example:

    fs.sendmsg(fs_id).call_command(:execute).execute_app_name(:playback).execute_app_arg('/tmp/sound.wav').loops(-1).event_lock(true)

The `sendmsg` command takes an optional uuid parameter. Since `execute` is so
common, there's a helper method that shortens the above to:

    fs.sendmsg(fs_id).execute(:playback, '/tmp/sound.wav').loops(-1).event_lock(true)

Pretty much any api method should work out of the box. A few more examples:

    fs.api.sched_api('+20').originate('sofia/external &echo()').dispatch!
    fs.api.uuid_send_dtmf(fs_id, 'W0W011W@250')
    fs.api.uuid_kill(fs_id, 'NORMAL_CLEARING')
    fs.api.sched_broadcast('+20', fs_id, 'commercial.wav').aleg
    fs.bgapi.originate 'sofia/mydomain.com'    

Calling `dispatch!` at the end of the chain is necessary in order to dispatch
the command to FreeSWITCH. Otherwise you'll get back a `Request` object. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[event_socket]: http://wiki.freeswitch.org/wiki/Event_Socket
[mod_commands]: http://wiki.freeswitch.org/wiki/Mod_commands
