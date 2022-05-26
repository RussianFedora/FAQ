..
    SPDX-FileCopyrightText: 2018-2022 EasyCoding Team and contributors

    SPDX-License-Identifier: CC-BY-SA-4.0

.. _tips-and-tricks:

******************************
Оптимизация и тонкая настройка
******************************

.. index:: gnome, ram, optimizations
.. _gnome-reduce-ram-usage:

Как уменьшить потребление оперативной памяти средой рабочего стола GNOME 3?
==============================================================================

Отключим службу автоматической регистрации ошибок и удалим GUI апплет, уведомляющий об их возникновении:

.. code-block:: text

    sudo dnf remove abrt

Удалим Магазин приложений (графический менеджер пакетов):

.. code-block:: text

    sudo dnf remove PackageKit gnome-software

Отключим службу управления виртуализацией (если на установленной системе не предполагается использовать виртуальные машины):

.. code-block:: text

    sudo systemctl disable libvirtd

Отключим службы Evolution, необходимые для синхронизации онлайн аккаунтов:

.. code-block:: text

    systemctl --user mask evolution-addressbook-factory evolution-calendar-factory evolution-source-registry

Отключим службы, необходимые для создания индекса файловой системы, необходимого для быстрого поиска (если не предполагается использовать поиск в главном меню):

.. code-block:: text

    systemctl --user mask tracker-miner-apps tracker-miner-fs tracker-store

.. index:: kde, ram, optimizations
.. _kde-reduce-ram-usage:

Как уменьшить потребление оперативной памяти средой рабочего стола KDE?
===========================================================================

Отключим службу индексации файлов. Для этого зайдём в **Параметры системы** -- **Поиск**, снимем флажок из чекбокса **Включить службы поиска файлов** и нажмём **Применить**. Теперь удалим Akonadi:

.. code-block:: text

    sudo dnf remove akonadi

Удалим устаревшие библиотеки Qt4 и службу автоматической регистрации ошибок ABRT:

.. code-block:: text

    sudo dnf remove qt abrt

Удалим Магазин приложений (графический менеджер пакетов):

.. code-block:: text

    sudo dnf remove PackageKit plasma-discover dnfdragora

Удалим runtime библиотеки для экономии ОЗУ (при этом по зависимостям будут удалены некоторые приложения, например KMail и KOrganizer):

.. code-block:: text

    sudo dnf remove kdepim-runtime-libs kdepim-apps-libs

Удалим :ref:`KDE Connect <kde-connect>` (если не планируется управлять смартфоном с компьютера и наоборот):

.. code-block:: text

    sudo dnf remove kde-connect kdeconnectd

Опционально удалим библиотеки GTK2 (в то же время от них до сих пор зависят многие популярные приложения, например Audacious, GIMP, Thunderbird):

.. code-block:: text

    sudo dnf remove gtk2

.. index:: bug, missing library, libcurl-gnutls
.. _kde-wipe-unused:

Как максимально очистить KDE от неиспользуемых программ?
===========================================================

1. Произведём стандартную очистку по :ref:`описанному выше <kde-reduce-ram-usage>` сценарию.
2. Удалим оставшиеся редко используемые пакеты:

.. code-block:: text

    sudo dnf remove krdc dragon kontact ktorrent kget konversation konqueror falkon kmail krusader krfb akregator juk kamoso k3b calligra\* kfind kgpg kmouth kmag

.. index:: bug, missing library, libcurl-gnutls
.. _libcurl-workaround:

Как решить проблему с отсутствием библиотеки libcurl-gnutls.so.4?
=====================================================================

См. `здесь <https://www.easycoding.org/2018/04/03/reshaem-problemu-otsutstviya-libcurl-gnutls-v-fedora.html>`__.

.. index:: bfq, hdd, optimizations, scheduler, kernel, udev, udevadm
.. _bfq-scheduler:

Как задействовать планировщик ввода/вывода BFQ для HDD?
==========================================================

BFQ -- это планировщик ввода-вывода (I/O), предназначенный для повышения отзывчивости пользовательского окружения при значительных нагрузках на дисковую подсистему.

