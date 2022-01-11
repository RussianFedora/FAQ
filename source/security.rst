..
    SPDX-FileCopyrightText: 2018-2022 EasyCoding Team and contributors

    SPDX-License-Identifier: CC-BY-SA-4.0

.. _security:

************
Безопасность
************

.. index:: selinux
.. _selinux:

Что такое SELinux?
========================

SELinux -- это мандатная система контроля доступа, ограничивающая доступ ряду сервисов к файлам и каталогам.

Более подробная информация может быть получена `здесь <https://ru.wikipedia.org/wiki/SELinux>`__.

.. index:: selinux, disable selinux, disable
.. _selinux-temp:

Как мне временно отключить SELinux?
=======================================

Мы настоятельно не рекомендуем этого делать, однако если это необходимо, то для временного однократного отключения SELinux, передадим ядру Linux специальный :ref:`параметра ядра <kernelpm-once>`:

.. code-block:: text

    SELINUX=0

.. index:: selinux, disable selinux
.. _selinux-disable:

Как мне навсегда отключить SELinux?
=======================================

Для постоянного отключения SELinux, откроем его главный файл файл конфигурации ``/etc/selinux/config`` в текстовом редакторе:

.. code-block:: text

    sudoedit /etc/selinux/config

Изменить значение директивы ``SELINUX`` на одно из допустимых значений:

  * ``enforcing`` — включён и блокирует всё, что явно не разрешено;
  * ``permissive`` — включён, но ничего не блокирует, а лишь записывает события в :ref:`системный журнал <journal-current>`;
  * ``disabled`` — полностью отключён.

Изменения вступят в силу при следующей загрузке системы.

.. index:: selinux, status selinux, status
.. _selinux-status:

Как узнать текущий статус SELinux?
=======================================

Получим текущий статус SELinux при помощи одной из следующих команд: ``getenforce`` или ``sestatus``.

.. index:: auditd, selinux, error, security
.. _selinux-auditd:

Как разрешить заблокированные действия SELinux?
===================================================

По умолчанию :ref:`SELinux <selinux>` будет блокировать доступ к любым файлам, каталогам, сокетам, которые не разрешены в политиках для конкретного процесса. Это вызывает множество проблем, поэтому пользователи зачастую предпочитают :ref:`отключать SELinux <selinux-disable>`, что в корне неверно. Вместо этого следует разобраться в причине блокировки и создать разрешающее правило.

Очистим журнал аудита для того, чтобы избавиться от предыдущих ошибок и случайно не позволить лишние действия, накопившиеся с момента его прошлой ротации:

.. code-block:: text

    sudo bash -c "cat /dev/null > /var/log/audit/audit.log"

Запустим приложение, модуль ядра и т.д., который вызывает срабатывание SELinux и блокировку доступа к ресурсу (файлу, каталогу, сокету). Как только это произойдёт, воспользуемся утилитой **audit2allow** для анализа журнала аудита, облегчающей создание новых разрешающих правил для SELinux:

.. code-block:: text

    sudo bash -c "cat /var/log/audit/audit.log | audit2allow -M foo-bar"

В результате работы данной утилиты будет создан новый модуль ``foo-bar.te``, в котором разрешаются действия, записи о запрещении которых были внесены в журнал auditd ранее.

Перед применением этого файла и созданием политики SELinux обязательно загрузим его в текстовый редактор и проверим корректность, т.к. в нем может содержаться больше разрешающих правил, чем требуется, а также присутствуют подсказки о том, как правильно настроить SELinux.

В сгенерированном файле модуля ``foo-bar.te`` после комментария *This avc can be allowed using one of the these booleans* присутствует список переменных двоичного типа, установка которых поможет разрешить заблокированное действие. Справочную информацию можно получить из документации SELinux:

.. code-block:: text

    getsebool -a

Описание переменных SELinux, относящихся к работе веб-сервера, можно найти `здесь <https://dwalsh.fedorapeople.org/SELinux/httpd_selinux.html>`__.

.. index:: httpd, selinux, access rights, security
.. _selinux-httpd:

Как настроить SELinux так, чтобы веб-сервер мог создавать файлы и каталоги?
==============================================================================

Если при работе веб-сервера в журналах появляются сообщения вида:

.. code-block:: text

    Warning: chmod(): Permission denied in /var/www/html/foo-bar/foo.php on line XXX
    Warning: Directory /var/www/html/foo-bar/foo not writable, please chmod to 755 in /var/www/html/foo-bar/foo.php on line XXX

Они означают, что процесс веб-сервера (или интерпретатора языка программирования) не может получить доступ на запись. Если права доступа (chmod и chown) при этом установлены верно, значит доступ блокирует :ref:`SELinux <selinux>`.

Установим правильный контекст безопасности для всех каталогов внутри ``document_root/foo-bar``:

.. code-block:: text

    sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/foo-bar(/.*)?"

Сбросим контекст безопасности для всех файлов внутри document_root рекурсивно:

.. code-block:: text

    sudo restorecon -Rv /var/www/html

Для отмены произведённых изменений контекста выполним:

.. code-block:: text

    sudo semanage fcontext -d "/var/www/html/foo-bar(/.*)?"

Получим список контекстов для httpd:

.. code-block:: text

    sudo semanage fcontext -l | grep httpd

Если предудущая команда выводит очень много информации, осуществим фильтрацию вывода:

.. code-block:: text

    sudo semanage fcontext -l | grep /var/www/html

Получим список файлов и каталогов с установленным контекстом SELinux:

.. code-block:: text

    ls -laZ /var/www/html/foo-bar

Более полную информацию о контекстах безопасности и работе с ними можно найти `здесь <https://docs.fedoraproject.org/en-US/Fedora/25/html/SELinux_Users_and_Administrators_Guide/sect-Security-Enhanced_Linux-Working_with_SELinux-SELinux_Contexts_Labeling_Files.html>`__.

Откроем текстовый редактор и создадим новый модуль ``httpd_wr.te``:

.. code-block:: text

    module httpd_wr 1.0;
    
    require {
        type httpd_t;
        type httpd_sys_rw_content_t;
        class file { create write setattr rename unlink };
        class dir { create write setattr add_name remove_name rmdir };
    }
    
    allow httpd_t httpd_sys_rw_content_t:file { create write setattr rename unlink };
    allow httpd_t httpd_sys_rw_content_t:dir { create write setattr add_name remove_name rmdir };

Проверим, скомпилируем и установим его:

.. code-block:: text

    sudo checkmodule -M -m httpd_wr.te -o httpd_wr.mod
    sudo semodule_package -o httpd_wr.pp -m httpd_wr.mod
    sudo semodule -i httpd_wr.pp

Больше полезной информации о модулях:

  * `создание модулей SELinux <https://habr.com/ru/company/pt/blog/142423/>`__;
  * `создание разрешений для классов <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/4/html/SELinux_Guide/rhlcommon-section-0049.html>`__;
  * `информация о контекстах и настройках для веб-сервера <https://dwalsh.fedorapeople.org/SELinux/httpd_selinux.html>`__.

.. index:: httpd, selinux, connection, network, port, security
.. _selinux-connections:

Как настроить SELinux так, чтобы веб-сервер мог осуществлять исходящие сетевые соединения?
==============================================================================================

.. _nsl-first:

Первый вариант (самый правильный):
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Откроем текствый редактор и создадим новый модуль ``httpd_network.te``:

.. code-block:: text

    module httpd_connect 1.0;
    
    require {
    	   type httpd_t;
    	   type ephemeral_port_t;
    	   class tcp_socket name_connect;
    }
    
    allow httpd_t ephemeral_port_t:tcp_socket name_connect;

Проверим, скомпилируем и установим его:

.. code-block:: text

    sudo checkmodule -M -m httpd_network.te -o httpd_network.mod
    sudo semodule_package -o httpd_network.pp -m httpd_network.mod
    sudo semodule -i httpd_network.pp 

