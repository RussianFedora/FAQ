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

.. code-block:: bash

    sudo dnf remove abrt

Удалим Магазин приложений (графический менеджер пакетов):

.. code-block:: bash

    sudo dnf remove PackageKit gnome-software

Отключим службу управления виртуализацией (если на установленной системе не предполагается использовать виртуальные машины):

.. code-block:: bash

    sudo systemctl disable libvirtd

Отключим службы Evolution, необходимые для синхронизации онлайн аккаунтов:

.. code-block:: bash

    systemctl --user mask evolution-addressbook-factory evolution-calendar-factory evolution-source-registry

Отключим службы, необходимые для создания индекса файловой системы, необходимого для быстрого поиска (если не предполагается использовать поиск в главном меню):

.. code-block:: bash

    systemctl --user mask tracker-miner-apps tracker-miner-fs tracker-store

.. index:: kde, ram, optimizations
.. _kde-reduce-ram-usage:

Как уменьшить потребление оперативной памяти средой рабочего стола KDE?
===========================================================================

Отключим службу индексации файлов. Для этого зайдём в **Параметры системы** - **Поиск**, снимем флажок из чекбокса **Включить службы поиска файлов** и нажмём **Применить**. Теперь удалим Akonadi:

.. code-block:: bash

    sudo dnf remove akonadi

Удалим устаревшие библиотеки Qt4 и службу автоматической регистрации ошибок ABRT:

.. code-block:: bash

    sudo dnf remove qt abrt

Удалим Магазин приложений (графический менеджер пакетов):

.. code-block:: bash

    sudo dnf remove PackageKit

Удалим runtime библиотеки для экономии ОЗУ (при этом по зависимостям будут удалены некоторые приложения, например KMail и KOrganizer):

.. code-block:: bash

    sudo dnf remove kdepim-runtime-libs

Удалим :ref:`KDE Connect <kde-connect>` (если не планируется управлять смартфоном с компьютера и наоборот):

.. code-block:: bash

    sudo dnf remove kde-connect kdeconnectd

Опционально удалим библиотеки GTK2 (в то же время от них до сих пор зависят многие популярные приложения, например Firefox, Gimp, GParted):

.. code-block:: bash

    sudo dnf remove gtk2

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

.. code-block:: bash

    sudoedit /etc/default/grub

В конец строки ``GRUB_CMDLINE_LINUX=`` добавим ``scsi_mod.use_blk_mq=1``, после чего :ref:`сгенерируем новую конфигурацию GRUB <grub-rebuild>`.

Создадим новое правило udev для принудительной активации BFQ для любых жёстких дисков:

.. code-block:: bash

    sudo bash -c "echo 'ACTION==\"add|change\", KERNEL==\"sd[a-z]\", ATTR{queue/rotational}==\"1\", ATTR{queue/scheduler}=\"bfq\"' >> /etc/udev/rules.d/60-ioschedulers.rules"

Применим изменения в политиках udev:

.. code-block:: bash

    sudo udevadm control --reload

Выполним перезагрузку системы:

.. code-block:: bash

    sudo systemctl reboot

.. index:: swf, flash, player, projector
.. _swf-player:

Чем можно запустить SWF файл без установки Flash плагина в браузер?
======================================================================

SWF файл - это исполняемый файл формата Adobe Flash. Для того, чтобы проиграть его без установки соответствующего плагина в браузер, можно загрузить специальную версию Flash Projector (ранее назывался Standalone).

Скачаем Projector:

.. code-block:: bash

    wget https://fpdownload.macromedia.com/pub/flashplayer/updaters/32/flash_player_sa_linux.x86_64.tar.gz -O fpsa.tar.gz

Создадим новый каталог и распакуем архив в него:

.. code-block:: bash

    mkdir -p ~/foo-bar
    tar -xzf fpsa.tar.gz -C ~/foo-bar

Запустим проигрыватель:

.. code-block:: bash

    ~/foo-bar/flashplayer

В открывшемся окне нажмём **Файл** - **Открыть** (или комбинацию **Ctrl + O**) и найдём SWF файл на диске.

По окончании использования удалим каталог с программой:

.. code-block:: bash

    rm -rf ~/foo-bar

Внимание! Запускать SWF файлы следует с особой осторожностью, т.к. плеер выполняется без какой-либо изоляции и имеет полный доступ к домашнему каталогу пользователя.

.. index:: python, python2, remove
.. _python2-remove:

Можно ли удалить Python 2 из системы?
========================================

Да. Поскольку поддержка Python версии 2 прекратится 01.01.2020, его уже не рекомендуется использовать. Вместо него следует применять Python 3. Большая часть активных проектов и библиотек уже давно была портирована на эту версию.

Возможность полностью избавиться от Python 2 появилась у пользователей Fedora 30 и выше. От данной версии интерпретатора более не зависят важные компоненты и его можно смело удалить:

.. code-block:: bash

    sudo dnf remove python2

Это действие автоматически удалит и все его зависимости.
