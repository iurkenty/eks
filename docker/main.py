# Import necessary modules
import urllib.request  # For making HTTP requests
import json  # For parsing JSON responses
from flask import Flask, render_template, request, send_from_directory  # For creating a Flask web application and serving files

# Create a Flask web application
app = Flask(__name__)

# Define the route for the root URL '/'
@app.route('/')
def index():
    # Get Client IP
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr)
    print(f'Client IP: {client_ip}')

    # Get your token from IP info's account dashboard
    token = "6b8785eb02a28e"

    # Create the URL for the IPinfo API, using f-string
    url = f"https://www.ipinfo.io/{client_ip}?token={token}"

    # Call the IPinfo API and save the response
    with urllib.request.urlopen(url) as response:
        response_content = response.read()

    # Parsing the API response
    data = json.loads(response_content)

    # Get the user-provided string from the URL parameter
    user_string = request.args.get('string', default='')

    # Render the template 'index.html' and pass the IP address, geolocation, and user string as variables
    return render_template('index.html', ip_address=data["ip"], geolocation=f"{data['city']}, {data['region']}", user_string=user_string)

# Define the route for '/index.html'
@app.route('/index.html')
def serve_index():
    # Get the user-provided string from the URL parameter
    user_string = request.args.get('string', default='')

    # Read the content of the 'index.html' file from the specified directory
    with open('index.html', 'r') as file:
        index_html_content = file.read()

        # Replace the placeholder '{{ user_string }}' in the 'index.html' content with the user-provided string
        index_html_content = index_html_content.replace('{{ user_string }}', user_string)

    # Return the modified 'index.html' content
    return index_html_content

# Start the Flask application if this script is executed directly
if __name__ == '__main__':
    app.run(host='0.0.0.0')