Получим названия диапазонов портов:

.. code-block:: text

    sudo semanage port -l

Добавим порт в диапазон:

.. code-block:: text

    semanage port -a -t ephemeral_port_t -p tcp 80-88

Удалим порт из диапазона:

.. code-block:: text

    semanage port -d -t ephemeral_port_t -p tcp 80-88

Здесь **ephemeral_port_t** -- название диапазона, **tcp** -- используемый протокол, а **80-88** -- диапазон разрешаемых портов.

.. _nsl-second:

Второй вариант (быстрый, но менее безопасный)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Разрешим любые исходящие соединения для веб-сервера:

.. code-block:: text

    sudo setsebool -P httpd_can_network_connect on

.. index:: openvpn, selinux, vpn, security
.. _openvpn-selinux:

OpenVPN не может получить доступ к сертификатам из-за SELinux. Что делать?
==============================================================================

Это нормально ибо запущенные сервисы не могут получать доступ к каталогам пользователя, однако для OpenVPN сделано исключение в виде каталога ``~/.cert``.

По умолчанию он не существует, поэтому его нужно создать и задать для него контекст безопасности SELinux:

.. code-block:: text

    mkdir ~/.cert
    restorecon -Rv ~/.cert

Теперь в нём можно размещать сертификаты и приватные ключи.

.. index:: cpu, kpti, hardware, vulnerability, disable, mitigation
.. _kpti:

Можно ли отключить KPTI?
===========================

KPTI -- это новый механизм ядра, направленный на защиту системы от уязвимости `Meltdown <https://ru.wikipedia.org/wiki/Meltdown_(%D1%83%D1%8F%D0%B7%D0%B2%D0%B8%D0%BC%D0%BE%D1%81%D1%82%D1%8C)>`__ в процессорах Intel. Настоятельно не рекомендуется его отключать, хотя это и возможно. Для этого необходимо и достаточно передать :ref:`параметр ядра <kernelpm-perm>`:

.. code-block:: text

    nopti

Параметр ``pti=off`` также поддерживается в полной мере.

.. index:: cpu, spectre, hardware, vulnerability, disable, mitigation
.. _spectrev1:

Можно ли отключить защиту от Spectre v1?
============================================

Программные заплатки могут быть отключены при помощи :ref:`параметра ядра <kernelpm-perm>`:

.. code-block:: text

    nospectre_v1

.. index:: cpu, spectre, hardware, vulnerability, disable, mitigation
.. _spectrev2:

Можно ли отключить защиту от Spectre v2?
============================================

Да, при помощи :ref:`параметра ядра <kernelpm-perm>`:

.. code-block:: text

    nospectre_v2

.. index:: cpu, spectre, hardware, vulnerability, disable, mitigation
.. _spectrev4:

Можно ли отключить защиту от Spectre v4?
===========================================

Да, при помощи :ref:`параметра ядра <kernelpm-perm>`:

.. code-block:: text

    nospec_store_bypass_disable

.. index:: cpu, l1tf, hardware, vulnerability, disable, mitigation
.. _l1tf:

Можно ли отключить защиту от L1TF?
======================================

Да, при помощи :ref:`параметра ядра <kernelpm-perm>`:

.. code-block:: text

    l1tf=off

.. index:: cpu, mds, hardware, vulnerability, disable, mitigation
.. _mds:

Можно ли отключить защиту от MDS?
=====================================

Да, при помощи :ref:`параметра ядра <kernelpm-perm>`:

.. code-block:: text

    mds=off

.. index:: cpu, itlb, hardware, vulnerability, disable, mitigation
.. _itlb:

Можно ли отключить защиту от iTLB?
=====================================

Да, при помощи :ref:`параметра ядра <kernelpm-perm>`:

.. code-block:: text

    nx_huge_pages=off

.. index:: cpu, tsx, hardware, vulnerability, disable, mitigation
.. _tsx:

Можно ли отключить защиту от TSX?
====================================

Да, при помощи :ref:`параметра ядра <kernelpm-perm>`:

.. code-block:: text

    tsx=on

Для полной деактивации должен использоваться совместно с :ref:`TAA <taa>`.

.. index:: cpu, taa, hardware, vulnerability, disable, mitigation
.. _taa:

Можно ли отключить защиту от TAA?
====================================

Да, при помощи :ref:`параметра ядра <kernelpm-perm>`:

.. code-block:: text

    tsx_async_abort=off

.. index:: cpu, kpti, hardware, vulnerability, disable, mitigation, l1tf, spectre, mds, itlb, tsx, taa
.. _mitigations-off:

Можно ли отключить все виды защит от уязвимостей в процессорах?
==================================================================

Да. Начиная с версии ядра Linux 5.1.2, появился особый :ref:`параметр ядра <kernelpm-perm>`, отключающий все виды программных защит:

.. code-block:: text

    mitigations=off

.. index:: gpu, hardware, vulnerability, disable, mitigation, i915, intel
.. _i915-mitigations:

Можно ли отключить защиту от уязвимостей в Intel GPU?
=========================================================

Да. Начиная с версии ядра Linux 5.12, появился особый :ref:`параметр ядра <kernelpm-perm>`, отключающий все виды программных защит интегрированных видеокарт Intel:

.. code-block:: text

    i915.mitigations=off

.. index:: hardware, vulnerability, disable, mitigation, cpu
.. _hardware-vuln:

Как узнать защищено ли ядро от известных уязвимостей в процессорах?
========================================================================

Ранее для этого применялись сторонние утилиты, но в современных версиях ядра для этого есть штатный механизм, который можно использовать:

.. code-block:: text

    grep . /sys/devices/system/cpu/vulnerabilities/*

.. index:: selinux, error
.. _selinux-boot-error:

При загрузке получаю ошибку SELinux. Как исправить?
=======================================================

Такое бывает если по какой-то причине сбился контекст безопасности SELinux. Исправить это можно двумя различными способами.

*Способ первый*:

.. code-block:: text

    sudo touch /.autorelabel
    sudo systemctl reboot

Внимание! Следующая загрузка системы займёт много времени из-за переустановки контекста для всех файлов и каталогов. Ни в коем случае не следует её прерывать. По окончании система автоматически перезагрузится ещё один раз.

*Способ второй*:

.. code-block:: text

    sudo restorecon -Rv /
    sudo systemctl reboot

После перезагрузки все ошибки, связанные с SELinux, должны исчезнуть.

.. index:: luks, encryption, USB, cryptsetup
.. _luks-usb:

Как можно надёжно зашифровать файлы на USB устройстве?
=========================================================

См. `здесь <https://www.easycoding.org/2016/11/14/shifruem-vneshnij-nakopitel-posredstvom-luks.html>`__.

.. index:: luks, encryption, home
.. _luks-home:

Можно ли зашифровать домашний раздел уже установленной системы?
==================================================================

См. `здесь <https://www.easycoding.org/2016/12/09/shifruem-domashnij-razdel-ustanovlennoj-sistemy.html>`__.

.. index:: luks, encryption, change password, password, cryptsetup
.. _luks-change-password:

Как сменить пароль зашифрованного LUKS раздела?
===================================================

Сменить пароль достаточно просто. Достаточно выполнить следующую команду:

.. code-block:: text

    sudo cryptsetup luksChangeKey /dev/sda1 -S 0

Здесь **/dev/sda1** -- зашифрованный раздел диска, а **0** -- порядковый номер LUKS слота для пароля.

Для успешной смены пароля раздел не должен быть смонтирован, поэтому если это корневой или домашний, то придётся выполнять загрузку с :ref:`LiveUSB <usb-flash>`.

.. index:: luks, encryption, drive information, information, cryptsetup
.. _luks-info:

Как получить информацию о зашифрованном LUKS устройстве?
=============================================================

Если требуется получить подробную информацию о зашифрованном LUKS разделе (алгоритм шифрование, тип хеша и количество итераций и т.д.), можно воспользоваться утилитой **cryptsetup**:

