import os, json, http.server, socketserver, sys

rootAddr = os.path.abspath(
    os.path.dirname(__file__) + '/../../client'
)

clients = None
running = False

class CustomRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/done_img':
            pass

    def do_GET(self):
        absPath = rootAddr + self.path
        if os.path.isfile(absPath):
            cutoff = self.path.find('/')
            if cutoff > 0:
                relaDir = self.path[:cutoff]
            else:
                relaDir = self.path
        else:
            relaDir = self.path
        if relaDir == '/':
            clients.append(self.client_address)
        elif relaDir == '/poll':
            
            pass
        if os.path.exists(absPath):
            if os.path.isdir(absPath):
                absPath = absPath + 'index.html'
            if os.path.isfile(absPath):
                self.send_response(200)
                with open(absPath, 'rb') as f:
                    data = f.read()
                    self.wfile.write(data)
            else:
                self.send_response(404)
                self.wfile.write('''<html>
<head>
<title>404 Page Not Found</title>
</head>
<body>
<p>Page does not exist</p>
<p>dipshit</p></body>
</html>'''.encode('utf-8'))

def run():
    global clients
    global running

    if running:
        print('Can\'t start server; already running')
        return False

    running = True
    clients = []
    
    httpd = socketserver.TCPServer(('', 8000),
                                   CustomRequestHandler)
    httpd.allow_reuse_address = True
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print('Closing server...')
        httpd.shutdown()
        httpd.server_close()
    running = False
    return True
