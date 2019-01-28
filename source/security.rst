.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
..
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
..
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
.. _security:

************************************
Вопросы, связанные с безопасностью
************************************

.. index:: SELinux
.. _selinux:

Что такое SELinux?
========================

SELinux - это мандатная система контроля доступа, ограничивающая доступ ряду сервисов к файлам и каталогам. Больше информации `здесь <https://ru.wikipedia.org/wiki/SELinux>`__.

.. index:: selinux, disable selinux, disable
.. _selinux-temp:

Как мне временно отключить SELinux?
=======================================

Мы настоятельно не рекомендуем этого делать, но если очень хочется, то для временного отключения достаточно выполнить команду:

.. code-block:: bash

    sudo setenforce 0

Для повторной активации:

.. code-block:: bash

    sudo setenforce 1

Также SELinux можно временно отключить при загрузке системы посредством передачи ядру Linux параметра:

.. code-block:: text

    SELINUX=0

.. index:: selinux, disable selinux
.. _selinux-disable:

Как мне навсегда отключить SELinux?
=======================================

Достаточно открыть файл конфигурации `/etc/selinux/config` в любом текстовом редакторе и изменить значение директивы `SELINUX`. Допустимые значения:

 * `enforcing` — включён и блокирует всё, что явно не разрешено;
 * `permissive` — включён, но ничего не блокирует и лишь пишет события в системный журнал;
 * `disabled` — полностью отключён.

Изменения вступят в силу при следующей загрузке системы.

.. index:: selinux, status selinux, status
.. _selinux-status:

Как узнать текущий статус SELinux?
=======================================

При помощи команды **getenforce** или **sestatus**.

.. index:: httpd, selinux, write, file, directory, security
.. _httpd-selinux:

Как настроить SELinux так, чтоб httpd мог создавать файлы/директории?
=======================================================================

Появляются сообщения вида:

`Warning: chmod(): Permission denied in /var/www/html/library/HTMLPurifier/DefinitionCache/Serializer.php on line 284`

`Warning: Directory /var/www/html/library/HTMLPurifier/DefinitionCache/Serializer/HTML not writable, please chmod to 755 in /var/www/html/library/HTMLPurifier/DefinitionCache/Serializer.php on line 297`

которые гласят, что директория `/var/www/html/library/HTMLPurifier/DefinitionCache/Serializer/HTML` не доступна для записи из httpd и скорее всего запись запрещает SELinux.

(все дальнейшие команды выполняются от пользователя root или используя sudo)

* требуется внести изменения в контекст SELinux для файлов (обратите внимание на шаблон в конце строки):

.. code-block:: bash

    semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/library/HTMLPurifier/DefinitionCache/Serializer/HTML(/.*)?"

* и принять изменения контекста:

.. code-block:: bash

    restorecon -Rv /var/www/html

* проверить список контекстов для httpd возможно так:

.. code-block:: bash

    semanage fcontext -l | grep httpd

* или, так как предудущая команда выводит очень много информации, лучше так:

.. code-block:: bash

    semanage fcontext -l | grep /var/www/html

* удалить ошибочную строку (например, забыл начальный слеш) возможно так:

    semanage fcontext -d "var/www/html/library/HTMLPurifier/DefinitionCache/Serializer/HTML/"

* проверить контекст для директорий и папок возможно так:

.. code-block:: bash

    ls -Z (выполнить в папке)
    ls -Z /var/www/html/request/library/HTMLPurifier/DefinitionCache/Serializer

См. про изменение контекста подробнее `здесь <https://docs.fedoraproject.org/ru-RU/Fedora/13/html/Security-Enhanced_Linux/sect-Security-Enhanced_Linux-SELinux_Contexts_Labeling_Files-Persistent_Changes_semanage_fcontext.html>`__.

* создать модуль (текстовый файл) httpd_wr.te следующего содержания:

.. code-block:: bash

    #################
    #
    # httpd can write some dir and files
    #
    #################
    module httpd_wr 1.0;
    
    require {
    	type httpd_t;
    	type httpd_sys_rw_content_t;
    	class file { create write setattr rename unlink };
    	class dir { create write setattr add_name remove_name rmdir };
    }
    #################
    #============= httpd_t ==============
    allow httpd_t httpd_sys_rw_content_t:file { create write setattr rename unlink };
    allow httpd_t httpd_sys_rw_content_t:dir { create write setattr add_name remove_name rmdir };

