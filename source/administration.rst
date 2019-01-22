.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
.. 
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
.. 
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
.. _administration:

***************************************************
Вопросы, связанные с администрированием системы
***************************************************

.. index:: параметры ядра, kernel options
.. _kernelpm-once:

Как однократно передать параметр ядра?
=========================================

Для передачи параметра необходимо в меню загрузчика Grub 2 выбрать нужную строку и нажать клавишу **E** на клавиатуре для перехода к её редактированию, затем в конце через пробел дописать нужный параметр (или параметры), после чего нажать **Enter**, чтобы начать процесс загрузки.

.. index:: параметры ядра, kernel options
.. _kernelpm-perm:

Как мне задать параметр ядра для постоянного использования?
=================================================================

Необходимо открыть с шаблонами загрузчика **/etc/default/grub** в любом текстовом редакторе, найти в нём переменную **GRUB_CMDLINE_LINUX** и внести соответствующие правки. После этого нужно пересобрать конфиг Grub 2 посредством **grub2-mkconfig**.

.. index:: журнал системы, journald
.. _journal-current:

Как мне посмотреть текущий журнал работы системы?
====================================================

Чтобы посмотреть журнал работы системы с момента загрузки, нужно выполнить:

.. code-block:: bash

    journalctl -b

Чтобы посмотреть только журнал работы ядра (аналог dmesg):

.. code-block:: bash

    journalctl -k

.. index:: журнал системы, journald
.. _journal-history:

Как мне посмотреть журналы с прошлых загрузок?
====================================================

Вывести список всех загрузок:

.. code-block:: bash

    journalctl --list-boots

Вывести содержимое журнала загрузки с идентификатором **X**:

.. code-block:: bash

    journalctl -b -X

.. index:: журнал системы, journald
.. _journal-tofile:

Как мне выгрузить журнал в файл?
======================================

Необходимо перенаправить поток стандартного вывода в файл:

.. code-block:: bash

    journalctl -b > ~/abc.txt

Также можно воспользоваться утилитой fpaste для автоматической загрузки файла на сервис `fpaste.org <https://paste.fedoraproject.org/>`__:

.. code-block:: bash

    journalctl -b | fpaste

При успешном выполнении будет создана ссылка для быстрого доступа.

.. index:: chroot
.. _chroot:

Как сделать chroot в установленную систему с LiveUSB?
===========================================================

Загружаемся с LiveCD/USB и запускаем эмулятор терминала или переходим в виртуальную консоль (особой разницы не имеет).

Для начала создадим каталог для точки монтирования:

.. code-block:: bash

    sudo mkdir /media/fedora

Смонтируем корневой раздел установленной ОС:

.. code-block:: bash

    sudo mount -t ext4 /dev/sda1 /media/fedora

Здесь **/dev/sda1** - раздел, на котором установлена ОС, а **ext4** - его файловая система. Внесём соответствующие правки если это не так.

Переходим в каталог с корневой ФС и монтируем ряд необходимых для работы окружения виртуальных ФС:

.. code-block:: bash

    cd /media/fedora
    sudo mount -t proc /proc proc
    sudo mount --rbind /sys sys
    sudo mount --make-rslave sys
    sudo mount --rbind /dev dev
    sudo mount --make-rslave dev
    sudo mount -t tmpfs tmpfs tmp

Теперь выполняем вход в chroot:

.. code-block:: bash

    sudo chroot /media/fedora

Выполняем нужные действия, а по окончании завершаем работу chroot окружения:

.. code-block:: bash

    logout

Отмонтируем раздел:

.. code-block:: bash

    sudo umount /media/fedora

.. index:: drivers, драйверы, nut, UPS, ИБП
.. _configure-ups:

Как настроить ИБП (UPS) в Fedora?
====================================

См. `здесь <https://www.easycoding.org/2012/10/01/podnimaem-nut-v-linux.html>`__.

.. index:: ssh, keys, error, ошибка
.. _ssh-keys-error:

При использовании SSH появляется ошибка доступа к ключам. Как исправить?
===========================================================================

