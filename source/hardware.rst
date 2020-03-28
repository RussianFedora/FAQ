..
    Fedora-Faq-Ru (c) 2018 - 2020, EasyCoding Team and contributors

    Fedora-Faq-Ru is licensed under a
    Creative Commons Attribution-ShareAlike 4.0 International License.

    You should have received a copy of the license along with this
    work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.

.. _hardware:

************
Оборудование
************

.. index:: video, gpu
.. _gpu-linux:

Какие видеокарты лучше всего работают на Linux?
==================================================

Лучше всего "из коробки" работают драйверы интегрированных видеокарт Intel. На втором месте дискретные :ref:`видеоадаптеры AMD <amd-drivers>` актуальных поколений.

.. index:: video, gpu, repository, nvidia, drivers, third-party
.. _nvidia-drivers:

Как правильно установить драйверы для видеокарт NVIDIA?
==========================================================

Существует несколько вариантов проприетарных драйверов NVIDIA:

  * стандартный драйвер (десктопы, серии GeForce, Quadro, Titan):

    * :ref:`современные поколения видеокарт (900, 1000, 1600 и 2000) <nvidia-standard>`;
    * :ref:`более старые поколения видеокарт (300, 400, 500, 600 и 700) <nvidia-legacy-390>`;
    * :ref:`устаревшие поколения видеокарт (серии 6000, 7000, 8000, 9000 и 200) <nvidia-legacy-340>`;

  * ноутбуки с гибридной графикой:

    * :ref:`NVIDIA Optimus драйвер (рекомендуемый способ) <nvidia-optimus>`;
    * :ref:`Bumblebee драйвер (устаревший способ) <nvidia-legacy-optimus>`;
    * :ref:`Bumblebee драйвер для старых ноутбуков <nvidia-legacy-unmanaged>`.

.. index:: video, gpu, repository, nvidia, drivers, third-party
.. _nvidia-standard:

Как установить стандартный драйвер видеокарт NVIDIA?
========================================================

Подключим репозитории :ref:`RPM Fusion <rpmfusion>`.

Загрузим все обновления системы:

.. code-block:: text

    sudo dnf upgrade --refresh

Установим стандартные драйверы:

.. code-block:: text

    sudo dnf install gcc kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs

Если используется 64-битная ОС, но требуется запускать ещё и Steam и 32-битные версии игр, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-libs.i686

Подождём 3-5 минут и убедимся, что модули были успешно собраны:

.. code-block:: text

    sudo akmods --force

Пересоберём :ref:`образ initrd <initrd-rebuild>`:

.. code-block:: text

    sudo dracut --force

Более подробная информация доступна `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: video, gpu, repository, nvidia, drivers, third-party
.. _nvidia-legacy-390:

Как установить стандартный драйвер видеокарт NVIDIA для старых видеокарт?
============================================================================

Подключим репозитории :ref:`RPM Fusion <rpmfusion>`.

Загрузим все обновления системы:

.. code-block:: text

    sudo dnf upgrade --refresh

Установим стандартные драйверы из LTS ветки 390.xx для старых видеокарт:

.. code-block:: text

    sudo dnf install gcc kernel-headers kernel-devel akmod-nvidia-390xx xorg-x11-drv-nvidia-390xx xorg-x11-drv-nvidia-390xx-libs nvidia-settings-390xx

Если используется 64-битная ОС, но требуется запускать ещё и Steam и 32-битные версии игр, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-390xx-libs.i686

Подождём 3-5 минут и убедимся, что модули были успешно собраны:

.. code-block:: text

    sudo akmods --force

Пересоберём :ref:`образ initrd <initrd-rebuild>`:

.. code-block:: text

    sudo dracut --force

Более подробная информация доступна `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: video, gpu, repository, nvidia, drivers, third-party
.. _nvidia-legacy-340:

Как установить стандартный драйвер видеокарт NVIDIA для устаревших видеокарт?
================================================================================

Подключим репозитории :ref:`RPM Fusion <rpmfusion>`.

Загрузим все обновления системы:

.. code-block:: text

    sudo dnf upgrade --refresh

Установим стандартные драйверы из LTS ветки 340.xx для устаревших видеокарт:

.. code-block:: text

    sudo dnf install gcc kernel-headers kernel-devel akmod-nvidia-340xx xorg-x11-drv-nvidia-340xx xorg-x11-drv-nvidia-340xx-libs

Если используется 64-битная ОС, но требуется запускать ещё и Steam и 32-битные версии игр, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-340xx-libs.i686

Подождём 3-5 минут и убедимся, что модули были успешно собраны:

.. code-block:: text

    sudo akmods --force

Пересоберём :ref:`образ initrd <initrd-rebuild>`:

.. code-block:: text

    sudo dracut --force

Более подробная информация доступна `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: video, gpu, repository, nvidia, drivers, third-party, optimus
.. _nvidia-optimus:

Как установить драйвер видеокарт NVIDIA для ноутбуков?
=========================================================

Начиная с Fedora 31 и версии проприетарного драйвера 435.xx, технология NVIDIA Optimus поддерживается в полной мере "из коробки". Старые поколения видеокарт (ниже серии 700) работать не будут.

Подключим репозитории :ref:`RPM Fusion <rpmfusion>` и установим :ref:`стандартный драйвер NVIDIA <nvidia-standard>`.

Для запуска приложения на дискретном видеоадаптере передадим ему следующие :ref:`переменные окружения <env-set>` ``__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia``:

.. code-block:: text

    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia /path/to/game/launcher

Здесь вместо **/path/to/game/launcher** укажем путь к бинарнику, который требуется запустить.

Более подробная информация доступна `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: video, gpu, repository, nvidia, drivers, third-party, bumblebee, primus, optimus, legacy
.. _nvidia-legacy-optimus:

