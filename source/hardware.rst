..
    SPDX-FileCopyrightText: 2018-2022 EasyCoding Team and contributors

    SPDX-License-Identifier: CC-BY-SA-4.0

.. _hardware:

**************
Оборудование
**************

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

    * :ref:`современные поколения видеокарт (800, 900, 1000, 1600, 2000 и 3000) <nvidia-standard>`;
    * :ref:`более старые поколения видеокарт (600, 700) <nvidia-legacy-470>`;
    * :ref:`устаревшие поколения видеокарт (400, 500) <nvidia-legacy-390>`;

  * ноутбуки с гибридной графикой:

    * :ref:`NVIDIA Optimus драйвер (рекомендуемый способ) <nvidia-optimus>`.

.. index:: video, gpu, repository, nvidia, drivers, third-party, cuda
.. _nvidia-cuda:

Как правильно установить драйвер CUDA для видеокарт NVIDIA?
===============================================================

Драйверы `CUDA <https://ru.wikipedia.org/wiki/CUDA>`__ входят в комплект :ref:`основных проприетарных драйверов <nvidia-drivers>`, хотя и не устанавливаются по умолчанию:

  * :ref:`современные поколения видеокарт (800, 900, 1000, 1600, 2000 и 3000) <nvidia-cuda-standard>`;
  * :ref:`более старые поколения видеокарт (600, 700) <nvidia-cuda-legacy-470>`;
  * :ref:`устаревшие поколения видеокарт (400, 500) <nvidia-cuda-legacy-390>`.

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

    sudo dnf install gcc kernel-headers kernel-devel akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-power nvidia-settings

Если используется 64-битная ОС, но требуется запускать ещё и Steam и 32-битные версии игр, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-libs.i686

Подождём 3-5 минут и убедимся, что модули были успешно собраны:

.. code-block:: text

    sudo akmods --force

Пересоберём :ref:`образ initrd <initrd-rebuild>`:

.. code-block:: text

    sudo dracut --force

Активируем systemd-юниты для корректной работы спящего режима и гибернации:

.. code-block:: text

    sudo systemctl enable nvidia-{suspend,resume,hibernate}

Произведём перезагрузку системы для вступления изменений в силу:

.. code-block:: text

    sudo systemctl reboot

Более подробная информация доступна `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: video, gpu, repository, nvidia, drivers, third-party, legacy
.. _nvidia-legacy-470:

Как установить стандартный драйвер видеокарт NVIDIA для более старых видеокарт?
==================================================================================

Подключим репозитории :ref:`RPM Fusion <rpmfusion>`.

Загрузим все обновления системы:

.. code-block:: text

    sudo dnf upgrade --refresh

Установим стандартные драйверы из LTS ветки 470.xx для более старых видеокарт:

.. code-block:: text

    sudo dnf install gcc kernel-headers kernel-devel akmod-nvidia-470xx xorg-x11-drv-nvidia-470xx xorg-x11-drv-nvidia-470xx-libs xorg-x11-drv-nvidia-470xx-power nvidia-settings-470xx

Если используется 64-битная ОС, но требуется запускать ещё и Steam и 32-битные версии игр, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-470xx-libs.i686

Подождём 3-5 минут и убедимся, что модули были успешно собраны:

.. code-block:: text

    sudo akmods --force

Пересоберём :ref:`образ initrd <initrd-rebuild>`:

.. code-block:: text

    sudo dracut --force

Активируем systemd-юниты для корректной работы спящего режима и гибернации:

.. code-block:: text

    sudo systemctl enable nvidia-{suspend,resume,hibernate}

Произведём перезагрузку системы для вступления изменений в силу:

.. code-block:: text

    sudo systemctl reboot

Более подробная информация доступна `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: video, gpu, repository, nvidia, drivers, third-party, legacy
.. _nvidia-legacy-390:

Как установить стандартный драйвер видеокарт NVIDIA для устаревших видеокарт?
=================================================================================

