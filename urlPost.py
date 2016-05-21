#!/usr/bin/env python
import sys
import json
import requests

def pyCurl(input):
    global r

    url = 'http://192.168.99.100:8002/route'
    headers = {'content-type': 'application/json'}
    r = requests.post(url, data = json.dumps(js), headers = headers)
    print r.text

def read_problem(file):
  global js

  try:
      with open(file,"r") as f:
          js = json.load(f)
  except IOError:
      print 'Error reading file'
      raise
  return 1

file = sys.argv[1]
read_problem(file)
pyCurl(js)