Проверим, какой из планировщиков :ref:`используется в данный момент <io-scheduler>`. Если это не BFQ, произведём редактирование файла шаблонов GRUB:

.. code-block:: text

    sudoedit /etc/default/grub

В конец строки ``GRUB_CMDLINE_LINUX=`` добавим ``scsi_mod.use_blk_mq=1``, после чего :ref:`сгенерируем новую конфигурацию GRUB <grub-rebuild>`.

Создадим новое правило udev для принудительной активации BFQ для любых жёстких дисков:

.. code-block:: text

    sudo bash -c "echo 'ACTION==\"add|change\", KERNEL==\"sd[a-z]\", ATTR{queue/rotational}==\"1\", ATTR{queue/scheduler}=\"bfq\"' >> /etc/udev/rules.d/60-ioschedulers.rules"

Применим изменения в :ref:`политиках udev <udev-rules-reload>`:

.. code-block:: text

    sudo udevadm control --reload

Выполним перезагрузку системы:

.. code-block:: text

    sudo systemctl reboot

.. index:: swf, flash, player, projector
.. _swf-player:

Чем можно запустить SWF файл без установки Flash плагина в браузер?
======================================================================

SWF файл -- это исполняемый файл формата Adobe Flash. Для того, чтобы проиграть его без установки соответствующего плагина в браузер, можно загрузить специальную версию Flash Projector (ранее назывался Standalone).

Скачаем Projector:

.. code-block:: text

    wget https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux.x86_64.tar.gz -O fpsa.tar.gz

Создадим новый каталог и распакуем архив в него:

.. code-block:: text

    mkdir -p ~/foo-bar
    tar -xzf fpsa.tar.gz -C ~/foo-bar

Запустим проигрыватель:

.. code-block:: text

    ~/foo-bar/flashplayer

В открывшемся окне нажмём **Файл** -- **Открыть** (или комбинацию **Ctrl + O**) и найдём SWF файл на диске.

По окончании использования удалим каталог с программой:

.. code-block:: text

    rm -rf ~/foo-bar

Внимание! Запускать SWF файлы следует с особой осторожностью, т.к. плеер выполняется без какой-либо изоляции и имеет полный доступ к домашнему каталогу пользователя.

.. index:: python, python2, remove
.. _python2-remove:

Можно ли удалить Python 2 из системы?
========================================

Да. Поскольку поддержка Python версии 2 была прекращена 01.01.2020, его уже не рекомендуется использовать. Вместо него следует применять Python 3. Большая часть активных проектов и библиотек уже давно были портированы на эту версию.

Возможность полностью избавиться от Python 2 появилась у пользователей Fedora 30 и выше. От данной версии интерпретатора более не зависят важные компоненты и его можно смело удалить:

.. code-block:: text

    sudo dnf remove python2

Это действие автоматически удалит и все его зависимости.

.. index:: fs, mount, options, fstab
.. _fs-noexec:

Как запретить возможность исполнения любых файлов из домашнего каталога?
===========================================================================

Для максимальной безопасности можно запретить запуск любых исполняемых файлов, а также загрузку динамических библиотек из домашнего каталога.

Откроем файл ``/etc/fstab`` в :ref:`текстовом редакторе <editor-selection>`:

.. code-block:: text

    sudoedit /etc/fstab

Добавим в опции монтирования домашнего каталога флаги ``noexec,nodev,nosuid`` после ``defaults``.

Пример итоговой строки после внесения изменений:

.. code-block:: text

    UUID=XXXXXXXXXX /home ext4 defaults,noexec,nodev,nosuid 1 2

Здесь **XXXXXXXXXX** -- :ref:`UUID раздела <get-uuid>`, а **ext4** -- используемая :ref:`файловая система <fs-selection>`.

Следует помнить, что это действие не повлияет на запуск различных скриптов интерпретаторами, т.е. запуск ``./foo-bar`` с установленным битом исполнения будет запрещён, но в то же время ``bash foo-bar`` выполнится в штатном режиме.

.. index:: fonts, msttcorefonts, corefonts
.. _msttcorefonts:

Как установить шрифты Microsoft в Fedora?
=============================================

См. `здесь <https://www.easycoding.org/2011/08/14/ustanovka-microsoft-core-fonts-v-fedora.html>`__.

.. index:: boot, emergency, shell, root
.. _eshell-error:

При загрузке режима восстановления появляется ошибка root account is locked. Как исправить?
===============================================================================================

Ошибка *Cannot open access to console, the root account is locked* появляется при запуске системы в режиме восстановления в том случае если при установке Fedora был создан :ref:`пользователь-администратор <admin-vs-user>` и не был задан пароль для учётной записи суперпользователя.

Таким образом, при недоступности раздела /home, войти в систему в emergency режиме не представляется возможным, т.к. отсутствуют пользователи с доступными профилями (суперпользователь заблокирован, а обычные пользовательские учётные записи отключены из-за отсутствия доступа к их домашним каталогам).

Решим данную проблему посредством загрузки с :ref:`Fedora LiveUSB <usb-flash>`, выполнением :ref:`chroot <chroot>` в установленную систему и :ref:`установкой пароля для root <root-password>`:

.. code-block:: text

    passwd root

Завершим работу chroot окружения:

.. code-block:: text

    logout

При следующей загрузке работа режима восстановления будет полностью восстановлена.

.. index:: zram, memory compression, ram, memory
.. _zram-pool-size:

Как изменить размер пула сжатия памяти?
==========================================

По умолчанию модуль :ref:`сжатия памяти zram <memory-compression>` создаёт пул, равный половине объёма имеющейся оперативной памяти.

Увеличивать размер пула выше стандартного значения категорически не рекомендуется, т.к. это может приводить к зависаниям системы.

Если всё-таки хочется внести поправки, откроем файл ``/etc/systemd/zram-generator.conf`` в текстовом редакторе:

.. code-block:: text

    sudoedit /etc/systemd/zram-generator.conf

Внесём изменения в переменные ``zram-fraction`` и ``max-zram-size``, явно указав необходимые значения:

.. code-block:: text

    zram-fraction = 0.5
    max-zram-size = 4096

Допустимые значения **zram-fraction**:

  * **0.5** -- выделение под пул 50% (выбор по умолчанию) от оперативной памяти;
  * **0.25** -- 25%;
  * **0.1** -- 10%;
  * **1.0** -- 100% соответственно (не рекомендуется).

В **max-zram-size** указывается максимально допустимый объём для пула в мегабайтах.

Изменения вступят в силу при следующей загрузке системы.

.. index:: rfremix
.. _rfremix-fedora:

Как правильно преобразовать RFRemix в Fedora?
=================================================

Заменим пакеты с брендированием:

.. code-block:: text

    sudo dnf swap rfremix-release fedora-release --allowerasing
    sudo dnf swap rfremix-logos fedora-logos --allowerasing

Полностью отключим и удалим репозитории :ref:`Russian Fedora <russian-fedora>`:

.. code-block:: text

    sudo dnf remove 'russianfedora*'

Произведём синхронизацию компонентов дистрибутива:

.. code-block:: text

    sudo dnf distro-sync --allowerasing

.. index:: rfremix, update
.. _rfremix-upgrade:

Как правильно обновиться с RFRemix до Fedora?
=================================================

В связи с прекращением поддержки RFRemix, выполним следующие действия:

  1. :ref:`преобразуем RFRemix в Fedora <rfremix-fedora>`.
  2. :ref:`установим обновления системы штатным способом <dist-upgrade>`.

.. index:: dual boot, windows
.. _dual-boot-optimizations:

Как оптимизировать Windows для корректной работы в dual-boot?
=================================================================

Если необходимо использовать Fedora вместе с Microsoft Windows в режиме :ref:`двойной загрузки <dual-boot>`, то необходимо применить ряд оптимизаций, специфичных для данной ОС:

  1. переведём часы в UTC во всех установленных ОС: :ref:`Fedora <system-time-utc>`, :ref:`Windows <windows-utc>`;
  2. отключим использование :ref:`гибридного режима завершения работы <ntfs-readonly>`.

