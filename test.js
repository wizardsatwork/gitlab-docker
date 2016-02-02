'use strict';

const spawn = require('child_process').spawn;
const execSync = require('child_process').execSync;

const bridge = JSON.parse(execSync('docker network inspect bridge'))[0];

const containers = Object.keys(bridge.Containers).map(id => ({
  id,
  ip: bridge.Containers[id].IPv4Address.split('/')[0],
}));

let containerString = '';

containers.forEach(container => {
  const containerData = JSON.parse(execSync('docker inspect ' + container.id));
  const name = containerData[0].Name.replace('/', '').toUpperCase().replace('-', '_');
  containerString += 'export ' + name + '_IP=' + container.ip + '\n';
});

process.stdout.write(containerString);