Подключим репозитории :ref:`RPM Fusion <rpmfusion>`.

Загрузим все обновления системы:

.. code-block:: text

    sudo dnf upgrade --refresh

Установим стандартные драйверы из LTS ветки 390.xx для устаревших видеокарт:

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

Произведём перезагрузку системы для вступления изменений в силу:

.. code-block:: text

    sudo systemctl reboot

Более подробная информация доступна `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: video, gpu, repository, nvidia, drivers, third-party, optimus
.. _nvidia-optimus:

Как установить драйвер видеокарт NVIDIA для ноутбуков?
=========================================================

Начиная с Fedora 31 и версии проприетарного драйвера 435.xx, технология NVIDIA Optimus поддерживается в полной мере "из коробки". Устаревшие поколения видеокарт (ниже серии 700) работать не будут.

Подключим репозитории :ref:`RPM Fusion <rpmfusion>` и установим :ref:`стандартный драйвер NVIDIA <nvidia-drivers>`.

Для запуска приложения на дискретном видеоадаптере передадим ему следующие :ref:`переменные окружения <env-set>` ``__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia``:

.. code-block:: text

    __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia /path/to/game/launcher

Здесь вместо **/path/to/game/launcher** укажем путь к бинарнику, который требуется запустить.

Более подробная информация доступна `здесь <https://www.easycoding.org/2017/01/11/pravilnaya-ustanovka-drajverov-nvidia-v-fedora.html>`__.

.. index:: video, gpu, repository, nvidia, drivers, third-party, cuda
.. _nvidia-cuda-standard:

Как установить драйвер CUDA для современных видеокарт NVIDIA?
=================================================================

Установим проприетарные драйверы NVIDIA для :ref:`современных поколений видеокарт <nvidia-standard>`.

Установим пакеты с набором библиотек CUDA:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-cuda-libs

Если используется 64-битная ОС, но требуется запускать ещё и 32-битные версии ПО, использующие CUDA для работы, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-cuda-libs.i686

.. index:: video, gpu, repository, nvidia, drivers, third-party, cuda, legacy
.. _nvidia-cuda-legacy-470:

Как установить драйвер CUDA для более старых видеокарт NVIDIA?
==================================================================

Установим проприетарные драйверы NVIDIA для :ref:`более старых поколений видеокарт <nvidia-legacy-470>`.

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-470xx-cuda xorg-x11-drv-nvidia-470xx-cuda-libs

Если используется 64-битная ОС, но требуется запускать ещё и 32-битные версии ПО, использующие CUDA для работы, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-470xx-cuda-libs.i686

.. index:: video, gpu, repository, nvidia, drivers, third-party, cuda, legacy
.. _nvidia-cuda-legacy-390:

Как установить драйвер CUDA для устаревших видеокарт NVIDIA?
================================================================

Установим проприетарные драйверы NVIDIA для :ref:`устаревших поколений видеокарт <nvidia-legacy-390>`.

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-390xx-cuda xorg-x11-drv-nvidia-390xx-cuda-libs

Если используется 64-битная ОС, но требуется запускать ещё и 32-битные версии ПО, использующие CUDA для работы, установим также 32-битный драйвер:

.. code-block:: text

    sudo dnf install xorg-x11-drv-nvidia-390xx-cuda-libs.i686

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

Пересоберём :ref:`образ initrd <initrd-rebuild>`, а также :ref:`конфиг Grub 2 <grub-rebuild>`.

.. index:: video, gpu, amd, ati, drivers
.. _amd-drivers:

Как правильно установить драйверы для видеокарт AMD?
========================================================

Установка драйверов для видеокарт AMD (ATI) не требуется, т.к. и amdgpu (современные видеокарты), и radeon (устаревшие модели) входят в состав ядра Linux.

.. index:: video, gpu, amd, ati, drivers, opencl
.. _amdgpu-pro:

Как активировать OpenCL на видеокартах AMD из состава AMDGPU-Pro драйвера?
===============================================================================