После выполнения указанных действий, обе ОС смогут сосуществовать на одном устройстве.

.. index:: webkitgtk, 1c
.. _webkitgtk-legacy:

Приложение требует webkitgtk. Что делать?
=============================================

Библиотека webkitgtk более не поддерживается апстримом, имеет сотни незакрытых критических уязвимостей (в т.ч. допускающих удалённое исполнение кода), и по этой причине она была удалена из репозиториев Fedora начиная с версии 25.

Если приложение требует webkitgtk, то лучше всего воздержаться от его использования, однако если это по какой-либо причине невозможно, то проще всего будет применить загрузку библиотеки через :ref:`переопределение LD_LIBRARY_PATH <library-path>`.

Настоятельно не рекомендуется устанавливать данную библиотеку глобально в систему!

.. index:: php, remi, install
.. _php-remi-install:

Можно ли установить несколько версий PHP одновременно?
=========================================================

Да, это возможно при использовании репозитория Remi's RPM.

В то же время одновременная установка и использование одной и той же *мажорной версии PHP* невозможна, т.е. нельзя одновременно установить и использовать версии **7.3.1** и **7.3.2**, однако **7.2.9** и **7.3.2** уже можно.

`Remi's RPM <https://rpms.remirepo.net/>`__ -- это сторонний репозиторий, созданный и поддерживаемый Remi Collect -- активным участником сообщества и мейнтейнером всего PHP стека в Fedora.

Основная цель данного репозитория -- предоставление различных версий стека PHP с возможностью одновременного использования, а также некоторых других программ для пользователей Fedora и Enterprise Linux (RHEL, CentOS, Oracle, Scientific Linux и т.д.).

**Важно:** Remi's RPM -- это сторонний репозиторий, поэтому в случае, если вы используете бета-версии Fedora или Fedora Rawhide, репозиторий может работать некорректно.

Для подключения выполним сдедующую команду:

.. code-block:: text

    sudo dnf install https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm

**Важно:** Перед использованием репозитория Remi, необходимо подключить :ref:`RPM Fusion <rpmfusion>`.

Для того, чтобы получать обновления PHP, активируем данный репозиторий:

.. code-block:: text
    
    sudo dnf config-manager --set-enabled remi

При необходимости можно включить экспериментальные репозитории с бета-версиями PHP (на примере версии 7.4):

.. code-block:: text

    sudo dnf config-manager --set-enabled remi-php74

Установим PHP-интерпретатор версии 7.3:

.. code-block:: text

    sudo dnf install php73-php

Для корректного использования PHP с веб-сервером Apache в режиме FastCGI, необходимо вручную указать путь к исполняемому файлу PHP в файле конфигурации веб-сервера.

В случае использования nginx, установим менеджер процессов PHP-FPM для PHP версии 7.3:

.. code-block:: text

    sudo dnf install php73-php-fpm

Стоит обратить внимание на то, что все пакеты в репозитории Remi's RPM, относящиеся к PHP, имеют в своем названии префикс вида ``php<php_version>``, где ``<php_version>`` -- первые две цифры версии PHP, которую необходимо использовать.

Запустим PHP-FPM и включим его автоматический старт при включения системы:

.. code-block:: text

    sudo systemctl enable --now php73-php-fpm.servie

Указанный выше префикс необходимо использовать и при взаимодействии с юнитами :ref:`systemd <systemd-info>`.

Для выполнения PHP сценария в терминале, вызовем интерпретатор и передадим путь к файлу в качестве параметра:

.. code-block:: text

    /usr/bin/php73 /path/to/file.php

Здесь ``/usr/bin/php73`` является символической ссылкой для быстрого вызова исполняемого файла интерпретатора PHP указанной версии, например ``/opt/remi/php73/root/usr/bin/php``.

Файлы конфигурации ``php.ini`` и ``php-fpm.conf`` располагаются в каталоге ``/etc/opt/remi/php73``. Префикс используется в качестве имени каталога.

.. index:: qt, wayland, xcb, workaround
.. _qt-wayland-issue:

С некоторыми Qt приложениями в Wayland наблюдаются проблемы. Как исправить?
===============================================================================