См. `здесь <https://www.easycoding.org/2016/07/31/reshaem-problemu-s-ssh-klyuchami-v-fedora-24.html>`__.

.. index:: journald, журналы, ограничение размера журналов
.. _journald-limit:

Системные журналы занимают слишком много места. Как их ограничить?
=====================================================================

См. `здесь <https://www.easycoding.org/2016/08/24/ogranichivaem-sistemnye-zhurnaly-v-fedora-24.html>`__.

.. index:: firewalld, port forwarding, проброс порта
.. _firewalld-port-forwarding:

Как пробросить локальный порт на удалённый хост?
====================================================

См. `здесь <https://www.easycoding.org/2017/05/23/probrasyvaem-lokalnyj-port-na-udalyonnyj-xost.html>`__.

.. index:: openvpn
.. _using-openvpn:

Как поднять OpenVPN сервер в Fedora?
=======================================

См. `здесь <https://www.easycoding.org/2017/07/24/podnimaem-ovn-server-na-fedora.html>`__. В данной статье вместо **ovn** следует использовать **openvpn** во всех путях и именах юнитов.

.. index:: systemd
.. _systemd-info:

Что такое systemd и как с ним работать?
==========================================

См. `здесь <https://www.easycoding.org/2017/11/05/upravlyaem-systemd-v-fedora.html>`__.

.. index:: server, matrix, сервер
.. _matrix-server:

Как поднять свой сервер Matrix в Fedora?
===========================================

См. `здесь <https://www.easycoding.org/2018/04/15/podnimaem-sobstvennyj-matrix-server-v-fedora.html>`__.

.. index:: fs, caches, сброс кэшей ФС
.. _drop-fs-caches:

Как очистить кэши и буферы всех файловых систем?
===================================================

Чтобы очистить кэши и буферы нужно выполнить:

.. code-block:: bash

    sync && echo 3 > /proc/sys/vm/drop_caches && sync

.. index:: timezone, utc, hardware clock
.. _system-time-utc:

Как настроить системные часы в UTC или локального времени и наоборот?
========================================================================

Переключение аппаратных часов компьютера в UTC из localtime:

.. code-block:: bash

    sudo timedatectl set-local-rtc no

Переключение аппаратных часов компьютера в localtime из UTC:

.. code-block:: bash

    sudo timedatectl set-local-rtc yes

.. index:: timezone, utc, hardware clock
.. _windows-utc:

У меня в дуалбуте с Fedora установлена Windows и часы постоянно сбиваются. В чём дело?
=========================================================================================

Чтобы такого не происходило, обе операционные системы должны хранить время в формате UTC. Для этого в Windows нужно применить следующий файл реестра:

.. code-block:: text

    Windows Registry Editor Version 5.00
    
    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation]
    "RealTimeIsUniversal"=dword:00000001

.. index:: drivers, disable driver, отключение драйвера
.. _driver-disable:

Как можно навсегда отключить определённый драйвер?
=====================================================

Чтобы навсегда отключить какой-то драйвер в Linux, необходимо создать файл в каталоге **/etc/modprobe.d** с любым именем, например **disable-nv.conf**, и примерно таким содержанием:

.. code-block:: text

    install nouveau /bin/false

Здесь вместо **nouveau** нужно указать реально используемые устройством драйверы.

Полный список загруженных драйверов можно получить так:

.. code-block:: bash

    lspci -nnk

Теперь необходимо пересобрать inird образ:

.. code-block:: bash

    sudo dracut --force

Чтобы отменить действие, достаточно удалить созданный файл и снова пересобрать initrd.

.. index:: server, web server
.. _simple-web-server:

Как запустить простейший веб-сервер в Fedora?
================================================

Для запуска простейшего веб-сервера можно использовать Python и модуль, входящий в состав базового пакета:

.. code-block:: bash

    python3 -m http.server 8080

Веб-сервер будет запущен на порту **8080**. В качестве webroot будет использоваться текущий рабочий каталог.

