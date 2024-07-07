FROM wordpress:latest

COPY ./php.ini /usr/local/etc/php/

COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite && a2ensite 000-default.conf

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
