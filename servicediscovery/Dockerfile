# set base image (host OS)
FROM python

# set the working directory in the container
WORKDIR /

# install dependencies
RUN pip install exoscale

COPY service.py /

RUN mkdir /srv/service-discovery

# command to run on container start
CMD [ "python", "./service.py" ]