AMD предоставляет поддержку `OpenCL <https://ru.wikipedia.org/wiki/OpenCL>`__ на своих видеокартах в проприетарных драйверах AMDGPU-Pro, которые выпускаются только для Ubuntu LTS, RHEL/CentOS, а также SLED/SLED, поэтому на Fedora работать не будут.

Вместо OpenCL для кодирования и декодирования мультимедиа можно использовать VA-API, который работает "из коробки".

.. index:: video, gpu, amd, ati, drivers, opencl, rocm
.. _rocm:

Как установить ROCm -- открытую реализацию OpenCL на видеокартах AMD?
=========================================================================

В данный момент AMD не предоставляет официальных сборок `ROCm <https://github.com/RadeonOpenCompute/ROCm>`__ -- открытой реализации `OpenCL <https://ru.wikipedia.org/wiki/OpenCL>`__ для Fedora, однако существует рабочий способ заставить работать её в данном дистрибутиве.

  1. Подключим официальный репозиторий AMD:

    .. code-block:: bash

      sudo tee /etc/yum.repos.d/ROCm.repo <<EOF
      [ROCm]
      name=ROCm
      baseurl=https://repo.radeon.com/rocm/centos8/4.0.1
      enabled=1
      gpgcheck=1
      gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
      skip_if_unavailable=True
      EOF

  2. Установим необходимые пакеты:

    .. code-block:: text

      sudo dnf install rocm-opencl

  3. Установим правильную версию пакета **rocminfo**, предварительно проверив её наличие в репозитории **repo.radeon.com**:

    .. code-block:: text

      sudo dnf repoquery --location rocminfo
      sudo rpm -Uvh --nodeps https://repo.radeon.com/rocm/centos8/4.0.1/rocminfo-1.4.0.1.rocm-rel-4.0-26-605b3a5.rpm

  4. Исправим скрипт **rocm_agent_enumerator** и адаптариуем его для Fedora:

    .. code-block:: text

      sudo sed -i 's/^#!.*/#!\/usr\/bin\/python/' /opt/rocm-4.0.1/bin/rocm_agent_enumerator

  5. Откроем файл **amdocl64_40000.icd** в текстовом редакторе:

    .. code-block:: text

      sudoedit /etc/OpenCL/vendors/amdocl64_40001.icd

    Добавим в него корректный путь к библиотеке **libamdocl64.so**:

    .. code-block:: text

      /opt/rocm-4.0.1/opencl/lib/libamdocl64.so

  6. Создадим OpenCL-профиль:

    .. code-block:: text

      sudoedit /etc/profile.d/rocm.sh

    Зададим необходимые для работы :ref:`переменные окружения <env-set>`:

    .. code-block:: bash

      export PATH=$PATH:/opt/rocm-4.0.1/opencl/bin
      export PATH=/opt/rocm-4.0.1/bin:$PATH \
          ROCM_PATH=/opt/rocm-4.0.1 \
          HIP_PATH=/opt/rocm-4.0.1/hip

После выполнения всех пунктов запустим новый экземпляр терминала для применения изменений в :ref:`переменных окружения <env-get-term>`, либо осуществим новый вход в систему.

Установим утилиту **hashcat**, которую будем использовать для проверки работоспособности OpenCL-стека:

.. code-block:: text

    sudo dnf install hashcat

Запустим hashcat в режиме теста производительности:

.. code-block:: text

    hashcat -b

Если тест прошёл успешно, всё было успешно установлено и настроено.

**Внимание!** На данный момент ROCm не поддерживает работу с графическими приложениями, такими как рендер Cycles в Blender, однако работа в этой области `ведется <https://github.com/RadeonOpenCompute/ROCm/issues/1106>`__.

Работа данного открытого OpenCL-стека не гарантируется на всех моделях видеокарт AMD Radeon.

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

  * Realtek (широко известны проблемы с чипами серий rtl8192cu, :ref:`rtl8821ce <rtl8821ce-install>` и :ref:`rtl8812au <rtl8812au-install>`);
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

