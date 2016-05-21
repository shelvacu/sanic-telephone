import json, http.server, socketserver

clients = []

class CustomRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/done_img':
            pass

    def do_GET(self):
        if self.path == '/':
            clients.append(self.client_address)
        elif self.path == '/poll':
            pass

def run():
    httpd = socketserver.TCPServer(('', 8000),
                                   CustomRequestHandler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print('Closing server...')
