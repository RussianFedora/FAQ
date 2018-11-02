.. Fedora-Faq-Ru (c) 2018, EasyCoding Team and contributors
.. 
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
.. 
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
.. _package-manager:

***************************************************************
Вопросы, связанные с пакетным менеджером и установкой пакетов
***************************************************************

.. index:: package, manager, менеджер пакетов
.. _pkg-manager:

Какой менеджер пакетов используется в настоящее время?
==========================================================

Dnf, являющийся, в свою очередь, форком Yum.

.. index:: package, manager, менеджер пакетов
.. _yum-fedora:

Могу ли я использовать Yum в Fedora?
=========================================

Начиная с Fedora 24 yum присутствует в Fedora лишь как символическая ссылка на dnf, сохранённая для обратной совместимости.

.. index:: installation, packaging, make install
.. _make-install:

Можно ли устанавливать программы посредством make install?
================================================================

Категорически не рекомендуется ибо:

 1. make install порождает в системе кучу никем и ничем не отслеживаемых файлов: бинарников, конфигов, прочих файлов. Это в большинстве случаев приведёт к множеству проблем при обновлении или удалении;
 2. make install не учитывает файлы других пакетов и может запросто перезаписать или удалить в системе что-то важное, т.к. действие выполняется с правами суперпользователя;
 3. make install не ведёт никакого журнала действий, поэтому всё, что оно произвело, невозможно полноценно откатить;
 4. установленные через make install приложения очень часто невозможно удалить вообще, т.к. многие разработчики не делают правило make uninstall, что, в принципе, верно ибо оно не нужно большинству, а если и делают, то оно способно лишь удалить скопированные файлы. Изменения конфигов, других файлов и пр. откатить оно не способно.

Установка пакетов штатным пакетным менеджеров имеет множество преимуществ:

 1. при установке пакетный менеджер разрешает все зависимости, добавляет нужные, устраняет конфликты;
 2. перед выполнением установки пакетный менеджер проверяет, чтобы устанавливаемый пакет не вмешивался в работу других, а также самой системы. Если это так, он не будет установлен;
 3. во время установки все изменения, сделанные пакетом, вносятся в специальную базу данных пакетного менеджера и при удалении или обновлении будут учтены;
 4. при удалении пакета производится полный откат действий, предпринятых при установке (даже если были изменены какие-то конфиги, эти действия будут откачены полностью, т.к. хранится diff внутри базы ПМ);
 5. при обновлении перезаписываются только изменённые файлы. Более того, может быть скачан и установлен только дифф. изменений;
 6. если при обновлении пакета возникает конфликт какого-то конфига, он не будет молча перезаписан, а будет применён патч на существующий, либо, если это невозможно, будет запрошено действие у пользователя.

.. index:: DM change, смена менеджера сеансов, менеджер сеансов
.. _change-dm:

У меня в системе используется GDM, но я хочу заменить его на SDDM. Это возможно?
==================================================================================

Установка SDDM:

.. code-block:: bash

    sudo dnf install sddm

Отключение GDM и активация SDDM:

.. code-block:: bash

    sudo systemctl -f enable sddm

Изменения вступят в силу при следующей загрузке системы.

.. index:: fedora, upgrade
.. _dist-upgrade:

Как мне обновить Fedora до новой версии?
===========================================

Процесс обновления стандартен и максимально безопасен:

.. code-block:: bash

    sudo dnf upgrade --refresh
    sudo dnf install dnf-plugin-system-upgrade
    sudo dnf system-upgrade download --releasever=29
    sudo dnf system-upgrade reboot

Здесь **29** - номер версии, на которую нужно обновиться. Весь процесс установки будет выполнен во время следующей загрузки системы.

Если произошёл какой-то конфликт, то рекомендуется очистить все кэши dnf:

.. code-block:: bash

    sudo dnf clean all

.. index:: dnf, package error, ошибка обновления
.. _dnf-duplicates:

При обновлении dnf ругается на дубликаты пакетов.
===================================================

Удалить дубликаты и повреждённые пакеты можно так:

.. code-block:: bash

    sudo package-cleanup --cleandupes --noscripts

.. index:: dnf, ошибка обновления, повреждение базы RPM
.. _dnf-rpmdb:

База RPM оказалась повреждена. Как восстановить?
=====================================================

Для запуска пересборки базы данных RPM следует выполнить:

.. code-block:: bash

    sudo rpm --rebuilddb

Настоятельно рекомендуется сделать резервную копию каталога **/var/lib/rpm** перед этим действием.

.. index:: dnf, kernel count, сохранение ядер Linux
.. _dnf-kernel-store:

Dnf сохраняет старые ядра. Это нормально?
==============================================

Да. По умолчанию dnf сохраняет 3 последних ядра, чтобы в случае сбоя была возможность загрузки в более старое и исправления работы системы.

.. index:: dnf, kernel count, сохранение ядер Linux
.. _dnf-kernel-change:

Как можно уменьшить количество сохраняемых ядер?
====================================================

Необходимо открыть файл **/etc/dnf/dnf.conf** в любом текстовом редакторе и изменить значение переменной **installonly_limit**:

.. code-block:: text

    installonly_limit=2

Минимально допустимое значение - **2** (будут сохраняться два ядра: текущее и предыдущее).

.. index:: dnf, proxy, прокси
.. _dnf-proxy:

Как настроить работу dnf через прокси?
=========================================

Необходимо открыть файл **/etc/dnf/dnf.conf** в любом текстовом редакторе и изменить значение переменной **proxy** (при отсутствии добавить):

.. code-block:: text

    proxy=socks5://localhost:8080

Поддерживаются HTTP, HTTPS и SOCKS.

.. index:: dnf, weak dependencies, слабые зависимости
.. _dnf-weakdeps:

Как отключить установку слабых зависимостей?
================================================

Необходимо открыть файл **/etc/dnf/dnf.conf** в любом текстовом редакторе и изменить значение переменной **install_weak_deps** (при отсутствии добавить):

.. code-block:: text

    install_weak_deps=0

.. index:: dnf, disable package updates, запрет обновлений пакетов
.. _dnf-pkgupdates:

Как мне запретить установку обновлений для ряда пакетов?
============================================================

Необходимо открыть файл **/etc/dnf/dnf.conf** в любом текстовом редакторе и изменить значение переменной **exclude** (при отсутствии добавить):

.. code-block:: text

    exclude=kernel* PackageKit*

Здесь вместо примера следует указать нужные пакеты, разделяя их пробелом. Допускаются символы подстановки.

.. index:: dnf, remove kernel, удаление ядра
.. _dnf-kernel-remove:

Как можно вручную удалить старое ядро?
==========================================

Для ручного удаления старого ядра можно выполнить:

.. code-block:: bash

    sudo dnf remove kernel-4.10.14* kernel-core-4.10.14* kernel-modules-4.10.14* kernel-devel-4.10.14*

Здесь **4.10.14** - это версия удаляемого ядра.

.. index:: fonts, шрифты Microsoft
.. _msttcorefonts:

Как установить шрифты Microsoft в Fedora?
=============================================

См. `здесь <https://www.easycoding.org/2011/08/14/ustanovka-microsoft-core-fonts-v-fedora.html>`_.

.. index:: repository, сторонние репозитории
.. _3rd-repositories:

Какие сторонние репозитории лучше всего подключать?
=======================================================

См. `здесь <https://www.easycoding.org/2017/03/24/poleznye-storonnie-repozitorii-dlya-fedora.html>`_.

.. index:: repository, flatpak, flathub
.. _flatpak:

Как работать с Flatpak пакетами в Fedora?
============================================

См. `здесь <https://www.easycoding.org/2018/07/25/rabotaem-s-flatpak-paketami-v-fedora.html>`_.

.. index:: repository, package, packaging, создание пакета
.. _create-package:

Я хочу создать пакет для Fedora. Что мне следует знать?
============================================================

См. `здесь <https://docs.fedoraproject.org/quick-docs/en-US/creating-rpm-packages.html>`_ и `здесь <https://www.easycoding.org/2018/06/17/pravilno-paketim-po-dlya-linux.html>`_.

.. index:: repository, codecs, кодеки мультимедиа, multimedia
.. _multimedia-codecs:

В системе нет кодеков мультимедиа. Как их установить?
============================================================

