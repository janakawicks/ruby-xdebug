class Debugger
    def initialize(host='127.0.0.1', port='9000')
        @proto = DbgProtocol.new()
        @tid = 5555
    end

    def step_into
        @proto.send_msg("step_into -i #{@tid}")
        r = @proto.recv_msg
        xml = Nokogiri::XML(r)
        filename = xml.xpath('/x:response/y:message/@filename', {'x' => 'urn:debugger_protocol_v1', 'y' => 'http://xdebug.org/dbgp/xdebug'}).to_s
        lineno = xml.xpath('/x:response/y:message/@lineno', {'x' => 'urn:debugger_protocol_v1', 'y' => 'http://xdebug.org/dbgp/xdebug'}).to_s.to_i

        display_src(filename, lineno)
    end

    def display_src(filename, lineno)
        @proto.send_msg("source -i #{@tid} -f #{filename}")
        r = @proto.recv_msg
        xml = Nokogiri::XML(r)
        code = xml.xpath('/x:response', {'x' => 'urn:debugger_protocol_v1'}).text
        i = 0
        source = CodeRay.scan(Base64.decode64(code), :php).terminal.split("\n")
        rjust = (source.length/10.0).ceil
        puts "\n\e[1mFrom\e[0m: #{filename} @ line #{lineno} : \n\n"
        source.each do |l|
            i = i+1
            if i == lineno
                puts "\e[1;34m => #{i.to_s.rjust(rjust)}\e[0m: #{l}"
            else
                puts "\e[1;34m    #{i.to_s.rjust(rjust)}\e[0m: #{l}"
            end
        end
    end
end
