# Docker-based LetsEncrypt generator for Google Cloud DNS

Use this docker image to generate [Let's Encrypt SSL](https://letsencrypt.org/) Certificates via ACME DNS-01 challenge for [DNS zones in Google Cloud](https://cloud.google.com/dns/), based on the wonderful ACME Client ["Lego" (v4.5)](https://github.com/go-acme/lego).

After moving my domains over to Google Cloud, I was looking for a convenient way to automate certificate retrieval. Previously, I was using the DNS-01 challenge in combination with a PowerDNS on my own servers.

## Usage

### Google Cloud Credentials
You will need to create a [Google Cloud Service Account](https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount), so that [Lego](https://github.com/go-acme/lego) may add TXT records for ACME Challenge verification to your zones. 

1. Open the [Service accounts](https://console.developers.google.com/iam-admin/serviceaccounts) page. If prompted, select a project.
2. Click **Create service account**.
3. In the Create service account window, type a name for the service account, and select **Furnish a new private key**. The key's type should be **JSON**.
4. Select **DNS > DNS-Administrator** in the **Role** dropdown.
5. Confirm creation. Your new public/private key pair is generated and downloaded to your machine; it serves as the only copy of this key. You are responsible for storing it securely, as this key grants full access to your DNS zones in the cloud.

### Running the container / requesting certificates

```sh
docker run \
    -e GCE_PROJECT=example-project \
    -e GCE_DOMAIN="example.com" \
    -e EMAIL=certmaster@example.com \
    -e DOMAINS=example.com,test.example.com \
    -v `pwd`/my-project-34efa2.json:/gcloud-service-account.json:ro \
    -v `pwd`/certstore:/certstore \
    alexdo/letsencrypt-gcloud-dns
```

**NOTE:** Multi-domain certificates are not supported. You need to request certificates for, eg., example.com and example.org seperately.

#### Environment variables and volumes

**Environment Variables:**  
* **`GCE_PROJECT`** – This is the name of your Google Cloud project
* **`GCE_DOMAIN`** – This is the name of a domain within the `GCE_PROJECT` project
* **`EMAIL`** – Your email address. This will be sent to letsencrypt and acts as a contact address. It won't be made public.
* **`DOMAINS`** – A list of (sub)domains to be included in the certificate, seperated by comma (`,`).
* **`RENEW_DAYS`** – Threshold for certificate renewal in days. Default: 30 (= renew when cert expires in less than 30 days).

**Volumes:**  
* **`/gcloud-service-account.json`** – You need to mount the JSON key of your Google Cloud service account here
* **`/certstore`** – This should be an empty folder initially. [Lego](https://github.com/go-acme/lego) will store your letsencrypt account information and, more importantly, your domain's certificates here.


## Building this image yourself

```sh
docker build -t some-name:1.2.3 .
```


## License

Copyright 2017-2021 Alexander Dormann

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