Как установить драйвер видеокарт NVIDIA для ноутбуков (устаревший способ)?
=============================================================================

**Важно:** данный способ следут применять только на устаревших версиях Fedora (30 и ниже). В современных настоятельно рекомендуется :ref:`перейти на актуальный <nvidia-optimus>`, поддерживаемой самой NVIDIA.

Если в ноутбуке установлена видеокарта, отличная от :ref:`NVIDIA GeForce GTX 1050 <nvidia-gtx1050>`, то процесс пройдёт в штатном режиме. Старые поколения (ниже серии 700) не поддерживаются.

Загрузим все обновления системы:

.. code-block:: text

    sudo dnf upgrade --refresh

Подключим репозиторий с Bumblebee:

.. code-block:: text

    sudo dnf --nogpgcheck install https://linux.itecs.ncsu.edu/redhat/public/bumblebee/fedora$(rpm -E %fedora)/noarch/bumblebee-release-1.3-1.noarch.rpm https://linux.itecs.ncsu.edu/redhat/public/bumblebee-nonfree/fedora$(rpm -E %fedora)/noarch/bumblebee-nonfree-release-1.3-1.noarch.rpm

Установим проприетарные драйверы с поддержкой NVIDIA Optimus:

.. code-block:: text

    sudo dnf install gcc kernel-headers kernel-devel bumblebee-nvidia bbswitch-dkms primus VirtualGL

Если используется 64-битная ОС, но требуется запускать ещё и Steam и 32-битные версии игр, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install VirtualGL.i686 primus.i686

Добавим аккаунт пользователя в группу **bumblebee**:

.. code-block:: text

    sudo usermod -a -G bumblebee $(whoami)

Произведём настройку сервисов:

.. code-block:: text

    sudo systemctl enable bumblebeed.service
    sudo systemctl mask nvidia-fallback.service

Более подробная информация доступна `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: video, gpu, repository, nvidia, drivers, third-party, bumblebee, primus, optimus, legacy, unmanaged
.. _nvidia-legacy-unmanaged:

Как установить драйвер видеокарт NVIDIA для устаревших ноутбуков?
=====================================================================

**Важно:** данный способ следут применять только на старых моделях ноутбуков, которые не работают с :ref:`современным драйвером <nvidia-optimus>`, поддерживаемым самой NVIDIA.

Загрузим все обновления системы:

.. code-block:: text

    sudo dnf upgrade --refresh

Подключим репозиторий с Bumblebee:

.. code-block:: text

    sudo dnf --nogpgcheck install https://linux.itecs.ncsu.edu/redhat/public/bumblebee/fedora$(rpm -E %fedora)/noarch/bumblebee-release-1.3-1.noarch.rpm

Подключим репозиторий с unmanaged-версией драйвера:

.. code-block:: text

    sudo dnf --nogpgcheck install https://linux.itecs.ncsu.edu/redhat/public/bumblebee-nonfree-unmanaged/$(rpm -E %fedora)/noarch/bumblebee-nonfree-unmanaged-release-1.5-1.noarch.rpm

Установим проприетарные драйверы с поддержкой NVIDIA Optimus:

.. code-block:: text

    sudo dnf install gcc kernel-headers kernel-devel bumblebee-nvidia bbswitch-dkms primus VirtualGL

Если используется 64-битная ОС, но требуется запускать ещё и Steam и 32-битные версии игр, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install VirtualGL.i686 primus.i686

Скачаем нужную версию legacy драйвера с `официального сайта NVIDIA <https://www.nvidia.com/en-us/drivers/unix/>`__. В качестве примера рассмотрим 340.xx:

.. code-block:: text

    wget https://us.download.nvidia.com/XFree86/Linux-x86_64/340.108/NVIDIA-Linux-x86_64-340.108.run

Переместим загруженный RUN-файл в каталог ``/etc/sysconfig/nvidia`` и установим для него корректные права доступа:

.. code-block:: text

    sudo mv ./NVIDIA-Linux-*.run /etc/sysconfig/nvidia/
    sudo chown root:bumblebee /etc/sysconfig/nvidia/NVIDIA-Linux-*.run

Добавим аккаунт пользователя в группу **bumblebee**:

.. code-block:: text

    sudo usermod -a -G bumblebee $(whoami)

Произведём настройку сервисов:

.. code-block:: text

    sudo systemctl enable bumblebeed.service
    sudo systemctl mask nvidia-fallback.service

Выполним перезагрузку:

.. code-block:: text

    sudo systemctl reboot

.. index:: video, gpu, repository, nvidia, drivers, third-party, bumblebee, primus, optimus
.. _nvidia-troubleshooting:

После установки драйверов NVIDIA возникает чёрный экран. Что делать?
=======================================================================

Если по окончании установки и перезагрузки вместо окна входа в систему появится чёрный экран, то в загрузчике добавим через пробел :ref:`следующие параметры ядра <kernelpm-once>`:

.. code-block:: text

    rd.drivers.blacklist=nouveau nouveau.modeset=0

Также необходимо зайти в модуль настройки UEFI BIOS компьютера или ноутбука и отключить функцию :ref:`UEFI Secure Boot <secure-boot>`, т.к. модули ядра проприетарного драйвера не имеют цифровой подписи, поэтому не могут быть загружены в данном режиме и, как следствие, возникнет чёрный экран, а также перевести его из режима **Windows Only** в **Other OS**.

.. index:: video, gpu, repository, nvidia, drivers, third-party, bumblebee, primus, optimus
.. _nvidia-remove:

Как удалить проприетарные драйверы NVIDIA?
=============================================

Удалим :ref:`стандартные драйверы всех типов <nvidia-standard>`:

.. code-block:: text

    sudo dnf remove \*nvidia\*

