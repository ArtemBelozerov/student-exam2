FROM centos:7
MAINTAINER Artem Belozerov 'artem.belozerov.outlook.com'
WORKDIR /opt/app
RUN yum update -y && yum clean all
RUN yum install wget unzip glibc-common git python3 -y
RUN git clone https://github.com/ArtemBelozerov/student-exam2.git
WORKDIR /opt/app/student-exam2/
ENV FLASK_APP js_example
#
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN python3 -m venv venv
RUN . venv/bin/activate
RUN pip3 install -e .
EXPOSE 5000:5000
CMD flask run -h 0.0.0.0 -p 5000
