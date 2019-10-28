.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
.. 
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
.. 
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
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

Отключим службу индексации файлов. Для этого зайдём в **Параметры системы** - **Поиск**, снимем флажок из чекбокса **Включить службы поиска файлов** и нажмём **Применить**. Теперь удалим Akonadi:

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

    sudo dnf remove kdepim-runtime-libs

Удалим :ref:`KDE Connect <kde-connect>` (если не планируется управлять смартфоном с компьютера и наоборот):

.. code-block:: text

    sudo dnf remove kde-connect kdeconnectd

Опционально удалим библиотеки GTK2 (в то же время от них до сих пор зависят многие популярные приложения, например Firefox, Gimp, GParted):

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

.. index:: bfq, hdd, optimizations, scheduler, kernel
.. _bfq-scheduler:

Как задействовать планировщик ввода/вывода BFQ для HDD?
==========================================================

BFQ - это планировщик ввода-вывода (I/O), предназначенный для повышения отзывчивости пользовательского окружения при значительных нагрузках на дисковую подсистему.

Для его активации произведём редактирование файла шаблонов GRUB:

.. code-block:: text

    sudoedit /etc/default/grub

В конец строки ``GRUB_CMDLINE_LINUX=`` добавим ``scsi_mod.use_blk_mq=1``, после чего :ref:`сгенерируем новую конфигурацию GRUB <grub-rebuild>`.

Создадим новое правило udev для принудительной активации BFQ для любых жёстких дисков:

.. code-block:: text

    sudo bash -c "echo 'ACTION==\"add|change\", KERNEL==\"sd[a-z]\", ATTR{queue/rotational}==\"1\", ATTR{queue/scheduler}=\"bfq\"' >> /etc/udev/rules.d/60-ioschedulers.rules"

Применим изменения в политиках udev:

.. code-block:: text

    sudo udevadm control --reload

Выполним перезагрузку системы:

.. code-block:: text

    sudo systemctl reboot

.. index:: swf, flash, player, projector
.. _swf-player:

Чем можно запустить SWF файл без установки Flash плагина в браузер?
======================================================================

SWF файл - это исполняемый файл формата Adobe Flash. Для того, чтобы проиграть его без установки соответствующего плагина в браузер, можно загрузить специальную версию Flash Projector (ранее назывался Standalone).

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

В открывшемся окне нажмём **Файл** - **Открыть** (или комбинацию **Ctrl + O**) и найдём SWF файл на диске.

По окончании использования удалим каталог с программой:

.. code-block:: text

    rm -rf ~/foo-bar

Внимание! Запускать SWF файлы следует с особой осторожностью, т.к. плеер выполняется без какой-либо изоляции и имеет полный доступ к домашнему каталогу пользователя.

.. index:: python, python2, remove
.. _python2-remove:

Можно ли удалить Python 2 из системы?
========================================

Да. Поскольку поддержка Python версии 2 прекратится 01.01.2020, его уже не рекомендуется использовать. Вместо него следует применять Python 3. Большая часть активных проектов и библиотек уже давно была портирована на эту версию.

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

Здесь **XXXXXXXXXX** - :ref:`UUID раздела <get-uuid>`, а **ext4** - используемая :ref:`файловая система <fs-selection>`.

Следует помнить, что это действие не повлияет на запуск различных скриптов интерпретаторами, т.е. запуск ``./foo-bar`` с установленным битом исполнения будет запрещён, но в то же время ``bash foo-bar`` выполнится в штатном режиме.

.. index:: fonts, msttcorefonts, corefonts
.. _msttcorefonts:

Как установить шрифты Microsoft в Fedora?
=============================================

См. `здесь <https://www.easycoding.org/2011/08/14/ustanovka-microsoft-core-fonts-v-fedora.html>`__.

.. index:: bug, grub, boot, loader, error
.. _grub-legacy-error:

После обновления дистрибутива с 29 версии до 30 не могу загрузить систему. Как исправить?
=============================================================================================

Некоторые пользователи, до сих пор использующие Legacy загрузку (BIOS), после :ref:`обновления <dist-upgrade>` с Fedora 29 до 30 не могут запустить систему из-за ошибок, связанных с загрузчиком Grub 2.

Это `известная проблема <https://fedoraproject.org/wiki/Common_F30_bugs#GRUB_boot_menu_is_not_populated_after_an_upgrade>`__. Для её решения осуществим следующую последовательность:

1. после появления ошибки Grub 2 и перехода в emergency режим, выполним команду:

.. code-block:: text

    configfile /grub2/grub.cfg.rpmsave

2. после успешной загрузки, произведём переустановку Grub 2 в MBR диска:

.. code-block:: text

    sudo grub2-install /dev/sda

Здесь **/dev/sda** - дисковое устройство, на котором установлена Fedora.

.. index:: dnf, zchunk, bug, error, update
.. _zchunk-checksum:

При попытке обновления появляется ошибка zchunk checksum error. Как исправить?
==================================================================================

Это `известная проблема <https://bugzilla.redhat.com/show_bug.cgi?id=1706321>`__. В качестве временного решения запретим использование zchunk в dnf.

Откроем главный конфигурационный файл dnf:

.. code-block:: text

    sudoedit /etc/dnf/dnf.conf

Добавим в самый конец следующую строку:

.. code-block:: text

    zchunk=False

Сохраним изменения в файле и повторим попытку обновления. На этот раз она должна пройти без ошибок.

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

.. index:: rhel, error, subscription manager, bug, dnf, update
.. _rhelsm-error:

При попытке обновления появляется ошибка, связанная с Red Hat Subscription Managment. Как исправить?
=======================================================================================================