Удалим :ref:`драйверы Bumblebee <nvidia-legacy-optimus>`:

.. code-block:: text

    sudo dnf remove bumblebee\* bbswitch\* primus\* VirtualGL\*

Пересоберём :ref:`образ initrd <initrd-rebuild>`, а также :ref:`конфиг Grub 2 <grub-rebuild>`.

.. index:: video, gpu, amd, ati, drivers
.. _amd-drivers:

Как правильно установить драйверы для видеокарт AMD?
========================================================

Установка драйверов для видеокарт AMD (ATI) не требуется, т.к. и amdgpu (современные видеокарты), и radeon (устаревшие модели) входят в состав ядра Linux.

.. index:: video, gpu, amd, ati, drivers, opencl
.. _amdgpu-pro:

Как заставить работать OpenCL на видеокартах AMD?
====================================================

AMD предоставляет поддержку `OpenCL <https://ru.wikipedia.org/wiki/OpenCL>`__ на своих видеокартах исключительно на проприетарных драйверах AMDGPU-PRO, которые выпускаются только для Ubuntu LTS и на Fedora работать не будут.

Вместо OpenCL для кодирования и декодирования мультимедиа можно использовать VA-API, который работает "из коробки".

.. index:: video, gpu, nvidia, cuda, drivers
.. _nvidia-cuda:

Как установить поддержку CUDA на видеокартах NVIDIA?
=======================================================

Поддержка `CUDA <https://ru.wikipedia.org/wiki/CUDA>`__ доступна исключительно в :ref:`проприетарных драйверах <nvidia-drivers>` NVIDIA. Установим необходимые пакеты:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs

.. index:: hardware, selection
.. _linux-hardware:

На что в первую очередь следует обратить внимание при выборе ноутбука для Linux?
====================================================================================

  1. Следует обратить внимание на производителя :ref:`установленного Wi-Fi модуля <wifi-chip>`.
  2. Не рекомендуется приобретать устройства с гибридной графикой ибо технология NVIDIA Optimus в настоящее время не поддерживается под GNU/Linux официально и работает исключительно посредством Bumblebee от сторонних разработчиков, который часто работает нестабильно.
  3. Ни при каком условии не приобретать ноутбук с видеокартой :ref:`NVIDIA GeForce GTX 1050 <nvidia-gtx1050>`.
  4. Перед покупкой рекомендуется исследовать работу :ref:`свежего Fedora Live USB <download>` непосредственно на данном устройстве, а также проверить :ref:`вывод dmesg <journal-current>` на наличие ошибок ACPI.

.. index:: hardware, firmware, update
.. _fedora-fwupd:

Как обновить прошивку UEFI BIOS и других устройств непосредственно из Fedora?
==================================================================================

Для оперативного обновления микропрограмм (прошивок) существует утилита `fwupd <https://github.com/hughsie/fwupd>`__:

.. code-block:: text

    sudo dnf install fwupd

Внимание! Для работы fwupd система должна быть установлена строго в :ref:`UEFI режиме <uefi-boot>`.

Обновление базы данных программы:

.. code-block:: text

    fwupdmgr refresh

Вывод списка устройств, микропрограмма которых может быть обновлена:

.. code-block:: text

    fwupdmgr get-devices

Проверка наличия обновлений с выводом подробной информации о каждом из них:

.. code-block:: text

    fwupdmgr get-updates

Установка обнаруженных обновлений микропрограмм:

.. code-block:: text

    fwupdmgr update

Некоторые устройства могут быть обновлены лишь при следующей загрузке системы, поэтому выполним перезагрузку:

.. code-block:: text

    sudo systemctl reboot

.. index:: wi-fi, chipset, hardware, selection
.. _wifi-chip:

Какие модули Wi-Fi корректно работают в Linux?
===================================================

Без проблем работают Wi-Fi модули следующих производителей:

  * Qualcomm Atheros (однако ath10k требуют загрузки прошивок из комплекта поставки ядра);
  * Intel Wireless (требуют загрузки индивидуальных прошивок iwl из поставки ядра).

Работают 50/50:

  * Realtek (широко известны проблемы с чипами серий rtl8192cu и rtl8812au);
  * MediaTek (ранее назывался Ralink).

Не работают:

  * Broadcom (для их работы необходима установка :ref:`проприетарных драйверов <broadcom-drivers>`, которые часто ведут себя непредсказуемо и могут вызывать сбои в работе ядра системы).

.. index:: nvidia, gtx1050, video card
.. _nvidia-gtx1050:

В моём ноутбуке установлена видеокарта NVIDIA GeForce GTX 1050 и после запуска система зависает. Что делать?
================================================================================================================

Случайные зависания системы, неработоспособность тачпада и других USB устройств -- это следствие сбоев при работе свободного драйвера nouveau на данной видеокарте.

В качестве решения необходимо установить проприетарные драйверы по такому алгоритму:

  1. произвести чистую установку систему со :ref:`свежего Fedora Live USB <download>` (respin);
  2. войти в систему, установить все обновления и, **не перезагружаясь**, выполнить установку :ref:`проприетарных драйверов Optimus <nvidia-optimus>`;
  3. выполнить перезагрузку системы.

Если всё сделано верно, то система начнёт функционировать в штатном режиме. В противном случае следует повторить с самого начала.

.. index:: drivers, disable driver
.. _driver-disable:

Как можно навсегда отключить определённый драйвер устройства?
================================================================

Чтобы навсегда отключить какой-то драйвер в Linux, необходимо создать файл в каталоге ``/etc/modprobe.d`` с любым именем, например ``disable-nv.conf``, и примерно таким содержанием:

.. code-block:: text

    install nouveau /bin/false

Здесь вместо **nouveau** нужно указать реально используемые устройством драйверы.

Полный список загруженных драйверов можно получить так:

