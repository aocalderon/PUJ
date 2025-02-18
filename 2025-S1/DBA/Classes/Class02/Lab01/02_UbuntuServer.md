Aquí tienes una **guía paso a paso** para la instalación de **Ubuntu Server 24.04** desde cero.

---

# **Guía de instalación de Ubuntu Server 24.04**

## **1. Descarga de Ubuntu Server 24.04**
1. **Visita la página oficial de Ubuntu Server**:  
   👉 [https://ubuntu.com/download/server](https://ubuntu.com/download/server)
2. **Descarga la imagen ISO** de Ubuntu Server 24.04 (64-bit).
3. **Verifica la integridad del archivo** comparando el hash SHA256 (opcional).

## **2. Creación del medio de instalación**
### **Opción 1: Crear un USB Booteable (recomendado)**
1. **Conectar una memoria USB** (mínimo 4 GB).
2. **Usar una herramienta para crear el USB de arranque**:
   - **Windows**: [Rufus](https://rufus.ie)
   - **Linux**: `dd` o [balenaEtcher](https://www.balena.io/etcher/)
   - **macOS**: `dd` o balenaEtcher
3. **Grabar la imagen ISO** en la USB:
   - En **Rufus**, selecciona la ISO y la USB, y usa el modo "Esquema de partición: GPT" y "Sistema de destino: UEFI".
   - En **Linux**, ejecuta:
     ```bash
     sudo dd if=ubuntu-24.04-live-server-amd64.iso of=/dev/sdX bs=4M status=progress
     ```
     Reemplaza `/dev/sdX` con tu unidad USB.

### **Opción 2: Grabar en un DVD (menos recomendado)**
1. Usa **Brasero**, **ImgBurn** o cualquier grabador de discos.
2. Quema la ISO en un DVD.

## **3. Configuración del BIOS/UEFI**
1. **Accede a la BIOS/UEFI** (normalmente con `F2`, `F12`, `DEL` o `ESC` al encender).
2. **Habilita el modo UEFI** (si es compatible).
3. **Deshabilita Secure Boot** si tienes problemas al iniciar la instalación.
4. **Cambia el orden de arranque** para que el USB/DVD sea la primera opción.

## **4. Instalación de Ubuntu Server 24.04**
1. **Inicia desde el USB/DVD** y selecciona "Install Ubuntu Server".
2. **Selecciona el idioma** (Español o Inglés recomendado).
3. **Configura la distribución del teclado**.
4. **Configura la red**:
   - Si tienes DHCP, la red se configura automáticamente.
   - Para IP estática, selecciona "Configuración manual" e introduce los valores correctos.
5. **Elige el tipo de instalación**:
   - "Ubuntu Server (sin interfaz gráfica)" es la opción estándar.
   - Puedes elegir una instalación mínima si deseas un sistema más ligero.
6. **Configura el almacenamiento**:
   - Opción recomendada: **Usar disco entero y configurar LVM** (permite ampliar particiones en el futuro).
   - Si deseas RAID o particionado manual, elige la opción correspondiente.
7. **Crea un usuario y contraseña**:
   - Ingresa el nombre de usuario, el nombre del servidor y la contraseña.
8. **Opcional: Instala OpenSSH** (para acceso remoto).
   - Se recomienda habilitarlo marcando la opción "Install OpenSSH server".
9. **Selecciona software adicional**:
   - Puedes instalar Docker, Kubernetes, entre otros paquetes útiles.
10. **Confirma la instalación** y espera a que finalice.

## **5. Primer arranque y configuración post-instalación**
1. **Reinicia el sistema y retira el medio de instalación**.
2. **Inicia sesión con tu usuario y contraseña**.
3. **Actualiza el sistema**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```
4. **Configura la zona horaria** (si no se configuró correctamente):
   ```bash
   sudo timedatectl set-timezone America/Bogota
   ```
5. **Configura el firewall (UFW)** (opcional pero recomendado):
   ```bash
   sudo ufw allow OpenSSH
   sudo ufw enable
   ```
6. **Verifica la dirección IP asignada**:
   ```bash
   ip a
   ```

## **6. Configuración adicional**
- **Crear un usuario adicional con permisos sudo**:
  ```bash
  sudo adduser nuevo_usuario
  sudo usermod -aG sudo nuevo_usuario
  ```
- **Configurar acceso remoto con SSH**:
  - Desde otra máquina, conéctate con:
    ```bash
    ssh usuario@ip_del_servidor
    ```
- **Instalar paquetes esenciales**:
  ```bash
  sudo apt install htop net-tools curl git -y
  ```
- **Configurar un hostname personalizado**:
  ```bash
  sudo hostnamectl set-hostname mi-servidor
  ```

---

## **Conclusión**
Con estos pasos, Ubuntu Server 24.04 estará listo para usarse. A partir de aquí, puedes instalar servicios como Apache, Nginx, PostgreSQL, Docker, Kubernetes, etc., según tus necesidades. 🚀
