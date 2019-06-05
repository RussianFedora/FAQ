.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
.. 
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
.. 
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
.. _networking:

*************************
Сетевое администрирование
*************************

.. index:: openvpn, vpn, traffic encryption, pptp, l2tp, ipsec, wireguard
.. _vpn-selection:

Хочу обезопасить свой Интернет-трафик. Какую реализацию VPN выбрать?
=======================================================================

WireGuard
^^^^^^^^^^^^^

:ref:`WireGuard <using-wireguard>` - самый современный и актуальный протокол для VPN. Обеспечивает максимальную скорость работы за счёт реализации в виде модуля ядра Linux и надёжную криптографическую защиту от прослушивания.

OpenVPN
^^^^^^^^^^^

:ref:`OpenVPN <using-openvpn>` - cамая популярная и стабильная в настоящее время реализация VPN. Способен работать как через UDP, так и TCP, имеет плагины маскировки под TLS, обеспечивает высокую защищённость, но имеет низкую производительность из-за постоянных переключений между режимами пользователя и ядра.

L2TP/IPSec
^^^^^^^^^^^^^^

Поддерживается большинством роутеров "из коробки", но является устаревшим. Изначально создавался для Windows, поэтому многие серверы заточены под соответствующие реализации клиентов.

PPTP
^^^^^^^^

Устаревший, `уязвимый by design <https://xakep.ru/2012/07/30/59067/>`__ протокол. Трафик, проходящий через сеть, использующую данный протокол, может быть легко расшифрован за несколько часов. Категорически не рекомендуется к применению даже на устаревшем оборудовании.

.. index:: ssh, keys, error
.. _ssh-keys-error:

При использовании SSH появляется ошибка доступа к ключам. Как исправить?
===========================================================================

См. `здесь <https://www.easycoding.org/2016/07/31/reshaem-problemu-s-ssh-klyuchami-v-fedora-24.html>`__.

.. index:: firewalld, port forwarding, firewall
.. _firewalld-port-forwarding:

Как пробросить локальный порт на удалённый хост?
====================================================

См. `здесь <https://www.easycoding.org/2017/05/23/probrasyvaem-lokalnyj-port-na-udalyonnyj-xost.html>`__.

.. index:: openvpn, vpn, network
.. _using-openvpn:

Как поднять OpenVPN сервер в Fedora?
=======================================

См. `здесь <https://www.easycoding.org/2017/07/24/podnimaem-ovn-server-na-fedora.html>`__. В данной статье вместо **ovn** следует использовать **openvpn** во всех путях и именах юнитов.

.. index:: wireguard, vpn, network
.. _using-wireguard:

Как поднять WireGuard сервер в Fedora?
=========================================

См. `здесь <https://www.easycoding.org/2019/02/28/podnimaem-wireguard-server-na-fedora.html>`__.

.. index:: server, matrix, im
.. _matrix-server:

Как поднять свой сервер Matrix в Fedora?
===========================================

См. `здесь <https://www.easycoding.org/2018/04/15/podnimaem-sobstvennyj-matrix-server-v-fedora.html>`__.

.. index:: server, web server, http
.. _simple-web-server:

Как запустить простейший веб-сервер в Fedora?
================================================

Для запуска простейшего веб-сервера можно использовать Python и модуль, входящий в состав базового пакета:

.. code-block:: text

    python3 -m http.server 8080

Веб-сервер будет запущен на порту **8080**. В качестве webroot будет использоваться текущий рабочий каталог.

.. index:: network, configuration
.. _network-configuration:

Как лучше настраивать сетевые подключения?
=============================================

В Fedora для настройки сети используется Network Manager. Для работы с ним доступны как графические менеджеры (встроены в каждую DE), так и консольный **nm-cli**.

.. index:: multimedia, dlna, server, streaming
.. _dlna-server:

Как поднять DLNA сервер в локальной сети?
============================================

См. `здесь <https://www.easycoding.org/2018/09/08/podnimaem-dlna-server-v-fedora.html>`__.

.. index:: network speed, iperf, benchmark
.. _fedora-iperf:

Как сделать замеры скорости локальной или беспроводной сети?
================================================================

Для точных замеров производительности сети нам потребуется как минимум два компьютера (либо компьютер и мобильное устройство), а также утилита iperf, присутствующая в репозиториях Fedora. Установим её:

.. code-block:: text

    sudo dnf install iperf2

На первом устройстве запустим сервер iperf:

.. code-block:: text

    iperf -s

По умолчанию iperf прослушивает порт **5001/tcp** на всех доступных сетевых соединениях.

Теперь временно разрешим входящие соединения на данный порт посредством :ref:`Firewalld <firewalld-about>` (правило будет действовать до перезагрузки):

.. code-block:: text

    sudo firewall-cmd --add-port=5001/tcp

