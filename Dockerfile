FROM debian:bullseye

WORKDIR /fabseal

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		pip git parallel \
        python3-opencv python3-venv \
		imagemagick wget ffmpeg libsm6 libxext6  -y&& \
    rm -rf /var/lib/apt/lists/*

RUN wget https://ftp.halifax.rwth-aachen.de/blender/release/Blender2.93/blender-2.93.3-linux-x64.tar.xz && tar -xf blender-2.93.3-linux-x64.tar.xz && chmod 777 blender-2.93.3-linux-x64/blender && ln -s /fabseal/blender-2.93.3-linux-x64/blender  /usr/local/bin/blender

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