.. code-block:: text

    lspci -nnk

Теперь необходимо пересобрать inird образ:

.. code-block:: text

    sudo dracut --force

Чтобы отменить действие, достаточно удалить созданный файл и снова пересобрать initrd.

.. index:: wi-fi, rfkill, wireless
.. _rfkill-status:

Модуль настройки сети не отображает беспроводных устройств. Что делать?
===========================================================================

Для начала воспользуемся утилитой **rfkill** для того, чтобы определить состояние беспроводных модулей:

.. code-block:: text

    rfkill

Статус **hard blocked** означает, что устройство отключено аппаратно и требуется включить его определённой последовательностью **Fn + Fx** (см. руководство ноутбука).

Статус **soft blocked** означает, что устройство отключено программно, например режимом *В самолёте*.

.. index:: wi-fi, rfkill, wireless
.. _rfkill-wifi:

Как программно включить или отключить беспроводной модуль Wi-Fi?
===================================================================

Снимем программную блокировку Wi-Fi и активируем модуль:

.. code-block:: text

    rfkill unblock wlan

Установим программную блокировку Wi-Fi и отключим модуль:

.. code-block:: text

    rfkill block wlan

.. index:: bluetooth, rfkill, wireless
.. _rfkill-bluetooth:

Как программно включить или отключить беспроводной модуль Bluetooth?
=======================================================================

Снимем программную блокировку Bluetooth и активируем модуль:

.. code-block:: text

    rfkill unblock bluetooth

Установим программную блокировку Bluetooth и отключим модуль:

.. code-block:: text

    rfkill block bluetooth

.. index:: lte, rfkill, wireless
.. _rfkill-lte:

Как программно включить или отключить беспроводной модуль LTE (4G)?
======================================================================

Снимем программную блокировку LTE (4G) и активируем модуль:

.. code-block:: text

    rfkill unblock wwan

Установим программную блокировку LTE (4G) и отключим модуль:

.. code-block:: text

    rfkill block wwan

.. index:: com, rs-232, port, screen
.. _screen-com:

Как правильно работать с COM портами (RS-232)?
==================================================

Для работы с COM портами (RS-232) можно применять следующие утилиты:

  * screen;
  * putty;
  * picocom;
  * minicom.

Воспользуемся утилитой **screen** для подключения к последовательному порту:

.. code-block:: text

    screen /dev/ttyS0 115200

Здесь **/dev/ttyS0** -- путь к первому COM порту в системе, а **115200** -- скорость работы в бодах.

Если при подключении вместо текста отображается различный мусор, значит скорость указана не правильно и её следует либо подбирать экспериментально, либо получить из руководства.

Для завершения сессии следует нажать **Ctrl + A** и **k**.

Если при попытке подключения появляется сообщение об ошибке *access denied*, необходимо добавить аккаунт в :ref:`группу dialout <com-dialout>`.

.. index:: monitor, resolution, xorg, x11, dac, dhmi, d-sub, vga
.. _dac-ddc:

При подключении монитора через переходник отображается неправильное разрешение. Как исправить?
==================================================================================================

Большинство "переходников" из цифры в аналог (DVI-D -> D-SUB, HDMI -> D-SUB и т.д.) не передают данные с монитора о поддерживаемых им разрешениях экрана системе посредством протокола `Display Data Channel (DDC) <https://ru.wikipedia.org/wiki/Display_Data_Channel>`__, поэтому существует два решения:

  * не использовать подобные устройства (к тому же они значительно ухудшают качество изображения);
  * :ref:`прописать поддерживаемые разрешения <x11-resulutions>` самостоятельно в конфиге X11.

.. index:: monitor, resolution, xorg, x11
.. _x11-resulutions:

Как прописать список поддерживаемых монитором разрешений?
============================================================

Создадим отдельный файл конфигурации для монитора ``10-monitor.conf`` в каталоге ``/etc/X11/xorg.conf.d`` и пропишем доступные разрешения и используемый драйвер.

Сначала посредством запуска утилиты **cvt** вычислим значение строки ``Modeline`` для требуемого разрешения:

.. code-block:: text

    cvt 1920 1080 60

Здесь **1920** -- разрешение по горизонтали, **1080** -- по вертикали, а **60** -- частота регенерации.

Теперь создадим конфиг следующего содержания:

.. code-block:: text

    Section "Monitor"
        Identifier "VGA1"
        Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
        Option "PreferredMode" "1920x1080_60.00"
    EndSection

    Section "Screen"
        Identifier "Screen0"
        Monitor "VGA1"
        DefaultDepth 24
        SubSection "Display"
            Modes "1920x1080_60.00"
        EndSubSection
    EndSection

    Section "Device"
        Identifier "Device0"
        Driver "intel"
    EndSection

Вместо **intel** укажем реально используемый драйвер видеокарты. Изменения вступят в силу при следующей загрузке системы.

.. index:: benchmark, cpu, system
.. _benchmark-cpu:

Какой бенчмарк можно использовать для оценки производительности системы?
===========================================================================

В качестве CPU бенчмарка рекомендуется использовать `sysbench <https://github.com/akopytov/sysbench#usage>`__, либо `stress-ng <https://kernel.ubuntu.com/~cking/stress-ng/>`__:

Установим sysbench:

.. code-block:: text

    sudo dnf install sysbench

Установим stress-ng:

.. code-block:: text

    sudo dnf install stress-ng

.. index:: benchmark, video card, gpu, glxgears, glmark2, unigine
.. _benchmark-gpu:

Какой бенчмарк можно использовать для оценки производительности видеокарты?
==============================================================================

В настоящее время существует несколько бенчмарков:

Glxgears
^^^^^^^^^^^

Установка:

.. code-block:: text

    sudo dnf install glx-utils

Запуск:

.. code-block:: text

    glxgears

Выводит информацию о кадровой частоте в терминал каждые 5 секунд.

GL Mark 2
^^^^^^^^^^^^

Установка:

.. code-block:: text

    sudo dnf install glmark2

Запуск:

.. code-block:: text

    glmark2

Выводит информацию о кадровой частоте и финальный результат в терминал.

Unigine Benchmark
^^^^^^^^^^^^^^^^^^^^^

Установка:

.. code-block:: text

    wget https://assets.unigine.com/d/Unigine_Superposition-1.1.run
    chmod +x Unigine_Superposition-1.1.run
    ./Unigine_Superposition-1.1.run

Запускать бенчмарк следует при помощи созданного ярлыка в меню приложений.

.. index:: firmware, linux, kernel, device
.. _linux-firmware:

Что такое firmware и для чего она необходима?
================================================

Firmware -- это бинарный проприетарный блоб, содержащий образ прошивки, который загружается и используется определённым устройством.

В большинстве случаев, соответствующее устройство не будет функционировать без наличия данной прошивки в каталоге прошивок ядра Linux.

.. index:: firmware, linux, kernel, device
.. _firmware-install:

Где взять бинарные прошивки для устройств и как их установить?
=================================================================

:ref:`Бинарные прошивки <linux-firmware>` для большей части устройств уже находятся в пакете **linux-firmware**, но некоторые (например часть принтеров HP), загружают их самостоятельно, либо поставляют внутри отдельных firmware-пакетов.

.. index:: firmware, linux, kernel, device
.. _firmware-status:

Как проверить используются ли в моём устройстве бинарные прошивки?
=====================================================================

При загрузке :ref:`бинарных прошивок <linux-firmware>` ядро обязательно сохраняет информацию об этом в :ref:`системный журнал <journal-current>`, поэтому достаточно лишь отфильтровать его по ключевому слову *firmware*:

.. code-block:: text

    journalctl -b | grep firmware

.. index:: desktop, display, resolution
.. _display-resolution:

Можно ли использовать несколько дисплеев с разным разрешением?
=================================================================

Да. Дисплеи с разным разрешением поддерживаются как X11, так и Wayland в полной мере и настраиваются либо в графическом режиме средствами установленной графической среды, либо через **xrandr**.

.. index:: desktop, display, dpi, ppi
.. _display-dpi:

Можно ли использовать несколько дисплеев с разным значением DPI?
===================================================================

Дисплеи с разным значением DPI (PPI) не поддерживаются в X11 (но будут в будущем полноценно поддерживаться в Wayland), поэтому для вывода изображения на таких конфигурациях применяется одна из двух конфигураций:

  * upscale (базовым выставляется наиболее низкое значение DPI);
  * downscale (базовым выставляется наиболее высокое значение DPI).

Оба этих метода далеки от совершенства, что сильно портит качество изображения. Таким образом, при выборе нескольких мониторов следует убедиться в том, чтобы их DPI были одинаковыми.

.. index:: scanner, scan, sane, drivers
.. _scan-drivers:

Как настроить сканер?
========================

Установим пакет **sane-backends**, содержащий драйверы поддерживаемых сканеров:

.. code-block:: text

    sudo dnf install sane-backends sane-backends-drivers-scanners

Перезапустим :ref:`приложения <scan-app>`, поддерживающие работу со сканерами, для вступления изменений в силу.

.. index:: scanner, scan, xsane, sane
.. _scan-app:

При помощи какого приложения можно осуществлять сканирование документов?
===========================================================================

Для работы со сканерами существует приложение XSane. Установим его:

.. code-block:: text

    sudo dnf install xsane

Если в нём не отображаются устройства сканирования, необходимо :ref:`установить драйверы <scan-drivers>`.

.. index:: smart, smartctl, hdd, ssd, drive, health
.. _smart-status:

Как получить информацию о состоянии HDD или SSD накопителя?
==============================================================

Подробную информацию о состоянии накопителя можно получить из вывода системы самодиагностики `S.M.A.R.T. <https://ru.wikipedia.org/wiki/S.M.A.R.T.>`__ при помощи утилиты **smartctl**.

Установим её:

.. code-block:: text

    sudo dnf install smartmontools

Запустим утилиту:

.. code-block:: text

    sudo smartctl -a /dev/sda

Здесь вместо **/dev/sda** следует указать устройство, информацию по состоянию которого требуется вывести.

.. index:: color profile, icc profile, video, display
.. _icc-profile:

Как улучшить цветопередачу монитора, либо дисплея ноутбука?
==============================================================

Для улучшения цветопередачи рекомендуется загрузить и установить соответствующий данной ЖК матрице цветовой профиль (ICC profile).

.. index:: color profile, icc profile, video, display
.. _icc-download:

Где найти ICC профиль для установленного в моём мониторе или ноутбуке дисплея?
=================================================================================

ICC профиль можно получить либо на сайте производителя устройства, либо извлечь из набора драйверов дисплея для Windows, либо найти готовый, созданный на специальном оборудовании.

Большое количество готовых цветовых профилей для ноутбуков, созданных на специальном калибровочном оборудовании, можно найти на сайте `Notebook Check <https://www.notebookcheck.net>`__.

.. index:: color profile, icc profile, video, display, kde, gnome
.. _icc-install:

Я нашёл цветовой профиль для дисплея. Как мне его установить в систему?
==========================================================================

Пользователям KDE необходимо открыть **Параметры системы** -- **Оборудование** -- **Цветовая коррекция**, перейти на вкладку **Профили**, нажать кнопку **Добавить профиль**, указать ICC-файл на диске, после чего подвердить установку. Теперь на вкладке **Устройства** можно заменить стандартный цветовой профиль на только что установленный. Также его можно назначить по умолчанию для всех пользователей системы (потребуется :ref:`доступ к sudo <sudo-password>`).

