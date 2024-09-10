docker run \
  --name jenkins-docker \
  --rm \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind \
  --storage-driver overlay2

This command runs a new container named "jenkins-docker" using the Docker-in-Docker (DinD) image. This container will run a Docker daemon inside a container, allowing Jenkins to communicate with it. The flags used are:

- --rm : Automatically remove the container when it exits
- --detach : Run the container in detached mode (background)
- --privileged : Give the container elevated privileges
- --network jenkins : Connect the container to the "jenkins" network
- --network-alias docker : Alias the container as "docker" in the network
- --env DOCKER_TLS_CERTDIR=/certs : Set the environment variable for the Docker TLS certificate directory
- --volume jenkins-docker-certs:/certs/client : Mount the "jenkins-docker-certs" volume to the container's "/certs/client" directory
- --volume jenkins-data:/var/jenkins_home : Mount the "jenkins-data" volume to the container's "/var/jenkins_home" directory
- --publish 2376:2376 : Publish the Docker daemon port (2376) from the container to the host

Step 3: Build the Jenkins image

FROM jenkins/jenkins:2.452.1-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

This is a Dockerfile that builds a custom Jenkins image based on the official Jenkins image (jenkins/jenkins:2.452.1-jdk17). The steps in this Dockerfile are:

- Install the lsb-release package
- Add the Docker repository to the sources list
- Install the Docker CE CLI
- Switch to the "jenkins" user
- Install the Blue Ocean and Docker Workflow plugins

Step 4: Build the Jenkins image

docker build -t myjenkins-blueocean:2.452.1-1 .

This command builds the Docker image using the Dockerfile in the current directory and tags it as "myjenkins-blueocean:2.452.1-1".

Step 5: Run the Jenkins container

docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.452.1-1
