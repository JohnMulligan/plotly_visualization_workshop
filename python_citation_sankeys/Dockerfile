FROM python:3.6 as base

# on build, copy application files
COPY requirements.txt requirements.txt

# for installing additional dependencies etc.
RUN pip3 install -r requirements.txt

from base as build

COPY . .

EXPOSE 5000

CMD [ "python", "app.py"]