.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
.. 
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
.. 
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
.. _tips-and-tricks:

***********************************************************
Вопросы, связанные с оптимизацией и тонкой настройкой
***********************************************************

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

    sudo dnf remove PackageKit

Удалим runtime библиотеки для экономии ОЗУ (при этом по зависимостям будут удалены некоторые приложения, например KMail и KOrganizer):

.. code-block:: text

    sudo dnf remove kdepim-runtime-libs

Удалим :ref:`KDE Connect <kde-connect>` (если не планируется управлять смартфоном с компьютера и наоборот):

.. code-block:: text

    sudo dnf remove kde-connect kdeconnectd

Опционально удалим библиотеки GTK2 (в то же время от них до сих пор зависят многие популярные приложения, например Firefox, Gimp, GParted):

.. code-block:: text

    sudo dnf remove gtk2
Удалим весь ненужный Windows подобный софт
.. code-block:: text
    sudo dnf remove  discover krdc akonadi qt abrt PackageKit kdepim-runtime-libs kde-connect kdeconn    ectd ark dragon kontact okular gwenview ktorrent kget konversation konqueror falkon kmail dnfdragor    a kdewallet krusader kwrite spectacle krfb akregator juk kamoso k3b calligra* kfind kgpg kmouth kmag

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