* проверить, скомпилировать и синсталлировать модуль:

.. code-block:: bash

    checkmodule -M -m httpd_wr.te -o httpd_wr.mod
    semodule_package -o httpd_wr.pp -m httpd_wr.mod
    semodule -i httpd_wr.pp

См. про создание модуля подробнее `здесь <https://habr.com/ru/company/pt/blog/142423/>`__.

См. список возможных разрешений для классов `здесь <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/4/html/SELinux_Guide/rhlcommon-section-0049.html>`__.

См. список контекстов и прочих настроек `здесь <https://dwalsh.fedorapeople.org/SELinux/httpd_selinux.html>`__.

Просмотр неправильных (не выставленных) правил, создает apfirst.te файл, разрешающий действия, запрет которых попал в лог.

* один раз, для очищения предыдущих ошибок:

.. code-block:: bash

* после каждой инициации действия и добавления новых разрешений в модуль:

    cat /dev/null > /var/log/audit/audit.log
cat /var/log/audit/audit.log | audit2allow -M appfirst

Разрешение httpd соединяться по сети:

.. code-block:: bash

    setsebool -P httpd_can_network_connect on

См. список контекстов и прочих настроек `здесь <https://dwalsh.fedorapeople.org/SELinux/httpd_selinux.html>`__.

.. index:: openvpn, selinux, vpn, security
.. _openvpn-selinux:

OpenVPN не может получить доступ к сертификатам из-за SELinux. Что делать?
==============================================================================

Это нормально ибо запущенные сервисы не могут получать доступ к каталогам пользователя, однако для OpenVPN сделано исключение в виде каталога **~/.cert**.

По умолчанию он не существует, поэтому его нужно создать и задать для него контекст безопасности SELinux:

.. code-block:: bash

    mkdir ~/.cert
    restorecon -Rv ~/.cert

Теперь в нём можно размещать сертификаты и приватные ключи.

.. index:: kpti, hardware, vulnerability, disable, mitigation
.. _kpti:

Можно ли отключить KPTI?
=======================================

KPTI - это новый механизм ядра, направленный на защиту системы от уязвимости `Meltdown <https://ru.wikipedia.org/wiki/Meltdown_(%D1%83%D1%8F%D0%B7%D0%B2%D0%B8%D0%BC%D0%BE%D1%81%D1%82%D1%8C)>`__ в процессорах Intel. Настоятельно не рекомендуется его отключать, хотя это и возможно. Для этого необходимо и достаточно передать ядру Linux:

.. code-block:: text

    nopti

Параметр **pti=off** также поддерживается в полной мере.

.. index:: spectre, hardware, vulnerability, disable, mitigation
.. _spectrev1:

Можно ли отключить защиту от Spectre v1?
============================================

Нет. Защита от уязвимости Spectre v1 выполняется напрямую микрокодом процессора.

.. index:: spectre, hardware, vulnerability, disable, mitigation
.. _spectrev2:

Можно ли отключить защиту от Spectre v2?
============================================

Да, при помощи параметра ядра:

.. code-block:: text

    nospectre_v2

.. index:: spectre, hardware, vulnerability, disable, mitigation
.. _spectrev4:

Можно ли отключить защиту от Spectre v4?
========================================================================

Да, при помощи параметра ядра:

.. code-block:: text

    nospec_store_bypass_disable

.. index:: l1tf, hardware, vulnerability, disable, mitigation
.. _l1tf:

Можно ли отключить защиту от L1TF?
========================================================================

Да, при помощи параметров ядра:

.. code-block:: text

    l1tf=off

.. index:: hardware, vulnerability, disable, mitigation, cpu
.. _hardware-vuln:

Как узнать защищено ли ядро от известных уязвимостей в процессорах?
========================================================================

Ранее для этого применялись сторонние утилиты, но в современных версиях ядра для этого есть штатный механизм, который можно использовать:

.. code-block:: bash

    grep . /sys/devices/system/cpu/vulnerabilities/*

.. index:: selinux, error
.. _selinux-boot-error:

При загрузке получаю ошибку SELinux. Как исправить?
=======================================================

Такое бывает если по какой-то причине сбился контекст безопасности SELinux. Исправить это можно двумя различными способами.

*Способ первый*:

.. code-block:: bash

    sudo touch /.autorelabel
    sudo systemctl reboot

Внимание! Следующая загрузка системы займёт много времени из-за переустановки контекста для всех файлов и каталогов. Ни в коем случае не следует её прерывать. По окончании система автоматически перезагрузится ещё один раз.

*Способ второй*:

.. code-block:: bash

    sudo restorecon -Rv /
    sudo systemctl reboot

После перезагрузки все ошибки, связанные с SELinux, должны исчезнуть.

.. index:: luks, encryption, USB
.. _luks-usb:

Как можно надёжно зашифровать файлы на USB устройстве?
=========================================================

См. `здесь <https://www.easycoding.org/2016/11/14/shifruem-vneshnij-nakopitel-posredstvom-luks.html>`__.

.. index:: luks, encryption, home
.. _luks-home:

Можно ли зашифровать домашний раздел уже установленной системы?
==================================================================

См. `здесь <https://www.easycoding.org/2016/12/09/shifruem-domashnij-razdel-ustanovlennoj-sistemy.html>`__.

.. index:: luks, encryption, change password, password
.. _luks-change-password:

Как сменить пароль зашифрованного LUKS раздела?
===================================================

Сменить пароль достаточно просто. Достаточно выполнить следующую команду:

.. code-block:: bash

    sudo cryptsetup luksChangeKey /dev/sda1 -S 0

Здесь **/dev/sda1** - зашифрованный раздел диска, а **0** - порядковый номер LUKS слота для пароля.

Для успешной смены пароля раздел не должен быть смонтирован, поэтому если это корневой или домашний, то придётся выполнять загрузку с :ref:`LiveUSB <usb-flash>`.

.. index:: luks, encryption, drive information, information
.. _luks-info:

Как получить информацию о зашифрованном LUKS устройстве?
=============================================================

Если требуется получить подробную информацию о зашифрованном LUKS разделе (алгоритм шифрование, тип хеша и количество итераций и т.д.), можно воспользоваться утилитой **cryptsetup**:

.. code-block:: bash

    sudo cryptsetup luksDump /dev/sda1

Здесь **/dev/sda1** - зашифрованный раздел диска.

.. index:: luks, encryption, performance, benchmark
.. _luks-benchmark:

Насколько сильно шифрование LUKS снижает производительность дисковой подсистемы?
=====================================================================================

На современных процессорах с аппаратной поддержкой набора инструкций AES-NI снижение производительности практически незаметно даже на самых производительных NVMe SSD накопителях.

Для того, чтобы оценить скорость работы на реальном оборудовании, в **cryptsetup** присутствует встроенный бенчмарк для тестирования разных алгоритмов шифрования и типа сцепления блоков шифротекста:

.. code-block:: bash

    cryptsetup benchmark

.. index:: luks, encryption, performance, cpu
.. _luks-aes:

Как узнать поддерживает ли процессор моего ПК набор инструкций AES-NI?
===========================================================================

Если в выводе **lscpu** присутствует строка **aes**, значит поддерживает:

.. code-block:: bash

    lscpu | grep aes

.. index:: firewalld, firewall
.. _firewalld-about:

Что такое Firewalld?
=======================

Firewalld - это современный динамически управляемый брандмауэр с поддержкой зон для интерфейсов.

.. index:: firewalld, configuration, firewall
.. _firewalld-configure:

Как можно настраивать Firewalld?
==================================

Для настройки применяется либо графическая утилита **system-config-firewall**, либо консольная **firewall-cmd**.

Документацию можно `найти в Wiki <https://fedoraproject.org/wiki/FirewallD/ru>`__.

.. index:: firewalld, cloak service, firewall
.. _firewalld-hide-service:

Как замаскировать сервис средствами Firewalld?
=================================================

См. `здесь <https://www.easycoding.org/2017/06/22/maskiruem-opredelyonnyj-servis-sredstvami-firewalld.html>`__.

.. index:: firewalld, block addresses, ip, network, firewall
.. _firewalld-block:

Как запретить подключения с конкретных IP-адресов?
======================================================

Достаточно добавить их в специально созданную зону **drop** файрвола:

.. code-block:: bash

    firewall-cmd --permanent --zone=drop --add-source=1.2.3.4

Здесь вместо **1.2.3.4** нужно указать необходимый IP-адрес или подсеть (**1.2.3.0/24**).