.. code-block:: text

    sudo cryptsetup luksDump /dev/sda1

Здесь **/dev/sda1** -- зашифрованный раздел диска.

.. index:: luks, encryption, performance, benchmark, cryptsetup
.. _luks-benchmark:

Насколько сильно шифрование LUKS снижает производительность дисковой подсистемы?
=====================================================================================

На современных процессорах с аппаратной поддержкой набора инструкций AES-NI снижение производительности практически незаметно даже на самых производительных NVMe SSD накопителях.

Для того, чтобы оценить скорость работы на реальном оборудовании, в **cryptsetup** присутствует встроенный бенчмарк для тестирования разных алгоритмов шифрования и типа сцепления блоков шифротекста:

.. code-block:: text

    cryptsetup benchmark

.. index:: luks, encryption, performance, cpu
.. _luks-aes:

Как узнать поддерживает ли процессор моего ПК набор инструкций AES-NI?
===========================================================================

Если в выводе ``/proc/cpuinfo`` присутствует строка **aes**, значит поддерживает:

.. code-block:: text

    grep -Eq 'aes' /proc/cpuinfo && echo Yes || echo No

.. index:: firewalld, firewall
.. _firewalld-about:

Что такое Firewalld?
=======================

Firewalld -- это современный динамически управляемый брандмауэр с поддержкой зон для интерфейсов.

.. index:: firewalld, configuration, firewall
.. _firewalld-configure:

Как можно настраивать Firewalld?
==================================

Для настройки применяется либо графическая утилита **firewall-config**, либо консольная **firewall-cmd**.

Документацию можно `найти в Wiki <https://fedoraproject.org/wiki/FirewallD/ru>`__.

.. index:: firewalld, configuration, firewall, hardening
.. _firewalld-hardened:

Как усилить настройки безопасности Firewalld?
=================================================

По умолчанию в Fedora Workstation применяется зона брандмауэра **FedoraWorkstation**, для которой разрешены входящие соединения на порты из диапазона 1025-65535, как по TCP, так и UDP.

Если необходимо запретить все входящие подключения, кроме явно разрешённых, переключим зону на **public**:

.. code-block:: text

    sudo firewall-cmd --set-default-zone=public

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

.. code-block:: text

    sudo firewall-cmd --permanent --zone=drop --add-source=1.2.3.4

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

.. code-block:: text

    find . -maxdepth 1 -type f -name "*.7z.*" -exec gpg2 --out "{}.asc" --recipient "example@example.org" --encrypt "{}" \;

Расшифровка:

.. code-block:: text

    find . -maxdepth 1 -type f -name "*.asc" -exec gpg2 --out "$(basename {})" --decrypt "{}" \;

.. index:: admin, user, sudo
.. _admin-vs-user:

Чем отличается пользователь-администратор от обычного?
=========================================================

Администратор (в терминологии программы установки Anaconda) имеет доступ к sudo.

.. index:: admin, user, sudo
.. _sudo-run:

Как запустить команду с правами суперпользователя?
=====================================================

Для запуска чего-либо с правами суперпользователя необходимо использовать sudo:

.. code-block:: text

    sudo foo-bar

Здесь вместо **foo-bar** следует указать команду, путь к исполняемому файлу, скрипту и т.д.

.. index:: admin, sudo, su
.. _sudo-password:

Какие пароли запрашивают sudo и su?
======================================

Утилита sudo запрашивает текущий пароль пользователя, а su -- рутовый.

.. index:: root password, password change, security
.. _root-password:

Как мне сменить пароль суперпользователя?
============================================

Для смены или установки пароля суперпользователя при наличии доступа к sudo, можно выполнить:

.. code-block:: text

    sudo passwd root

.. index:: sudo, security
.. _sudo-access:

Как мне получить доступ к sudo?
==================================

Если при установке Fedora, при создании пользователя, не был установлен флажок в чекбокс **Создать администратора**, то необходимо самостоятельно добавить пользовательский аккаунт в группу **wheel**:

.. code-block:: text

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

.. code-block:: text

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

Сначала установим и активируем sshd:

.. code-block:: text

    sudo dnf install openssh-server
    sudo systemctl enable --now sshd.service

Создадим собственный файл конфигурации, в который будем вносить изменения:

.. code-block:: text

    sudo touch /etc/ssh/sshd_config.d/00-foobar.conf
    sudo chmod 0600 /etc/ssh/sshd_config.d/00-foobar.conf

Имя файла начинается с **00**, т.к., согласно документации OpenSSH, приоритет среди всех файлов конфигурации имеет та директива, которая была указана раньше.

Отредактируем созданный файл для внесения своих изменений:

.. code-block:: text

    sudoedit /etc/ssh/sshd_config.d/00-foobar.conf

Отключим вход суперпользователем:

.. code-block:: text

    PermitRootLogin no

Запретим вход по паролям (будет доступна лишь аутентификация по ключам):

.. code-block:: text

    PasswordAuthentication no
    PermitEmptyPasswords no

Сохраним изменения и перезапустим sshd:

.. code-block:: text

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

.. code-block:: text

    ssh-keygen -t rsa -C "user@example.org"

Здесь в качестве параметра **-t** указывается тип ключа: RSA, DSA, ecdsa или ed25519. Рекомендуется использовать либо RSA, либо ed25519.

Для RSA можно добавить параметр **-b** и указать длину в битах, например **-b 4096**.

.. index:: ssh, key-based authentication, transfer key
.. _ssh-transfer:

Как безопасно передать публичный ключ SSH на удалённый сервер?
===================================================================

Для простой, быстрой и безопасной передачи можно использовать утилиту **ssh-copy-id**:

.. code-block:: text

    ssh-copy-id user@example.org

Здесь **user@example.org** -- данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост.

.. index:: ssh, port forwarding, tunneling
.. _ssh-port-forwarding:

Как пробросить порт с удалённой машины на локальную через SSH?
==================================================================

Для примера пробросим с удалённого сервера на локальную машину порт MySQL/MariaDB:

.. code-block:: text

    ssh user@example.org -L 3306:127.0.0.1:3306 -N -f

Здесь **user@example.org** -- данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост, а **3306** -- порт. Параметры ``-N -f`` заставляют SSH клиент сразу вернуть управление, уйти в фоновый режим и продолжать поддерживать соединение до своего завершения.

.. index:: ssh, socks, tunneling
.. _ssh-socks:

Как настроить виртуальный SOCKS туннель через SSH?
======================================================

.. code-block:: text

    ssh user@example.org -D 127.0.0.1:8080 -N -f

Здесь **user@example.org** -- данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост, а **8080** -- локальный порт, на котором будет запущен SSH клиент в режиме эмуляции SOCKS5 сервера. Параметры ``-N -f`` заставляют SSH клиент сразу вернуть управление, уйти в фоновый режим и продолжать поддерживать соединение до своего завершения.

После запуска необходимо настроить браузер и другие приложения на работу через данный SOCKS5 прокси.

.. index:: ssh, configuration, sftp
.. _ssh-sftp:

Можно ли разрешить доступ посредством SSH только к файлам, без возможности выполнения команд?
=================================================================================================

Да. Для этого создадим специальную группу (например **sftp**):

.. code-block:: text

    sudo groupadd sftp

Создадим собственный файл конфигурации, в который будем вносить изменения:

.. code-block:: text

    sudo touch /etc/ssh/sshd_config.d/01-sftp.conf
    sudo chmod 0600 /etc/ssh/sshd_config.d/01-sftp.conf

Откроем конфиг ``/etc/ssh/sshd_config.d/01-sftp.conf`` в текстовом редакторе:

.. code-block:: text

    sudoedit /etc/ssh/sshd_config.d/01-sftp.conf

Добавим следующие строки:

.. code-block:: text

    Subsystem sftp internal-sftp
    Match Group sftp
        ChrootDirectory %h
        AllowTCPForwarding no
        ForceCommand internal-sftp

Сохраним изменения и перезапустим sshd:

.. code-block:: text

    sudo systemctl restart sshd.service

.. index:: destroy file, shred, wipe, erasing
.. _destroy-file:

Как безвозвратно уничтожить файл?
=====================================

Для уничтожения данных можно использовать штатную утилиту **shred** из пакета GNU Coreutils:

.. code-block:: text

    shred -u -v /путь/к/файлу.txt

Восстановить такой файл будет практически невозможно ибо сектора диска, на которых он располагался, будут многократно перезаписаны случайной последовательностью, а затем заполнены нулями.

.. index:: destroy disk, shred, disk, drive, wipe, erasing
.. _destroy-disk:

Можно лишь уничтожить содержимое всего диска?
=================================================

Да, для этого можно использовать уже упомянутую выше утилиту **shred**:

.. code-block:: text

    sudo shred -v /dev/sdX

Здесь **/dev/sdX** — устройство, которое будет очищено. На больших HDD процесс займёт много времени.

.. index:: destroy file, ssd, trim, wipe, erasing
.. _destroy-ssd-file:

Как уничтожить файл на SSD?
===============================

Для безвозвратного удаления файла на SSD накопителе достаточно просто удалить его штатным средством системы и дождаться выполнения процедуры TRIM, которая физически забьёт ячейки, которые им использовались, нулями.

Если не используется TRIM реального времени, принудительно запустить этот процесс на всех твердотельных накопителях можно так:

.. code-block:: text

    sudo systemctl start fstrim.service

.. index:: wipe, ssd, secure erase, uefi, bios, hdparm, sata, erasing
.. _wipe-ssd:

Как полностью очистить SATA SSD без возможности восстановления?
==================================================================

Все модели SATA SSD поддерживают специальную ATA-команду `Secure Erase <https://ata.wiki.kernel.org/index.php/ATA_Secure_Erase>`__, при получении которой контроллер обязан полностью очистить все ячейки диска и вернуть все параметры к настройкам по умолчанию.

Установим утилиту **hdparm**:

.. code-block:: text

    sudo dnf install hdparm

Далее **/dev/sdb** -- это устройство SSD накопителя, который мы планируем очистить. Очищать устройство, на котором установлена система, можно только после загрузки с :ref:`Fedora LiveUSB <usb-flash>`.

Убедимся, что UEFI BIOS не блокирует функцию самоуничтожения диска:

.. code-block:: text

    sudo hdparm -I /dev/sdb

Если в выводе присутствует **frozen**, значит диск блокируется и сначала нужно её снять.

В большинстве реализаций UEFI BIOS сбросить блокировку с SATA накопителей можно лишь посредством "горячего" подключения устройства. Необходимо включить компьютер, не подсоединяя SATA-кабель к накопителю, а затем уже после загрузки системы подключить его.

Если всё сделано верно, в выводе обнаружим **not frozen** и сможем продолжить процесс.

Установим специальный пароль блокировки накопителя, т.к. без передачи верного пароля команда ATA Secure Erase будет проигнорирована:

.. code-block:: text

    sudo hdparm --user-master u --security-set-pass FooBar /dev/sdb

Ни в коем случае не следует устанавливать новое значение пароля в виде пустой строки, либо NULL, т.к. на многих материнских платах это приведёт к невозможности загрузки с этого устройства, а равно как и его смены.

Запустим процесс очистки:

.. code-block:: text

    sudo hdparm --user-master u --security-erase FooBar /dev/sdb

Через некоторое время (зависит от объёма и производительности контроллера устройства) диск будет полностью очищен, а все настройки, включая пароль блокировки, сброшены.

В случае **если произошёл сбой** очистки, сбросим установленный пароль вручную:

.. code-block:: text

    sudo hdparm --user-master u --security-disable FooBar /dev/sdb

.. index:: permissions, file, chmod
.. _newfile-permissions:

Как рассчитываются права доступа для новых файлов и каталогов?
==================================================================

Права доступа (chmod) в GNU/Linux рассчитываются в по формуле ``$default-chmod - $current-umask``. ``$default-chmod`` для файлов равен ``0666``, а для каталогов -- ``0777``.

В Fedora umask по умолчанию для пользоватьских учётных записей равен ``0002`` (ведущий нуль в chmod означает использование восьмеричной системы счисления).

Таким образом, chmod для новых файлов ``0666 - 0002 = 0664`` (``-rw-rw--r--``), а для каталогов -- ``0777 - 0002 = 0775`` (``drwxrwxr-x``).

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

  1. генерирование уникального псевдослучайного MAC адреса для каждого соединения при загрузке системы (параметр ``stable``). Это избавит от проблем с переподключением к публичным хот-спотам и небходимости повторно проходить аутентификацию в captive-порталах;
  2. генерирование уникального псевдослучайного MAC адреса для каждого соединения при каждом переподключении (параметр ``random``). Наиболее безопасно, но может вызывать описанные выше проблемы.

Профиль **stable**. Файл ``00-macrandomize-stable.conf``:

.. code-block:: ini

    [device]
    wifi.scan-rand-mac-address=yes
    
    [connection]
    wifi.cloned-mac-address=stable
    ethernet.cloned-mac-address=stable
    connection.stable-id=${CONNECTION}/${BOOT}

Профиль **random**. Файл ``00-macrandomize-random.conf``:

.. code-block:: ini

    [device]
    wifi.scan-rand-mac-address=yes
    
    [connection]
    wifi.cloned-mac-address=random
    ethernet.cloned-mac-address=random

Для применения одной из конфигураций создадим в каталоге ``/etc/NetworkManager/conf.d`` файл с выбранным профилем, после чего перезапустим Network Manager:

.. code-block:: text

    sudo systemctl restart NetworkManager

Для отключения рандомизации и возвращения настроек по умолчанию достаточно просто удалить созданный файл и перезапустить Network Manager.

.. index:: ca, certificate, certification authority
.. _add-custom-ca:

Как добавить собственный удостоверяющий центр в список доверенных?
=======================================================================

Для добавления нового удостоверяющего центра необходимо скопировать файл его сертификата в формате PEM или DER в каталог ``/etc/pki/ca-trust/source/anchors``, после чего выполнить:

.. code-block:: text

    sudo update-ca-trust

Следует помнить, что данное действие не будет распространяться на браузер Mozilla Firefox, имеющий собственную базу доверенных корневых УЦ.

.. index:: ca, certificate, certification authority
.. _blackist-ca:

Как внести удостоверяющий центр в список запрещённых?
==========================================================

Для добавления удостоверяющего центра в список заблокированных необходимо скопировать файл его сертификата в формате PEM или DER в каталог ``/etc/pki/ca-trust/source/blacklist``, после чего выполнить:

.. code-block:: text

    sudo update-ca-trust

Следует помнить, что данное действие не будет распространяться на браузер Mozilla Firefox, имеющий собственную базу доверенных корневых УЦ.

.. index:: certificate, private key, decrypt, openssl
.. _openssl-decrypt-key:

Как убрать пароль шифрования закрытого RSA ключа средствами OpenSSL?
======================================================================

Воспользуемся утилитой **openssl** для расшифровки:

.. code-block:: text

    openssl rsa -in foo-bar.key -out foo-bar-nopass.key

Здесь **foo-bar.key** -- имя файла с закрытым RSA ключом, который необходимо расшифровать. После ввода верного пароля, результат появится в файле **foo-bar-nopass.key**.

.. index:: certificate, private key, encrypt, openssl, aes
.. _openssl-encrypt-key:

Как установить или изменить пароль шифрования закрытого RSA ключа средствами OpenSSL?
========================================================================================

Воспользуемся утилитой **openssl** для установки или изменения пароля:

.. code-block:: text

    openssl rsa -aes256 -in foo-bar-nopass.key -out foo-bar.key

