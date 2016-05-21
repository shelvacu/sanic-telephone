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
    httpd = socketserver.TCPServer(('127.0.0.1', 8000),
                                   CustomRequestHandler)
    httpd.allow_reuse_address = True
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print('Closing server...')