Пользователи Gnome должны установить утилиту Gnome Color Manager, после чего импортировать и применить загруженный ICC-файл.

Изменения вступают в силу немедленно.

.. index:: tlp, laptop, notebook, battery
.. _tlp-battery:

Нужно ли использовать TLP для оптимизации работы батареи?
============================================================

На современных поколениях ноутбуков использовать TLP не следует, т.к. контроллеры аккумуляторных батарей способны самостоятельно контролировать уровень заряда и балансировать износ ячеек.

Если всё же требуется установить предел заряда например от 70% до 90%, вместо TLP лучше один раз воспользоваться фирменной утилитой производителя устройства, задать необходимые настройки и сохранить изменения в NVRAM материнской платы. В таком случае они будут работать в любой ОС.

.. index:: gpu, opengl, gl, engine, glxinfo
.. _gl-engine:

Как определить какой движок используется для вывода трёхмерной графики?
=========================================================================

Воспользуемся утилитой **glxinfo** для вывода информации об используемом OpenGL движке:

.. code-block:: text

    glxinfo | grep -E 'OpenGL version|OpenGL renderer'

.. index:: cpu, microcode, intel, amd
.. _microcode-version:

Как определить версию установленного микрокода процессора?
=============================================================

Получим версию микрокода из вывода ``/proc/cpuinfo``:

.. code-block:: text

    cat /proc/cpuinfo | grep microcode | uniq

.. index:: nvidia, gpu, vsync
.. _vsync-off:

Как отключить вертикальную синхронизацию для одного приложения?
==================================================================

На видеокартах NVIDIA с установленным :ref:`проприетарным драйвером <nvidia-drivers>` отключить вертикальную синхронизацию для одного приложения можно посредством установки :ref:`переменной окружения <env-set>` ``__GL_SYNC_TO_VBLANK`` значения ``0``:

.. code-block:: text

    __GL_SYNC_TO_VBLANK=0 /usr/bin/foo-bar

.. index:: gpu, video, reset, settings
.. _kde-video-reset:

Как сбросить настройки экрана в KDE?
=======================================

Настройки экрана хранятся внутри JSON файлов в каталоге ``~/.local/share/kscreen``, поэтому для того, чтобы их сбросить, достаточно очистить его:

