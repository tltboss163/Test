
#!/bin/bash

echo "Установка зависимостей..."

# Установка Node.js 20.x и npm
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Установка PostgreSQL
apt-get update
apt-get install -y postgresql nginx

# Настройка базы данных PostgreSQL
sudo -u postgres psql -c "CREATE DATABASE alias_game;"
sudo -u postgres psql -c "CREATE USER alias_user WITH PASSWORD 'your_password';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE alias_game TO alias_user;"

# Переход в директорию проекта и установка зависимостей
cd /home/debian/Game
npm install

# Сборка проекта
npm run build

# Создание systemd сервиса
cat > /etc/systemd/system/alias-game.service << EOF
[Unit]
Description=Alias Game Server
After=network.target postgresql.service

[Service]
Type=simple
User=debian
WorkingDirectory=/home/debian/Game
Environment=NODE_ENV=production
Environment=DATABASE_URL=postgresql://alias_user:your_password@localhost:5432/alias_game
ExecStart=/usr/bin/npm start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Настройка Nginx
cat > /etc/nginx/sites-available/alias-game << EOF
server {
    listen 80;
    server_name your_domain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Активация конфигурации Nginx
ln -s /etc/nginx/sites-available/alias-game /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx

# Запуск и активация сервиса
systemctl enable alias-game
systemctl start alias-game

echo "Установка завершена!"
