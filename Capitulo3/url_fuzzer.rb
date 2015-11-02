##
# This file is part of the Metasploit Framework and may be subject to
# redistribution and commercial restrictions. Please see the Metasploit
# Framework web site for more information on licensing and terms of use.
#   http://metasploit.com/framework/
##
 
require 'msf/core'
 
class Metasploit3 < Msf::Auxiliary
    include Msf::Exploit::Remote::Tcp

    def initialize(info={})
        super(update_info(info,
            'Name'          => "Simple URL fuzzer",
            'Description'   => %q{
                    URL Fuzzer para servidores web 
            },
            'License'       => MSF_LICENSE,
            'Author'        =>  "Nacho Sorribas",
        ))
        register_options(
            [
		Opt::RPORT(80) # Puerto del servidor web
            ], self.class)
    end

    # Esta es la función que se ejecuta al hacer “run” o “exploit”
    def run 
        count = 10
        while (true)
            uri = Rex::Text.rand_text_alphanumeric(count) # fuzzing data
            print_status("Sending evil buffer, buffer lenght = %d" % uri.length)
            connect()
            sock.put("GET /#{uri}HTTP/1.1\r\n\r\n")
            res = sock.get_once(-1,1)
            if res 
                print_good ("Http server is up")
                print_status(res)
            else
                print_error ("Http server not responding. Last buffer sent of %d bytes" % uri.length)
                break
            end
            count = count + count
        end
		 
    end

end