Пользователи, установшие систему со :ref:`свежих образов <download>` Fedora 30, при попытке :ref:`установки обновлений <dnf-update>` стали замечать ошибку с текстом *This system is not registered to Red Hat Subscription Managment. You can use subscription-manager to register*.

Это `известная проблема <https://bugzilla.redhat.com/show_bug.cgi?id=1718622>`__, из-за которой пакет **subscription-manager**, предназначенный для Red Hat Enterprise Linux, ошибочно включался в состав ISO образов Fedora.

Режим данную проблему посредством удаления данного пакета:

.. code-block:: text

    sudo dnf remove subscription-manager

Теперь ошибки при работе пакетного менеджера будут полностью устранены.

.. index:: zram, memory compression, ram, memory
.. _zram-pool-size:

Как изменить размер пула сжатия памяти?
==========================================

По умолчанию модуль :ref:`сжатия памяти zram <memory-compression>` создаёт пул, равный половине объёма имеющейся оперативной памяти.

Увеличивать размер пула выше стандартного значения категорически не рекомендуется, т.к. это может приводить к зависаниям системы.

Если всё-таки хочется внести поправки, откроем файл ``/etc/zram.conf`` в текстовом редакторе:

.. code-block:: text

    sudoedit /etc/zram.conf

Внесём изменения в переменную ``FACTOR``, явно указав нужное значение:

.. code-block:: text

    FACTOR=2

Формула расчёта: ``1 / FACTOR``. Значение **2** - выделение под пул 50% (выбор по умолчанию) от оперативной памяти, **4** - 25%, **1** - 100% соответственно (не рекомендуется).

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

Могу ли я установить несколько версий PHP одновременно?
============================================================

Да, это возможно при использовании репозитория Remi`s RPM.

Однако, одновременная установка и использование одной и той же версии PHP **невозможна**, т.е. одноврменно установить и использовать версии ``7.3.1`` и ``7.3.2`` нельзя. 

`Remi`s RPM <https://rpms.remirepo.net>`__ - это сторонний репозиторий, созданный и поддерживаемый Remi Collect - активным участником сообщества и мейнтейнером всего PHP стека в Fedora.

Основная цель Remi`s RPM Repo - предоставление различных версий стека PHP и некоторых других программ для пользователей Fedora и Enterprise Linux (RHEL, CentOS, Oracle, Scientific Linux,…)

Особенностью данного репозитория является поддержка одновременного использования нескольких различных версий стека PHP в системе.

**Важно:** Remi`s RPM - это сторонний репозиторий, поэтому в случае, если вы используете бета-версии Fedora или Fedora Rawhide, репозиторий может не поддерживать вашу систему.

Чтобы подключить репозиторий Remi, выполним:

.. code-block:: text

    sudo dnf install https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm

**Важно:** Перед использованием репозитория Remi, неоходимо подключить репозиторий :ref:`RPM Fusion <rpmfusion>`. 

Для того, чтобы получать обновления PHP во время прцоедуры обновления всей системы, установим репозиторий включенным по-умолчанию:

.. code-block:: text
    
    sudo dnf config-manager --set-enabled remi

В случае необходимости, включим репозиторий с PHP версии 7.4:

.. code-block:: text

    sudo dnf config-manager --set-enabled remi-php74

Установим PHP-интерпретатор версии 7.3:

.. code-block:: text

    sudo dnf install php73-php

Для корректного использования PHP с веб-сервером Apache в режиме FastCGI, необходимо указать путь к 
исполняемому файлу PHP в файле конфигурации веб-сервера.

В случае использования Nginx, установим менеджер процессов PHP-FPM для PHP версии 7.3:

.. code-block:: text

    sudo dnf install php73-php-fpm

Обратите внимание, что все пакеты в репозитории Remi`s RPM, относящиеся к PHP, имеют в своем названии префикс вида:

.. code-block:: text

    php<php_version>

Где ``<php_version>`` - первые две цифры версии PHP, которую вы хотите использовать.

Запустим PHP-FPM и включим его автоматический старт при включения системы:

.. code-block:: text

    sudo systemctl enable --now php73-php-fpm.servie

Префикс необходимо использовать и при взаимодействии с юнитами SystemD.

Для выполнения скрипта из файла в терминале, необходимо вызвать интерпретатор и передать файл скрипта в качестве параметра:

.. code-block:: text

    /usr/bin/php73 /path/to/file.php

В данном случае, префикс является символьной ссылкой для вызова исполняемого файла PHP-интерпретатора нужной версии:

.. code-block:: text

    /opt/remi/php73/root/usr/bin/php

Файлы конфигурации ``php.ini`` и ``php-fpm.conf`` находятся в каталоге:

.. code-block:: text

    /etc/opt/remi/php73/

Здесь префикс используется как имя каталога инстанса PHP.

.. index:: trim, fstrim, systemd, override, service, workaround, ssd
.. _fstrim-override:

Перестал работать TRIM для /home. Как исправить?
=====================================================

Это `известная проблема <https://bugzilla.redhat.com/show_bug.cgi?id=1762640>`__ в пакете utils-linux.

Для её решения создадим override для :ref:`systemd-юнита <systemd-info>` ``fstrim.service``:

.. code-block:: text

    sudo systemctl edit fstrim.service

В появившемся текстовом редакторе пропишем следующие строки:

.. code-block:: ini

    [Service]
    ProtectHome=read-only

Сохраним изменения и выйдем из редактора.

Обновим конфигурацию юнитов systemd:

.. code-block:: text

    sudo systemctl daemon-reload

Запустим сервис :ref:`fstrim <ssd-tuning>` вручную (при необходимости):

.. code-block:: text

    sudo systemctl start fstrim.service

С этого момента функция TRIM для домашнего раздела будет работать исправно.
