FROM continuumio/anaconda3:4.4.0
EXPOSE 8000
RUN apt-get update && apt-get install -y apache2 \
    apache2-dev \   
    vim \
 && apt-get clean \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/python/
COPY ./flask_predict_api.wsgi /usr/local/python/flask_predict_api.wsgi
COPY ./flask_demo /usr/local/python/
RUN pip install -r requirements.txt \
&& pip install --upgrade pip
RUN /opt/conda/bin/mod_wsgi-express install-module
RUN mod_wsgi-express setup-server flask_predict_api.wsgi --port=8000 \
    --user www-data --group www-data \
    --server-root=/etc/mod_wsgi-express-80
CMD /etc/mod_wsgi-express-80/apachectl start -D FOREGROUND

