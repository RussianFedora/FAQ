.. _using-system:

*************************************************************
Вопросы, связанные с работой в системе и администрированием
*************************************************************

.. index:: автодополнение
.. _autocompletion:

У меня в системе не работает автодополнение команд. Как исправить?
=====================================================================

Необходимо установить пакет sqlite:

.. code-block:: bash

    sudo dnf install sqlite

При определённых условиях он может не быть установлен и из-за этого система автоматического дополнения команд может перестать функционировать.

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

Также можно воспользоваться утилитой fpaste для автоматической загрузки файла на сервис `fpaste.org <https://paste.fedoraproject.org/>`_:

.. code-block:: bash

    journalctl -b | fpaste

При успешном выполнении будет создана ссылка для быстрого доступа.

.. index:: резервное копирование, backup
.. _backup-system:

Можно ли делать резервную копию корневого раздела работающей системы?
=========================================================================

Настоятельно не рекомендуется из-за множества работающих виртуальных файловых систем и псевдофайлов в **/sys**, **/dev**, **/proc** и т.д.

.. index:: резервное копирование, backup
.. _backup-home:

Как сделать копию домашнего каталога?
=========================================

См. `здесь <https://www.easycoding.org/2017/09/03/avtomatiziruem-rezervnoe-kopirovanie-v-fedora.html>`_.

.. index:: резервное копирование, backup
.. _backup-create:

Как лучше всего делать резервную копию корневого раздела?
=============================================================

Необходимо загрузиться с LiveCD или LiveUSB, смонтировать раздел с корневой файловой системой и выполнить:

.. code-block:: bash

    sudo tar --one-file-system --selinux \
    --exclude="$bdir/tmp/*" \
    --exclude="$bdir/var/tmp/*" \
    -cvJpf /путь/к/бэкапу.tar.xz -C /путь/к/корню .

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

.. index:: initrd, пересобрать initrd
.. _initrd-rebuild:

Как мне пересобрать образ initrd?
====================================

Для пересборки образа initrd следует выполнить:

.. code-block:: bash

    sudo dracut -f

.. index:: boot, загрузчик, grub
.. _grub-reinstall:

Как мне переустановить Grub 2?
====================================

См. `здесь <https://fedoraproject.org/wiki/GRUB_2>`_.

.. index:: boot, загрузчик, grub
.. _grub-rebuild:

Как пересобрать конфиг Grub 2?
====================================

Пересборка конфига Grub 2 для legacy конфигураций:

.. code-block:: bash

    sudo grub2-mkconfig -o /boot/grub2/grub.cfg

Пересборка конфигра Grub 2 для UEFI конфигураций:

.. code-block:: bash

    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

.. index:: drivers, драйверы, nut, UPS, ИБП
.. _configure-ups:

Как настроить ИБП (UPS) в Fedora?
====================================

См. `здесь <https://www.easycoding.org/2012/10/01/podnimaem-nut-v-linux.html>`_.

.. index:: ssh, keys, error, ошибка
.. _ssh-keys-error:

При использовании SSH появляется ошибка доступа к ключам. Как исправить?
===========================================================================

См. `здесь <https://www.easycoding.org/2016/07/31/reshaem-problemu-s-ssh-klyuchami-v-fedora-24.html>`_.

.. index:: slow shutdown, медленное завершение работы
.. _slow-shutdown:

Система медленно завершает работу. Можно ли это ускорить?
============================================================

См. `здесь <https://www.easycoding.org/2016/08/08/uskoryaem-zavershenie-raboty-fedora-24.html>`_.

.. index:: journald, журналы, ограничение размера журналов
.. _journald-limit:

Системные журналы занимают слишком много места. Как их ограничить?
=====================================================================

См. `здесь <https://www.easycoding.org/2016/08/24/ogranichivaem-sistemnye-zhurnaly-v-fedora-24.html>`_.

.. index:: firewalld, port forwarding, проброс порта
.. _firewalld-port-forwarding:

Как пробросить локальный порт на удалённый хост?
====================================================

См. `здесь <https://www.easycoding.org/2017/05/23/probrasyvaem-lokalnyj-port-na-udalyonnyj-xost.html>`_.

.. index:: openvpn
.. _using-openvpn:

Как поднять OpenVPN сервер в Fedora?
=======================================

См. `здесь <https://www.easycoding.org/2017/07/24/podnimaem-ovn-server-na-fedora.html>`_. В данной статье вместо **ovn** следует использовать **openvpn** во всех путях и именах юнитов.

.. index:: systemd
.. _systemd-info:

Что такое systemd и как с ним работать?
==========================================

См. `здесь <https://www.easycoding.org/2017/11/05/upravlyaem-systemd-v-fedora.html>`_.

.. index:: bug, missing library, libcurl-gnutls
.. _libcurl-workaround:

Как решить проблему с отсутствием библиотеки libcurl-gnutls.so.4?
=====================================================================

См. `здесь <https://www.easycoding.org/2018/04/03/reshaem-problemu-otsutstviya-libcurl-gnutls-v-fedora.html>`_.

.. index:: server, matrix, сервер
.. _matrix-server:

Как поднять свой сервер Matrix в Fedora?
===========================================

См. `здесь <https://www.easycoding.org/2018/04/15/podnimaem-sobstvennyj-matrix-server-v-fedora.html>`_.

.. index:: firefox, hardware acceleration
.. _firefox-hwaccel:

Как активировать аппаратное ускорение в браузере Firefox?
=============================================================

ля активации аппаратного ускорения рендеринга страниц в Mozilla Firefox на поддерживаемых драйверах необходимо открыть модуль конфигурации **about:config** и исправить значения следующих переменных (при отсутствии создать):

.. code-block:: text

    layers.acceleration.force-enabled = true
    layers.offmainthreadcomposition.enabled = true
    webgl.force-enabled = true
    gfx.xrender.enabled = true

Изменения вступят в силу при следующем запуске браузера.

Внимание! Это не затрагивает аппаратное декодирование мультимедиа средствами видеоускорителя, которое в настоящее время не поддерживается ни в Firefox, ни в Chrome на ОС Linux.

.. index:: gdb, debugging, отладка
.. _debug-application:

Приложение падает. Как мне его отладить?
===========================================

Для начала рекомендуется (хотя и не обязательно) установить отладочную информацию для данного пакета:

.. code-block:: bash

    sudo dnf debuginfo-install foo-bar

После завершения процесса отладки символы можно снова удалить.

Чтобы получить бэктрейс падения, нужно выполнить в терминале:

.. code-block:: bash

    gdb /usr/bin/foo-bar 2>&1 | tee ~/backtrace.log

Далее в интерактивной консоли отладчика ввести: **handle SIGPIPE nostop noprint** и затем **run**, дождаться сегфолта и выполнить **bt full** для получения бэктрейса. Теперь можно прописать **quit** для выхода из режима отладки.

Далее получившийся файл **~/backtrace.log** следует загрузить на любой сервис размещения текстовых файлов.

Также рекомендуется ещё сделать трассировку приложения до момента падения:

.. code-block:: bash

    strace -o ~/trace.log /usr/bin/foo-bar

Полученный файл **~/trace.log** также следует загрузить на сервис.

.. index:: fs, caches, сброс кэшей ФС
.. _drop-fs-caches:

Как очистить кэши и буферы всех файловых систем?
===================================================

Чтобы очистить кэши и буферы нужно выполнить:

.. code-block:: bash

    sync && echo 3 > /proc/sys/vm/drop_caches && sync
