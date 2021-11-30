# vim:set ft=dockerfile:

# DESCRIPTION:    Dockerfile for the PetitPotam attack, inspired by https://github.com/SecureAuthCorp/impacket/Dockerfile
# TO_BUILD:       docker build --rm -t gbellier/docker-petitpotam .
# TO_RUN:	  docker run gbellier/docker-petitpotam

FROM python:3.10-alpine as compile
WORKDIR /opt
RUN \
	apk add --no-cache git gcc musl-dev python3-dev libffi-dev openssl-dev cargo && \
	python3 -m pip install virtualenv && \
	virtualenv -p python venv
ENV PATH="/opt/venv/bin:$PATH"
RUN \
	git clone --depth 1 https://github.com/SecureAuthCorp/impacket.git && \
	python3 -m pip install impacket/ && \
	git clone --depth 1 https://github.com/topotam/PetitPotam.git && \
	cp PetitPotam/PetitPotam.py /opt/venv/bin/ && \
	chmod +x /opt/venv/bin/PetitPotam.py

FROM python:3.10-alpine
COPY --from=compile /opt/venv /opt/venv
USER nobody
ENV PATH="/opt/venv/bin:$PATH"
ENTRYPOINT ["PetitPotam.py"]