.. code-block:: text

    rm -f ~/.local/share/kscreen/*

Изменения вступят в силу при следующем входе в систему.

.. index:: audio card, audio, sound, pulse audio, reset, settings
.. _pa-reset:

Как сбросить настройки звука?
================================

В Fedora настройками звука управляет PulseAudio, поэтому для того, чтобы сбросить его настройки, удалим всё содержимое каталога ``~/.config/pulse``:

.. code-block:: text

    rm -f ~/.config/pulse/*

Для вступления изменений в силу перезапустим PulseAudio:

.. code-block:: text

    pulseaudio -k
    pulseaudio -D

Сразу после этого все настройки звука будут сброшены на установленные по умолчанию.

.. index:: multimedia, encoding, nvidia, ffmpeg, gpu
.. _nvidia-encoding:

Как ускорить кодирование видео с использованием видеокарт NVIDIA?
====================================================================

Для этого нужно установить ffmpeg, а также :ref:`проприетарные драйверы NVIDIA <nvidia-drivers>` из репозиториев :ref:`RPM Fusion <rpmfusion>`.

Использование NVENC:

.. code-block:: text

    ffmpeg -i input.mp4 -acodec aac -ac 2 -ab 128k -vcodec h264_nvenc -profile high444p -pixel_format yuv444p -preset default output.mp4

Использование CUDA/CUVID:

.. code-block:: text

    ffmpeg -c:v h264_cuvid -i input.mp4 -c:v h264_nvenc -preset slow output.mkv

Здесь **input.mp4** — имя оригинального файла, который требуется перекодировать, а в **output.mp4** будет сохранён результат.

Больше информации можно найти `здесь <https://trac.ffmpeg.org/wiki/HWAccelIntro>`__.

.. index:: steam, gaming, optimus, bumblebee, primusrun, laptop, gpu, nvidia
.. _steam-optimus:

Как запустить игру из Steam на дискретной видеокарте с поддержкой Optimus?
=============================================================================

Актуальные версии клиента Steam `поддерживают <https://support.steampowered.com/kb_article.php?ref=6316-GJKC-7437>`__ технологию NVIDIA Optimus "из коробки" если установлен :ref:`проприетарный драйвер Bumblebee <nvidia-optimus>`.

Чтобы запустить игру на дискретной видеокарте, нажмём **правой кнопкой мыши** по нужной игре в Библиотеке, выберем пункт контекстного меню **Свойства**, нажмём кнопку **Установить параметры запуска** и в открывшемся окне введём команду.

Для :ref:`современных драйверов Optimus <nvidia-optimus>`:

.. code-block:: text

    __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%

Для :ref:`устаревших драйверов Bumblebee <nvidia-legacy-optimus>`:

.. code-block:: text

    primusrun %command%

Сохраним изменения, нажав **OK** и **Закрыть**.

Теперь данная игра будет всегда запускаться на дискретном видеоадаптере ноутбука.

.. index:: nvidia, gpu, wayland
.. _nvidia-wayland:

Корректно ли работает Wayland на видеокартах NVIDIA?
=======================================================

Из-за того, что NVIDIA `отказывается поддержать <https://ru.wikipedia.org/wiki/%D0%A1%D0%B8%D0%BD%D0%B4%D1%80%D0%BE%D0%BC_%D0%BD%D0%B5%D0%BF%D1%80%D0%B8%D1%8F%D1%82%D0%B8%D1%8F_%D1%87%D1%83%D0%B6%D0%BE%D0%B9_%D1%80%D0%B0%D0%B7%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%BA%D0%B8>`__ существующие технологии вывода в Wayland, на видеокартах этого производителя он не поддерживается в настоящее время.

Таким образом, пользователям Fedora с :ref:`проприетарными драйверами NVIDIA <nvidia-drivers>` следует убедиться, что в файле ``/etc/gdm/custom.conf`` убран символ комментария (**#**) около строки ``WaylandEnable=false``.

.. index:: repository, broadcom, drivers, third-party, akmod, wl
.. _broadcom-drivers:

Как правильно установить драйверы Wi-Fi модулей Broadcom?
=============================================================

Установим пропатченную версию **wpa_supplicant** из :ref:`COPR <copr>`, т.к. с обычной драйверы Broadcom `не работают <https://bugzilla.redhat.com/show_bug.cgi?id=1703745>`__:

.. code-block:: text

    sudo dnf copr enable dcaratti/wpa_supplicant
    sudo dnf upgrade --refresh wpa_supplicant

Подключим репозитории :ref:`RPM Fusion <rpmfusion>`, затем произведём установку драйвера:

.. code-block:: text

    sudo dnf upgrade --refresh
    sudo dnf install gcc kernel-devel kernel-headers akmod-wl

Убедимся, что драйверы установились корректно:

.. code-block:: text

    sudo akmods --force

Перезагрузим систему:

.. code-block:: text

    sudo systemctl reboot

.. index:: bluetooth, mouse, reconnect
.. _bluetooth-auto:

Как включить автоматическое подключение Bluetooth устройств при загрузке?
============================================================================

Включим автоматический запуск systemd-юнита:

.. code-block:: text

    sudo systemctl enable --now bluetooth.service

Отредактируем файл конфигурации ``/etc/bluetooth/main.conf``:

.. code-block:: text

    sudoedit /etc/bluetooth/main.conf

Активируем автоматическое подключение доверенных устройств при запуске:

.. code-block:: ini

    [Policy]
    AutoEnable=true

Любым способом определим HW-адрес устройства (отображается как при поиске, так и в списке подключённых), затем войдём в консоль настройки Blueooth сервера:

.. code-block:: text

    bluetoothctl

Получим список сопряжённых устройств:

.. code-block:: text

    paired-devices

Если нужное нам оборудование c HW **AA:BB:CC:DD:EE:FF** уже числится в списке, удалим его:

.. code-block:: text

    remove AA:BB:CC:DD:EE:FF

Запустим процесс поиска новых устройств, убедимся, что девайс обнаруживается, затем отключим его:

.. code-block:: text

    scan on
    scan off

Назначим доверенным:

.. code-block:: text

    trust AA:BB:CC:DD:EE:FF

Произведём сопряжение и осуществим подключение:

.. code-block:: text

    pair AA:BB:CC:DD:EE:FF
    connect AA:BB:CC:DD:EE:FF

Теперь при следующей загрузке системы, а также выходе из режима сна, выбранное устройство подключится автоматически (при его доступности конечно же).

.. index:: hdd, hard drive, hdparam
.. _hdd-spindown:

Как принудительно остановить жёсткий диск?
=============================================

Для принудительной остановки накопителя на жёстких магнитных дисках воспользуемся утилитой **hdparam**:

.. code-block:: text

    sudo hdparam -y /dev/sda

Здесь **/dev/sda** -- устройство диска, который требуется остановить. Перед выполнением команды необходимо размонтировать все разделы, расположенные на нём.

Внимание! Внезапная остановка HDD может привести к выходу его из строя. Следует использовать её на свой страх и риск.

.. index:: hdd, hard drive, hdparam
.. _hdd-timeout:

Как установить таймаут остановки жёсткого диска?
===================================================

Воспользуемся утилитой **hdparam** для установки таймаута бездействия, по истечении которого накопитель будет автоматически :ref:`остановлен <hdd-spindown>`:

.. code-block:: text

    sudo hdparam -S 300 /dev/sda

Здесь **300** -- интервал неактивности в секундах, а **/dev/sda** -- устройство диска, который будет остановлен.

.. index:: monitor, laptop, ghosting, ips
.. _ips-ghosting:

На мониторе отображаются артефакты уже закрытых окон. Как исправить?
=======================================================================

Остаточное отображение элементов уже закрытых окон является вполне нормальным явлением для большинства IPS матриц. Этот эффект называется "послесвечением" или "ghosting".

Некоторые матрицы могут программно подавлять его за счёт постоянной внутренней перерисовки, но большинство не предпринимают ничего.

Послесвечение не является гарантийным случаем, поэтому перед покупкой рекомендуется проверять матрицу монитора на наличие этого эффекта.

.. index:: memory, ram, testing, dimm, memtest86
.. _memory-testing:

Как проверить оперативную память компьютера?
================================================

Каждый :ref:`Live образ <usb-flash>` Fedora содержит специальную утилиту memtest86+, однако она требует загрузки в Legacy режиме (:ref:`UEFI <uefi-boot>` не поддерживается).

Для проверки выполним следующее:

  1. осуществим загрузку с DVD/USB *в Legacy режиме*;
  2. в меню выберем вариант **Memory test**;
  3. выберем однопоточный, либо многопоточный режим (на многих процессорах многопоточный приводит к зависаниям системы, поэтому лучше выбирать однопоточный);
  4. запустим тест и подождём несколько часов (рекомендуется выполнять тестирование в течение как минимум 8-12 часов для выявления всех возможных дефектов памяти);
  5. по окончании нажмём **Esc** для выхода и перезагрузки компьютера.

.. index:: printer, printing, cups, web
.. _cups-web:

Как войти в веб-интерфейс CUPS?
==================================

