# ssh-proxy-server
This image allows you to easily run a ssh server server in your docker
infrastructure to use as a ssh proxy. Allowing you to access any service
connected to the same docker network(s) as this proxy container without having 
to expose them directly.

## usage
### Docker run
```bash
docker run 2222:22 -e SSH_KEY1="<ssh key>" -e SSH_KEY... mrleerkotte/ssh-proxy-server
```

### Docker-compose
```yaml
version: '3.5'
services:
  ssh-prx:
  ¦ image: mrleerkotte/ssh-proxy-server
  ¦ ports:
  ¦ ¦ - '2222:22'
  ¦ # Specify any amount of ssh keys you would like to add to the proxy.
  ¦ # The image will loop through all SSH_KEY* environment variables and
  ¦ # add them to: /home/prx/.ssh/authorized_keys
  ¦ environment:
  ¦ ¦ - 'SSH_KEY1=<your ssh public key>'
  ¦ ¦ - 'SSH_KEY2=<your ssh public key>'
  ¦ ¦ - 'SSH_KEY...'
  ¦ volumes:
  ¦ ¦ - ssh-data:/etc/ssh

  # Add NGINX as an easy way to test the connectivity.
  nginx:
  ¦ image: nginx

volumes:
  ssh-data:
```