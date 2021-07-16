FROM gcc
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /code
ADD . /code
RUN make
