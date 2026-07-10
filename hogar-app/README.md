# Hogar — MVP móvil

App Expo + React Native + TypeScript para que Jessica y Mateo organicen gastos, tareas y notas en un grupo privado de dos personas.

## Arquitectura

- `src/screens`: acceso, grupo, inicio y los módulos principales.
- `src/components`: interfaz reutilizable y layout seguro para móvil.
- `src/navigation`: pestañas inferiores y flujo de cierre mensual.
- `src/services`: cliente Supabase y consultas.
- `src/hooks`: estado demostrativo del MVP.
- `src/utils`: cálculos puros y comprobables de dinero, tareas y notas.
- `supabase`: esquema, funciones, RLS y datos de prueba.

El modo de muestra funciona sin backend y permite explorar todo el flujo con Jessica y Mateo. Al conectar Supabase, autenticación y RLS están preparados; la siguiente iteración debe sustituir el estado demo por las llamadas de `services/api.ts` en cada mutación.

## Instalación y ejecución

1. Instala Node.js 20 o superior.
2. Entra a `hogar-app` y ejecuta `npm install`.
3. Copia `.env.example` como `.env` y completa las dos variables de Supabase.
4. Ejecuta `npx expo start`.
5. Escanea el QR con Expo Go o presiona `a`, `i` o `w` para Android, iOS o web.

Variables necesarias:

```env
EXPO_PUBLIC_SUPABASE_URL=https://TU-PROYECTO.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=TU_CLAVE_ANON_PUBLICA
```

En Supabase, ejecuta primero `supabase/schema.sql`. Para datos remotos, crea las cuentas `jessica@hogar.app` y `mateo@hogar.app`, confirma sus correos y luego ejecuta `supabase/seed.sql`.

## Cómo probar el flujo

1. Abre la app y elige **Explorar con datos de Jessica y Mateo**.
2. Inicio muestra total, balance, pendientes y última nota.
3. Gastos: agrega cada tipo de división, filtra por categoría y comprueba la frase de deuda. Los formularios rechazan cero, porcentajes distintos de 100 y montos que no coinciden.
4. Balance: los datos de muestra dan total `$560.000`; Jessica pagó `$260.000`, Mateo `$300.000`; Jessica asumía `$320.000`, Mateo `$240.000`; por tanto Jessica le debe a Mateo `$60.000`.
5. Tareas: crea una y márcala realizada por cualquiera o por ambos. El resumen distingue asignación de ejecución y nunca mezcla tareas con dinero.
6. Notas: alterna Recibidas/Enviadas/Favoritas, abre una no leída, cambia favorito, archiva y crea una nueva.
7. Perfil > **Ver cierre mensual** muestra los tres bloques separados.

## Probar autenticación y grupos

Con `.env` configurado, crea una cuenta con nombre, correo y contraseña. La base crea el perfil automáticamente. Crea un grupo con el primer usuario; con el segundo usa el código de seis caracteres. La función `join_group` rechaza un tercer miembro.

## Verificar seguridad por grupo

1. Crea un tercer usuario y otro grupo.
2. Desde su sesión intenta consultar IDs del grupo de Jessica y Mateo mediante el cliente Supabase.
3. Las consultas a gastos, divisiones, tareas, notas, liquidaciones y cierres deben devolver cero filas o error RLS.
4. Comprueba que un destinatario puede leer/favoritar sus notas, mientras una persona externa no puede seleccionarlas.
5. Nunca uses la `service_role` dentro de la app; solo la clave pública `anon`.

## Cálculos

Por usuario: `saldo = total pagado − total asumido`. Saldo positivo significa que adelantó dinero; saldo negativo, que debe compensar. En tareas se cuenta `completed_by`, no `assigned_to`; “ambos” se informa por separado. Las notas cuentan envíos, favoritas y categoría más frecuente del mes.
