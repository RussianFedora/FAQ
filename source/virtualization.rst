..
    SPDX-FileCopyrightText: 2018-2022 EasyCoding Team and contributors

    SPDX-License-Identifier: CC-BY-SA-4.0

.. _virtualization:

***************
Виртуализация
***************

.. index:: virtualization, vm, kvm, virtualbox
.. _virt-selection:

Какую систему управления виртуальными машинами лучше установить?
=====================================================================

Рекомендуется использовать :ref:`KVM <kvm>`, т.к. её гипервизор и необходимые модули уже находятся в ядре Linux и не вызывают проблем.

.. index:: cpu, virtualization
.. _cpu-virt:

Как определить имеет ли процессор аппаратную поддержку виртуализации?
========================================================================

Проверим наличие флагов **vmx** (Intel), либо **svm** (AMD) в выводе ``/proc/cpuinfo``:

.. code-block:: text

    grep -Eq '(vmx|svm)' /proc/cpuinfo && echo Yes || echo No

.. index:: virtualization, kvm, vm
.. _kvm:

Как правильно установить систему виртуализации KVM?
=======================================================

Установим KVM и графическую утилиту управления виртуальными машинами **virt-manager**:

.. code-block:: text

    sudo dnf group install Virtualization

Перезагрузим машину для вступления изменений в силу:

.. code-block:: text

    sudo systemctl reboot

.. index:: virtualization, kvm, polkit
.. _kvm-users:

Как отключить запрос пароля во время запуска или остановки виртуальных машин при использовании KVM?
=======================================================================================================

Возможностью управления виртуальными машинами обладают члены группы **libvirt**, поэтому нужно добавить в неё свой аккаунт:

.. code-block:: text

    sudo usermod -a -G libvirt $(whoami)

.. index:: virtualization, repository, virtualbox, vm
.. _virtualbox:

Как правильно установить VirtualBox в Fedora?
================================================

Сначала нужно подключить репозиторий :ref:`RPM Fusion <rpmfusion>`, затем выполнить:

.. code-block:: text

    sudo dnf upgrade --refresh
    sudo dnf install gcc kernel-devel kernel-headers akmod-VirtualBox VirtualBox

Для нормальной работы с USB устройствами и общими папками потребуется также добавить свой аккаунт в группу **vboxusers** и **vboxsf**:

.. code-block:: text

    sudo usermod -a -G vboxusers $(whoami)
    sudo usermod -a -G vboxsf $(whoami)

.. index:: virtualbox, drive image, disk image, kvm, qemu, qcow2, vdi
.. _vdi-to-qcow2:

Как преобразовать образ виртуальной машины VirtualBox в формат, совместимый с KVM?
======================================================================================

Для конвертирования образов воспользуемся штатной утилитой **qemu-img**:

.. code-block:: text

    qemu-img convert -f vdi -O qcow2 /path/to/image.vdi /path/to/image.qcow2

В случае необходимости создания образа фиксированного размера, добавим параметр ``-o preallocation=full``:

.. code-block:: text

    qemu-img convert -f vdi -O qcow2 /path/to/image.vdi /path/to/image.qcow2 -o preallocation=full

.. index:: vmware, drive image, disk image, kvm, qemu, qcow2, vmx, vmdk
.. _vmdk-to-qcow2:

Как преобразовать образ виртуальной машины VMWare в формат, совместимый с KVM?
===================================================================================

Вариант 1. Воспользуемся утилитой **virt-v2v**:

.. code-block:: text

    virt-v2v -i vmx /path/to/image.vmx -o local -os /path/to/kvm -of qcow2

Вариант 2. Воспользуемся утилитой **qemu-img**:

.. code-block:: text

    qemu-img convert -f vmdk -O qcow2 /path/to/image.vmdk /path/to/image.qcow2

.. index:: hyper-v, drive image, disk image, kvm, qemu, qcow2, vpc
.. _vpc-to-qcow2:

Как преобразовать образ виртуальной машины Hyper-V в формат, совместимый с KVM?
===================================================================================

Для преобразования образа воспользуемся штатной утилитой **qemu-img**:

.. code-block:: text

    qemu-img convert -f vpc -O qcow2 /path/to/image.vpc /path/to/image.qcow2

.. index:: spectre, hardware, vulnerability, disable, mitigation, windows
.. _windows-cpuvuln:

Можно ли отключить защиту от уязвимостей CPU в гостевых Windows внутри виртуальных машин?
============================================================================================

Да, `согласно MSDN <https://support.microsoft.com/en-us/help/4072698/>`__, при помощи следующего REG файла:

.. code-block:: ini

    Windows Registry Editor Version 5.00

    [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management]
    "FeatureSettingsOverride"=dword:00000003
    "FeatureSettingsOverrideMask"=dword:00000003

.. index:: drive image, disk image, virtualbox
.. _image-type:

Какие дисковые образы лучше: динамически расширяющиеся или фиксированного размера?
=====================================================================================

Фиксированного размера, т.к. они меньше фрагментируются.

