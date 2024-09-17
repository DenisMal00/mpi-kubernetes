# Base image for MPI and other necessary tools
FROM ubuntu:20.04

# Set the environment to non-interactive to avoid timezone prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install build tools, MPI, SSH, and other required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    mpich \
    openssh-client \
    openssh-server \
    wget \
    tar \
    libmpich-dev

# Set up SSH server
RUN mkdir /var/run/sshd


# Generate SSH keys for root user and copy public key to authorized_keys
RUN ssh-keygen -t rsa -b 2048 -f /root/.ssh/id_rsa -q -N "" && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# Set correct permissions for SSH keys
RUN chmod 600 /root/.ssh/authorized_keys && chmod 700 /root/.ssh

# Download and extract OSU Micro-Benchmarks
RUN wget http://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-5.9.tar.gz && \
    tar -xzf osu-micro-benchmarks-5.9.tar.gz

# Compile OSU Micro-Benchmarks
WORKDIR osu-micro-benchmarks-5.9
RUN ./configure CC=mpicc CXX=mpicxx && make && make install


# Set the entrypoint to start SSH and keep the container running
CMD ["/usr/sbin/sshd", "-D"]
