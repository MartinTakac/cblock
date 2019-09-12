FROM gitlab.soulmachines.com:5005/cogarch/sml-base:latest

# /usr/src has the third party and BL libraries
COPY . /usr/src/app

# Instead of building the app within the docker build step we have to do it using docker run
# otherwise it can't use the bl_third_party volume 

WORKDIR /usr/src/app/source

RUN chmod +x build_and_test.sh

RUN rm -rf build_linux

CMD /bin/bash