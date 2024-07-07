# Используем официальный образ WordPress
FROM wordpress:latest

# Устанавливаем необходимые зависимости и расширения PHP
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Устанавливаем Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Копируем дополнительные PHP настройки
COPY ./php.ini /usr/local/etc/php/

# Настраиваем Apache
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite && a2ensite 000-default.conf

# Устанавливаем права на папку с исходным кодом (если требуется)
RUN chown -R www-data:www-data /var/www/html

# Открываем порт 80 для HTTP трафика
EXPOSE 80

# Запуск Apache в фореореграунд режиме
CMD ["apache2-foreground"]
