# Ollama + Open WebUI

Local LLM inference with web interface.

## Usage
1. `docker compose up -d`
2. Access Open WebUI at `http://<SERVER_IP>:3002`
3. Pull models via UI or `ollama pull llama3.1`

## Notes
- Resource intensive on old laptops
- Models stored in volumes
- Can use GPU if available