Некоторые приложения, использующие фреймворк Qt, могут некорректно работать в Wayland, поэтому активируем для них принудительное использование системы X11:

.. code-block:: text

    QT_QPA_PLATFORM=xcb /usr/bin/foo-bar

При необходимости постоянного старта в таком режиме создадим переопределение для ярлыка, прописав ``env QT_QPA_PLATFORM=xcb`` перед строкой запуска внутри директивы ``Exec=``.

Пример:

.. code-block:: text

    Exec=env QT_QPA_PLATFORM=xcb /usr/bin/foo-bar

Здесь **/usr/bin/foo-bar** -- путь запуска проблемного приложения.

.. index:: kde, dbus, print screen, spectacle, screenshot
.. _spectacle-dbus:

В Spectacle при вызове через Print Screen отсутствует оформление окна. Как исправить?
========================================================================================

Это `известная проблема <https://bugzilla.redhat.com/show_bug.cgi?id=1754395>`__ пакета **Lmod**, приводящая к тому, что при вызове через D-Bus не полностью передаются :ref:`переменные окружения <env-set>`.

Удалим Lmod:

.. code-block:: text

    sudo dnf remove Lmod

Произведём перезагрузку системы:

.. code-block:: text

    sudo systemctl reboot

.. index:: amd, radeon, amdgpu
.. _amdgpu-black-screen:

Как решить проблему с чёрным экраном после обновления ядра на видеокартах AMD?
==================================================================================

Иногда чёрный экран на видеокартах AMD может появляться по причинам отсутствия нужной прошивки в initramfs образе.

Для решения данной проблемы :ref:`пересоберём образ initrd <initrd-rebuild>` с принудительным добавлением прошивок, используемых драйвером amdgpu:

.. code-block:: text

    sudo dracut --regenerate-all --force --install "/usr/lib/firmware/amdgpu/*"

Произведём перезагрузку системы:

.. code-block:: text

    sudo systemctl reboot

.. index:: nvidia, vga, error, workaround, x11
.. _nvidia-vga0-error:

Как исправить ошибку, связанную с VGA-0, на видеокартах NVIDIA?
===================================================================

Если в системном журнале появляется сообщение вида *WARNING: GPU:0: Unable to read EDID for display device VGA-0*, отключим соответствующий видеовыход.

Создадим файл ``80-vgaoff.conf``:

.. code-block:: text

    sudo touch /etc/X11/xorg.conf.d/80-vgaoff.conf
    sudo chown root:root /etc/X11/xorg.conf.d/80-vgaoff.conf
    sudo chmod 0644 /etc/X11/xorg.conf.d/80-vgaoff.conf

Откроем его в :ref:`текстовом редакторе <editor-selection>`:

.. code-block:: text

    sudoedit /etc/X11/xorg.conf.d/80-vgaoff.conf

Добавим следующее содержание:

.. code-block:: text

    Section "Monitor"
        Identifier "VGA-0"
        Option "Ignore" "true"
        Option "Enable" "false"
    EndSection

Произведём перезагрузку системы:

.. code-block:: text

    sudo systemctl reboot

.. index:: intel, video, gpu, modesetting, x11
.. _intel-modesetting:

Как активировать драйвер modesetting на видеокартах Intel?
===============================================================

Создадим новый файл конфигурации X11 -- ``10-modesetting.conf``:

.. code-block:: text

    sudo touch /etc/X11/xorg.conf.d/10-modesetting.conf
    sudo chmod 0644 /etc/X11/xorg.conf.d/10-modesetting.conf

Откроем его в :ref:`текстовом редакторе <editor-selection>`:

.. code-block:: text

    sudoedit /etc/X11/xorg.conf.d/10-modesetting.conf

Вставим следующее содержание:

.. code-block:: text

    Section "Device"
        Identifier  "Intel Graphics"
        Driver      "modesetting"
    EndSection

Сохраним изменения в файле.

Удалим компоненты стандартного драйвера Intel:

.. code-block:: text

    sudo dnf remove xorg-x11-drv-intel