Для начала следует подключить репозиторий RPM Fusion и установить кодеки из группы **multimedia**:

.. code-block:: bash

    sudo dnf groupinstall multimedia

.. index:: repository, codecs, кодеки мультимедиа, multimedia, chromium
.. _chromium-codecs:

Я установил браузер Chromium из репозиториев, но он отказывается воспроизводить видео с большинства сайтов. Как исправить?
==============================================================================================================================

Из-за патентных ограничений браузер Chromium в репозиториях Fedora сильно кастрирован. Для восстановления полной функциональности необходимо подключить RPMFusion и установить пакет с кодеками для данного браузера:

.. code-block:: bash

    sudo dnf install chromium-libs-media-freeworld

.. index:: repository, codecs, кодеки мультимедиа, multimedia
.. _firefox-codecs:

Как активировать все доступные кодеки в браузере Firefox?
==============================================================

Браузер Mozilla Firefox использует ffmpeg для работы с мультимедийным контентом, поэтому необходимо его установить из репозитория RPM Fusion:

.. code-block:: bash

    sudo dnf install ffmpeg-libs

.. index:: repository, nvidia, drivers, драйверы
.. _nvidia-drivers:

Как правильно установить драйверы NVIDIA?
==============================================

См. `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`_.

.. index:: package, packaging, сборка пакета, building
.. _build-package:

Как собрать RPM пакет в mock?
==================================

См. `здесь <https://www.easycoding.org/2017/02/22/sobiraem-rpm-pakety-dlya-fedora-v-mock.html>`_.

.. index:: repository, virtualbox
.. _virtualbox:

Как правильно установить VirtualBox в Fedora?
================================================

Сначала нужно подключить репозиторий RPM Fusion, затем выполнить:

.. code-block:: bash

    sudo dnf upgrade --refresh
    sudo dnf install gcc kernel-devel kernel-headers akmod-VirtualBox VirtualBox

Для нормальной работы с USB устройствами и общими папками потребуется также добавить свой аккаунт в группу **vboxusers** и **vboxsf**:

.. code-block:: bash

    sudo usermod -a -G vboxusers $(whoami)
    sudo usermod -a -G vboxsf $(whoami)

.. index:: repository, broadcom, drivers, драйверы
.. _broadcom-drivers:

Как правильно установить драйверы Wi-Fi модулей Broadcom?
=============================================================

Сначала нужно подключить RPM Fusion, затем выполнить:

.. code-block:: bash

    sudo dnf upgrade --refresh
    sudo dnf install gcc kernel-devel kernel-headers akmod-wl

.. index:: dnf, cache, кэши dnf
.. _dnf-caches:

Как отключить автообновление кэшей dnf?
==============================================

См. `здесь <https://www.easycoding.org/2016/01/27/otklyuchaem-avto-obnovlenie-v-dnf-pod-fedora-22.html>`_.

.. index:: dkms, akmods, difference
.. _dkms-akmods:

Что лучше: dkms или akmods?
==============================

Конечно akmods, т.к. он автоматически собирает и устанавливает полноценные RPM пакеты.

.. index:: packaging, создание пакета, добавление в репозиторий
.. _becoming-maintainer:

Как добавить свой пакет в репозиторий Fedora и стать мейнтейнером?
=====================================================================

См. `здесь <https://www.easycoding.org/2016/06/20/dobavlyaem-paket-v-glavnyj-repozitorij-fedora.html>`_.

.. index:: package updates, testing, тестовые репозитории
.. _updates-testing:

Каким способом можно обновить пакет из тестовых репозиториев?
=================================================================

Чтобы установить обновление из Fedora Testing, необходимо временно подключить соответствующий репозиторий:

.. code-block:: bash

    sudo dnf upgrade --refresh foo-bar* --enablerepo=updates-testing

Репозиторий **updates-testing** подключается однократно, только для данного сеанса работы dnf.

.. index:: dnf, package contents, список файлов пакета
.. _dnf-list-contents:

Как получить список файлов установленного пакета?
=====================================================

.. code-block:: bash

    sudo dnf repoquery -l foo-bar

.. index:: dnf, package contents, список файлов пакета
.. _dnf-find-file:

Как узнать в каком пакете находится конкретный файл?
=======================================================

Для этого можно воспользоваться плагином dnf repoquery:

.. code-block:: bash

    sudo dnf repoquery -f */имя_файла

Для поиска бинарников и динамических библиотек можно применять альтернативный метод:

.. code-block:: bash

    sudo dnf provides */имя_бинарника

.. index:: dnf, java, alternatives, несколько версий java
.. _java-multiple:

Можно ли установить несколько версий Java в систему?
========================================================

Да, это возможно. В настоящее время поддерживаются следующие версии Java. Допускается их одновременная установка.

Java 8:

.. code-block:: bash

    sudo dnf install java-1.8.0-openjdk

Java 9:

.. code-block:: bash

    sudo dnf install java-9-openjdk

Java 11:

.. code-block:: bash

    sudo dnf install java-11-openjdk

.. index:: dnf, java, alternatives, несколько версий java
.. _alternatives-java:

Как мне выбрать версию Java по умолчанию?
==============================================

Для выбора дефолтной версии Java следует использовать систему альтернатив:

.. code-block:: bash

    sudo update-alternatives --config java

.. index:: dnf, repository contents, список пакетов репозитория
.. _dnf-repo-contents:

Как вывести список пакетов из определённого репозитория?
============================================================

Вывод полного списка пакетов из репозитория (на примере rpmfusion-free):

.. code-block:: bash

    sudo dnf repo-pkgs rpmfusion-free list

Вывод полного списка установленных пакетов из репозитория (также на примере rpmfusion-free):

.. code-block:: bash

    sudo dnf repo-pkgs rpmfusion-free list installed

.. index:: dnf, repository orphans, список пакетов-сирот
.. _dnf-repo-orphans:

Как вывести список пакетов, установленных не из репозиториев, либо удалённых из них?
========================================================================================

Выполним в терминале:

.. code-block:: bash

    sudo dnf -C list extras

.. index:: dnf, transactions, history cleanup, очистка истории транзакций
.. _dnf-transactions-cleanup:

Как очистить журнал транзакций dnf?
=======================================

Для очистки журнала транзакций dnf history, выполним:

.. code-block:: bash

    sudo rm -rf /var/lib/dnf/history/*

.. index:: dnf, installed list export, экспорт списка установленных пакетов
.. _dnf-list-export:

Как сохранить список установленных пакетов, чтобы легко установить их после переустановки системы?
=====================================================================================================

Экспортируем список установленных вручную пакетов:

.. code-block:: bash

    sudo dnf repoquery --qf "%{name}" --userinstalled > ~/packages.lst

Копируем любым способом получившийся файл **~/packages.lst** на другое устройство.

Устанавливаем отсутствующие пакеты:

.. code-block:: bash

    sudo dnf install $(cat ~/packages.lst)

.. index:: dnf, download package only, скачать пакет без установки
.. _dnf-download-only:

Можно ли скачать, но не устанавливать пакет из репозитория?
===============================================================

Скачивание пакета foo-bar в текущий рабочий каталог:

.. code-block:: bash

    dnf download foo-bar

Скачивание пакета foo-bar в текущий рабочий каталог вместе со всеми его зависимостями, отсутствующими в системе в настоящий момент:

.. code-block:: bash

    dnf download --resolve foo-bar

Скачивание пакета foo-bar вместе со всеми зависимостями в указанный каталог:

.. code-block:: bash

    dnf download --resolve foo-bar --downloaddir ~/mypkg

Для работы плагина dnf-download права суперпользователя не требуются.

.. index:: dnf, repositories, управление репозиториями
.. _dnf-manage-repo:

Как правильно включать или отключать репозитории?
=========================================================

Включить репозиторий постоянно (на примере *foo-bar*):

.. code-block:: bash

    sudo dnf config-manager --set-enabled foo-bar

Отключить репозиторий постоянно:

.. code-block:: bash

    sudo dnf config-manager --set-disabled foo-bar

Временно подключить репозиторий и установить пакет из него:

.. code-block:: bash

    sudo dnf install --refresh foo-bar --enablerepo=foo-bar

Опциональный параметр **--refresh** добавляется для принудительного обновления кэшей dnf.