.. index:: drive image, disk image, virtualbox, vdi
.. _convert-to-fixed:

Как конвертировать динамически расширяющийся образ диска VirtualBox в фиксированный?
========================================================================================

Динамическая конвертация не поддерживается, поэтому воспользуемся утилитой **VBoxManage**, входящей в базовую поставку VirtualBox, для создания нового дискового образа на базе старого:

.. code-block:: text

    VBoxManage clonehd /path/to/System.vdi /path/to/System_fixed.vdi --variant Fixed

Теперь в свойствах виртуальной машины подключим новый образ фиксированного размера. Старый при этом можно удалить.

.. index:: drive image, disk image, kvm, qemu, qcow2
.. _convert-qcow2-to-fixed:

Как конвертировать динамически расширяющийся образ диска QCOW2 в фиксированный?
===================================================================================

Динамическая конвертация не поддерживается, поэтому воспользуемся утилитой **qemu-img** для создания нового дискового образа на базе старого.

Остановим виртуальную машину и переименуем старый файл:

.. code-block:: text

    mv System.qcow2 System-old.qcow2

Выполним преобразование:

.. code-block:: text

    qemu-img convert -f qcow2 -O qcow2 System-old.qcow2 System.qcow2 -o preallocation=full

Проверим работу с новой конфигурацией и, если всё верно, удалим оригинал:

.. code-block:: text

    rm -f System-old.qcow2

.. index:: cpu, virtualization, acceleration
.. _kvm-no-acceleration:

Можно ли использовать KVM на CPU без поддержки аппаратной виртуализации?
===========================================================================

Нет. KVM требует наличие активной :ref:`аппаратной виртуализации <cpu-virt>` и при её осутствии работать не будет.

В то же время, без наличия этой функции со стороны CPU, могут работать VirtualBox до версии 6.1.0 и VMWare, хотя и с очень низкой производительностью.

.. index:: kvm, libvirt, selinux, semanage, restorecon
.. _kvm-move-directory:

Можно ли перенести каталог с образами виртуальных машин KVM?
===============================================================

По умолчанию образы создаваемых виртуальных машин создаются в каталоге ``/var/lib/libvirt/images``, что многих не устраивает.

Переместим образы виртуальных машин на отдельный накопитель, смонтированный как ``/media/foo-bar``. ISO будем размещать в каталоге ``iso``, а дисковые образы виртуальных машин -- ``images``.

Создаём собственные политики SELinux для указанных каталогов:

.. code-block:: text

    sudo semanage fcontext -a -t virt_image_t "/media/foo-bar/iso(/.*)?"
    sudo semanage fcontext -a -t virt_image_t "/media/foo-bar/images(/.*)?"

Сбросим контекст безопасности SELinux для них:

.. code-block:: text

    sudo restorecon -Rv /media/foo-bar/iso
    sudo restorecon -Rv /media/foo-bar/images

В настройках Virt Manager добавим новую библиотеку ``/media/foo-bar/images`` и зададим её использование для всех виртуальных машин по умолчанию.

.. index:: virtualization, kvm, transfer
.. _kvm-transfer:

Как переместить виртуальную машину KVM на другой ПК?
========================================================

Переместим образы дисков из каталога ``/var/lib/libvirt/images`` старого хоста на новый :ref:`любым удобным способом <copying-data>`.

Экспортируем конфигурацию виртуальной машины:

.. code-block:: text

    virsh dumpxml vmname > vmname.xml

Здесь **vmname** -- название машины KVM, а **vmname.xml** -- имя файла, в котором будут сохранены настройки.

Импортируем ранее сохранённую конфигурацию:

.. code-block:: text

    virsh define /path/to/vmname.xml

Новая виртуальная машина появится в списке и будет готова к работе немедленно.

.. index:: virtualization, virtualbox, transfer
.. _virtualbox-transfer:

Как переместить виртуальную машину VirtualBox на другой ПК?
===============================================================

Получим список доступных виртуальных машин VirtualBox:

.. code-block:: text

    vboxmanage list vms

Экспортируем настройки и данные в открытый формат виртуализации версии 2.0:

.. code-block:: text

    vboxmanage export vmname -o vmname.ova --ovf20

Здесь **vmname** -- название виртуальной машины VirtualBox, а **vmname.ova** -- имя файла экспорта.

Переместим полученный файл на новый хост :ref:`любым удобным способом <copying-data>`, затем осуществим его импорт:

.. code-block:: text

    vboxmanage import /path/to/vmname.ova --options importtovdi

Через некоторое время новая виртуальная машина появится в списке и будет готова к работе.

.. index:: virtualization, kvm, vm, windows
.. _kvm-windows:

Как правильно установить в KVM Windows?
===========================================

См. `здесь <https://www.easycoding.org/2019/12/19/zapuskaem-windows-v-kvm-na-fedora.html>`__.

.. index:: virtualization, kvm, qemu, qcow2
.. _qcow2-type:

Какой тип QCOW2 образов выбрать?
====================================

