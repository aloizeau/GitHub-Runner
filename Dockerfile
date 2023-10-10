# Use the latest Ubuntu LTS as the base image
FROM ubuntu:20.04

# Set the maintainer label
LABEL maintainer="Your Name <your.email@example.com>"

# Set environment variables for configuration
ENV RUNNER_VERSION="2.283.3"
ENV RUNNER_NAME="private-runner"
ENV GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
ENV GITHUB_REPOSITORY="GitHub-Runner"

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install the GitHub runner
RUN mkdir actions-runner && \
    cd actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Configure the GitHub runner
RUN ./actions-runner/config.sh --url https://github.com/${GITHUB_REPOSITORY} --token ${GITHUB_TOKEN} --name ${RUNNER_NAME} --labels "self-hosted,linux"

# Start the GitHub runner
CMD ./actions-runner/run.sh