Здесь **-aes256** -- используемый алгоритм шифрования (AES-256), **foo-bar-nokey.key** -- имя файла с закрытым RSA ключом, пароль которого нужно задать или изменить. Результат будет сохранён в файле **foo-bar.key**.

.. index:: bash, command, sudo, root
.. _sudo-multi:

Как посредством sudo запустить сразу несколько команд?
==========================================================

Команда :ref:`sudo <sudo-access>` предназначена для запуска исключительно одной команды от имени другого пользователя, поэтому если необходимо запустить сразу несколько команд, либо осуществлять перенаправление вывода, придётся использовать другой вариант:

.. code-block:: text

    sudo bash -c "first | seconds && third"

В данном примере все три приложения будут запущены с правами суперпользователя, причём стандартный вывод *first* перенаправляется в стандартный ввод *second* через канал (pipe) и при успешном завершении запустится процесс *third*.

.. index:: wireshark, root, access rights
.. _wireshark-no-root:

Как запускать WireShark без предоставления ему прав суперпользователя?
==========================================================================

WireShark поддерживает запуска как с правами суперпользователя, так и без них. Добавим свой аккаунт в группу **wireshark**:

.. code-block:: text

    sudo usermod -a -G wireshark $(whoami)

Изменения вступят в силу при следующем входе в систему.

.. index:: password, cli
.. _password-gen:

Как сгенерировать криптостойкий пароль без использования стороннего ПО?
===========================================================================

Для того, чтобы сгенерировать криптостойкий пароль не обязательно устанавливать и применять специальные утилиты.

Воспользуемся штатными средствами, входящими в базовый пакет GNU Coreutils:

.. code-block:: text

    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 4

Данный пример сгенерирует 4 криптостойких пароля по 20 символов каждый.

.. index:: who, login, user
.. _users-logged:

Как получить список вошедших в систему пользователей?
========================================================

Список вошедших в систему пользователей можно получить посредством утилиты **who**:

.. code-block:: text

    who

.. index:: w, login, user
.. _users-activity:

Как получить список вошедших в систему пользователей и информацию об их деятельности?
========================================================================================

Список вошедших в систему пользователей и базовую информацию об их действиях можно получить посредством утилиты **w**:

.. code-block:: text

    w

.. index:: last, login, user
.. _users-last:

Как получить информацию обо всех входах в систему?
=====================================================

Информацию о любых попытках входа в систему можно получить посредством утилиты **last**:

.. code-block:: text

    last

.. index:: com, rs-232, root, access rights, dialout
.. _com-dialout:

Как получить доступ к COM портам без наличия прав суперпользователя?
=======================================================================

Для того, чтобы получить доступ к :ref:`COM порту (RS-232) <screen-com>` без наличия прав суперпользователя, необходимо добавить свой аккаунт в группу **dialout**:

.. code-block:: text

    sudo usermod -a -G dialout $(whoami)

Изменения вступят в силу при следующем входе в систему.

.. index:: gpg, gnupg, password, kwallet, kde
.. _gpg-kwallet:

Можно ли сохранить пароль GnuPG ключа в связке ключей KWallet?
=================================================================

Да. Установим пакет **kwalletcli**:

.. code-block:: text

    sudo dnf install kwalletcli

Откроем файл ``~/.gnupg/gpg-agent.conf`` в текстовом редакторе и добавим строку:

.. code-block:: text

    pinentry-program /usr/bin/pinentry-kwallet

Выполним выход из системы. При следующем вводе пароля расшифровки закрытого ключа, KWallet предложит сохранить его в связке ключей.

.. index:: gpg, gnupg, manager, gui
.. _gpg-gui:

Безопасно ли использовать менеджеры связки ключей GnuPG с графическим интерфейсом?
=====================================================================================

Да.

.. index:: gpg, gnupg, manager, gui, plasma, kde, kleopatra, kgpg
.. _gpg-kleopatra:

Можно ли одновременно использовать Kleopatra и KGpg?
=======================================================

Нет, не следует использовать одновременно разные графические менеджеры, т.к. настройки, вносимые ими в файл конфигурации GnuPG, будут конфликтовать и приводить к непредсказуемым последствиям.

Пользователям KDE мы рекомендуем Kleopatra, как наиболее современную и функциональную оболочку.

.. index:: gpg, gnupg, smart card, token, nitrokey
.. _gpg-token:

Какой токен для безопасного хранения GnuPG ключей вы можете порекомендовать?
===============================================================================

Мы рекомендуем использовать токены `Nitrokey Pro 2 <https://www.nitrokey.com/ru>`__, т.к. они имеют как открытое железо, так и софт (спецификации, прошивки, а также программное обеспечение опубликовано под свободными лицензиями).

.. index:: gpg, gnupg, smart card, token
.. _gpg-use-token:

Как работать с токеном или смарт-картой из консоли?
======================================================

Для работы с аппаратным токеном будем использовать утилиту GnuPG2.

Вставим устройство в USB порт компьютера или ноутбука, либо смарт-карту в считыватель, затем выведем его статус:

.. code-block:: text

    gpg2 --card-status

Установим PIN-код:

.. code-block:: text

    gpg2 --change-pin

Перейдём в режим работы с токеном:

.. code-block:: text

    gpg2 --card-edit

Переключимся в режим администратора:

.. code-block:: text

    admin

Сгенерируем новую связку ключей GnuPG на токене:

.. code-block:: text

    generate

GnuPG2 запросит стандартные данные: имя и адрес электронной почты владельца ключевой пары, срок действия, а также указать стойкость шифра. Следует помнить, что размер памяти токена сильно ограничен, поэтому если генерировать исключительно 4096 битные ключи, место быстро закончится (например Nitrokey Pro 2 вмещает лишь 3 ключевых пары со стойкостью шифра 4096 бит).

Также будет предложено сохранить копию секретного ключа на диск. Для максимальной безопасности лучше отказаться от этого.

Проверим сгенерировались ли ключи:

.. code-block:: text

    list

Если всё сделано верно, то новая ключевая пара появится в списке немедленно.

.. index:: gpg, gnupg, smart card, token, ssh, authentication
.. _gpg-ssh:

Как использовать токен для аутентификации SSH?
=================================================

Сначала нам необходимо добавить в нашу ключевую пару особый ключ для аутентификации. По умолчанию он не создаётся.

Выведем список доступных ключевых пар:

.. code-block:: text

    gpg2 --list-secret-keys

Откроем наш основной ключ в режиме редактирования:

.. code-block:: text

    gpg2 --edit-key XXXXXXXXX

Здесь **XXXXXXXXX** -- ID нашего ключа.

Добавим новый подключ:

.. code-block:: text

    addkey

В списке атрибутов оставим только **Authentication** и обязательно отключим *Encrypt* и *Sign*.

Выберем созданный подключ и переместим его на токен:

.. code-block:: text

    key 2
    keytocard

Экспортируем публичный ключ SSH из созданного подключа для аутентификации:

.. code-block:: text

    gpg2 --export-ssh-key XXXXXXXXX --output ~/.ssh/id_rsa.pub

Здесь **XXXXXXXXX** -- ID нашего ключа.

Активируем поддержку SSH агента в GnuPG агенте, добавив в конец файла ``~/.gnupg/gpg-agent.conf`` следующую строку:

.. code-block:: text

    enable-ssh-support

Настроим автоматический запуск GnuPG агента вместе с системой, создав скрипт ``~/bin/gpg-agent.sh``:

.. code-block:: text

    #!/usr/bin/sh
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent

Выдадим ему права на выполнение:

.. code-block:: text

    chmod +x ~/bin/gpg-agent.sh

Добавим этот скрипт а автозагрузку используемой DE, либо в ``~/.bashrc`` и выполним новый вход в систему.

.. index:: gpg, gnupg, smart card, token, key transfer
.. _gpg-transfer:

Можно ли переместить на токен уже имеющуюся ключевую пару GnuPG?
===================================================================

Да. Выведем список доступных ключевых пар:

.. code-block:: text

    gpg2 --list-secret-keys

Откроем наш основной ключ в режиме редактирования:

.. code-block:: text

    gpg2 --edit-key XXXXXXXXX

Здесь **XXXXXXXXX** -- ID нашего ключа.

Выберем каждый подключ и переместим его на токен:

.. code-block:: text

    key 1
    keytocard

Повторим для всех оставшихся подключей.

**Отключим токен от компьютера или ноутбука**, затем выполним удаление локального секретного ключа:

.. code-block:: text

    gpg2 --delete-secret-key XXXXXXXXX

Здесь **XXXXXXXXX** -- ID нашего ключа.

.. index:: nmap, scanner, vulnerability, hosts
.. _nmap-scan:

Как просканировать хост на наличие работающих сервисов?
===========================================================

Стандартное сканирование самых популярных портов:

.. code-block:: text

    nmap -A -T4 -Pn 127.0.0.1

Стандартное сканирование портов в указанном диапазоне (параметр ``-p 1-100``):

.. code-block:: text

    nmap -A -T4 -Pn -p 1-100 127.0.0.1

Стандартное сканирование всего диапазона портов (параметр ``-p-``):

.. code-block:: text

    nmap -A -T4 -Pn -p- 127.0.0.1

Стандартное сканирование всего диапазона портов, включая UDP (параметр ``-sU``):

.. code-block:: text

    sudo nmap -sU -A -T4 -Pn -p- 127.0.0.1

Сканирование UDP требует прав суперпользователя.

.. index:: luks, encryption, add key, key, cryptsetup
.. _luks-addkey:

Как добавить ключевой файл для разблокировки зашифрованного LUKS раздела?
============================================================================

Создадим каталог для хранения ключей ``/etc/keys`` (может быть любым):

.. code-block:: text

    sudo mkdir -p /etc/keys

Сгенерируем ключевой файл ``foo-bar.key`` размером 4 КБ на основе системного генератора псевдослучайных чисел:

.. code-block:: text

    sudo dd if=/dev/urandom of=/etc/keys/foo-bar.key bs=1024 count=4

Установим корректные права доступа:

.. code-block:: text

    sudo chown root:root /etc/keys/foo-bar.key
    sudo chmod 0400 /etc/keys/foo-bar.key

Добавим ключ в свободный слот LUKS заголовка зашифрованного раздела:

.. code-block:: text

    sudo cryptsetup luksAddKey /dev/sda2 /etc/keys/foo-bar.key

Утилита cryptsetup запросит ввод мастер-пароля.

Здесь **/dev/sda2** -- устройство зашифрованного LUKS тома, для которого требуется добавить ключевой файл.

.. index:: luks, encryption, remove key, key, cryptsetup
.. _luks-removekey:

Как удалить ключевой файл разблокировки зашифрованного LUKS раздела?
=======================================================================

Если разблокировка по ключевому файлу более не требуется, его можно удалить.

Удалим слот с ключом ``foo-bar.key`` из LUKS заголовка зашифрованного раздела:

.. code-block:: text

    sudo cryptsetup luksRemoveKey /dev/sda2 /etc/keys/foo-bar.key

Надёжно :ref:`уничтожим <destroy-file>` ключевой файл:

.. code-block:: text

    sudo shred -u -v /etc/keys/foo-bar.key

Здесь **/dev/sda2** -- устройство зашифрованного LUKS тома, у которого требуется удалить слот с ключевым файлом.

.. index:: luks, encryption, key, cryptsetup, fstab, crypttab
.. _luks-auto:

Как настроить автоматическую расшифровку LUKS разделов при загрузке?
=======================================================================

Откроем файл ``/etc/crypttab`` в :ref:`редакторе по умолчанию <editor-selection>`:

.. code-block:: text

    sudoedit /etc/crypttab

Добавим в конец файла строку вида:

.. code-block:: text

    foo-bar UUID=XXXXXX /etc/keys/foo-bar.key luks

Здесь **foo-bar** -- внутреннее имя, которое будет использоваться dev-mapper, **XXXXXX** -- :ref:`UUID диска <get-uuid>`, **/etc/keys/foo-bar.key** -- полный путь к :ref:`ключевому файлу <luks-addkey>`. При шифровании :ref:`SSD накопителя <get-uuid>` вместо параметра **luks** следует использовать **discard**.

Откроем файл ``/etc/fstab``:

.. code-block:: text

    sudoedit /etc/fstab

Добавим в конец строку вида:

.. code-block:: text

    /dev/mapper/foo-bar /media/data ext4 defaults 1 2

Здесь **foo-bar** -- внутреннее имя, указанное ранее в crypttab, **/media/data** -- точка монтирования, а **ext4** -- используемая файловая система.

Если всё сделано верно, то при следующей загрузке раздел будет смонтирован автоматически без запроса пароля.

.. index:: root, password, restore, recovery
.. _root-reset:

Я забыл пароль суперпользователя. Как мне его сбросить?
==========================================================

При наличии доступа к sudo, пароль суперпользователя можно изменить :ref:`в штатном режиме <root-password>`.

Если текущий пользователь не может использовать sudo, но есть физический доступ к устройству, см. `здесь <https://docs.fedoraproject.org/en-US/quick-docs/reset-root-password/>`__.

.. index:: luks, encryption, key, cryptsetup, crypttab
.. _luks-noauto:

Можно ли отключить автоматическое монтирование устройств LUKS при загрузке?
==============================================================================

Да. Для этого добавим параметр ``noauto`` для соответствующей записи в файле ``/etc/crypttab``:

.. code-block:: text

    foo-bar UUID=XXXXXX /etc/keys/foo-bar.key noauto

Здесь **foo-bar** -- внутреннее имя, которое будет использоваться dev-mapper, **XXXXXX** -- :ref:`UUID диска <get-uuid>`, **/etc/keys/foo-bar.key** -- полный путь к :ref:`ключевому файлу <luks-addkey>`. Параметр **noauto** должен применяться только совместно с ключом.

Данное зашифрованное устройство будет смонтировано и автоматически расшифровано при первой попытке доступа к нему.

.. index:: encryption, cryptsetup, truecrypt, veracrypt
.. _truecrypt-fedora:

Как работать с TrueCrypt контейнерами в Fedora?
==================================================

Из-за :ref:`несвободной лицензии <fedora-licenses>` TrueCrypt и все его форки (в т.ч. VeraCrypt) не могут быть добавлены в репозитории Fedora, однако в настоящее время утилита **cryptsetup** полностью поддерживает работу с созданными ими контейнерами.

Cryptsetup поддерживает монтирование как :ref:`TrueCrypt <truecrypt-mount>`, так и :ref:`VeraCrypt <veracrypt-mount>` томов (файлы и устройства), а также умеет их администрировать (управлять ключами, паролями). Ограничение лишь одно -- нельзя создавать новые зашифрованные данными механизмами контейнеры.

.. index:: encryption, cryptsetup, truecrypt, mount
.. _truecrypt-mount:

Как смонтировать TrueCrypt контейнер в Fedora?
=================================================

Откроем файл контейнера средствами cryptsetup:

.. code-block:: text

    sudo cryptsetup --type tcrypt open /path/to/container.tc foo-bar

Смонтируем файловую систему:

.. code-block:: text

    sudo mkdir /media/data
    sudo mount -t auto /dev/mapper/foo-bar /media/data

По окончании работы произведём размонтирование:

.. code-block:: text

    sudo umount /media/data
    sudo rmdir /media/data

Закроем файл контейнера:

.. code-block:: text

    sudo cryptsetup --type tcrypt close /dev/mapper/foo-bar

Здесь **/path/to/container.tc** полный путь к файлу контейнера на диске (либо зашифрованному устройству), а **foo-bar** -- внутреннее имя для dev-mapper.