.. index:: gpg, gnupg, signatures
.. _gpg-signatures:

Как работать с подписями GnuPG?
==================================

См. `здесь <https://www.easycoding.org/2018/01/11/rabotaem-s-cifrovymi-podpisyami-gpg.html>`__.

.. index:: gpg, encrypt files, encryption
.. _gpg-encrypt:

Как зашифровать и расшифровать файлы с определённой маской в текущем каталоге?
==================================================================================

Шифрование всех файлов с маской *.7z.* (многотомные архивы 7-Zip):

.. code-block:: bash

    find . -maxdepth 1 -type f -name "*.7z.*" -exec gpg2 --out "{}.asc" --recipient "example@example.org" --encrypt "{}" \;

Расшифровка:

.. code-block:: bash

    find . -maxdepth 1 -type f -name "*.asc" -exec gpg2 --out "$(basename {})" --decrypt "{}" \;

.. index:: admin, user, sudo
.. _admin-vs-user:

Чем отличается пользователь-администратор от обычного?
=========================================================

Администратор (в терминологии программы установки Anaconda) имеет доступ к sudo.

.. index:: admin, sudo, su
.. _sudo-password:

Какие пароли запрашивают sudo и su?
======================================

Утилита sudo запрашивает текущий пароль пользователя, а su - рутовый.

.. index:: root password, password change, security
.. _root-password:

Как мне сменить пароль суперпользователя?
============================================

Для смены или установки пароля суперпользователя при наличии доступа к sudo, можно выполнить:

.. code-block:: bash

    sudo passwd root

.. index:: sudo, security
.. _sudo-access:

Как мне получить доступ к sudo?
==================================

Если при установке Fedora, при создании пользователя, не был установлен флажок в чекбокс **Создать администратора**, то необходимо самостоятельно добавить пользовательский аккаунт в группу **wheel**:

.. code-block:: bash

    su -c "usermod -a -G wheel $(whoami)"

.. index:: sudo, su, security
.. _sudo-vs-su:

Что лучше: sudo или su?
==========================

Sudo ибо позволяет гибко настраивать права доступа, включая список разрешённых команд, а также ведёт полный журнал её использования.

.. index:: sudo, file manager
.. _sudo-file-manager:

Почему я не могу запустить файловый менеджер с правами суперпользователя?
============================================================================

Это сделано из соображений безопасности. Более подробная информация доступна `здесь <https://blog.martin-graesslin.com/blog/2017/02/editing-files-as-root/>`__.

.. index:: sudo, config editing, config
.. _sudo-edit-config:

Как мне отредактировать конфиг, доступный только суперпользователю?
======================================================================

Необходимо использовать **sudoedit**:

.. code-block:: bash

    sudoedit /путь/к/файлу/конфигурации.conf

.. index:: sudo, config editing, config
.. _sudoedit-info:

Sudoedit безопаснее прямого запуска текстового редактора с правами суперпользователя?
========================================================================================

Да, намного ибо sudoedit копирует нужный файл во временный каталог и загружает в выбранном по умолчанию текстовом редакторе с обычными правами, а по завершении редактирования копирует на прежнее место.

.. index:: ssh, configuration, security
.. _ssh-install:

Как включить и безопасно настроить сервер SSH?
==================================================

Сначала необходимо активировать sshd:

.. code-block:: bash

    sudo systemctl enable sshd.service

Теперь следует открыть конфиг **/etc/ssh/sshd_config** в любом текстовом редакторе и внести правки.

Отключение входа суперпользователем:

.. code-block:: text

    PermitRootLogin no

Запрет входа по паролям (будет доступна лишь аутентификация по ключам):

.. code-block:: text

    PasswordAuthentication no
    PermitEmptyPasswords no

Перезапуск sshd для применения изменений:

.. code-block:: bash

    sudo systemctl restart sshd.service

.. index:: ssh, password authentication, password, authentication
.. _ssh-passwords:

Допустимо ли использовать парольную аутентификацию для SSH?
================================================================

В настоящее время мы настоятельно не рекомендуем эксплуатировать SSH серверы с включённой парольной аутентификацией (настройки по умолчанию), т.к. он станет постоянной целью для атак заражённых устройств, которые будут пытаться подобрать пароль по словарям, а также полным перебором, создавая тем самым лишнюю нагрузку на SSH сервер.