На втором устройстве запустим клиент и подключимся к серверу:

.. code-block:: text

    iperf -c 192.168.1.2

В качестве клиента может выступать и мобильное устройство на базе ОС Android с установленным `Network Tools <https://play.google.com/store/apps/details?id=net.he.networktools>`__. В этом случае в главном меню программы следует выбрать пункт **Iperf2**, а в окне подключения ввести:

.. code-block:: text

    -c 192.168.1.2

Параметр **-c** обязателен. Если он не указан, программа выдаст ошибку.

**192.168.1.2** - это внутренний IP-адрес устройства в ЛВС, на котором запущен сервер. Номер порта указывать не требуется.

.. index:: ssh, rsync, sync
.. _rsync-remote:

Как передать содержимое каталога на удалённый сервер?
==========================================================

Передача содержимого локального каталога на удалённый сервер посредством rsync:

.. code-block:: text

    rsync -chavzP --stats /path/to/local user@example.org:/path/to/remote

Здесь **user@example.org** - данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост.

.. index:: ssh, rsync, sync
.. _rsync-local:

Как получить содержимое каталога с удалённого сервера?
===========================================================

Получение содержимого каталога с удалённого сервера посредством rsync:

.. code-block:: text

    rsync -chavzP --stats user@example.org:/path/to/remote /path/to/local

Здесь **user@example.org** - данные для подключения к серверу, т.е. имя пользователя на удалённом сервере и хост.

.. index:: dns, change dns
.. _change-dns:

Как правильно указать DNS серверы в Fedora?
================================================

Для того, чтобы указать другие DNS серверы, необходимо использовать Network Manager (графический или консольный): **свойства соединения** -> страница **IPv4** -> **другие DNS серверы**.

.. index:: dns, resolv.conf, resolver
.. _dns-resolv:

Можно ли править файл /etc/resolv.conf в Fedora?
====================================================

Нет, т.к. этот файл целиком управляется Network Manager и перезаписывается при каждом изменении статуса подключения (активация-деактивация соединений, перезапуск сервиса и т.д.).

Если необходимо указать другие DNS серверы, это следует производить через :ref:`свойства <change-dns>` соответствующего соединения.

.. index:: firewall, icmp, firewalld
.. _disable-icmp:

Как можно средствами Firewalld запретить ICMP?
===================================================

По умолчанию ICMP трафик разрешён для большей части зон, поэтому запретить его можно вручную:

.. code-block:: text

    sudo firewall-cmd --zone=public --remove-icmp-block={echo-request,echo-reply,timestamp-reply,timestamp-request} --permanent

Применим новые правила:

.. code-block:: text

    sudo firewall-cmd --reload

В данном примере для зоны **public** блокируются как входящие, так и исходящие ICMP ECHO и ICMP TIMESTAMP.

.. index:: firewall, firewalld, openvpn
.. _openvpn-allowed-ips:

Как средствами Firewalld разрешить подключение к OpenVPN серверу только с разрешённых IP адресов?
=====================================================================================================

Сначала отключим правило по умолчанию для :ref:`OpenVPN <using-openvpn>`, разрешающее доступ к серверу с любых IP адресов:

.. code-block:: text

    sudo firewall-cmd --zone=public --remove-service openvpn --permanent

Теперь создадим rich rule, разрешающее доступ с указанных IP-адресов (или подсетей):

.. code-block:: text

    sudo firewall-cmd --zone=public --add-rich-rule='rule family=ipv4 source address="1.2.3.4" service name="openvpn" accept' --permanent
    sudo firewall-cmd --zone=public --add-rich-rule='rule family=ipv4 source address="5.6.7.0/24" service name="openvpn" accept' --permanent

Применим новые правила:

.. code-block:: text

    sudo firewall-cmd --reload

Здесь **public** - имя зоны для публичного интерфейса, **1.2.3.4** - IP-адрес, а **5.6.7.0/24** - подсеть, доступ для адресов из которой следует разрешить.

.. index:: firewall, firewalld, wireguard
.. _wireguard-allowed-ips:

Как средствами Firewalld разрешить подключение к WireGuard серверу только с разрешённых IP адресов?
======================================================================================================

Сначала отключим правило по умолчанию для :ref:`WireGuard <using-wireguard>`, разрешающее доступ к серверу с любых IP адресов:

.. code-block:: text

    sudo firewall-cmd --zone=public --remove-port=27015/udp --permanent

Теперь создадим rich rule, разрешающее доступ с указанных IP-адресов (или подсетей):

.. code-block:: text

    sudo firewall-cmd --zone=public --add-rich-rule='rule family=ipv4 source address="1.2.3.4" port port=27015 protocol=udp accept' --permanent
    sudo firewall-cmd --zone=public --add-rich-rule='rule family=ipv4 source address="5.6.7.0/24" port port=27015 protocol=udp accept' --permanent