Существует два типа образов:

  * :ref:`динамически расширяющийся <qcow2-dynamic>`;
  * :ref:`фиксированного размера <qcow2-fixed>`.

У каждого есть как достоинства, так и недостатки.

.. index:: virtualization, kvm, qemu, qcow2
.. _qcow2-dynamic:

Что нужно знать о динамически расширяющихся образах?
========================================================

Достоинства:

  * занимают меньше места на диске, постепенно расширяясь до заданного предела.

Недостатки:

  * очень сильно фрагментируются;
  * производительность значительно уступает :ref:`образам фиксированного размера <qcow2-fixed>`.

.. index:: virtualization, kvm, qemu, qcow2
.. _qcow2-fixed:

Что нужно знать об образах фиксированного размера?
========================================================

Достоинства:

  * практически не фрагментируются, т.к. все блоки для них заранее зарезервированы на диске;
  * имеют более высокую производительность по сравнению с :ref:`динамически расширяющимися образами <qcow2-dynamic>`.

Недостатки:

  * занимают очень много места на диске, хотя если файловая система поддерживает `разреженные (sparse) файлы <https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB>`__, эта функция будет использоваться в полном объёме.

.. index:: virtualization, kvm, qemu, qcow2, resize
.. _qcow2-resize:

Как увеличить размер дискового образа QCOW2?
================================================

Воспользуемся утилитой **qemu-img** для увеличения дискового образа:

.. code-block:: text

    qemu-img resize --preallocation=full /path/to/image.qcow2 +10G

При использовании :ref:`образов фиксированного размера <qcow2-fixed>`, добавим параметр ``--preallocation=full``:

.. code-block:: text

    qemu-img resize --preallocation=full /path/to/image.qcow2 +10G

Здесь вместо **+10G** укажем насколько следует расширить образ. Все операции должны выполняться при остановленной виртуальной машине, в которой он смонтирован.

По окончании, внутри гостевой ОС расширим используемую файловую систему до новых границ образа при помощи fdisk, GParted или любого другого редактора разделов диска.

.. index:: virtualization, kvm, qemu, qcow2, resize, shrink
.. _qcow2-shrink:

Как уменьшить размер дискового образа QCOW2?
================================================

Уменьшение размера дискового образа QCOW2 :ref:`при помощи qemu-img <qcow2-resize>` -- это достаточно небезопасная операция, которая может привести к его повреждению, поэтому вместо отрицательных значений для *resize* сначала уменьшим размер дисковых разделов внутри самой гостевой ОС при помощи fdisk, Gparted или любого другого редактора разделов диска так, чтобы справа осталось лишь неразмеченное пространство.

Далее воспользуемся утилитой **qemu-img** и сделаем копию образа, которая уже не будет включать неразмеченное дисковое пространство:

.. code-block:: text

    qemu-img convert -f qcow2 -O qcow2 /path/to/image.qcow2 /path/to/new_image.qcow2

В случае необходимости создания :ref:`образа фиксированного размера <qcow2-fixed>`, добавим параметр ``-o preallocation=full``:

.. code-block:: text

    qemu-img convert -f qcow2 -O qcow2 /path/to/image.qcow2 /path/to/new_image.qcow2 -o preallocation=full

Подключим новый образ к виртуальной машине вместо старого и проверим работу. Если всё верно, старый можно удалить.

.. index:: virtualization, kvm, qemu, qcow2, ssd, trim
.. _kvm-ssd:

Как оптимизировать KVM для работы с SSD-накопителей?
========================================================

Каких-то особых оптимизаций производить не требуется. Достаточно лишь использовать дисковые образы гостевых ОС в формате QCOW2, а также при их подключении указать тип контроллера **VirtIO** и установить следующие опции:

  * discard mode: unmap;
  * detect zeroes: unmap.

Конечно же как в хостовой, так и в гостевой ОС, должна быть :ref:`включена поддержка TRIM <ssd-tuning>`.

.. index:: virtualization, virt manager, kvm, qemu, desktop, shortcut
.. _kvm-desktop-entry:

Как создать ярлык запуска виртуальной машины KVM?
=====================================================

Для создания ярлыка в главном меню рабочей среды, создадим файл ``fedora-rawhide.desktop`` в каталоге ``~/.local/share/applications`` следующего содержания:

.. code-block:: ini

    [Desktop Entry]
    Name=Fedora Rawhide
    Name[ru_RU]=Fedora Rawhide
    GenericName=Start Fedora Rawhide
    GenericName[ru_RU]=Запуск Fedora Rawhide
    Comment=Start Fedora Rawhide
    Comment[ru_RU]=Запуск Fedora Rawhide
    Exec=/usr/bin/virt-manager --connect "qemu:///session" --show-domain-console "Fedora-Rawhide"
    Icon=virtualbox
    Categories=Development;
    StartupNotify=false
    Terminal=false
    Type=Application

Здесь вместо **Fedora-Rawhide** укажем реальное имя виртуальной машины KVM, а **qemu:///session** -- сеанс, в котором она создана (**session** -- пользовательский; **system** -- системный).
