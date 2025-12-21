!/usr/bin/env bash

# ToggleMaster environment setup for RPM based systems (Amazon Linux)
# by diasdm

echo -e "\n"

# Root user check
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root."
    echo
    exit 1
fi


# Constant variables
GIT_REPO="fiap-toggle-master-monolith"
APP_NAME="togglemaster"
WORK_DIR="/opt/${APP_NAME}"
ENV_DIR="/etc/${APP_NAME}"
ENV_FILE=".${APP_NAME}.env"
SYSTEMD_DIR="/etc/systemd/system"
SYSTEMD_SERV="${APP_NAME}.service"
DB_PORT="5432"


# Requirements check
REQ_LIST=("git" "python3" "pip3")

missing=0
for REQ in "${REQ_LIST[@]}"; do
    if ! command -v "$REQ" >/dev/null 2>&1; then
        echo "Required package command was not found: \"${REQ}\""
        missing=1
    fi
done
(( missing )) && { echo ; exit 1 ; }


# Working directory check
if [[ ! -d "$WORK_DIR" ]]; then
    echo "Error: working directory does not exist: $WORK_DIR"
    echo
    exit 1
fi

# Git repository directory check
if [[ ! -d "${WORK_DIR}/${GIT_REPO}" ]]; then
    echo "Error: the Git directory does not exist: ${WORK_DIR}/${GIT_REPO}"
    echo "Make sure the Git repository was cloned"
    echo
    exit 1
fi


# User database credentials input
[ -z "${DB_HOST}" ] && read -p "INPUT THE DB ENDPOINT: " DB_HOST

if ! timeout 2 bash -c "</dev/tcp/${DB_HOST}/${DB_PORT}" 2>/dev/null; then
    echo "The host endpoint is unreachable"
    echo
    exit 1
fi

[ -z "${DB_NAME}" ] && read -p "INPUT THE DB NAME: " DB_NAME
[ -z "${DB_USER}" ] && read -p "INPUT THE DB USER: " DB_USER
[ -z "${DB_PASSWORD}" ] && read -s -p "INPUT THE DB PASSWORD: " DB_PASSWORD

if [[ -z "${DB_PASSWORD}" ]]; then
    echo -e "\n\nThe password cannot be empty.\n"
    exit 1;
fi

echo -e "\n"

mkdir -v -p "$ENV_DIR"
chmod o-rx "$ENV_DIR"
chmod o+rx "$WORK_DIR"
chmod o+rx "${WORK_DIR}/${GIT_REPO}"


# Add the database credentials to environment variables file
cat <<EOF > "${ENV_DIR}/${ENV_FILE}"
DB_HOST=${DB_HOST}
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
EOF

chown root:root "${ENV_DIR}/${ENV_FILE}"
chmod 600 "${ENV_DIR}/${ENV_FILE}"


# Setup the working directory Python environment
cd "${WORK_DIR}/${GIT_REPO}"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
set -a
source "${ENV_DIR}/${ENV_FILE}"
set +a
flask init-db
deactivate
echo


# Create the systemd service file
cat <<EOF > "${SYSTEMD_DIR}/${SYSTEMD_SERV}"
[Unit]
Description=FIAP ToggleMaster Python Application
After=network.target
Wants=network.target

[Service]
Type=simple

# Run as an ephemeral non-root user
DynamicUser=yes
StateDirectory=${APP_NAME}
CacheDirectory=${APP_NAME}
LogsDirectory=${APP_NAME}
RuntimeDirectory=${APP_NAME}

# Application working directory
WorkingDirectory=${WORK_DIR}/${GIT_REPO}

# Load environment variables
EnvironmentFile=${ENV_DIR}/${ENV_FILE}

# Check if Python requirements are met
ExecCondition=${WORK_DIR}/${GIT_REPO}/venv/bin/pip check

# Wait for the database to be reachable
ExecStartPre=timeout 2 bash -c "</dev/tcp/$DB_HOST/$DB_PORT"

# Start Gunicorn (no --daemon under systemd)
ExecStart=${WORK_DIR}/${GIT_REPO}/venv/bin/gunicorn --bind 0.0.0.0:5000 app:app

Restart=on-failure
RestartSec=5
StartLimitBurst=10

# Logging
StandardOutput=journal
StandardError=journal

# Hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
RestrictSUIDSGID=true

ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGTERM
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
systemctl daemon-reload
systemctl enable "${APP_NAME}.service"
systemctl start "${APP_NAME}.service"
systemctl --no-page -l status "${APP_NAME}.service"