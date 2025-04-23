# Docker

## Dockerfile

1. Para el contenedor partimos de la imágen `rockylinux` con el tag 8.
2. Se añade EPEL (un repositorio con más paquetes) y instalamos `httpd`, `php` 
y alguna cosa más de php mediante `yum`, el cual es el gestor de paquetes de 
CentOS y derivados.

    Los comandos anidados con `&&` se encargan de borrar el cache generado por 
`yum` después de haber insalado exitosamente los paquetes, esto se hace para 
alivianar la imagen resultante.

    *Se debe realizar mediante comandos anidado por el funcionamiento de las 
capas de Docker*

3. `COPY` como indica el nombre copia ficheros/directorios, en este caso se 
copian todos los `.conf` de `./apache-conf.d/` y el `index.php` a 
`/var/www/html/`.
4. Adiconalmente se copia el script `start.sh` con permisos 600 (únicamente 
lectura y ejecucíon por el dueño) el cual contiene los comnados para iniciar 
`php` y `httpd`.
5. La instrucción `CMD` especifica el comando que se ejecutará cuando se inicie 
el contenedor. En este caso, ejecuta el script `start.sh` que contiene los 
comandos para iniciar `php` y `httpd`.


## docker-compose.yml

Se define un servicio llamado 'servidor-web' el cual se construye a partir del 
`Dockerfile` del directorio actual, esto debido a `build: .`.

- Se le asigna un nombre al contenedor resultante con la instrucción: 
`container_name: lab-apache-proxy`.
- La instrucción `ports` asocia los puertos del contenedor al host. En este 
caso:
    - `8000:80`: El puerto 80 del contenedor (proxy) es accesible como puerto 
8000 en el host
    - `8001:8000`: El puerto 8000 del contenedor (web) es accesible como puerto 
8001 en el host

# Apache

## sitio.conf

En este fichero se especifica una configuración básica para que Apache escuche 
peticiones en el puerto 8000 y se define un `VirtualHost` que muestre el 
contenido de `/var/www/html`.

## proxy.conf

Se define otro `VirtualHost` en el puerto 80 que hace de proxy reverso al sitio 
del puerto 8000.

---

# Levantar servidor

```sh
docker compose up --build -d
```

La url para acceder desde el proxy es [127.0.0.1:8000](http://127.0.0.1:8000) y 
el del sitio es [127.0.0.1:8001](http://127.0.0.1:8001) *en teoría al acceder a 
cada url te va a saludar con IPs distintas. La local es la del proxy, ya que el 
sitio está en el mismo servidor*.

En caso de querer entar al contenedor para revisar algo basta con el comnado: 
`docker exec -it lab-apache-proxy bash`. Este viene bastante pelado y no trae 
`nano`, en caso de preferirlo antes que `vi`con tirar `yum install nano -y` ya 
estaría pronto.
