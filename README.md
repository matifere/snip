# snip
Un simple gestor de snippets utilizando supabase

## instalar
Si bien existe una version web https://snipter.netlify.app/ proximamente se lanzaran versiones para escritorio y movil.

## compilacion
si por alguna razon deseas subir la app a algun dominio podes hacerlo siguiendo estos pasos:
 - en main.dart se deben comentar las lineas relacionadas con el .env y quitar los comentarios de las que toman los datos desde memoria
 - luego se compila con los siguientes flags:
 ```
 flutter build web --release \
  --dart-define=SUPABASE_URL=https://tu-proyecto.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=tu-clave-larga-anonima
 ```
