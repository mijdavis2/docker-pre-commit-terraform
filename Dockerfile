FROM alpine:3.13

ARG VERSION?=dev
LABEL name="pre-commit-terraform" version=$VERSION

# hadolint ignore=DL3018
RUN apk add --update --no-cache \
    curl \
    zip \
    bash \
    git \
    python3 && \
    ln -s /usr/bin/python3 /usr/bin/python

ENV WORKDIR=/home/appuser
ENV INSTALL_DIR=${WORKDIR}/.local/bin
ENV PATH=${PATH}:${INSTALL_DIR}
ARG TFENV_VERSION=2.0.0
ARG TGENV_VERSION=0.1.0
ARG TERRAFORM_VERSION=0.13.5
ARG TERRAGRUNT_VERSION=0.25.5
ARG TFLINT_VERSION=0.24.1
ARG TERRAFORM_DOCS_VERSION=0.10.1
ARG TFSEC_VERSION=0.37.3

RUN addgroup -S appgroup && adduser -SDH appuser -G appgroup
RUN mkdir -p ${INSTALL_DIR}
WORKDIR ${WORKDIR}

RUN git clone -b v${TFENV_VERSION} https://github.com/tfutils/tfenv.git ${WORKDIR}/.tfenv && \
    ln -s ${WORKDIR}/.tfenv/bin/* ${INSTALL_DIR} && \
    tfenv install ${TERRAFORM_VERSION} && \
    tfenv use ${TERRAFORM_VERSION}
RUN git clone -b ${TGENV_VERSION} https://github.com/taosmountain/tgenv.git ${WORKDIR}/.tgenv && \
    ln -s ${WORKDIR}/.tgenv/bin/* ${INSTALL_DIR} && \
    tgenv install ${TERRAGRUNT_VERSION} && \
    tgenv use ${TERRAGRUNT_VERSION}
RUN curl -s -Lo tflint_linux_amd64.zip https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip && \
    unzip tflint_linux_amd64.zip && \
    rm -rf tflint_linux_amd64.zip && \
    chmod +x tflint && \
    mv tflint /usr/local/bin
RUN curl -s -Lo terraform-docs https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64 && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/local/bin
RUN curl -s -Lo tfsec https://github.com/tfsec/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64 && \
    chmod +x tfsec && \
    mv tfsec /usr/local/bin

RUN chown -R appuser:appgroup ${WORKDIR}
USER appuser
COPY ./ ./
ENV PATH ${PATH}:${INSTALL_DIR}
