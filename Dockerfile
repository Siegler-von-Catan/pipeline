FROM debian:bullseye

WORKDIR /fabseal

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		pip git parallel \
        python3-opencv python3-venv \
		imagemagick \
		blender && \
    rm -rf /var/lib/apt/lists/*

ENV VENV=/opt/venv
RUN python3 -m venv $VENV

ENV PATH="$VENV/bin:$PATH"

RUN pip install --upgrade pip && \
    pip install wheel && \
	pip cache purge

COPY sealExtraction /fabseal/sealExtraction
COPY ShapeFromShading /fabseal/ShapeFromShading
COPY displacementMapToStl /fabseal/displacementMapToStl

RUN cd sealExtraction && \
	pip install -r requirements.txt && \
    pip install . && \
	pip cache purge
RUN cd ShapeFromShading && \
	pip install -r requirements.txt && \
    pip install . && \
	pip cache purge

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		parallel && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /fabseal

ENTRYPOINT [ "/fabseal/run.sh" ]

