#Created by Tim Niblett 05/2016 - this posts data to the valhalla router
#!/usr/bin/env python
import sys
import json
import requests
import polyline_decode as pdecode

def pyCurl(input): #Define function to send request
    global r #define the request object as r
    global path_length
    #Put your valhalla url here
    url = 'http://192.168.99.100:8002/route'
    #Define your headers here: in this case we are using json data
    headers = {'content-type': 'application/json'}
    #define r as equal to the POST request
    r = requests.post(url, data = json.dumps(js), headers = headers)
    #print r.text
    #capture server response
    response = r.json()
    path_length = response['trip']['legs'][0]['summary']['length']
    coords = response['trip']['legs'][0]['shape']
    print path_length
    return pdecode.decode(coords)


def read_problem(file):
  global js

  try:
      with open(file,"r") as f:
          js = json.load(f)
  except IOError:
      print 'Error reading file'
      raise
  return 1

def getCoords(asciiString):
    print "empty"


file = sys.argv[1]
read_problem(file)
output = pyCurl(js)
print output
