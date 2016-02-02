import json
import sys
from pprint import pprint
from subprocess import check_output

jdata = check_output("docker network inspect bridge", shell=True)
containers = json.loads(jdata)[0][u'Containers']

containerString = ""

for container in containers:
  containerName = json.loads(check_output("docker inspect " + container, shell=True))[0]['Name']
  containerName = containerName.replace('/', '').replace('-', '_').upper()

  containerIp = containers[container][u'IPv4Address'].split('/')[0]

  containerString += containerName + '_IP=' + containerIp + '\n'

print containerString
