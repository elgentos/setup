/usr/share/keyrings/cloud.google.gpg: | $(CURL)
	sudo apt install apt-transport-https ca-certificates gnupg -y
	$(CURL) https://packages.cloud.google.com/apt/doc/apt-key.gpg \
		| sudo apt-key --keyring $@ add -

/etc/apt/sources.list.d/google-cloud-sdk.list: | /usr/share/keyrings/cloud.google.gpg
	sudo apt install apt-transport-https ca-certificates gnupg -y
	echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
		| sudo tee -a $@
	sudo apt update -y

$(GCLOUD): | /etc/apt/sources.list.d/google-cloud-sdk.list
	sudo apt install google-cloud-sdk -y

$(GCLOUD_CONFIG): | $(GCLOUD)
	@echo $(INTERACTIVE) | grep -q '1' \
		&& $(GCLOUD) init --skip-diagnostics \
		|| echo "n" | $(GCLOUD) init --skip-diagnostics --console-only;

gcloud: | $(GCLOUD) $(GCLOUD_CONFIG)

optional:: | gcloud
