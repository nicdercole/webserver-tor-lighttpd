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
