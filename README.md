# Creazione di una Macchina Docker per un Sito .Onion con Dockerfile, Chiavi di Sicurezza e File Hostname per Tor

Questa guida spiega come creare una macchina Docker per ospitare un sito web .onion, utilizzando un Dockerfile per inserire le chiavi di sicurezza e il file hostname necessari per Tor. È importante generare questi file tramite Tor prima di procedere con la configurazione del Dockerfile. Questo per evitare che ad ogni avvio della docker machine si ricreino le chiavi.

Genera la Chiave Privata e l'Hostname: Usa Tor per creare una nuova coppia di chiavi e un hostname per il tuo servizio nascosto. Questo si fa configurando Tor per creare un nuovo servizio nascosto e lasciando che generi automaticamente questi file. Salva i File Generati solitamente si trovano in /var/lib/tor/hidden_service/.

Crea il Dockerfile: [dockerfile](./dockerfile) 

```bash
FROM debian

# Aggiorna i pacchetti e installa Tor e lighttpd
RUN apt update && apt install -y tor lighttpd curl apt-transport-https nano

# Copia i file di configurazione (assicurati di avere questi file nella tua directory locale)
COPY ./tor/torsocks.conf /etc/tor/torsocks.conf
COPY ./tor/torrc /etc/tor/torrc

# Espone la porta 80 per il web server
EXPOSE 80

# Crea la directory del servizio nascosto e imposta i permessi
RUN mkdir -p /var/lib/tor/hidden_service/ && \
    chmod 700 /var/lib/tor/hidden_service/

# Copia la chiave privata e il file hostname nel container
COPY ./hidden_service/XXXX_secret_key /var/lib/tor/hidden_service/XXXX_secret_key
COPY ./hidden_service/XXXX_public_key /var/lib/tor/hidden_service/XXXX_public_key
COPY ./hidden_service/hostname /var/lib/tor/hidden_service/hostname

# Imposta i permessi corretti per i file
RUN chmod 600 /var/lib/tor/hidden_service/XXXX_secret_key && \ 
    chmod 600 /var/lib/tor/hidden_service/XXXX_public_key && \
    chmod 600 /var/lib/tor/hidden_service/hostname

# Imposta i permessi corretti per i file
RUN chown -R debian-tor:debian-tor /var/lib/tor/hidden_service/

# Comando per avviare i servizi
CMD service tor start && lighttpd -D -f /etc/lighttpd/lighttpd.conf
```

Crea il docker-compose.yml: [docker-compose.yml](./docker-compose.yml) 

```bash
version: '3'

services:
  webserver-tor:
    build: .
    container_name: debian_lighttpd_tor
    ports:
      - "8888:80"
    volumes:
      - ./html:/var/www/html
      - ./tor:/etc/tor
```

# in alternativa

```bash
docker pull nicdercole/webserver-tor-lighttpd
```
```bash
docker run -d --name debian_lighttpd_tor -p 8888:80 -v $(pwd)/html:/var/www/html -v $(pwd)/tor:/etc/tor my-tor-webserver
```