Применим новые правила:

.. code-block:: text

    sudo firewall-cmd --reload

Здесь **27015** - порт сервера WireGuard, **public** - имя зоны для публичного интерфейса, **1.2.3.4** - IP-адрес, а **5.6.7.0/24** - подсеть, доступ для адресов из которой следует разрешить.

.. index:: ip address, external ip, curl
.. _get-external-ip:

Как узнать внешний IP адрес за NAT провайдера?
===================================================

Для этой цели можно использовать внешний сервис, возвращающий только внешний IP и утилиту **curl**:

.. code-block:: text

    curl https://ifconfig.me

.. index:: firewall, firewalld, web server, http, https, cloudflare
.. _firewalld-cloudflare:

Как средствами Firewalld разрешить подключение к веб-серверу только с IP адресов CloudFlare?
================================================================================================

При использовании CloudFlare в качестве системы защиты от DDoS атак, а также WAF, возникает необходимость разрешать входящие подключения исключительно с IP адресов данного сервиса.

Сначала отключим правило по умолчанию для веб-сервера, разрешающее доступ с любых IP адресов:

.. code-block:: text

    sudo firewall-cmd --zone=public --remove-service http --permanent
    sudo firewall-cmd --zone=public --remove-service https --permanent

Напишем небольшой скрипт ``foo-bar.sh``, который получит актуальные пулы IP-адресов и создаст rich rule, разрешающие доступ лишь с подсетей CloudFlare (`IPv4 <https://www.cloudflare.com/ips-v4>`__, `IPv6 <https://www.cloudflare.com/ips-v6>`__):

.. code-block:: bash

    #!/bin/bash
    set -ef

    API=https://www.cloudflare.com/ips-v
    ZONE=public

    function fw_add {
        local IFS=$'\n'
        local lines=($(curl -sS $API$1))
        for i in "${lines[@]}"
        do
            firewall-cmd --zone=$ZONE --add-rich-rule="rule family=ipv$1 source address=\"$i\" service name=\"http\" accept" --permanent
            firewall-cmd --zone=$ZONE --add-rich-rule="rule family=ipv$1 source address=\"$i\" service name=\"https\" accept" --permanent
        done
    }

    fw_add 4
    fw_add 6

Запустим наш скрипт:

.. code-block:: text

    sudo ./foo-bar.sh

Применим новые правила файрвола:

.. code-block:: text

    sudo firewall-cmd --reload

Здесь **public** - имя зоны для публичного сетевого интерфейса.

.. index:: web server, http, https, cloudflare, ip
.. _cloudflare-forwarding:

Как пробросить IP адреса клиентов за CloudFlare?
====================================================

См. `здесь <https://www.easycoding.org/2013/08/12/nastraivaem-probros-ip-klientov-za-cloudflare.html>`__.

.. index:: network, icmp, mtr, traceroute
.. _using-mtr:

Как проверить наличие или отсутствие потерь пакетов до узла?
===============================================================

Для проверки работоспособности сети и наличия, либо отсутствия потерь пакетов между узлами маршрута, широко используется утилита **mtr**:

.. code-block:: text

    sudo dnf install mtr

Запустим проверку маршрута до узла **example.org**:

.. code-block:: text

    mtr example.org

Приостановить работу можно нажатием клавиши **P**, для возобновить - **пробел**, а для выхода - **Q**.

.. index:: network, connection, netstat, ss, socket
.. _ss-established:

Как получить список установленных сетевых соединений?
========================================================

Воспользуемся утилитой **ss** для вывода списка установленных сетевых соединений:

.. code-block:: text

    ss -tupn

.. index:: network, connection, netstat, ss, socket, unconn, listen
.. _ss-listening:

Как получить список открытых портов?
=======================================

Воспользуемся утилитой **ss** для вывода открытых портов, ожидающих входящих соединений:

.. code-block:: text

    ss -tulpn

Статус **LISTEN** означает, что TCP-порт открыт и ожидает входящих соединений. В то же время для UDP-портов будет отображаться статус **UNCONN**, т.к. этот протокол не подразумевает предварительное открытие подключений.

.. index:: hostname, network, dhcp
.. _transient-hostname:

Почему при подключении к сети имя хоста машины изменяется?
=============================================================

DHCP сервер провайдера способен выдавать помимо IP-адресов и DNS-серверов ещё и нестандартное имя хоста. Полученное таким способом значение называется *transient hostname*. Оно будет применимо с компьютеру с момента установки соединения и до отключения от соответствующей сети.

Если на компьютере имеется несколько сетевых подключений, каждое из которых предоставляет свой hostname, основным будет считаться то, чьё соединение было установлено последним.
