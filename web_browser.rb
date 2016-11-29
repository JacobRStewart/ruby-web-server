require "socket"
require "json"

host = "localhost"
port = "2000"
path = "index.html"

puts "Enter GET or POST:"
method = gets.chomp.upcase

case method
when "GET"
  request = "GET #{path} HTTP/1.0\nFrom: user@gmail.com\nUser-Agent: HTTPTool/1.0\r\n\r\n"
when "POST"
  puts "Enter name:"
  name = gets.chomp
  puts "Enter email:"
  email = gets.chomp

  info = { name: name, email: email}
  body = info.to_json
  path = "thanks.html"

  request = "POST #{path} HTTP/1.0\nFrom: user@gmail.com\nContent-Length: #{body.length}\nUser-Agent: HTTPTool/1.0\r\n\r\n#{body}"
else
  puts "Invalid HTTP method"
end


socket = TCPSocket.open(host,port)
socket.print(request)
response = socket.read
socket.close

header, body = response.split("\r\n\r\n", 2)
status_code = header.split[1]

if status_code == "200"
  puts body
else
  puts header
end