.. index:: console, change hostname, изменение имени хоста, имя хоста
.. _change-hostname:

Как изменить имя хоста?
==========================

Изменение имени хоста возможно посредством **hostnamectl**:

.. code-block:: bash

    hostnamectl set-hostname NEW

Здесь вместо **NEW** следует указать новое значение. Изменения вступят в силу немедленно.

.. index:: network, настройка сети
.. _network-configuration:

Как лучше настраивать сетевые подключения?
=============================================

В Fedora для настройки сети используется Network Manager. Для работы с ним доступны как графические менеджеры (встроены в каждую DE), так и консольный **nm-cli**.

.. index:: filesystem, check, проверка файловой системы, lvm
.. _fs-check-lvm:

Как мне проверить ФС в составе LVM с LiveUSB?
==================================================

Если файловая система была повреждена, необходимо запустить **fsck** и разрешить ему исправить её. При использовании настроек по умолчанию (LVM, ФС ext4) это делается так:

.. code-block:: bash

    fsck -t ext4 /dev/mapper/fedora-root
    fsck -t ext4 /dev/mapper/fedora-home

Если вместо ext4 применяется другая файловая система, необходимо указать её после параметра **-t**.

.. index:: filesystem, check, проверка файловой системы
.. _fs-check-partitions:

Как мне проверить ФС при использовании классических разделов с LiveUSB?
==========================================================================

Если используется классическая схема с обычными разделами, то утилите **fsck** необходимо передавать соответствующее блочное устройство, например:

.. code-block:: bash

    fsck -t ext4 /dev/sda2
    fsck -t ext4 /dev/sda3

Если вместо **ext4** применяется другая файловая система, необходимо указать её после параметра **-t**. Также вместо **/dev/sda2** следует прописать соответствующее блочное устройство с повреждённой ФС.

Полный список доступных устройств хранения данных можно получить:

.. code-block:: bash

    sudo fdisk -l


.. index:: filesystem, check, проверка файловой системы, luks
.. _fs-check-luks:

Как мне проверить ФС на зашифрованном LUKS разделе с LiveUSB?
================================================================

Если используются зашифрованные LUKS разделы, то сначала откроем соответствующее устройство:

.. code-block:: bash

    cryptsetup luksOpen /dev/sda2 luks-root

Здесь вместо **/dev/sda2** следует прописать соответствующее блочное устройство зашифрованного накопителя.

Теперь запустим проверку файловой системы:

.. code-block:: bash

    fsck -t ext4 /dev/mapper/luks-root

Если вместо **ext4** применяется другая файловая система, необходимо указать её после параметра **-t**.

По окончании обязательно отключим LUKS том:

.. code-block:: bash

    cryptsetup luksClose /dev/mapper/luks-root

.. index:: multimedia, dlna, server, сервер мультимедиа
.. _dlna-server:

Как поднять DLNA сервер в локальной сети?
============================================

См. `здесь <https://www.easycoding.org/2018/09/08/podnimaem-dlna-server-v-fedora.html>`__.

.. index:: memory depuplication, дедупликация памяти
.. _deduplication-memory:

Возможна ли полная дедупликация оперативной памяти?
=======================================================

Да, дедупликация памяти `поддерживается <https://www.ibm.com/developerworks/linux/library/l-kernel-shared-memory/index.html>`__ в ядре Linux начиная с версии 2.6.32 модулем `KSM <https://ru.wikipedia.org/wiki/KSM>`__ и по умолчанию применяется лишь в системах виртуализации, например в :ref:`KVM <kvm>`.

.. index:: disk depuplication, дедупликация данных
.. _deduplication-disk:

Возможна ли полная дедупликация данных на дисках?
=====================================================

Полная автоматическая дедупликация данных на дисках `поддерживается <https://btrfs.wiki.kernel.org/index.php/Deduplication>`__ лишь файловой системой :ref:`BTRFS <fs-btrfs>`.

.. index:: zram, сжатие памяти, memory compression
.. _memory-compression:

Можно ли включить сжатие оперативной памяти?
================================================

