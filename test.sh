#!/bin/bash

curl -X POST -H "Content-Type: application/json" --data '{"locations": [{"lat": 34.4178674379245,"lon": -119.87054944038391},{"lat": 34.43177945000364,"lon": -119.82655048370361}],"costing":"auto","directions_options": {"units": "miles"}}' http://192.168.99.100:8002/route