Перезагрузим систему и выберем сеанс X11 (**Gnome on X11** для пользователей Fedora Workstation):

.. code-block:: text

    sudo systemctl reboot

.. index:: usb, flash, drive, mount options, file system, journal, lazytime, tune2fs, ext4
.. _usb-flash-tuning:

Как увеличить срок жизни USB Flash?
=======================================

Использование современных журналируемых :ref:`файловых систем <fs-selection>` Linux на накопителях USB Flash, контроллер которых не способен автоматически балансировать износ ячеек, требует выполнения небольшой оптимизации.

Изменим режим журнала в ``writeback``, а также активируем параметр монтирования ``lazytime``:

.. code-block:: text

    sudo debugfs -w -R "set_super_value mount_opts data=writeback,lazytime" /dev/sdX1

Для максимального продления срока службы допускается полностью отключить журнал ФС (только на ext4):

.. code-block:: text

    sudo tune2fs -O ^has_journal /dev/sdX1

**Внимание!** Отключение журнала может привести к потере всех данных на устройстве при его некорректном извлечении, либо исчезновении питания.

Здесь **/dev/sdX1** -- раздел на устройстве флеш-памяти, который требуется настроить.

Изменения вступят в силу при следующем монтировании.

.. index:: grub, boot, bootloader, workaround, issue, btrfs, ext4
.. _grub-sparse-not-allowed:

При загрузке возникает ошибка sparse file not allowed. Как исправить?
==========================================================================

Если раздел **/boot** установленной системы использует файловую систему :ref:`BTRFS <fs-btrfs>`, при загрузке системы появится ошибка *error: ../../grub-core/commands/loadenv.c:216:sparse file not allowed*.

Это `известная проблема <https://bugzilla.redhat.com/show_bug.cgi?id=1955901>`__, связанная с записью конфигурации grubenv и неполноценной реализацией драйвера поддержки BTRFS в загрузчике (он перезаписывает непосредственно блоки файла без обновления соответствующих метаданных, после чего BTRFS считает раздел повреждённым из-за несовпадения контрольных сумм).

В качестве решения предлагается несколько вариантов:

  1. перейти на :ref:`поддерживаемую конфигурацию <fedora-partitions>` загрузки -- :ref:`переместить <moving-system>` **/boot** на раздел с ФС ext4;
  2. :ref:`отключить скрытие меню <grub-show>` загрузки GRUB 2.

.. index:: btrfs, file system, balancing
.. _btrfs-balancing:

Нужно ли выполнять балансировку раздела с BTRFS?
===================================================

Файловая система :ref:`BTRFS <fs-btrfs>` использует двухуровневую структуру хранения данных: пространство поделено на *фрагменты*, которые содержат *блоки данных*. При определенных условиях эксплуатации в ФС может возникать большое количество мало заполненных фрагментов. Это приводит к ситуации, когда свободное место вроде есть, а записать очередной файл на диск не получается.

Операция балансировки выполняет перенос блоков между фрагментами, а освободившиеся при этом удаляются. Официальная `документация <https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Balancing>`__ рекомендует выполнять балансировку регулярно, однако разработчики Fedora `против <https://pagure.io/fedora-btrfs/project/issue/16>`__ такого подхода.

Если на разделе мало свободного места (меньше 20%), часто осуществляется интенсивная запись данных (например от СУБД), и происходят ошибки записи, то скорее всего балансировка поможет.

Оценим выгоду от :ref:`выполнения балансировки <btrfs-balancing-execute>` следующей командой:

.. code-block:: text

    sudo btrfs fi usage [mountpoint]

Если значение в поле **Device allocated** значительно превышает **Used**, то процедура окажется полезной, в противном случае выполнять её не имеет никакого смысла.

Здесь **mountpoint** -- точка монтирования раздела.

.. index:: btrfs, file system, balancing
.. _btrfs-balancing-execute:

Как произвести балансировку раздела с BTRFS?
===============================================

Произведём :ref:`балансировку <btrfs-balancing>` для всех фрагментов, заполненных менее, чем наполовину:

.. code-block:: text

    sudo btrfs fi balance start -dusage=50 -musage=50 [mountpoint]