Да, в ядро Linux начиная с версии 3.14 по умолчанию входит модуль zram, который позволяет увеличить производительность системы посредством использования вместо дисковой подкачки виртуального устройства в оперативной памяти с активным сжатием.

Включение zram в Fedora:

.. code-block:: bash

    sudo systemctl enable --now zram-swap

Отключение zram в Fedora:

.. code-block:: bash

    sudo systemctl stop zram-swap
    sudo systemctl disable zram-swap

После использования вышеуказанных команд рекомендуется выполнить перезагрузку системы.

.. index:: network speed, скорость сети, iperf
.. _fedora-iperf:

Как сделать замеры скорости локальной или беспроводной сети?
================================================================

Для точных замеров производительности сети нам потребуется как минимум два компьютера (либо компьютер и мобильное устройство), а также утилита iperf, присутствующая в репозиториях Fedora. Установим её:

.. code-block:: bash

    sudo dnf install iperf2

На первом устройстве запустим сервер iperf:

.. code-block:: bash

    iperf -s

По умолчанию iperf прослушивает порт **5001/tcp** на всех доступных сетевых соединениях.

Теперь временно разрешим входящие соединения на данный порт посредством :ref:`Firewalld <firewalld-about>` (правило будет действовать до перезагрузки):

.. code-block:: bash

    sudo firewall-cmd --add-port=5001/tcp

На втором устройстве запустим клиент и подключимся к серверу:

.. code-block:: text

    iperf -c 192.168.1.2

В качестве клиента может выступать и мобильное устройство на базе ОС Android с установленным `Network Tools <https://play.google.com/store/apps/details?id=net.he.networktools>`__. В этом случае в главном меню программы следует выбрать пункт **Iperf2**, а в окне подключения ввести:

.. code-block:: text

    -c 192.168.1.2

Параметр **-c** обязателен. Если он не указан, программа выдаст ошибку.

**192.168.1.2** - это внутренний IP-адрес устройства в ЛВС, на котором запущен сервер. Номер порта указывать не требуется.

.. index:: sysctl, kernel option
.. _sysctl-temporary:

Как временно изменить параметр sysctl?
==========================================

Временно установить любой параметр ядра возможно через sysctl:

.. code-block:: bash

    sudo sysctl -w foo.bar=X

Здесь **foo.bar** имя параметра, а **X** - его значение. Изменения вступят в силу немедленно и сохранятся до перезагрузки системы.

.. index:: sysctl, kernel option
.. _sysctl-permanent:

Как задать и сохранить параметр sysctl?
===========================================

Чтобы сохранить параметр ядра, создадим специальный файл **99-foobar.conf** в каталоге **/etc/sysctl.d**:

.. code-block:: text

    foo.bar1=X1
    foo.bar2=X2

Каждый параметр должен быть указан с новой строки. Здесь **foo.bar** имя параметра, а **X** - его значение.

Для вступления изменений в силу требуется перезагрузка:

.. code-block:: bash

    sudo systemctl reboot

.. index:: sysctl, kernel option
.. _sysctl-order:

В каком порядке загружаются sysctl файлы настроек?
======================================================

При загрузке ядро проверяет следующие каталоги в поисках **.conf** файлов:

 1. **/usr/lib/sysctl.d** - предустановленные конфиги системы и определённых пакетов;
 2. **/run/sysctl.d** - различные конфиги, сгенерированные в рантайме;
 3. **/etc/sysctl.d** - пользовательские конфиги.

Порядок выполнения - в алфавитном порядке, поэтому для его изменения многие конфиги содержат цифры и буквы. Например конфиг **00-foobar.conf** выполнится раньше, чем **zz-foobar.conf**.

.. index:: text mode, runlevel
.. _configure-runlevel:

Как переключить запуск системы в текстовый режим и обратно?
===============================================================

Чтобы активировать запуск Fedora в текстовом режиме, нужно переключиться на цель **multi-user.target**:

.. code-block:: bash

    sudo systemctl set-default multi-user.target

