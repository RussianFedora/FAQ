..
    Fedora-Faq-Ru (c) 2018 - 2020, EasyCoding Team and contributors

    Fedora-Faq-Ru is licensed under a
    Creative Commons Attribution-ShareAlike 4.0 International License.

    You should have received a copy of the license along with this
    work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.

.. _virtualization:

*************
Виртуализация
*************

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
