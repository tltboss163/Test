# Элиас - Игра в слова

Интерактивное веб-приложение для игры "Элиас" (Alias) — командная игра, где участники объясняют слова друг другу. Реализовано на TypeScript с Express бэкендом и React фронтендом.

## Функции игры

- 10+ категорий слов
- Создание команд с уникальными названиями и аватарами 
- Таймер раунда с настраиваемой продолжительностью
- Подсчет очков для каждой команды
- Сезонные темы оформления
- Звуковые эффекты
- Панель администратора для управления словами и категориями

## Установка на сервер

### Системные требования

- Node.js 18+ или 20+
- NPM 8+
- 2GB RAM (рекомендуется)
- 1GB свободного места на диске

### Шаги по установке

1. **Клонируйте репозиторий**

```bash
git clone <URL_РЕПОЗИТОРИЯ>
cd alias-game
```

2. **Установите зависимости**

```bash
npm install
```

3. **Сборка проекта**

```bash
npm run build
```

4. **Запуск сервера**

Для разработки:
```bash
npm run dev
```

Для продакшена:
```bash
npm start
```

### Настройка как системной службы (Linux)

1. **Создайте файл службы:**

```bash
sudo nano /etc/systemd/system/alias-game.service
```

2. **Добавьте следующее содержимое (замените пути и пользователя на свои):**

```ini
[Unit]
Description=Alias Game Server
After=network.target

[Service]
Type=simple
User=<ВАШ_ПОЛЬЗОВАТЕЛЬ>
WorkingDirectory=/path/to/alias-game
ExecStart=/usr/bin/npm start
Restart=on-failure
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

3. **Включите и запустите службу:**

```bash
sudo systemctl enable alias-game
sudo systemctl start alias-game
```

4. **Проверьте статус:**

```bash
sudo systemctl status alias-game
```

### Настройка с Nginx (рекомендуется для продакшена)

1. **Установите Nginx:**

```bash
sudo apt update
sudo apt install nginx
```

2. **Создайте конфигурацию сайта:**

```bash
sudo nano /etc/nginx/sites-available/alias-game
```

3. **Добавьте следующую конфигурацию:**

```nginx
server {
    listen 80;
    server_name your-domain.com;  # Замените на ваш домен или IP

    location / {
        proxy_pass http://localhost:5000;  # Порт, на котором запущено приложение
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

4. **Включите сайт и перезапустите Nginx:**

```bash
sudo ln -s /etc/nginx/sites-available/alias-game /etc/nginx/sites-enabled/
sudo nginx -t  # Проверка конфигурации
sudo systemctl restart nginx
```

5. **Настройте SSL с помощью Let's Encrypt (рекомендуется):**

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

### Переменные окружения

Создайте файл `.env` в корневой директории проекта со следующими настройками:

```env
PORT=5000  # Порт, на котором запускается сервер
SESSION_SECRET=your_secret_key  # Секретный ключ для сессий (замените на случайную строку)
NODE_ENV=production  # Окружение (development или production)
```

### Обновление приложения

```bash
cd /path/to/alias-game
git pull
npm install
npm run build
sudo systemctl restart alias-game  # Если настроена системная служба
```

## Администрирование

- Административная панель доступна по адресу `/admin`
- Логин по умолчанию: `admin`
- Пароль по умолчанию: `admin`

**ВАЖНО**: После первого входа в админ-панель рекомендуется сменить пароль!

## Структура проекта

- `client/` - Клиентская часть (React, TypeScript)
- `server/` - Серверная часть (Express, Node.js)
- `shared/` - Общие компоненты и типы
- `public/` - Статические файлы

## Разработка и вклад в проект

Перед внесением изменений убедитесь, что ваша среда разработки настроена:

```bash
# Установите зависимости
npm install

# Запустите в режиме разработки
npm run dev
```

## Лицензия

Этот проект лицензирован под [MIT License](LICENSE).