.. index:: drivers, disable driver, lspci, dracut
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

Запустим тест CPU из состава sysbench:

.. code-block:: text

    sysbench --test=cpu --cpu-max-prime=20000 --num-threads=$(nproc) run

Запустим тест CPU из состава stress-ng:

.. code-block:: text

    stress-ng --cpu $(nproc) --cpu-method matrixprod --metrics --timeout 60

Запустим тест CPU из состава openssl:

.. code-block:: text

    openssl speed -multi $(nproc)

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

.. index:: firmware, linux, kernel, device, hardware, dnf
.. _firmware-install:

Где взять бинарные прошивки для устройств и как их установить?
=================================================================

:ref:`Бинарные прошивки <linux-firmware>` для большей части устройств уже находятся в пакете **linux-firmware**, но некоторые (например часть принтеров HP), загружают их самостоятельно, либо поставляют внутри отдельных firmware-пакетов.

Осуществим установку группы **@hardware-support**, содержащей весь необходимый набор:

.. code-block:: text

    sudo dnf install @hardware-support

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

    systemctl --user restart pulseaudio.service

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

    __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia %command%

Сохраним изменения, нажав **OK** и **Закрыть**.

Теперь данная игра будет всегда запускаться на дискретном видеоадаптере ноутбука.

.. index:: nvidia, gpu, wayland
.. _nvidia-wayland:

Корректно ли работает Wayland на видеокартах NVIDIA?
=======================================================

Из-за того, что NVIDIA `отказывается поддержать <https://ru.wikipedia.org/wiki/%D0%A1%D0%B8%D0%BD%D0%B4%D1%80%D0%BE%D0%BC_%D0%BD%D0%B5%D0%BF%D1%80%D0%B8%D1%8F%D1%82%D0%B8%D1%8F_%D1%87%D1%83%D0%B6%D0%BE%D0%B9_%D1%80%D0%B0%D0%B7%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%BA%D0%B8>`__ существующие технологии вывода в Wayland, на видеокартах этого производителя базовая поддержка появилась лишь в :ref:`проприетарных драйверах <nvidia-drivers>` версии 470.xx и выше.

