# Demonstrasjon av Terraform

Dette repoet er laget for å demonstrere hvordan man kan benytte Terraform å spinne opp litt forskjellig infrastruktur.

## Innhold
- Et VPC
- Valgfritt antall VM'er som kjører [nginxdemos/hello](https://hub.docker.com/r/nginxdemos/hello/) eksponert på port 8080
- En brannmur med enkle regler [definert i et eget CSV-format](./files/fw_rules.csv).
- En lastbalanserer
  - Dynamisk provisjonering av et TLS-sertifikat (Let's Encrypt) via Terraform
  - Konfigurering av nevnte sertifikat mot skyleverandør og bruk av dette på lastbalanserer (TLS-terminering)
  - Enkel konfigurasjon av lastbalanserer for å ta imot trafikk på port 443 og forwarde til friske apper (VM'er) som helsesjekkes
  - Round robin, ingen stickiness
- Logisk gruppering i kontrollpanelet til skyleverandøren 

## Tekniske krav
For å kunne kjøre dette på egen maskin kreves følgende:
1. [Installert Terraform](https://developer.hashicorp.com/terraform/downloads)
2. En konto på DigitalOcean med et valgfritt domene satt opp (NS), med generert API-nøkkel. Har du ikke konto kan du benytte [denne lenken](https://m.do.co/c/76396d2dc29c) som gir deg $200 (og meg $25)
 i credits
3. Konfigurasjon:
   - Satt følgende miljøvariabler:
        ```shell
        # Samme verdi skal tildeles 2 variabler
        DIGITALOCEAN_TOKEN=dop_v1_xxxxxxxxxxxx
        DO_AUTH_TOKEN=dop_v1_xxxxxxxxxxxx
        ```
   - Opprette en variabelfil (`mittmiljo.tfvars`) eller en variabelfil som lastes automatisk (`mittmiljo.auto.tfvars`) hvor du konfigurer oppsettet ditt. Eksempelvis:
     ```hcl
     dns_domain    = "mitt-domene-i-digitalocean.no"
     region        = "ams3"
     name          = "iac-er-moro"
     vm_count      = 2
     network_space = "10.14.0.0/16"
     ```
4. Kjøre Terraform med med følgende kommandoer:
   - `terraform init` – gjøres første gangen for å laste ned providere
   - `terraform apply` – gir deg en plan og ber deg ta stilling til om du vil ha endringene utført