.. index:: encryption, cryptsetup, veracrypt, mount
.. _veracrypt-mount:

Как смонтировать VeraCrypt контейнер в Fedora?
=================================================

Откроем файл контейнера средствами cryptsetup:

.. code-block:: text

    sudo cryptsetup --veracrypt --type tcrypt open /path/to/container.hc foo-bar

Смонтируем файловую систему:

.. code-block:: text

    sudo mkdir /media/data
    sudo mount -t auto /dev/mapper/foo-bar /media/data

По окончании работы произведём размонтирование:

.. code-block:: text

    sudo umount /media/data
    sudo rmdir /media/data

Закроем файл контейнера:

.. code-block:: text

    sudo cryptsetup --veracrypt --type tcrypt close /dev/mapper/foo-bar

Здесь **/path/to/container.hc** полный путь к файлу контейнера на диске (либо зашифрованному устройству), а **foo-bar** -- внутреннее имя для dev-mapper.

.. index:: encryption, cryptsetup, fstab, crypttab, veracrypt, truecrypt
.. _veracrypt-auto:

Как настроить автоматическое монтирование VeraCrypt томов при загрузке?
===========================================================================

Откроем файл ``/etc/crypttab`` в :ref:`редакторе по умолчанию <editor-selection>`:

.. code-block:: text

    sudoedit /etc/crypttab

Добавим в конец файла строку вида:

.. code-block:: text

    foo-bar UUID=XXXXXX /etc/keys/foo-bar.key tcrypt-veracrypt

Здесь **foo-bar** -- внутреннее имя, которое будет использоваться dev-mapper, **XXXXXX** -- :ref:`UUID диска <get-uuid>`, либо полный путь к файлу контейнера, **/etc/keys/foo-bar.key** -- полный путь к ключевому файлу, либо файлу с паролем (разрыв строки в конце файла не ставится).

Откроем файл ``/etc/fstab``:

.. code-block:: text

    sudoedit /etc/fstab

Добавим в конец строку вида:

.. code-block:: text

    /dev/mapper/foo-bar /media/data auto defaults,x-systemd.automount 0 0

Здесь **foo-bar** -- внутреннее имя, указанное ранее в crypttab, а **/media/data** -- точка монтирования.

Если всё сделано верно, то при следующей загрузке зашифрованный VeraCrypt том будет смонтирован автоматически.

.. index:: encryption, cryptsetup, bitlocker
.. _bitlocker-fedora:

Как работать с BitLocker контейнерами в Fedora?
===================================================

Начиная с версии 2.3.0 утилита **cryptsetup** поддерживает работу с зашифрованными BitLocker томами.

Допускается :ref:`монтирование <bitlocker-mount>`, базовые операции с ними, но не создание новых.

.. index:: encryption, cryptsetup, bitlocker, mount
.. _bitlocker-mount:

Как смонтировать BitLocker контейнер в Fedora?
==================================================

Откроем устройство, зашифрованное BitLocker, средствами cryptsetup:

.. code-block:: text

    sudo cryptsetup --type bitlk open /dev/sdX1 foo-bar

Смонтируем файловую систему:

.. code-block:: text

    sudo mkdir /media/data
    sudo mount -t auto /dev/mapper/foo-bar /media/data

По окончании работы произведём размонтирование:

.. code-block:: text

    sudo umount /media/data
    sudo rmdir /media/data

Закроем файл контейнера:

.. code-block:: text

    sudo cryptsetup --type bitlk close /dev/mapper/foo-bar

Здесь **/dev/sdX1** -- зашифрованное BitLocker устройство, а **foo-bar** -- внутреннее имя для dev-mapper.

.. index:: encryption, cryptsetup, fstab, crypttab, bitlocker
.. _bitlocker-auto:

Как настроить автоматическое монтирование BitLocker томов при загрузке?
===========================================================================

Откроем файл ``/etc/crypttab`` в :ref:`редакторе по умолчанию <editor-selection>`:

.. code-block:: text

    sudoedit /etc/crypttab

Добавим в конец файла строку вида:

.. code-block:: text

    foo-bar UUID=XXXXXX /etc/keys/foo-bar.key bitlk

Здесь **foo-bar** -- внутреннее имя, которое будет использоваться dev-mapper, **XXXXXX** -- :ref:`UUID диска <get-uuid>`, **/etc/keys/foo-bar.key** -- полный путь к ключевому файлу, либо файлу с паролем (разрыв строки в конце файла не ставится).

Откроем файл ``/etc/fstab``:

.. code-block:: text

    sudoedit /etc/fstab

Добавим в конец строку вида:

.. code-block:: text

    /dev/mapper/foo-bar /media/data auto defaults,x-systemd.automount 0 0

Здесь **foo-bar** -- внутреннее имя, указанное ранее в crypttab, а **/media/data** -- точка монтирования.

Если всё сделано верно, то при следующей загрузке зашифрованный BitLocker том будет смонтирован автоматически.

.. index:: selinux, context, storage
.. _selinux-local-storage:

Где хранятся установленные пользователем контексты SELinux?
==============================================================

Заданные пользователем нестандартные контексты, а также переопределения хранятся внутри каталога ``/etc/selinux/targeted/contexts/files`` в следующих файлах:

  * ``file_contexts.local`` -- текстовый формат;
  * ``file_contexts.local.bin`` -- скомпилированный бинарный формат.

Не следует их править в текстовых, либо шестнадцатиричных редакторах, т.к. это может привести к сбою в политиках SELinux и сбросу настроек по умолчанию. Вместо этого необходимо использовать :ref:`инструмент semanage <selinux-local-remove>`.

.. index:: selinux, context, semanage
.. _selinux-local-list:

Как получить список установленных пользователем контекстов SELinux?
======================================================================

Выведем полный список нестандартных контекстов, а также переопределений политик SELinux:

.. code-block:: text

    sudo semanage fcontext --list -C

.. index:: selinux, context, semanage
.. _selinux-local-remove:

Как удалить пользовательские контексты SELinux?
===================================================

Удалим конкретный нестандартный контекст, либо переопределение политик SELinux:

.. code-block:: text

    sudo semanage fcontext -d "/foo/bar(/.*)?"

Удалим все нестандартный контексты, а также переопределения политик SELinux:

.. code-block:: text

    sudo semanage fcontext -D

Для полного вступления изменений в силу рекомендуется :ref:`сбросить контекст <selinux-boot-error>` SELinux.

.. index:: encryption, cryptsetup, luks, container, cryptography
.. _luks-container-create:

Как создать зашифрованный контейнер на диске?
================================================

При помощи утилиты **dd** создадим пустой файл для хранения криптоконтейнера размером в 1 ГБ:

.. code-block:: text

    sudo dd if=/dev/zero bs=1M count=1024 of=/media/data/foo-bar.dat

Минимальный размер создаваемого образа должен быть не меньше 32 МБ, т.к. противном случае возникнет ошибка *Requested offset is beyond real size of device*.

Здесь **/media/data/foo-bar.dat** -- полный путь к файлу на диске.

Создадим зашифрованный LUKS контейнер:

.. code-block:: text

    sudo cryptsetup --verify-passphrase luksFormat /media/data/foo-bar.dat -c aes-xts-plain64 -s 256 -h sha512

Подтвердим процесс создания посредством набора на клавиатуре **YES** в верхнем регистре, затем укажем пароль, который будет использоваться для шифрования.

Загрузим контейнер и расшифруем содержимое:

.. code-block:: text

    sudo cryptsetup luksOpen /media/data/foo-bar.dat foo-bar

Создадим файловую систему ext4:

.. code-block:: text

    sudo mkfs -t ext4 -m 1 -L foo-bar /dev/mapper/foo-bar

Завершим сеанс работы с контейнером:

.. code-block:: text

    sudo cryptsetup luksClose /dev/mapper/foo-bar

