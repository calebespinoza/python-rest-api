FROM python:3-alpine3.8

EXPOSE 8001
COPY requirements.txt /tmp
WORKDIR /tmp
RUN pip3 install -r requirements.txt
COPY . /home/src
WORKDIR /home/src
CMD ["flask", "run", "--port=8001", "--host=0.0.0.0"]
