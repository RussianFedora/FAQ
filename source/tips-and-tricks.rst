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
==============================================================================

Отключим службу индексации файлов

.. code-block:: bash

    Для этого заходим в Параметры системы - Поиск. И снимаем галку с "Включить службы поиска файлов".

Удалим устаревшие библиотеки Qt4 и службу автоматической регистрации ошибок ABRT:

.. code-block:: bash

    sudo dnf remove qt abrt

Удалим runtime библиотеки для экономии ОЗУ. Пhи этом по зависимостям будут удалены некоторые приложения типа KMail и KOrganizer. Если хотите экономить ОЗУ - не используйте их.

.. code-block:: bash

    sudo dnf remove kdepim-runtime-libs

Удалим kdeconnectd. Если вы не планируете управлять вашим смартфоном с компьютера и наоборот, то это сэкономит пару десятков мегабайт ОЗУ.

.. code-block:: bash

    sudo dnf remove kdeconnectd

Удалим библиотеки GTK2. От этих устаревших библиотек до сих пор зависят многие удобные приложения, например Firefox, Gimp, gparted. Так что если вы не готовы от них отказаться - не удаляйте gtk2.

.. code-block:: bash

    sudo dnf remove gtk2