.. index:: encryption, cryptsetup, luks, container, cryptography
.. _luks-container-mount:

Как смонтировать зашифрованный файловый контейнер?
=====================================================

Загрузим :ref:`криптоконтейнер <luks-container-create>` и расшифруем содержимое:

.. code-block:: text

    sudo cryptsetup luksOpen /media/data/foo-bar.dat foo-bar

Создадим каталог для точки монтирования:

.. code-block:: text

    sudo mkdir /media/foo-bar

Смонтируем файловую систему:

.. code-block:: text

    sudo mount -t auto /dev/mapper/foo-bar /media/foo-bar

По окончании работы произведём размонтирование:

.. code-block:: text

    sudo umount /media/foo-bar

Удалим каталог точки монтирования:

.. code-block:: text

    sudo rmdir /media/foo-bar

Завершим сеанс работы с контейнером:

.. code-block:: text

    sudo cryptsetup luksClose /dev/mapper/foo-bar

.. index:: luks, encryption, key, cryptsetup, wipe, erasing
.. _luks-erase:

Как быстро уничтожить содержимое LUKS контейнера?
=====================================================

Быстро и безопасно уничтожим ключи шифрования заголовка LUKS-контейнера:

.. code-block:: text

    sudo cryptsetup luksErase /dev/sdX1

Здесь **/dev/sdX1** -- зашифрованный раздел диска, данные с которого требуется уничтожить. Он не должен быть смонтирован. Ввод пароля не требуется.

После выполнения данного действия все ключевые слоты LUKS-контейнера будут заполнены нулями и доступ к данным, хранящимся на данном разделе, станет невозможен даже при знании верного пароля или наличии ключа.

Внимание! Это действие не затирает содержимое физически, поэтому после его использования рекомендуется :ref:`осуществить эту процедуру <destroy-disk>` самостоятельно.

.. index:: luks, encryption, tpm, cryptsetup
.. _luks-tpm:

Можно ли использовать TPM для разблокировки LUKS контейнера?
===============================================================

См. `здесь <https://www.easycoding.org/2019/09/24/avtomaticheski-razblokiruem-luks-diski-pri-pomoshhi-tpm.html>`__.

.. index:: selinux, samba, smb
.. _selinux-samba:

Как настроить работу Samba с SELinux?
========================================

См. `здесь <https://fedoraproject.org/wiki/SELinux/samba>`__.

.. index:: ssh, mitm, dns, protection
.. _ssh-mitm-protection:

Как защитить SSH от возможных MITM-атак?
============================================

Для защиты от MITM-атак в протоколе SSH применяется проверка отпечатков публичного ключа сервера в момент установки рукопожатия с эталоном, сохранённым на клиенте.

Во время первого подключения пользователю предлагается проверить отпечаток сервера и либо разрешить, либо отклонить соединение.

После одобрения, они вместе с IP-адресом сохраняются в файле ``~/.ssh/known_hosts`` и при следующих подключениях проверяется их действительность. В случае изменения, например из-за проведения злоумышленником атаки "человек посередине", соединение не устанавливается, а пользователю выводится соответствующее сообщение об ошибке.

К сожалению, ручная проверка отпечатка мало кем производится, поэтому был придуман новый, более надёжный способ -- размещение публичных ключей в виде особых **SSHFP** записей DNS.

При использовании данного метода, при подключении будет проверяться соответствие ключей, полученных от сервера, записям из SSHFP для конкретного домена. При этом конечно же необходимо использовать надёжные DNS-резолверы с поддержкой шифрования :ref:`DNS-over-TLS <dns-crypt>`, а также рекомендуется подписать DNS-зону `DNSSEC <https://ru.wikipedia.org/wiki/DNSSEC>`__.

С помощью утилиты **ssh-keygen**, на сервере сгенерируем DNS-записи для домена **example.org**:

.. code-block:: text

    ssh-keygen -r example.org

Добавим их в настройки DNS через панель управления регистратора домена или хостера и подождём несколько часов до полной синхронизации между серверами.

Проверим корректность SSHFP-записей:

.. code-block:: text

    dig +nocmd +noquestion +nostats +noheader SSHFP example.org

Если всё верно, активируем работу функции на каждом SSH-клиенте, добавив в файл ``~/.ssh/config`` следующие строки:

.. code-block:: text

    Host example
        HostName example.org
        Port 22
        User user
        VerifyHostKeyDNS yes

Подключимся к серверу **по доменному имени** (в случае использования прямого IP-адреса, будет выполняться классическая проверка по файлу **known_hosts**):

.. code-block:: text

    ssh example

.. index:: luks, encryption, cryptsetup
.. _luks-version:

Как определить версию LUKS конкретного криптоконтейнера?
============================================================

Версия LUKS всегда указана в разделе **Version** :ref:`информации о шифровании <luks-info>`.

.. index:: luks, encryption, cryptsetup
.. _luks-upgrade:

Можно ли изменить используемую криптоконтейнером версию LUKS?
================================================================

Нет. Для изменения :ref:`версии <luks-version>` с LUKS1 на LUKS2 требуется пересоздать криптоконтейнер.

.. index:: luks, encryption, trim, cryptsetup
.. _luks-trim-open:

Как активировать TRIM для открытых вручную LUKS-контейнеров?
================================================================

Зашифрованные :ref:`LUKS-контейнеры <luks-container-create>`, открытые вручную при помощи ``cryptsetup open``, по умолчанию не будут поддерживать :ref:`процедуру TRIM <ssd-trim>`, поэтому рассмотрим несколько способов исправить это.

**Способ 1.** Передадим :ref:`параметр ядра <kernelpm-perm>` Linux ``rd.luks.options=discard``.

Теперь все контейнеры, открытые утилитой, будут поддерживать TRIM. Однако действие не распространяется на указанные в файле ``/etc/crypttab``, т.к. он имеет более высокий приоритет.

**Способ 2.** Воспользуемся параметром командной строки ``--allow-discards``.

LUKS :ref:`версии 2 <luks-version>` поддерживает возможность принудительно задать использование процедуры TRIM внутри контейнера при любых операциях монтирования. В LUKS1 это не реализовано и поэтому работать не будет.

Для LUKS1 (вводится при каждом открытии тома):

.. code-block:: text

    sudo cryptsetup --allow-discards open /path/to/container foo-bar

Для LUKS2 (вводится только один раз):

.. code-block:: text

    sudo cryptsetup --allow-discards --persistent open /path/to/container foo-bar

Убедимся, что в :ref:`информации о шифровании <luks-info>`, в разделе **Flags**, появился **allow-discards**.

.. index:: luks, encryption, trim, cryptsetup
.. _luks-trim-execute:

Как выполнить TRIM для открытых вручную LUKS-контейнеров?
==============================================================

Функция автоматической очистки неиспользуемые данных TRIM выполняется либо в :ref:`реальном времени <ssd-trim>`, либо :ref:`по таймеру <ssd-timer>`, но только для автоматически смонтированных и указанных в файле ``/etc/crypttab`` разделов.

Для зашифрованных :ref:`LUKS-контейнеров <luks-container-create>`, открытых вручную при помощи ``cryptsetup open``, её необходимо сначала :ref:`активировать <luks-trim-open>`, а затем периодически запускать утилиту ``fstrim``:

.. code-block:: text

    sudo fstrim -v /media/foo-bar

Здесь **/media/foo-bar** -- это точка монтирования.

.. index:: network, internet, unshare
.. _app-disable-network:

Как запретить приложению доступ к сети?
===========================================

Иногда возникает необходимость ограничить какому-либо приложению доступ к сети Интернет.

Установим ограничение пространствами имён ядра (более подробную информацию о них можно получить в ``man namespaces``) при помощи утилиты **unshare**:

.. code-block:: text

    unshare -r -n foo-bar

Здесь вместо **foo-bar** укажем приложение, которое требуется запустить.
