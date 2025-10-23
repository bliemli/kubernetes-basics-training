FROM docker.io/floryn90/hugo:0.134.2-ext-ubuntu AS builder

ARG TRAINING_HUGO_ENV=default

COPY . /src

RUN hugo --environment ${TRAINING_HUGO_ENV} --minify

FROM ghcr.io/nginx/nginx-unprivileged:1.29.2-alpine

LABEL org.opencontainers.image.title="BFH OpenShift labs"
LABEL org.opencontainers.image.description="Labs based on acend's Kubernetes Basics training"
LABEL org.opencontainers.image.authors="Benjamin Affolter, acend.ch"
LABEL org.opencontainers.image.source="https://github.com/bliemli/kubernetes-basics-training/"
LABEL org.opencontainers.image.licenses="CC-BY-SA-4.0"

EXPOSE 8080

COPY --from=builder /src/public /usr/share/nginx/html
COPY --from=builder /src/nginx.conf.template /etc/nginx/templates/default.conf.template
