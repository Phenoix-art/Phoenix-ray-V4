from http.server import HTTPServer, SimpleHTTPRequestHandler
import os
import threading
import webbrowser

PORT = 3000
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def log_message(self, format, *args):
        pass

def serve():
    server = HTTPServer(('0.0.0.0', PORT), Handler)
    print(f'G2Ray Configurator: http://localhost:{PORT}')
    server.serve_forever()

if __name__ == '__main__':
    threading.Thread(target=serve, daemon=True).start()