Здесь **-dusage** -- максимальный процент заполнения при балансировке данных, **-musage** -- максимальный процент заполнения при балансировке метаданных, а **mountpoint** -- точка монтирования раздела.

Чем меньше значение *usage*, тем быстрее выполнится операция. Если на диске мало свободного места, то начинать следует с небольших значений, например с *5*, постепенно увеличивая это число. Также можно балансировать отдельно данные и метаданные.

Подробнее о балансировке можно прочитать в официальной документации (на английском языке):

  * `Sysadmin guide <https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Balancing>`__
  * `Problem FAQ <https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space>`__

.. index:: vconsole, boot, tty, systemd, workaround, bug
.. _failed-setup-virtual-console:

Как исправить ошибку Failed to start Setup Virtual Console?
==============================================================

Если при загрузке системы возникает ошибка *Failed to start Setup Virtual Console*, это `известная проблема <https://fedoraproject.org/wiki/Common_F34_bugs#kbd-legacy-media>`__, связанная с отсутствием установленных keymaps для множества отличных от en_US локалей.

В качестве решения установим пакет **kbd-legacy**:

.. code-block:: text

    sudo dnf install kbd-legacy

Пересоберём :ref:`образ initrd <initrd-rebuild>` для всех установленных ядер:

.. code-block:: text

    sudo dracut --regenerate-all --force

Перезапустим сервис и проверим результат его работы:

.. code-block:: text

    sudo systemctl start systemd-vconsole-setup.service
    systemctl status systemd-vconsole-setup.service

.. index:: pipewire, wireplumber, bug, issue, workaround
.. _wireplumber-no-sound:

После обновления до Fedora 35 отсутствует звук. Как исправить?
=================================================================

Отсутствие усстройств вывода звука после обновления до Fedora 35 при использовании звукового сервера PipeWire -- это `известная проблема <https://bugzilla.redhat.com/show_bug.cgi?id=2016253>`__, связанная с `переходом на WirePlumber <https://fedoraproject.org/wiki/Changes/WirePlumber>`__.

Решим её активацией необходимого systemd-сервиса:

.. code-block:: text

    systemctl --global enable --now wireplumber.service

Изменения вступят в силу немедленно.

.. index:: libreoffice, hardware, acceleration, x11, wayland, workaround, bug
.. _libreoffice-wayland:

Как устранить лаги при редактировании документов в LibreOffice?
==================================================================

При возникновении лагов во время работы с документами в приложениях LibreOffice вне зависимости от настроек аппаратного ускорения, переключим :ref:`активный сеанс <session-type>` сессии с :ref:`Wayland на X11 <x11-session>`.

.. index:: nvidia, driver, dnf, upgrade, bug, issue, workaround
.. _nvidia-upgrade-bug:

После обновления до Fedora 36 не работают драйверы NVIDIA. Как исправить?
============================================================================

Это `известная проблема <https://bugzilla.redhat.com/show_bug.cgi?id=2011120>`__, из-за которой плагин dnf system-upgrade перезагружает систему до того, как пакеты :ref:`проприетарных драйверов NVIDIA <nvidia-drivers>` будут корректно собраны и установлены.

В качестве решения обновим базу установленных модулей ядра Linux:

.. code-block:: text

    sudo depmod -ae

Произведём перезагрузку устройства:

.. code-block:: text

    systemctl reboot

.. index:: printer, usb, hardware, upgrade, bug, issue, workaround
.. _ipp-usb-disable:

После обновления перестали работать USB принтеры и сканеры. Как исправить?
=============================================================================

Начиная с Fedora 36, применяется технология печати без необходимости установки драйверов (driverless printing) на основе эмуляции `протокола IPP <https://ru.wikipedia.org/wiki/Internet_Printing_Protocol>`__ для любых подключённых локально USB-принтеров.

Если устройство не работает, либо не поддерживается, для возврата к классической конфигурации печати удалим пакет **ipp-usb**:

.. code-block:: text

    sudo dnf remove ipp-usb

Перезагрузим устройство:

.. code-block:: text

    systemctl reboot
