FROM alpine:3.13

ARG VERSION?=dev
LABEL name="pre-commit-terraform" version=$VERSION

# hadolint ignore=DL3018
RUN apk add --update --no-cache \
    curl \
    zip \
    bash \
    python3 && \
    ln -s /usr/bin/python3 /usr/bin/python

RUN curl -s -Lo tflint_linux_amd64.zip https://github.com/terraform-linters/tflint/releases/download/v0.24.1/tflint_linux_amd64.zip && \
    unzip tflint_linux_amd64.zip && \
    chmod +x tflint && \
    mv tflint /usr/local/bin

RUN mkdir -p /opt/pre-commit
WORKDIR /opt/pre-commit
COPY ./ ./
ENV PATH ${PATH}:/opt/pre-commit
