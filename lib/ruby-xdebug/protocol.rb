class DbgProtocol

    def initialize(host='127.0.0.1', port='9000')
        server = TCPServer.new(host, port)
        @sock = server.accept
        recv_msg
    end

    def recv_length
        length = ''
        loop {
            c = @sock.recv(1)
            if c == ''
                @sock.close
                raise 'Socket Closed'
            elsif c == "\x00"
                break
            elsif c.to_i.to_s == c
                length = length + c
            end
        }
        length.to_i
    end

    def recv_null
        loop {
            c = @sock.recv(1)
            if c == ''
                @sock.close
                raise 'Socket Closed'
            elsif c == "\x00"
                break
            end
        }
    end

    def recv_msg
        body = ''
        to_recv = recv_length
        while to_recv > 0
            buf = @sock.recv(to_recv)
            to_recv = to_recv - buf.length
            body = body + buf
        end
        recv_null
        body
    end

    def send_msg(cmd)
        @sock.send cmd + "\x00", 0
    end
end
