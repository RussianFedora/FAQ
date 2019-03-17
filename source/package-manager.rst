.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
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

.. index:: package, manager
.. _pkg-manager:

Какой менеджер пакетов используется в настоящее время?
==========================================================

Dnf, являющийся, в свою очередь, форком Yum.

.. index:: package, manager
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

.. index:: installation, pip, npm
.. _using-pip:

Можно ли использовать PIP или NPM для установки программ и модулей?
=======================================================================

Нет. Глобальная установка чего-либо через pip (pip2, pip3), либо npm, по своей деструктивности аналогична :ref:`make install <make-install>`.

.. index:: installation, pip
.. _pip-user:

Нужной Python библиотеки нет в репозиториях. Как можно безопасно использовать PIP?
=======================================================================================

В таком случае рекомендуется либо локальная установка модулей посредством pip с параметром ``--user``, либо использование :ref:`Python Virtual Environment <python-venv>`:

.. code-block:: bash

    pip3 --user install foo-bar

Установленные таким способом модули будут размещены в домашнем каталоге пользователя и не помешают работе системы.

.. index:: installation, pip, venv
.. _python-venv:

Как правильно применять Python Virtual Environment?
========================================================

Установим пакеты **python3-virtualenv** и **python3-setuptools**:

.. code-block:: bash

    sudo dnf install python3-setuptools python3-virtualenv

Создадим виртуальное окружение:

.. code-block:: bash

    python3 -m venv foo-bar

Запустим его:

.. code-block:: bash

    source foo-bar/bin/activate

Теперь внутри него допускается использовать любые механизмы установки пакетов Python: pip, install.py и т.д.

Здесь **foo-bar** - название venv контейнера. Допускается создавать неограниченное их количество.

.. index:: dm change, dm, display manager, sddm, gdm
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
    sudo dnf system-upgrade download --releasever=$(($(rpm -E %fedora) + 1))
    sudo dnf system-upgrade reboot

Весь процесс установки будет выполнен во время следующей загрузки системы.

Если произошёл какой-то конфликт, то рекомендуется очистить все кэши dnf:

.. code-block:: bash

    sudo dnf clean all

.. index:: fedora, upgrade, rawhide
.. _dist-rawhide:

Как мне обновить Fedora до Rawhide?
===========================================

Допускается обновление с любой поддерживаемой версии Fedora до Rawhide. Следует помнить, что это действие необратимо. Пути назад на стабильный выпуск без полной переустановки системы уже не будет.

.. code-block:: bash

    sudo dnf upgrade --refresh
    sudo dnf install dnf-plugin-system-upgrade
    sudo dnf system-upgrade download --releasever=rawhide
    sudo dnf system-upgrade reboot

Весь процесс установки будет выполнен во время следующей загрузки системы.

.. index:: fedora, upgrade
.. _upgrade-jump:

Можно ли обновляться через несколько версий?
===============================================

Официально поддерживается лишь :ref:`обновление <dist-upgrade>` с текущей на следующую версию. Если требуется осуществить прыжок через несколько версий, настоятельно рекомендуется обновлять систему последовательно (например F27 -> F28 -> F29 -> F30).

.. index:: fedora, upgrade
.. _upgrade-time:

Когда лучше выполнять обновление при выходе новой версии дистрибутива?
=========================================================================

Рекомендуется :ref:`обновлять систему <dist-upgrade>` до новой версии Fedora в течение месяца после её официального релиза.

.. index:: dnf, package error, error
.. _dnf-duplicates:

При обновлении dnf ругается на дубликаты пакетов.
===================================================

Установим утилиту **package-cleanup**:

.. code-block:: bash

    sudo dnf install dnf-utils

Удалим дубликаты и повреждённые пакеты:

.. code-block:: bash

    sudo package-cleanup --cleandupes

.. index:: dnf, error, rpm
.. _dnf-rpmdb:

База RPM оказалась повреждена. Как восстановить?
=====================================================

