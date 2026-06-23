docker:
	sudo apt update
	sudo apt install -y ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	printf 'Types: deb\nURIs: https://download.docker.com/linux/ubuntu\nSuites: %s\nComponents: stable\nArchitectures: %s\nSigned-By: /etc/apt/keyrings/docker.asc\n' "$$(. /etc/os-release && echo $${UBUNTU_CODENAME:-$$VERSION_CODENAME})" "$$(dpkg --print-architecture)" | sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null
	sudo apt update
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

docker-user:
	sudo usermod -aG docker $(shell whoami)
	sudo systemctl restart docker
	exit
	@echo "need to logout"

central:
	git clone https://github.com/getodk/central
	mv central ../
	cd ../central && git submodule update -i
	touch ../central/files/allow-postgres14-upgrade
	@echo "need to update .env"

centralSetup:
	cd ../central && docker compose build
	cd ../central && docker compose up --no-start
	cd ../central && docker compose up -d

add-user:
	@echo "The followings need to be done under central directory"
	@echo "docker compose exec service odk-cmd --email your.email@address user-create"
	@echo "docker compose exec service odk-cmd --email your.email@address user-promote"
	@echo "docker compose exec service odk-cmd --email your.email@address user-set-password"