Чтобы активировать запуск в графическом режиме, необходимо убедиться в том, что установлен какой-либо менеджер графического входа в систему (GDM, SDDM, LightDM и т.д.), а затем переключиться на цель **graphical.target**:

.. code-block:: bash

    sudo systemctl set-default graphical.target

Определить используемый в настоящее время режим можно так:

.. code-block:: bash

    systemctl get-default

Изменения вступят в силу лишь после перезапуска системы:

.. code-block:: bash

    sudo systemctl reboot

.. index:: swap, pagefile
.. _swap-to-file:

Как настроить подкачку в файл в Fedora?
===========================================

Создадим файл подкачки на 4 ГБ:

.. code-block:: bash

    sudo dd if=/dev/zero of=/media/pagefile count=4096 bs=1M

Установим правильный chmod:

.. code-block:: bash

    sudo chmod 600 /media/pagefile

Подготовим swapfs к работе:

.. code-block:: bash

    sudo mkswap /media/pagefile

Активируем файл подкачки:

.. code-block:: bash

    sudo swapon /media/pagefile

Для того, чтобы подкачка подключалась автоматически при загрузке системы, откроем файл **/etc/fstab** и добавим в него следующую строку:

.. code-block:: text

    /media/pagefile    none    swap    sw    0    0

Действия вступят в силу немедленно.

.. index:: ssh, rsync, sync
.. _rsync-remote:

Как передать содержимое каталога на удалённый сервер?
==========================================================

Передача содержимого локального каталога на удалённый сервер посредством rsync:

.. code-block:: bash

    rsync -chavzP --stats /path/to/local user@example.org:/path/to/remote

Здесь **user@example.org** - данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост.

.. index:: ssh, rsync, sync
.. _rsync-local:

Как получить содержимое каталога с удалённого сервера?
===========================================================

Получение содержимого каталога с удалённого сервера посредством rsync:

.. code-block:: bash

    rsync -chavzP --stats user@example.org:/path/to/remote /path/to/local

Здесь **user@example.org** - данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост.

.. index:: disk usage, disk monitor
.. _disk-usage:

Как узнать какой процесс осуществляет запись на диск?
==========================================================

Для мониторинга дисковой активности существуют улититы **iotop** и **fatrace**. Установим их:

.. code-block:: bash

    sudo dnf install iotop fatrace

Запустим iotop в режиме накопления показаний:

.. code-block:: bash

    sudo iotop -a

Запустим fatrace в режиме накопления с выводом лишь информации о событиях записи на диск:

.. code-block:: bash

    sudo fatrace -f W

Запустим fatrace в режиме накопления с выводом информации о событиях записи на диск в файл в течение 10 минут (600 секунд):

.. code-block:: bash

    sudo fatrace -f W -o ~/disk-usage.log -s 600

.. index:: hardware, firmware, update, прошивка, обновление
.. _fedora-fwupd:

Как обновить прошивку UEFI BIOS и других устройств непосредственно из Fedora?
==================================================================================

Для оперативного обновления микропрограмм (прошивок) существует утилита `fwupd <https://github.com/hughsie/fwupd>`__:

.. code-block:: bash

    sudo dnf install fwupd

Внимание! Для работы fwupd система должна быть установлена строго в :ref:`UEFI режиме <uefi-boot>`.

Обновление базы данных программы:

.. code-block:: bash

    fwupdmgr refresh

Вывод списка устройств, микропрограмма которых может быть обновлена:

.. code-block:: bash

    fwupdmgr get-devices

Проверка наличия обновлений с выводом подробной информации о каждом из них:

.. code-block:: bash

    fwupdmgr get-updates

Установка обнаруженных обновлений микропрограмм:

.. code-block:: bash

    fwupdmgr update

Некоторые устройства могут быть обновлены лишь при следующей загрузке системы, поэтому выполним перезагрузку:

.. code-block:: bash

    sudo systemctl reboot

.. index:: drive, label
.. _change-label:

Как сменить метку раздела?
==============================

Смена метки раздела с файловой системой ext2, ext3 и ext4:

.. code-block:: bash

    sudo e2label /dev/sda1 "NewLabel"

Смена метки раздела с файловой системой XFS:

.. code-block:: bash

    sudo xfs_admin -L "NewLabel" /dev/sda1

Здесь **/dev/sda1** - раздел, на котором требуется изменить метку.

.. index:: drive, uuid
.. _get-uuid:

Как получить UUID всех смонтированных разделов?
===================================================

Для получения всех UUID можно использовать утилиту **blkid**:

.. code-block:: bash

    sudo blkid

Вывод UUID для указанного раздела:

.. code-block:: bash

    sudo blkid /dev/sda1

Здесь **/dev/sda1** - раздел, для которого требуется вывести UUID.

.. index:: drive, uuid
.. _change-uuid:

Как изменить UUID раздела?
==============================

Смена UUID раздела с файловой системой ext2, ext3 и ext4:

.. code-block:: bash

    sudo tune2fs /dev/sda1 -U $(uuidgen)

Смена UUID раздела с файловой системой XFS:

.. code-block:: bash

    sudo xfs_admin -U generate /dev/sda1

Здесь **/dev/sda1** - раздел, на котором требуется изменить UUID.

.. index:: dns, change dns
.. _change-dns:

Как правильно указать DNS серверы в Fedora?
================================================

Для того, чтобы указать другие DNS серверы, необходимо использовать Network Manager (графический или консольный): **свойства соединения** -> страница **IPv4** -> **другие DNS серверы**.

.. index:: dns, resolv.conf
.. _dns-resolv:

Можно ли править файл /etc/resolv.conf в Fedora?
====================================================

Нет, т.к. этот файл целиком управляется Network Manager и перезаписывается при каждом изменении статуса подключения (активация-деактивация соединений, перезапуск сервиса и т.д.).

Если необходимо указать другие DNS серверы, это следует производить через :ref:`свойства <change-dns>` соответствующего соединения.

.. index:: firewall, icmp, firewalld
.. _disable-icmp:

Как можно средствами Firewalld запретить ICMP?
===================================================

По умолчанию ICMP трафик разрешён для большей части зон, поэтому запретить его можно вручную:

.. code-block:: bash

    sudo firewall-cmd --zone=public --remove-icmp-block={echo-request,echo-reply,timestamp-reply,timestamp-request} --permanent

Применим новые правила:

.. code-block:: bash

    sudo firewall-cmd --reload

В данном примере для зоны **public** блокируются как входящие, так и исходящие ICMP ECHO и ICMP TIMESTAMP.

.. index:: firewall, firewalld, openvpn
.. _openvpn-allowed-ips:

Как средствами Firewalld разрешить подключение к OpenVPN серверу только с разрешённых IP адресов?
=====================================================================================================

Сначала отключим правило по умолчанию для :ref:`OpenVPN <using-openvpn>`, разрешающее доступ к серверу с любых IP адресов:

.. code-block:: bash

    sudo firewall-cmd --zone=public --remove-service openvpn --permanent

Теперь создадим rich rule, разрешающее доступ с указанных IP-адресов (или подсетей):

.. code-block:: bash

    sudo firewall-cmd --zone=public --add-rich-rule='rule family=ipv4 source address="1.2.3.4" service name="openvpn" accept' --permanent
    sudo firewall-cmd --zone=public --add-rich-rule='rule family=ipv4 source address="5.6.7.0/24" service name="openvpn" accept' --permanent

Применим новые правила:

.. code-block:: bash

    sudo firewall-cmd --reload

Здесь **public** - имя зоны для публичного интерфейса, **1.2.3.4** - IP-адрес, а **5.6.7.0/24** - подсеть, доступ для адресов из которой следует разрешить.

.. index:: ip address, external ip, curl
.. _get-external-ip:

Как узнать внешний IP адрес за NAT провайдера?
===================================================

Для этой цели можно использовать внешний сервис, возвращающий только внешний IP и утилиту **curl**:

.. code-block:: bash

    curl https://ifconfig.me
