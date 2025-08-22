#####################################################################
#           Docker Getting Started
#####################################################################
docker image ls
docker image pull hello-world                   # docker pull hello-world
docker image ls
docker container run hello-world		        # docker run
docker container ls                             # docker ps
docker container ls -a				            # docker ps -a
docker image remove hello-world 		        # docker rmi
docker image ls
docker run hello-world
docker image ls
docker ps -a

docker run --rm alpine echo 'hello-world'	    # --rm flag
docker run --rm alpine printenv
docker run -it --rm alpine /bin/sh		        # -it flag & CMD argument
docker system prune                             # remove unused containers, networks
docker system prune -a --volumes                # remove all unused images, containers, networks, and volumes