Система печати CUPS предоставляет возможность входа через веб-интерфейс, который запущен локально на `127.0.0.1:631 <http://127.0.0.1:631/>`__.

Для административных операций в качестве логина и пароля используется данные либо учётной записи любого пользователя с правом :ref:`доступа к sudo <sudo-access>`, либо суперпользователя.

.. index:: printer, printing, hp, p1102, cups
.. _hp1102-drivers:

Можно ли заставить принтер HP P1102 работать на свободных драйверах?
=======================================================================

Да, это возможно.

Удалим hplip:

.. code-block:: text

    sudo dnf remove hplip\*

Установим стандартные драйверы принтеров:

.. code-block:: text

    sudo dnf install foomatic-db foomatic-db-ppds

Установим пакет с `необходимыми утилитами <http://foo2zjs.rkkda.com/>`__:

.. code-block:: text

    sudo dnf install foo2zjs foo2xqx

Запустим модуль настройки CUPS (графический из используемой DE, либо :ref:`веб-интерфейс <cups-web>`), выберем из списка наше устройство *с суффиксом* **driverless**, осуществим стандартные настройки и завершим процедуру.

Теперь принтер сможет работать без использования проприетарных плагинов и прошивок.

.. index:: lenovo, thinkpad, throttling, cpu, laptop, notebook
.. _thinkpad-throttling:

Можно ли исправить проблему с троттлингом ноутбуков ThinkPad?
==================================================================

См. `здесь <https://www.easycoding.org/2019/07/22/reshaem-problemu-s-throttling-na-noutbukax-thinkpad.html>`__.

.. index:: wi-fi, dkms, kernel module, kernel, rtl8821ce, realtek
.. _rtl8821ce-install:

Как установить драйвер сетевой карты на чипе rtl8821ce?
==========================================================

К сожалению, Wi-Fi модули на базе чипа rtl8821ce входят :ref:`в число проблемных <wifi-chip>`, поэтому для их корректной работы необходимо установить сторонний драйвер при помощи :ref:`dkms <dkms-akmods>`.

Отключим технологию :ref:`UEFI Secure Boot <secure-boot>`, т.к. она полностью блокирует возможность загрузки неподписанных модулей.

Произведём полное :ref:`обновление системы <dnf-update>` до актуальной версии:

.. code-block:: text

    sudo dnf upgrade --refresh

Установим пакеты git, dkms, компилятор GCC, а также исходники и заголовочные файлы ядра Linux:

.. code-block:: text

    sudo dnf install git gcc dkms kernel-devel kernel-headers

Загрузим `rtl8821ce с GitHub <https://github.com/tomaspinho/rtl8821ce>`__:

.. code-block:: text

    git clone --depth=1 https://github.com/tomaspinho/rtl8821ce.git rtl8821ce

Скопируем содержимое ``rtl8821ce`` в общий каталог хранения исходников, где они будут доступны для dkms:

.. code-block:: text

    sudo cp -r rtl8821ce /usr/src/rtl8821ce-v5.5.2_34066.20190614

Запустим сборку модуля ядра и установим его:

.. code-block:: text

    sudo dkms add -m rtl8821ce -v v5.5.2_34066.20190614
    sudo dkms build -m rtl8821ce -v v5.5.2_34066.20190614
    sudo dkms install -m rtl8821ce -v v5.5.2_34066.20190614

Здесь **v5.5.2_34066.20190614** -- версия модуля rtl8821ce, которая может быть получена из файла ``rtl8821ce/include/rtw_version.h`` (без учёта суффикса **BTCOEXVERSION**).

Перезагрузим систему для вступления изменений в силу:

.. code-block:: text

    sudo systemctl reboot

Теперь Wi-Fi адаптер должен появиться в системе и начать корректно функционировать.

.. index:: wi-fi, dkms, kernel module, kernel, rtl8821ce, realtek
.. _rtl8821ce-update:

Как обновить или удалить драйвер сетевой карты на чипе rtl8821ce?
=====================================================================

При выходе новой версии драйвера rtl8812au рекомендуется сначала удалить старый, затем с нуля установить новую версию.

Удалим старый драйвер при помощи dkms:

.. code-block:: text

    sudo dkms remove rtl8821ce/v5.5.2_34066.20190614 --all

Удалим старые исходники:

.. code-block:: text

    sudo rm -rf /usr/src/rtl8821ce-v5.5.2_34066.20190614

Здесь **v5.5.2_34066.20190614** -- версия установленного в системе модуля rtl8821ce.

Загрузим и установим новую версию по :ref:`стандартной инструкции <rtl8821ce-install>`.

.. index:: ram, memory, dmidecode, dmi
.. _ram-info:

Как получить информацию об установленной оперативной памяти?
================================================================

Установим утилиту **dmidecode**:

.. code-block:: text

    sudo dnf install dmidecode

Выведем информацию об установленной оперативной памяти:

.. code-block:: text

    sudo dmidecode -t memory

.. index:: hardware acceleration, vaapi, intel
.. _vaapi-intel:

Как активировать VA-API на видеокартах Intel?
================================================

Для полноценной работы модуля :ref:`аппаратного декодирования <video-hwaccel>` мультимедиа подключим репозитории :ref:`RPM Fusion <rpmfusion>` и установим драйвер **libva-intel-driver**:

.. code-block:: text

    sudo dnf install libva-intel-driver

.. index:: hardware acceleration, vaapi, vdpau, nvidia
.. _vaapi-nvidia:

Как активировать VA-API на видеокартах NVIDIA?
=================================================

Т.к. NVIDIA использует VDPAU для :ref:`аппаратного декодирования <video-hwaccel>` мультимедиа, для активации VA-API, установим особый драйвер-конвертер **libva-vdpau-driver**:

.. code-block:: text

    sudo dnf install libva-vdpau-driver
