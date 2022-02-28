FROM ubuntu
RUN apt-get update -y
RUN apt-get install python3 -y
RUN apt-get install python3-pip -y
WORKDIR APP
COPY . .
RUN pip3 install -r requirements.txt
CMD python3 app.py