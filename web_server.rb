require 'socket'
require 'json'

server = TCPServer.open("localhost", 2000)

loop do
	client = server.accept
	response = client.recv(1000).split(" ")
	method, path, http = response[0..2]

	puts "Recieved request: #{method} #{path} #{http}"
	if File.exist?(path)
		puts "#{path} found.\n"
		content = File.read(path)

		case method
		when "GET"
			client.puts("HTTP/1.0 200 OK\nDate and time: #{Time.now.ctime}\nContent-Type: #text/html\nContent-Length: #{content.length}\r\n\r\n#{content}")
		when "POST"
			params = {}
			params[:viking] = JSON.parse(response[-1])
			info = "<li>Name: #{params[:viking]["name"]}</li> <li>Email: #{params[:viking]["email"]}</li>"
			html = content.gsub!(/<%= yield %>/, info)
			client.puts("HTTP/1.0 200 OK\nContent-Length: #{html.length}\r\n\r\n#{html}")
		end
	else
		client.puts("HTTP/1.0 404 Not Found\r\n\r\n")
	end

	puts "Response sent! Closing the connection.\n"
	client.close
end