Автоматическая блокировка средствами fail2ban также не особо поможет, т.к. современные ботнеты умеют координировать свои атаки посредством мастер-сервера и знают стандартные настройки данных утилит.

.. index:: ssh, port
.. _ssh-port:

Следует ли сменить порт SSH на нестандартный?
==================================================

Это никак не поможет скрыть сервер от крупных бот-сетей, сканирующих весь допустимый диапазон портов, и лишь создаст дополнительные неудобства для самих пользователей.

.. index:: ssh, key-based authentication
.. _ssh-keys:

Безопасна ли аутентификация по ключам в SSH?
=================================================

Да. В настоящее время это самый безопасный метод аутентификации. Если во время рукопожатия SSH клиент не предоставил серверу разрешённый ключ, последний немедленно закроет соединение.

.. index:: ssh, key-based authentication, generate key
.. _ssh-keygen:

Как сгенерировать ключи для SSH?
=====================================

Для создания ключевой пары из открытого и закрытого ключей, необходимо воспользоваться утилитой **ssh-keygen**:

.. code-block:: bash

    ssh-keygen -t rsa -C "user@example.org"

Здесь в качестве параметра **-t** указывается тип ключа: RSA, DSA, ecdsa или ed25519. Рекомендуется использовать либо RSA, либо ed25519.

Для RSA можно добавить параметр **-b** и указать длину в битах, например **-b 4096**.

.. index:: ssh, key-based authentication, transfer key
.. _ssh-transfer:

Как безопасно передать публичный ключ SSH на удалённый сервер?
===================================================================

Для простой, быстрой и безопасной передачи можно использовать утилиту **ssh-copy-id**:

.. code-block:: bash

    ssh-copy-id user@example.org

Здесь **user@example.org** - данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост.

.. index:: ssh, port forwarding, tunneling
.. _ssh-port-forwarding:

Как пробросить порт с удалённой машины на локальную через SSH?
==================================================================

Для примера пробросим с удалённого сервера на локальную машину порт MySQL/MariaDB:

.. code-block:: bash

    ssh user@example.org -L 3306:127.0.0.1:3306 -N -f

Здесь **user@example.org** - данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост, а **3306** - порт. Параметры **-N -f** заставляют SSH клиент сразу вернуть управление, уйти в фоновый режим и продолжать поддерживать соединение до своего завершения.

.. index:: ssh, socks, tunneling
.. _ssh-socks:

Как настроить виртуальный SOCKS туннель через SSH?
======================================================

.. code-block:: bash

    ssh user@example.org -D 127.0.0.1:8080 -N -f

Здесь **user@example.org** - данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост, а **8080** - локальный порт, на котором будет запущен SSH клиент в режиме эмуляции SOCKS5 сервера. Параметры **-N -f** заставляют SSH клиент сразу вернуть управление, уйти в фоновый режим и продолжать поддерживать соединение до своего завершения.

После запуска необходимо настроить браузер и другие приложения на работу через данный SOCKS5 прокси.

.. index:: ssh, configuration, sftp
.. _ssh-sftp:

Можно ли разрешить доступ посредством SSH только к файлам, без возможности выполнения команд?
=================================================================================================

Да. Для этого создадим специальную группу (например **sftp**):

.. code-block:: bash

    sudo groupadd sftp

Откроем конфиг **/etc/ssh/sshd_config** в текстовом редакторе и в самом конце добавим:

.. code-block:: text

    Subsystem sftp internal-sftp
    Match Group sftp
        ChrootDirectory %h
        AllowTCPForwarding no
        ForceCommand internal-sftp

Перезапустим sshd для применения изменений:

.. code-block:: bash

    sudo systemctl restart sshd.service

.. index:: destroy file, shred
.. _destroy-file:

Как безвозвратно уничтожить файл?
=====================================

Для уничтожения данных можно использовать штатную утилиту **shred** из пакета GNU Coreutils:

.. code-block:: bash

    shred -u -v /путь/к/файлу.txt

Восстановить такой файл будет практически невозможно ибо сектора диска, на которых он располагался, будут многократно перезаписаны случайной последовательностью, а затем заполнены нулями.

.. index:: destroy disk, shred, disk, drive
.. _destroy-disk:

Можно лишь уничтожить содержимое всего диска?
=================================================

Да, для этого можно использовать уже упомянутую выше утилиту **shred**:

.. code-block:: bash

    sudo shred -v /dev/sdX

Здесь **/dev/sdX** — устройство, которое будет очищено. На больших HDD процесс займёт много времени.

.. index:: destroy file, ssd, trim
.. _destroy-ssd-file:

Как уничтожить файл на SSD?
===============================

Для безвозвратного удаления файла на SSD накопителе достаточно просто удалить его штатным средством системы и дождаться выполнения процедуры TRIM, которая физически забьёт ячейки, которые им использовались, нулями.

Если не используется TRIM реального времени, принудительно запустить этот процесс на всех твердотельных накопителях можно так:

.. code-block:: bash

    sudo systemctl start fstrim.service

.. index:: permissions, file, chmod
.. _newfile-permissions:

Как рассчитываются права доступа для новых файлов и каталогов?
==================================================================

Права доступа (chmod) в GNU/Linux рассчитываются в по формуле **$default-chmod - $current-umask**. **$default-chmod** для файлов равен 0666, а для каталогов - 0777.

В Fedora umask по умолчанию для пользоватьских учётных записей равен **0002** (ведущий нуль в chmod означает использование восьмеричной системы счисления).

Таким образом, chmod для новых файлов **0666 - 0002 = 0664** (-rw-rw--r--), а для каталогов - **0777 - 0002 = 0775** (drwxrwxr-x).

.. index:: cryptography, gost, openssl
.. _fedora-gost:

Можно ли включить поддержку российской криптографии в Fedora?
==================================================================

См. `здесь <https://www.easycoding.org/2018/11/28/dobavlyaem-podderzhku-gost-dlya-openssl-v-fedora.html>`__.

.. index:: wi-fi, random mac, mac
.. _mac-randomize:

Как включить рандомизацию MAC адресов при подключении к Wi-Fi точкам в Fedora?
==================================================================================

Network Manager поддерживает два сценария рандомизации MAC адресов:

 1. генерирование уникального псевдослучайного MAC адреса для каждого соединения при загрузке системы (параметр **stable**). Это избавит от проблем с переподключением к публичным хот-спотам и небходимости повторно проходить аутентификацию в captive-порталах;
 2. генерирование уникального псевдослучайного MAC адреса для каждого соединения при каждом переподключении (параметр **random**). Наиболее безопасно, но может вызывать описанные выше проблемы.

Профиль **stable**. Файл **00-macrandomize-stable.conf**:

.. code-block:: ini

    [device]
    wifi.scan-rand-mac-address=yes

    [connection]
    wifi.cloned-mac-address=stable
    ethernet.cloned-mac-address=stable
    connection.stable-id=${CONNECTION}/${BOOT}

Профиль **random**. Файл **00-macrandomize-random.conf**:

.. code-block:: ini

    [device]
    wifi.scan-rand-mac-address=yes

    [connection]
    wifi.cloned-mac-address=random
    ethernet.cloned-mac-address=random

Для применения одной из конфигураций создадим в каталоге **/etc/NetworkManager/conf.d** файл с выбранным профилем, после чего перезапустим Network Manager:

.. code-block:: bash

    sudo systemctl restart NetworkManager

Для отключения рандомизации и возвращения настроек по умолчанию достаточно просто удалить созданный файл и перезапустить Network Manager.

.. index:: ca, certificate, certification authority
.. _add-custom-ca:

Как добавить собственный удостоверяющий центр в список доверенных?
=======================================================================

Для добавления нового удостоверяющего центра необходимо скопировать файл его сертификата в формате PEM или DER в каталог **/etc/pki/ca-trust/source/anchors**, после чего выполнить:

.. code-block:: bash

    sudo update-ca-trust

Следует помнить, что данное действие не будет распространяться на браузер Mozilla Firefox, имеющий собственную базу доверенных корневых УЦ.

.. index:: ca, certificate, certification authority
.. _blackist-ca:

Как внести удостоверяющий центр в список запрещённых?
==========================================================

Для добавления удостоверяющего центра в список заблокированных необходимо скопировать файл его сертификата в формате PEM или DER в каталог **/etc/pki/ca-trust/source/blacklist**, после чего выполнить:

.. code-block:: bash

    sudo update-ca-trust

Следует помнить, что данное действие не будет распространяться на браузер Mozilla Firefox, имеющий собственную базу доверенных корневых УЦ.
