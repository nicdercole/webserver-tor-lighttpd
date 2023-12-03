Creazione di una Macchina Docker per un Sito .Onion con Dockerfile, Chiavi di Sicurezza e File Hostname per Tor

Questa guida spiega come creare una macchina Docker per ospitare un sito web .onion, utilizzando un Dockerfile per inserire le chiavi di sicurezza e il file hostname necessari per Tor. È importante generare questi file tramite Tor prima di procedere con la configurazione del Dockerfile.

Passo 1: Generazione delle Chiavi e del File Hostname con Tor

Genera la Chiave Privata e l'Hostname: Usa Tor per creare una nuova coppia di chiavi e un hostname per il tuo servizio nascosto. Questo si fa configurando Tor per creare un nuovo servizio nascosto e lasciando che generi automaticamente questi file. Salva i File Generati solitamente si trovano in /var/lib/tor/hidden_service/.

Crea il Dockerfile: [dockerfile](dockerfile)