Для запуска пересборки базы данных RPM следует выполнить:

.. code-block:: bash

    sudo rpm --rebuilddb

Настоятельно рекомендуется сделать резервную копию каталога ``/var/lib/rpm`` перед этим действием.

.. index:: dnf, kernel count, kernel
.. _dnf-kernel-store:

Dnf сохраняет старые ядра. Это нормально?
==============================================

Да. По умолчанию dnf сохраняет 3 последних ядра, чтобы в случае сбоя была возможность загрузки в более старое и исправления работы системы.

.. index:: dnf, kernel count, kernel
.. _dnf-kernel-change:

Как можно уменьшить количество сохраняемых ядер?
====================================================

Необходимо открыть файл ``/etc/dnf/dnf.conf`` в любом текстовом редакторе и изменить значение переменной ``installonly_limit``:

.. code-block:: text

    installonly_limit=2

Минимально допустимое значение - **2** (будут сохраняться два ядра: текущее и предыдущее).

.. index:: dnf, proxy
.. _dnf-proxy:

Как настроить работу dnf через прокси?
=========================================

Необходимо открыть файл ``/etc/dnf/dnf.conf`` в любом текстовом редакторе и изменить значение переменной ``proxy`` (при отсутствии добавить):

.. code-block:: text

    proxy=socks5://localhost:8080

Поддерживаются HTTP, HTTPS и SOCKS.

Если используемый прокси-сервер требует проверки подлинности (аутентификации), то необходимо также указать данные для входа:

.. code-block:: text

    proxy_username=LOGIN
    proxy_password=PASSWORD

Здесь **LOGIN** - логин пользователя на прокси-сервере, а **PASSWORD** - его пароль.

.. index:: dnf, weak dependencies
.. _dnf-weakdeps:

Как отключить установку слабых зависимостей?
================================================

Необходимо открыть файл ``/etc/dnf/dnf.conf`` в любом текстовом редакторе и изменить значение переменной ``install_weak_deps`` (при отсутствии добавить):

.. code-block:: text

    install_weak_deps=0

.. index:: dnf, package, updates
.. _dnf-pkgupdates:

Как мне запретить установку обновлений для ряда пакетов?
============================================================

Необходимо открыть файл ``/etc/dnf/dnf.conf`` в любом текстовом редакторе и изменить значение переменной ``exclude`` (при отсутствии добавить):

.. code-block:: text

    exclude=kernel* PackageKit*

Здесь вместо примера следует указать нужные пакеты, разделяя их пробелом. Допускаются символы подстановки.

.. index:: dnf, remove kernel, kernel
.. _dnf-kernel-remove:

Как можно вручную удалить старое ядро?
==========================================

Для ручного удаления старого ядра можно выполнить:

.. code-block:: bash

    sudo dnf remove kernel-4.10.14* kernel-core-4.10.14* kernel-modules-4.10.14* kernel-devel-4.10.14*

Здесь **4.10.14** - это версия удаляемого ядра.

.. index:: fonts, msttcorefonts, corefonts
.. _msttcorefonts:

Как установить шрифты Microsoft в Fedora?
=============================================

См. `здесь <https://www.easycoding.org/2011/08/14/ustanovka-microsoft-core-fonts-v-fedora.html>`__.

.. index:: repository, third-party
.. _3rd-repositories:

Какие сторонние репозитории лучше всего подключать?
=======================================================

См. `здесь <https://www.easycoding.org/2017/03/24/poleznye-storonnie-repozitorii-dlya-fedora.html>`__.

.. index:: repository, flatpak, flathub
.. _flatpak:

Как работать с Flatpak пакетами в Fedora?
============================================

См. `здесь <https://www.easycoding.org/2018/07/25/rabotaem-s-flatpak-paketami-v-fedora.html>`__.

.. index:: repository, codecs, multimedia, third-party
.. _multimedia-codecs:

В системе нет кодеков мультимедиа. Как их установить?
============================================================

Для начала следует подключить репозиторий :ref:`RPM Fusion <rpmfusion>`, после чего установить кодеки из группы **multimedia**:

.. code-block:: bash

    sudo dnf groupinstall multimedia

.. index:: repository, codecs, multimedia, chromium, third-party
.. _chromium-codecs:

Я установил браузер Chromium из репозиториев, но он отказывается воспроизводить видео с большинства сайтов. Как исправить?
==============================================================================================================================

Из-за патентных ограничений браузер Chromium в репозиториях Fedora сильно кастрирован. Для восстановления полной функциональности необходимо подключить RPMFusion и установить пакет с кодеками для данного браузера:

.. code-block:: bash

    sudo dnf install chromium-libs-media-freeworld

.. index:: repository, codecs, multimedia, third-party, ffmpeg
.. _firefox-codecs:

Как активировать все доступные кодеки в браузере Firefox?
==============================================================

Браузер Mozilla Firefox использует ffmpeg для работы с мультимедийным контентом, поэтому необходимо его установить из репозитория :ref:`RPM Fusion <rpmfusion>`:

.. code-block:: bash

    sudo dnf install ffmpeg-libs

.. index:: repository, nvidia, drivers, third-party
.. _nvidia-drivers:

Как правильно установить драйверы NVIDIA?
==============================================

См. `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: virtualization, vm, kvm, virtualbox
.. _virtualization:

Какую систему управления виртуальными машинами лучше установить?
=====================================================================

Рекомендуется использовать :ref:`KVM <kvm>`, т.к. её гипервизор и необходимые модули уже находятся в ядре Linux и не вызывают проблем.

.. index:: virtualization, kvm, vm
.. _kvm:

Как правильно установить систему виртуализации KVM?
=======================================================

Установим KVM и графическую утилиту управления виртуальными машинами **virt-manager**:

.. code-block:: bash

    sudo dnf group install Virtualization

Перезагрузим машину для вступления изменений в силу:

.. code-block:: bash

    sudo systemctl reboot

.. index:: virtualization, kvm, polkit
.. _kvm-users:

Как отключить запрос пароля во время запуска или остановки виртуальных машин при использовании KVM?
=======================================================================================================

Возможностью управления виртуальными машинами обладают члены группы **libvirt**, поэтому нужно добавить в неё свой аккаунт:

.. code-block:: bash

    sudo usermod -a -G libvirt $(whoami)

.. index:: virtualization, repository, virtualbox, vm
.. _virtualbox:

Как правильно установить VirtualBox в Fedora?
================================================

Сначала нужно подключить репозиторий :ref:`RPM Fusion <rpmfusion>`, затем выполнить:

.. code-block:: bash

    sudo dnf upgrade --refresh
    sudo dnf install gcc kernel-devel kernel-headers akmod-VirtualBox VirtualBox

Для нормальной работы с USB устройствами и общими папками потребуется также добавить свой аккаунт в группу **vboxusers** и **vboxsf**:

.. code-block:: bash

    sudo usermod -a -G vboxusers $(whoami)
    sudo usermod -a -G vboxsf $(whoami)

.. index:: repository, broadcom, drivers, third-party
.. _broadcom-drivers:

Как правильно установить драйверы Wi-Fi модулей Broadcom?
=============================================================

Сначала нужно подключить :ref:`RPM Fusion <rpmfusion>`, затем выполнить:

.. code-block:: bash

    sudo dnf upgrade --refresh
    sudo dnf install gcc kernel-devel kernel-headers akmod-wl

.. index:: dnf, cache
.. _dnf-caches:

Как отключить автообновление кэшей dnf?
==============================================

См. `здесь <https://www.easycoding.org/2016/01/27/otklyuchaem-avto-obnovlenie-v-dnf-pod-fedora-22.html>`__.

.. index:: dkms, akmods, difference
.. _dkms-akmods:

Что лучше: dkms или akmods?
==============================

Конечно akmods, т.к. он автоматически собирает и устанавливает полноценные RPM пакеты.

.. index:: package updates, testing
.. _updates-testing:

Каким способом можно обновить пакет из тестовых репозиториев?
=================================================================

Чтобы установить обновление из Fedora Testing, необходимо временно подключить соответствующий репозиторий:

.. code-block:: bash

    sudo dnf upgrade --refresh foo-bar* --enablerepo=updates-testing

Репозиторий **updates-testing** подключается однократно, только для данного сеанса работы dnf.

.. index:: dnf, package contents, list
.. _dnf-list-contents:

Как получить список файлов установленного пакета?
=====================================================

.. code-block:: bash

    sudo dnf repoquery -l foo-bar

.. index:: dnf, package contents, list
.. _dnf-find-file:

Как узнать в каком пакете находится конкретный файл?
=======================================================

Для этого можно воспользоваться плагином dnf repoquery:

.. code-block:: bash

    sudo dnf repoquery -f */имя_файла

Для поиска бинарников и динамических библиотек можно применять альтернативный метод:

.. code-block:: bash

    sudo dnf provides */имя_бинарника

.. index:: dnf, java, alternatives, multiple
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

.. index:: dnf, java, alternatives, multiple
.. _alternatives-java:

Как мне выбрать версию Java по умолчанию?
==============================================

Для выбора дефолтной версии Java следует использовать систему альтернатив:

.. code-block:: bash

    sudo update-alternatives --config java

.. index:: dnf, repository contents, list
.. _dnf-repo-contents:

Как вывести список пакетов из определённого репозитория?
============================================================

Вывод полного списка пакетов из репозитория (на примере rpmfusion-free):

.. code-block:: bash

    sudo dnf repo-pkgs rpmfusion-free list

Вывод полного списка установленных пакетов из репозитория (также на примере rpmfusion-free):

.. code-block:: bash

    sudo dnf repo-pkgs rpmfusion-free list installed

.. index:: dnf, repository orphans, orphans, list
.. _dnf-repo-orphans:

Как вывести список пакетов, установленных не из репозиториев, либо удалённых из них?
========================================================================================

Выполним в терминале:

.. code-block:: bash

    sudo dnf list extras

.. index:: dnf, transactions, history cleanup, cleanup, clean
.. _dnf-transactions-cleanup:

Как очистить журнал транзакций dnf?
=======================================

Для очистки журнала транзакций dnf history, выполним:

.. code-block:: bash

    sudo rm -rf /var/lib/dnf/history/*

.. index:: dnf, installed list export, export, list, packages
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

.. index:: dnf, download package only, packages
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

.. index:: dnf, repositories
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

Опциональный параметр ``--refresh`` добавляется для принудительного обновления кэшей dnf.

.. index:: dnf, modular, modules
.. _dnf-modular:

Что такое модульные репозитории?
====================================

Репозитории Fedora Modular позволяют установить в систему несколько различных версий определённых пакетов. Они включены по умолчанию начиная с Fedora 29.

Вывод списка доступных модулей:

.. code-block:: bash

    sudo dnf module list

Установка пакета в виде модуля (на примере *nodejs*):

.. code-block:: bash

    dnf module install nodejs:6/default

Более подробную информацию о модулях можно найти `здесь <https://docs.fedoraproject.org/en-US/modularity/using-modules/>`__.

.. index:: dnf, modular, modules
.. _dnf-disable-modules:

Мне не нужна поддержка модулей. Как их можно отключить?
===========================================================

Отключение репозитория с модулями:

.. code-block:: bash

    sudo dnf config-manager --set-disabled fedora-modular
    sudo dnf config-manager --set-disabled updates-modular

Повторное включение поддержки модулей:

.. code-block:: bash

    sudo dnf config-manager --set-enabled fedora-modular
    sudo dnf config-manager --set-enabled updates-modular

.. index:: dnf, updates, gui
.. _dnf-gui-updates:

Можно ли устанавливать обновления через dnf из графического режима?
======================================================================

Устанавливать обновления посредством dnf из графического режима конечно же возможно, однако мы настоятельно не рекомендуем этого делать ибо в случае любого сбоя и падения приложения с эмулятором терминала, упадёт и менеджер пакетов, после чего ваша система может быть серьёзно повреждена и станет непригодной для использования.

Для установки обновлений посредством dnf рекомендуется два варианта:

 * переключение в консоль фреймбуфера посредством нажатия комбинации **Ctrl+Alt+F2** (для возврата в графический режим - **Ctrl+Alt+F1**), выполнение в ней нового входа в систему и запуск процесса обновления;
 * использование screen сессии. В таком случае в случае падения эмулятора терминала, процесс не будет прерван.

.. index:: packagekit, updates, gui
.. _packagekit-updates:

Безопасно ли использовать основанные на PackageKit модули обновления из графического режима?
=================================================================================================

Да, использование Gnome Software, Apper, Discover и других, основанных на PackageKit, для обновления системы из графического режима полностью безопасно, т.к. они сначала скачивают файлы обновлений в свой кэш, а для непосредственной установки уже используют специальный сервис. В случае падения GUI приложения, никаких повреждений не будет.

.. index:: updates, testing
.. _fedora-bodhi:

Как правильно тестировать новые версии пакетов в Fedora?
=============================================================

Все обновления сначала попадают в :ref:`тестовые репозитории <updates-testing>`, поэтому их сначала нужно :ref:`установить <dnf-advisory>`.

По результатам тестирования следует перейти в `Fedora Bodhi <https://bodhi.fedoraproject.org/>`__, выбрать соответствующее обновление и либо добавить ему карму (работает исправно), либо отнять (возникли какие-то проблемы), а также опционально составить краткий отчёт (особенно если обновление работает не так, как ожидалось).

Также для упрощения работы тестировщиков была создана утилита `Fedora Easy Karma <https://fedoraproject.org/wiki/Fedora_Easy_Karma>`__, позволяющая работать с Bodhi из командной строки.

.. index:: dnf, updates, testing
.. _dnf-advisory:

Как проще установить определённое обновление из тестового репозитория?
==========================================================================

Проще всего найти данное обновление в :ref:`Bodhi <fedora-bodhi>`, затем выполнить:

.. code-block:: bash

    sudo dnf upgrade --refresh --enablerepo=updates-testing --advisory=FEDORA-2018-XXXXXXXXX

Здесь **FEDORA-2018-XXXXXXXXX** - уникальный идентификатор обновления из Bodhi.

.. index:: koji, builds, testing
.. _koji-download:

Как скачать определённую сборку пакета из Koji?
====================================================

Для начала установим клиент :ref:`Koji <koji-about>`:

.. code-block:: bash

    sudo dnf install koji

Выведем список всех успешно завершённых сборок пакета **kernel** за последнюю неделю:

.. code-block:: bash

    koji list-builds --package=kernel --after=$(($(date +%s) - 604800)) --state=COMPLETE

Скачаем выбранную сборку для используемой архитектуры:

.. code-block:: bash

    koji download-build kernel-4.19.7-300.fc29 --arch=$(uname -m)

.. index:: package, version, update, fesco
.. _package-version:

Почему некоторые пакеты в Fedora не обновляют до новейших версий?
=====================================================================

Согласно `Fedora updates policy <https://docs.fedoraproject.org/en-US/fesco/Updates_Policy/#stable-releases>`__, запрещается обновлять пакеты в пределах стабильного выпуска Fedora до новых мажорных версий кроме тех, для которых было выдано :ref:`специальное разрешение <upgrades-allowed>` от FESCo.

.. index:: package, version, update, fesco
.. _upgrades-allowed:

Какие пакеты разрешено обновлять до новых версий в пределах стабильного выпуска?
====================================================================================

В настоящее время `определён список пакетов <https://docs.fedoraproject.org/en-US/fesco/Updates_Policy/#exceptions-list>`__, для которых разрешены обновления до новых версий в пределах стабильного выпуска Fedora:

 * ядро Linux;
 * весь KDE стек (включая Qt);
 * веб-браузеры и почтовые клиенты.

.. index:: gnome, shell, extension
.. _gnome-shell-extensions:

Откуда правильно устанавливать расширения для Gnome Shell?
==============================================================

Расширения для Gnome Shell можно устанавливать как в виде пакета из репозиториев, так и напрямую из `Магазина расширений Gnome <https://extensions.gnome.org/>`__. Разница лишь в том, что расширения, установленные пакетом, будут доступны сразу для всех пользователей системы.

Рекомендуется устанавливать расширения из Магазина, т.к. многие пакеты очень редко получают обновления.

.. index:: gnome, shell, extension, firefox, chromium
.. _gnome-shell-browser:

Как разрешить установку расширений Gnome Shell из веб-браузера?
==================================================================

Для того, чтобы разрешить установку :ref:`расширений Gnome Shell <gnome-shell-extensions>` из браузеров, необходимо установить соответствующий пакет:

.. code-block:: bash

    sudo dnf install gnome-shell-browser

Также данное дополнение можно установить и вручную:

 * `Firefox <https://addons.mozilla.org/ru/firefox/addon/gnome-shell-integration/>`__;
 * `Chrome/Chromium <https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=ru>`__.

.. index:: kde, plasma, extension, firefox, chromium
.. _plasma-browser:

Как разрешить установку расширений KDE Plasma из веб-браузера?
=================================================================

Для того, чтобы разрешить установку расширений оболочки KDE Plasma из браузеров, необходимо установить соответствующий пакет:

.. code-block:: bash

    sudo dnf install plasma-browser-integration

Также данное дополнение можно установить и вручную:

 * `Firefox <https://addons.mozilla.org/ru/firefox/addon/plasma-integration/>`__;
 * `Chrome/Chromium <https://chrome.google.com/webstore/detail/plasma-integration/cimiefiiaegbelhefglklhhakcgmhkai?hl=ru>`__.

.. index:: gnome, shell, tray, system tray, icon
.. _gnome-shell-tray:

Как вернуть классический системный лоток (трей) в Gnome Shell?
==================================================================

Начиная с Gnome 3.26, из области уведомлений оболочки была удалена поддержка классического системного лотка, поэтому многие приложения при закрытии или сворачивании могут не завершать свою работу, а продолжать работать в фоне без отображения видимого окна.

Восстановить трей можно посредством установки одного из :ref:`расширений Gnome Shell <gnome-shell-extensions>`. Самым популярным является `TopIcons Plus <https://extensions.gnome.org/extension/1031/topicons/>`__.

Установка для всех пользователей в виде пакета из репозиториев Fedora:

.. code-block:: bash

    sudo dnf install gnome-shell-extension-topicons-plus

.. index:: dnf, user
.. _dnf-user:

При запуске dnf без прав суперпользователя он заново загружает и обновляет кэши. Это нормально?
==================================================================================================

Да. Если необходимо, чтобы dnf использовал глобальные общесистемные кэши репозиториев, следует применять параметр ``-C``, например:

.. code-block:: bash

    dnf -C search foo

.. index:: dnf, 32-bit, i686, package
.. _dnf-remove-32bit:

Как удалить все установленные в системе 32-битные пакеты?
=============================================================

Удаление всех 32-битных пакетов из системы:

.. code-block:: bash

    sudo dnf remove "*.i686"

.. index:: dnf, mirror, repository
.. _dnf-mirror:

Можно ли создать собственное зеркало репозиториев Fedora?
============================================================

Да, см. `здесь <https://fedoraproject.org/wiki/Infrastructure/Mirroring>`__.
