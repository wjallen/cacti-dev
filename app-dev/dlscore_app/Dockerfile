FROM python:3.5.6

RUN cd / && \
    git clone https://github.com/sirimullalab/DLSCORE && \
    cd DLSCORE && \
    git checkout 41dc2b082627309c3be43235643545d5acf746f0

COPY requirements.txt /requirements.txt

RUN pip install -r /requirements.txt

