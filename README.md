# Docker

1. Para ambos contenedores se parte de la imagen `rockylinux` con el tag 8.

2. Para el contenedor del sitio se instala `httpd` y `php` mediante `yum`, el 
gestor de paquetes de CentOS y derivados.

    Para el contenedor del proxy únicamente se le instala `httpd`.

    Los comandos anidados con `&&` se encargan de borrar el cache generado por 
`yum` después de haber instalado exitosamente los paquetes. Esto se hace para 
alivianar la imagen resultante.

    *Se debe realizar mediante comandos anidados por el funcionamiento de las 
capas de Docker.*

3. `COPY` como su nombre indica copia ficheros/directorios:

- A los contenedores del sitio se le copia el `index.php` en `/var/www/html` y 
`start.sh` con los permisos 600 (únicamente lectura y ejecución por el dueño). 
Este script contiene los comandos para iniciar `php` y `httpd`.

- Al contenedor del proxy se le copia la configuración de apache: 
`balanceador/apache.conf` que se encarga de configurar el servidor web como 
proxy.

4. La instrucción `CMD` especifica el comando que se ejecutará cuando se inicie 
el contenedor. En el caso de los que hostean el sitio se ejecuta el script 
`start.sh` y en el contenedor que hace como proxy se ejecuta `httpd 
-DFOREGROUND`

## docker-compose.yml

Se definen tres servicios servicio llamados 'sitio-a', 'sitio-b', 'sitio-c' los 
cuales se construye a partir del Dockerfile en `sitio/`
- Se le asigna un nombre al los contenedores resultantes con la instrucción: 
`container_name: lab-balanceador-[a-b]`.

También se define el servicio 'balanceador' con el Dockerfile ubicado en 
`balanceador/` y se nombra al contenedor resultante como: 'lab-balanceador'
- `ports` asocia los puertos del contenedor al host. En este caso:
    - `8000:80`: El puerto 80 del contenedor (balanceador) es accesible como 
puerto 8000 en el host.

# Apache

*Los sitios usan la configuración por defecto de Apache.*

## balanceador.conf

Se define un `VirtualHost` en el puerto 80 que especifica un balanceador 
llamado 'elcluster' el cual contiene una lista de miembros (las urls son los 
nombres de los servicios especificados en el `docker-compose.yml`) y el método 
de ditstribución de carga:

- *`byrequests`:* distribuye las peticiones según el número de solicitudes que 
ha recibido cada miembro del balancer.
- *`bytraffic:* distribuye las peticiones según la cantidad de tráfico (bytes) 
que ha manejado cada miembro.
- *`bybusyness:* distribuye las peticiones dando prioridad a los workers con 
menos peticiones pendientes.

---

# Levantar servidor

```sh
docker compose up --build -d
```

La url para acceder al sitio es: [127.0.0.1:8000](http://127.0.0.1:8000).

En caso de querer entrar a alguno de los contenedores para revisar algo basta 
con el comando: `docker exec -it <nombre-del-contedor> bash`. Las imágenes 
vienen bastante peladas y no traen `nano`. En caso de preferirlo antes que `vi` 
con tirar `yum install nano -y` ya estaría pronto.
