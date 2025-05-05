#!/bin/bash

set -e

echo "🟢 System aktualisieren..."
sudo apt update
sudo apt upgrade -y

echo "🟢 Notwendige Pakete installieren..."
sudo apt install -y curl apt-transport-https ca-certificates software-properties-common gnupg lsb-release

echo "🟢 Docker GPG-Key hinzufügen..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "🟢 Docker-Repository hinzufügen..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🟢 Paketquellen aktualisieren..."
sudo apt update

echo "🟢 Docker installieren..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

echo "🟢 Benutzer zur Docker-Gruppe hinzufügen..."
sudo usermod -aG docker $USER

echo "🟢 Neueste Docker Compose-Version installieren..."
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "🟢 Docker-Dienst aktivieren und starten..."
sudo systemctl enable docker
sudo systemctl start docker

echo "✅ Docker und Docker Compose wurden erfolgreich installiert."
echo "♻️ System wird jetzt in 5 Sekunden neu gestartet, um Gruppenrechte zu übernehmen..."

sleep 5
sudo reboot