Так как с данной реализацией до сих пор наблюдаются проблемы у многих пользователей, для активации поддержки сеанса на базе Wayland в GDM добавим символ комментария (**#**) перед строкой ``WaylandEnable=false`` в файле ``/etc/gdm/custom.conf`` и произведём перезагрузку.

.. index:: repository, broadcom, drivers, third-party, akmod, wl
.. _broadcom-drivers:

Как правильно установить драйверы Wi-Fi модулей Broadcom?
=============================================================

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

См. `здесь <https://www.easycoding.org/2019/07/22/reshaem-problemu-s-throttling-na-noutbukax-thinkpad.html>`__ и `здесь <https://www.easycoding.org/2020/01/06/ustanavlivaem-thermald-na-fedora.html>`__.

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

    sudo cp -r rtl8821ce /usr/src/rtl8821ce-v5.5.2_34066.20200325

Запустим сборку модуля ядра и установим его:

.. code-block:: text

    sudo dkms add -m rtl8821ce -v v5.5.2_34066.20200325
    sudo dkms build -m rtl8821ce -v v5.5.2_34066.20200325
    sudo dkms install -m rtl8821ce -v v5.5.2_34066.20200325

Здесь **v5.5.2_34066.20200325** -- версия модуля rtl8821ce, которая может быть получена из файла ``rtl8821ce/include/rtw_version.h`` (без учёта суффикса **BTCOEXVERSION**).

Перезагрузим систему для вступления изменений в силу:

.. code-block:: text

    sudo systemctl reboot

Теперь Wi-Fi адаптер должен появиться в системе и начать корректно функционировать.

.. index:: wi-fi, dkms, kernel module, kernel, rtl8821ce, realtek
.. _rtl8821ce-update:

Как обновить или удалить драйвер сетевой карты на чипе rtl8821ce?
=====================================================================

При выходе новой версии драйвера rtl8821ce рекомендуется сначала удалить старый, затем с нуля установить новую версию.

Удалим старый драйвер при помощи dkms:

.. code-block:: text

    sudo dkms remove rtl8821ce/v5.5.2_34066.20200325 --all

Удалим старые исходники:

.. code-block:: text

    sudo rm -rf /usr/src/rtl8821ce-v5.5.2_34066.20200325

Здесь **v5.5.2_34066.20200325** -- версия установленного в системе модуля rtl8821ce.

Загрузим и установим новую версию по :ref:`стандартной инструкции <rtl8821ce-install>`.

.. index:: wi-fi, dkms, kernel module, kernel, rtl8812au, realtek
.. _rtl8812au-install:

Как установить драйвер сетевой карты на чипе rtl8812au?
==========================================================

К сожалению, Wi-Fi модули на базе чипа rtl8812au входят :ref:`в число проблемных <wifi-chip>`, поэтому для их корректной работы необходимо установить сторонний драйвер при помощи :ref:`dkms <dkms-akmods>`.

Отключим технологию :ref:`UEFI Secure Boot <secure-boot>`, т.к. она полностью блокирует возможность загрузки неподписанных модулей.

Произведём полное :ref:`обновление системы <dnf-update>` до актуальной версии:

.. code-block:: text

    sudo dnf upgrade --refresh

Установим пакеты git, dkms, компилятор GCC, а также исходники и заголовочные файлы ядра Linux:

.. code-block:: text

    sudo dnf install git gcc dkms kernel-devel kernel-headers

Загрузим `rtl8812au с GitHub <https://github.com/gnab/rtl8812au>`__:

.. code-block:: text

    git clone --depth=1 https://github.com/gnab/rtl8812au.git rtl8812au

Скопируем содержимое ``rtl8812au`` в общий каталог хранения исходников, где они будут доступны для dkms:

.. code-block:: text

    sudo cp -r rtl8812au /usr/src/rtl8812au-v4.2.3

Запустим сборку модуля ядра и установим его:

.. code-block:: text

    sudo dkms add -m rtl8812au -v v4.2.3
    sudo dkms build -m rtl8812au -v v4.2.3
    sudo dkms install -m rtl8812au -v v4.2.3

Здесь **v4.2.3** -- версия модуля rtl8812au, которая может быть получена из файла ``rtl8812au/include/rtw_version.h``.

Перезагрузим систему для вступления изменений в силу:

.. code-block:: text

    sudo systemctl reboot

Теперь Wi-Fi адаптер должен появиться в системе и начать корректно функционировать.

.. index:: wi-fi, dkms, kernel module, kernel, rtl8812au, realtek
.. _rtl8812au-update:

Как обновить или удалить драйвер сетевой карты на чипе rtl8812au?
=====================================================================

При выходе новой версии драйвера rtl8812au рекомендуется сначала удалить старый, затем с нуля установить новую версию.

Удалим старый драйвер при помощи dkms:

.. code-block:: text

    sudo dkms remove rtl8812au/v4.2.3 --all

Удалим старые исходники:

.. code-block:: text

    sudo rm -rf /usr/src/rtl8812au-v4.2.3

Здесь **v4.2.3** -- версия установленного в системе модуля rtl8812au.

Загрузим и установим новую версию по :ref:`стандартной инструкции <rtl8812au-install>`.

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

.. index:: hardware acceleration, vaapi, vdpau, drivers
.. _hwaccel-drivers:

Какие драйверы необходимы для работы аппаратного ускорения декодирования мультимедиа?
=========================================================================================

Реализация аппаратного ускорения декодирования мультимедиа доступна на следующих видеокартах:

  * :ref:`Intel <vaapi-intel>`;
  * :ref:`NVIDIA <vaapi-nvidia>`;
  * AMD (включено в mesa).

.. index:: hardware acceleration, vaapi, intel
.. _vaapi-intel:

Как активировать VA-API на видеокартах Intel?
================================================

Для полноценной работы модуля :ref:`аппаратного декодирования <video-hwaccel>` мультимедиа подключим репозитории :ref:`RPM Fusion <rpmfusion>` и установим драйверы **libva-intel-driver** (i915) и **intel-media-driver** (iHD):

.. code-block:: text

    sudo dnf install libva-intel-driver intel-media-driver

.. index:: hardware acceleration, vaapi, vdpau, nvidia
.. _vaapi-nvidia:

Как активировать VA-API на видеокартах NVIDIA?
=================================================

Т.к. NVIDIA использует VDPAU для :ref:`аппаратного декодирования <video-hwaccel>` мультимедиа, для активации VA-API, установим особый драйвер-конвертер **libva-vdpau-driver**:

.. code-block:: text

    sudo dnf install libva-vdpau-driver

.. index:: battery, laptop, notebook
.. _battery-status:

Как вывести информацию о состоянии батареи ноутбука?
========================================================

Для вывода информации об используемых аккумуляторных батареях, воспользуемся утилитой **upower**:

.. code-block:: text

    upower -i /org/freedesktop/UPower/devices/battery_BAT0

Если в устройстве их более одной, вместо **BAT0** укажем следующую по порядку.

.. index:: bluetooth, mpris, multimedia, remote control
.. _mpris-proxy:

Как включить управление воспроизведением с Bluetooth-наушников?
===================================================================

За управление воспроизведением при помощи D-Bus событий отвечает служба `MPRIS <https://ru.wikipedia.org/wiki/MPRIS>`__.

В первую очередь убедимся, что используемый медиа-проигрыватель его поддерживает. В большинстве случаев необходимо и достаточно просто включить модуль MPRIS в настройках. В VLC например включён "из коробки".

Установим утилиту **mpris-proxy** из пакета **bluez**.

.. code-block:: text

    sudo dnf install bluez

В случае необходимости провести отладку подключения, запустим **mpris-proxy** вручную:

.. code-block:: text

    mpris-proxy

Для того, чтобы сервис запускался автоматически при старте системы, создадим :ref:`systemd-юнит <systemd-info>`:

.. code-block:: text

    mkdir -p ~/.config/systemd/user
    touch ~/.config/systemd/user/mpris-proxy.service

Откроем файл ``~/.config/systemd/user/mpris-proxy.service`` в любом :ref:`текстовом редакторе <editor-selection>` и добавим следующее содержимое:

.. code-block:: ini

    [Unit]
    Description=Forward bluetooth midi controls via mpris2 so they are picked up by supporting media players

    [Service]
    Type=simple
    ExecStart=/usr/bin/mpris-proxy

    [Install]
    WantedBy=multi-user.target

Установим правильный контекст безопасности :ref:`SELinux <selinux>`:

.. code-block:: text

    restorecon -Rv ~/.config/systemd/user

Обновим список доступных пользовательских юнитов systemd:

.. code-block:: text

    systemctl --user daemon-reload

Активируем сервис mpris-proxy и настроим его автоматический запуск:

.. code-block:: text

    systemctl --user enable --now mpris-proxy.service

.. index:: bluetooth, hd audio, aac, aptx, ldac, sbc, audio, multimedia, codecs, pulseaudio
.. _bluetooth-codecs-pulseaudio:

Как включить поддержку Bluetooth-кодеков высокого качества в PulseAudio?
============================================================================

В репозиториях Fedora модули звукового сервера PulseAudio для работы с Bluetooth собраны без поддержки AAC, aptX, aptX HD и LDAC ввиду патентных ограничений.

Однако `существует форк <https://github.com/EHfive/pulseaudio-modules-bt>`__, в котором добавлена полная поддержка данных кодеков, а также расширены возможности по настройке SBC:

.. code-block:: text

    a2dp_sink_sbc: High Fidelity Playback (A2DP Sink: SBC)
    a2dp_sink_aac: High Fidelity Playback (A2DP Sink: AAC)
    a2dp_sink_aptx: High Fidelity Playback (A2DP Sink: aptX)
    a2dp_sink_aptx_hd: High Fidelity Playback (A2DP Sink: aptX HD)
    a2dp_sink_ldac: High Fidelity Playback (A2DP Sink: LDAC)
    headset_head_unit: Headset Head Unit (HSP/HFP)

Подключим репозиторий :ref:`RPM Fusion <rpmfusion>` и заменим обычный пакет **pulseaudio-module-bluetooth** на версию с суффиксом **-freeworld**:

.. code-block:: text

    sudo dnf swap pulseaudio-module-bluetooth pulseaudio-module-bluetooth-freeworld --allowerasing

Перезапустим сервер PulseAudio:

.. code-block:: text

    systemctl --user restart pulseaudio.service

Теперь в настройках используемой графической среды, после подключения наушников, выберем необходимый кодек.

Внимание! Выбранный кодек должен поддерживаться наушниками аппаратно.

.. index:: bluetooth, hd audio, aac, aptx, ldac, sbc, audio, multimedia, codecs, pipewire
.. _bluetooth-codecs-pipewire:

Как включить поддержку Bluetooth-кодеков высокого качества в PipeWire?
==========================================================================

В репозиториях Fedora модули звукового сервера PipeWire для работы с Bluetooth собраны без поддержки AAC, aptX, aptX HD и LDAC ввиду патентных ограничений.

Подключим репозиторий :ref:`RPM Fusion <rpmfusion>` и установим пакет **pipewire-codec-aptx**:

.. code-block:: text

    sudo dnf install pipewire-codec-aptx

Перезапустим сервер PipeWire:

.. code-block:: text

    systemctl --user restart pipewire.service pipewire-pulse.service pipewire-media-session.service

.. index:: alsa, pulseaudio, audio, 5.1, 7.1, channel
.. _audio-analog-multichannel:

Как настроить многоканальный аналоговый аудиовыход?
========================================================

В простейшем случае просто выберем в настройках звука используемой рабочей среды профиль **Аналоговый объёмный 5.1 выход** (2.1, 4.0, 4.1, 5.0, 7.1).

Если же доступен только профиль **Cтерео**, то, возможно, некоторые выходы звуковой карты зарезервированы для микрофона и линейного входа.

В этом случае запустим утилиту **hdajackretask** из пакета **alsa-tools** (при отсутствии установим его -- ``sudo dnf install alsa-tools``), которая позволит нам легко и быстро переназначить выходы звуковой карты в соответствии с текущим подключением устройств вывода звука.

Интерфейс программы прост и интуитивно понятен: выходы определяются по цвету (Green, Pink, Blue и т.д.) и расположению (Rear Side, Front Side и т.д.). Здесь же можно назначить функции разъёмов на передней панели системного блока.

После внесения необходимых изменений нажмём кнопку **Install boot override** и произведём перезагрузку системы:

.. code-block:: text

    sudo systemctl reboot

Теперь в настройках звуковой карты появятся требуемые профили объёмного вывода.

.. index:: monitor, display, dead pixels, lcd, lcdtest
.. _display-check:

Как проверить дисплей на дефектные пиксели?
===============================================

Установим утилиту **lcdtest** из репозиториев Fedora:

.. code-block:: text

    sudo dnf install lcdtest

Запустим её из меню приложений на том дисплее, который требуется проверить на дефектные ("битые") пиксели.

Управление программой осуществляется исключительно при помощи клавиатуры.

Нажмём клавишу **S**, чтобы перейти в режим заливки всего экрана, а затем по очереди произведём переключение основных цветов (в любом порядке):

  * **W** - заливка белым цветом;
  * **R** - заливка красным цветом;
  * **G** - заливка зелёным цветом;
  * **B** - заливка синим цветом;
  * **K** - заливка чёрным цветом.

По окончании проверки нажмём клавишу **Q** для выхода.

.. index:: audio, pipewire, pulseaudio
.. _pipewire-revert:

Как переключиться с PipeWire на PulseAudio?
================================================

Удалим пакет **pipewire-pulseaudio** и сразу же установим **pulseaudio**:

.. code-block:: text

    sudo dnf swap pipewire-pulseaudio pulseaudio --allowerasing

Для полного вступления в силу изменений осуществим перезагрузку:

.. code-block:: text

    sudo systemctl reboot

.. index:: performance, profiles, tuned
.. _performance-profiles:

Как увеличить производительность системы?
=============================================

См. `здесь <https://www.easycoding.org/2021/07/22/upravlyaem-profilyami-proizvoditelnosti-linux.html>`__.

.. index:: trim, ssd, udev, rules, udevadm, hdd, smr, usb
.. _trim-usb:

Как включить поддержку TRIM на USB устройствах?
===================================================

По умолчанию поддержка :ref:`процедуры TRIM <ssd-trim>` для USB SSD, а также USB HDD с `технологией SMR <https://en.wikipedia.org/wiki/Shingled_magnetic_recording>`__, недоступна, поэтому любые попытки вручную запустить утилиту **fstrim** приведут к возникновению ошибки *fstrim: /media/foo-bar/: the discard operation is not supported*.

Чтобы это исправить, создадим специальный файл конфигурации udev, который разрешит использование данной функции для USB-устройств с указанными VID:PID.

Получим значения VID:PID для нужного USB-устройства:

.. code-block:: text

    lsusb

Создадим файл конфигурации ``/etc/udev/50-usb-trim.rules`` и установим для него корректные права доступа:

.. code-block:: text

    sudo touch /etc/udev/50-usb-trim.rules
    sudo chown root:root /etc/udev/50-usb-trim.rules
    sudo chmod 0644 /etc/udev/50-usb-trim.rules

Откроем данный файл в текстовом редакторе:

.. code-block:: text

    sudoedit /etc/udev/50-usb-trim.rules

Добавим по одной строке для каждого USB-устройства, для которого требуется разрешить TRIM:

.. code-block:: text

    ACTION=="add|change", ATTRS{idVendor}=="1234", ATTRS{idProduct}=="5678", SUBSYSTEM=="scsi_disk", ATTR{provisioning_mode}="unmap"

Здесь вместо **1234** укажем VID, а **5678** -- PID, полученные ранее.

Сохраним изменения и :ref:`перезагрузим правила udev <udev-rules-reload>`:

.. code-block:: text

    sudo udevadm control --reload

Изменения вступят в силу при следующем подключении накопителя.

.. index:: trim, ssd, hdd, smr, usb
.. _trim-usb-manual:

Как вручную выполнить TRIM на USB устройстве?
=================================================

Убедимся, что поддержка :ref:`TRIM на USB <trim-usb>` устройстве активирована.

Запустим данную процедуру вручную при помощи утилиты **fstrim**:

.. code-block:: text

    sudo fstrim -v /media/foo-bar

Здесь **/media/foo-bar** -- это точка монтирования.

.. index:: pipewire, wireplumber, audio, sound, session, manager
.. _pipewire-wireplumber:

Как заменить менеджер сессий PipeWire с WirePlumber на альтернативный?
=========================================================================

Начиная `с Fedora 35 <https://fedoraproject.org/wiki/Changes/WirePlumber>`__, в качестве менеджера сессий PipeWire используется WirePlumber.

При необходимости заменим его любой другой совместимой реализацией, например стандартным **pipewire-media-session**:

.. code-block:: text

    sudo dnf swap wireplumber pipewire-media-session

Произведём перезагрузку для вступления изменений в силу:

.. code-block:: text

    sudo systemctl reboot
