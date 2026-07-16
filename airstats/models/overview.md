{% docs __overview__ %}
# Airstats pipeline


Hey, welcome to our Airstats pipeline documentation!
![Airstats](https://www.swri.org/sites/default/files/styles/client_services_banner/public/client-services-images/AdobeStock_64756777.jpeg.webp?itok=3X9nJF3T)

# Airstats pipeline
Silver layer consists of 3 tables:
 - silver_airports
 - silver_runways
 - silver_airport_comments

`silver_airports` table contains meaningful airport data, including primary key `airport_ident`.


Every airport has one or more runways, this data is stored in `silver_runways` table. Relationship with `silver_airports` table is defined using foreign key `airport_ident`.


Users can leave comments about every airport, this data is stored in `silver_airport_comments` table. Relationship with `silver_airports` table is defined using foreign key `airport_ident`.



# Tools
Pipeline built with DBT:
![input schema](assets/dbt_logo_BLK.svg)


{% enddocs %}