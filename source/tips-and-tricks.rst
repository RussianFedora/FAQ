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
.. index:: bfq, hdd, optimizations
.. _bfq:

Как задействовать планировщик ввода/вывода BFQ для HDD?
=======================================================

BFQ — планировщик I/O, который предназначен для повышения отзывчивости пользовательского окружения при нагрузках на дисковую подсистему.

Отредактируем файл настроек GRUB:

.. code-block:: bash

    sudo nano /etc/default/grub

В ``GRUB_CMDLINE_LINUX=`` добавим `` scsi_mod.use_blk_mq=1`` после чего :ref:`сгенерируем новую конфигурацию GRUB <grub-rebuild>`

Теперь включим BFQ для HDD:

.. code-block:: bash

    sudo -i

    echo 'ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"' >> /etc/udev/rules.d/60-ioschedulers.rules

Для того чтобы изменения вступили в силу потребуется перезагрузка.
