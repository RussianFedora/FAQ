..
    SPDX-FileCopyrightText: 2018-2022 EasyCoding Team and contributors

    SPDX-License-Identifier: CC-BY-SA-4.0

.. _development:

***************************
Разработка и сборка пакетов
***************************

.. index:: repository, package, packaging, rpm
.. _create-package:

Я хочу создать пакет для Fedora. Что мне следует знать?
============================================================

См. `здесь <https://www.easycoding.org/2019/01/28/sozdayom-rpm-pakety-dlya-fedora.html>`__ и `здесь <https://www.easycoding.org/2018/06/17/pravilno-paketim-po-dlya-linux.html>`__.

.. index:: package, packaging, rpm, building
.. _build-package:

Как собрать RPM пакет в mock?
==================================

См. `здесь <https://www.easycoding.org/2017/02/22/sobiraem-rpm-pakety-dlya-fedora-v-mock.html>`__.

.. index:: packaging, repository, maintainer
.. _becoming-maintainer:

Как добавить свой пакет в репозиторий Fedora и стать мейнтейнером?
=====================================================================

См. `здесь <https://www.easycoding.org/2016/06/20/dobavlyaem-paket-v-glavnyj-repozitorij-fedora.html>`__.

.. index:: koji, about
.. _koji-about:

Что такое Koji?
===================

`Fedora Koji <https://koji.fedoraproject.org/koji/>`__ -- это автоматизированная среда для сборки пакетов для Fedora.

.. index:: fedpkg, package, rebuild, mock, rpm
.. _fedpkg-rebuild:

Хочу внести свои правки в пакет и пересобрать его для личных нужд. Как проще это сделать?
===============================================================================================

Установим утилиты fedpkg и mock:

.. code-block:: text

    sudo dnf install fedpkg mock

Скачаем исходники необходимого пакета **foo-bar**:

.. code-block:: text

    fedpkg clone -a foo-bar

Перейдём в каталог с загруженными исходниками и переключимся на ветку для конкретной версии Fedora (если нужна версия из Rawhide -- следует использовать **master**):

.. code-block:: text

    cd foo-bar
    fedpkg switch-branch f36

Внесём свои правки, сделаем коммит в репозиторий:

.. code-block:: text

    git add -A
    git commit -m "Description of our changes."

Запустим автоматическую :ref:`сборку в mock <build-package>`:

.. code-block:: text

    fedpkg mockbuild

.. index:: git, tarball
.. _git-tarball:

Как создать tarball с исходниками из Git репозитория?
=========================================================

Если проект по какой-либо причине не поставляет готовые тарболы и отсутствует возможность их скачать напрямую с хостинга VCS, можно создать их из Git.

Клонируем репозиторий источника:

.. code-block:: text

    git clone https://example.org/foo-bar.git

Создадим архив с исходниками:

.. code-block:: text

    git archive --format=tar --prefix=foo-bar-1.0.0/ HEAD | gzip > ~/rpmbuild/SOURCES/foo-bar-1.0.0.tar.gz

Здесь **HEAD** -- указатель на актуальный коммит (вместо этого можно использовать SHA1 хеш любого коммита, а также имя тега или ветки), **foo-bar** -- название проекта, а **1.0.0** -- его версия.

.. index:: fedpkg, koji, build, rpmfusion
.. _rpmfusion-override:

Как переопределить пакет в Koji репозитория RPM Fusion?
===========================================================

Создание build override для репозитория f36-free:

.. code-block:: text

    koji-rpmfusion tag f36-free-override foo-bar-1.0-1.fc36

Удаление build override для репозитория f36-free:

.. code-block:: text

    koji-rpmfusion untag f36-free-override foo-bar-1.0-1.fc36

.. index:: rpmfusion, koji, build, repository
.. _rpmfusion-koji-regen:

Как обновить кэши репозиториев Koji в RPM Fusion?
=====================================================

Запустим обновление кэшей репозиториев для free:

.. code-block:: text

    koji-rpmfusion regen-repo f36-free-build --nowait

Запустим обновление кэшей репозиториев для nonfree:

.. code-block:: text

    koji-rpmfusion regen-repo f36-nonfree-build --nowait

.. index:: git, gmail, mail
.. _git-gmail:

Как настроить Git для работы с почтовым сервисом Gmail?
===========================================================

Для того, чтобы использовать функцию ``git send-mail`` с почтовым сервисом Gmail, необходимо:

  1. включить двухфакторную аутентификацию в настройках Google аккаунта;
  2. в настройках безопасности почтового ящика Gmail разрешить использование "небезопасных приложений" (под небезопасными Google понимает любые, не поддерживающие OAuth2);
  3. там же включить доступ к почте посредством POP3 или IMAP (это активирует также и необходимый для нас протокол SMTP);
  4. в настройках безопасности сгенерировать новый пароль для приложения;
  5. указать в файле ``~/.gitconfig`` параметры почтового сервиса;
  6. когда будет запрошен пароль, ввести созданный ранее пароль приложения.

Пример файла ``~/.gitconfig`` для работы с почтовым сервисом Gmail:

.. code-block:: ini

    [sendemail]
        smtpEncryption = tls
        smtpServer = smtp.gmail.com
        smtpUser = yourname@gmail.com
        smtpServerPort = 587

.. index:: library, shared library, linker, dlopen
.. _dlopen-usage:

Правильно ли использовать dlopen для загрузки динамических библиотек в приложении?
======================================================================================

Для загрузки динамических библиотек в приложении использовать dlopen допускается, но мы настоятельно рекомендуем избегать этого и использовать полноценную линковку по следующим причинам:

  1. в каждом дистрибутиве GNU/Linux именование библиотек, особенно если у них нет чётко установленной апстримом SOVERSION константы, ложится на плечи мейнтейнеров. К примеру есть популярная libcurl. Во всех дистрибутивах она линкуется с openssl и называется libcurl.so, а в Debian и Ubuntu была переименована в libcurl-gnutls.so из-за линковки с gnutls;
  2. нет никакой гарантии, что загрузится именно необходимая версия библиотеки, имеющая необходимую функцию, а отсутствии оной приложение будет аварийно завершено с ошибкой сегментирования;
  3. если существует несколько версий библиотеки с разными SOVERSION, необходимо самостоятельно их искать на диске и подгружать с рядом хаков ибо имя libfoo.so без указанной SOVERSION в большинстве дистрибутивов представляет собой символическую ссылку и доступен лишь после установки соответствующего development пакета. Соответственно на машинах обычных пользователей он отсутствует;
  4. о библиотеках, подгружаемых динамически, не в курсе LD, а следовательно он не сможет при загрузке образа приложения подгрузить их в память;
  5. в случае корректной линковки LD перед запуском приложения осуществит автоматический поиск необходимых экспортируемых функций во всех указанных библиотеках. При их отсутствии приложение не будет запущено;
  6. при сборке пакета динамически подгружаемые через dlopen библиотеки не будут определены и прописаны в качестве зависимостей пакета, что может вызвать проблемы у пользователей и падение приложения;

.. index:: environment, options, env, terminal
.. _env-get-term:

Как получить полный список установленных переменных окружения в текущем терминале?
======================================================================================

Получить список установленных :ref:`переменных окружения <env-set>` можно посредством выполнения утилиты **env**:

.. code-block:: text

    env

.. index:: environment, options, env, application
.. _env-get-app:

Как получить полный список установленных переменных для запущенного процесса?
================================================================================

Получение списка установленных :ref:`переменных окружения <env-set>` для запущенных процессов:

.. code-block:: text

    cat /proc/$PID/environ

Здесь **$PID** -- :ref:`PID <get-pid>` процесса, информацию о котором необходимо получить.

.. index:: environment, options, env
.. _env-set:

Как задать переменную окружения?
====================================

Вариант 1. Запуск процесса с заданной переменной окружения:

.. code-block:: text

    FOO=BAR /usr/bin/foo-bar

Вариант 2. Экспорт переменной окружения в запущенном терминале и дальнейший запуск приложения:

.. code-block:: text

    export FOO=BAR
    /usr/bin/foo-bar

Вариант 3. Модификация директивы ``Exec=`` в ярлыке запуска приложения:

.. code-block:: text

    Exec=env FOO=BAR /usr/bin/foo-bar

.. index:: environment, options, env
.. _env-unset:

Как удалить переменную окружения?
====================================

Вариант 1. Удаление экспортированной :ref:`переменной окружения <env-set>` при помощи команды оболочки **unset**:

.. code-block:: text

    unset FOO

Вариант 2. Удаление экспортированной переменной окружения в запущенном терминале и дальнейший запуск приложения:

.. code-block:: text

    unset FOO
    /usr/bin/foo-bar

Вариант 3. Модификация директивы ``Exec=`` в ярлыке запуска приложения:

.. code-block:: text

    Exec=env -u FOO /usr/bin/foo-bar

.. index:: git, vcs, configuration
.. _git-configuration:

Как правильно настроить Git для работы?
===========================================

Сначала укажем своё имя и адрес электронной почты:

.. code-block:: text

    git config --global user.name "Your Name"
    git config --global user.email email@example.org

Установим :ref:`предпочитаемый текстовый редактор <editor-git>` для работы с коммитами:

.. code-block:: text

    git config --global core.editor vim

.. index:: git, vcs, pull request, push, commit
.. _git-pull-request:

Я хочу внести правки в проект. Как правильно отправить их в апстрим?
=======================================================================

Если проект хостится на одном из популярных сервисов (GitHub, BitBucket или GitLab), сначала войдём в свой аккаунт (при осутствии создадим) и сделаем форк репозитория.

Осуществим :ref:`базовую настройку Git <git-configuration>` клиента если это ещё не было сделано ранее.

Клонируем наш форк:

.. code-block:: text

    git clone git@github.com:YOURNAME/foo-bar.git

Создадим ветку **new_feature** для наших изменений (для каждого крупного изменения следует создавать отдельную ветку и *ни в коем случае не коммитить в master*):

.. code-block:: text

    git checkout -b new_feature

Внесём свои правки в проект, затем осуществим их фиксацию:

.. code-block:: text

    git add -A
    git commit -s

В появившемся :ref:`текстовом редакторе <editor-git>` укажем подробное описание всех наших изменений на английском языке. Несмотря на то, что параметр ``-s`` является опциональным, большинство проектов требуют его использования для автоматического создания подписи вида:

.. code-block:: text

    Signed-off-by: Your Name <email@example.org>

Многие проекты обновляются слишком быстро, поэтому потребуется осуществить синхронизацию наших изменений с актуальной веткой апстрима. Для этого подключим к нашем форку оригинальный репозиторий:

.. code-block:: text

    git remote add upstream https://github.com/foo/foo-bar.git

Скачаем актуальные изменения и выполним rebase основной ветки нашего форка с апстримом:

.. code-block:: text

    git fetch upstream
    git checkout master
    git merge upstream/master

Осуществим rebase ветки с нашими изменениями с основной:

.. code-block:: text

    git checkout new_feature
    git rebase master

Отправим наши изменения на сервер:

.. code-block:: text

    git push -u origin new_feature

Создадим новый Pull Request.

.. index:: c++, cxx, application, console
.. _cxx-console:

Как скомпилировать простую программу на языке C++ из консоли?
================================================================

Установим компилятор GCC-C++ (G++) и ряд вспомогательных компонентов:

.. code-block:: text

    sudo dnf install gcc-c++ rpm-build

Создадим простейший пример ``helloworld.cpp``:

.. code-block:: c++

    #include <iostream>

    int main(int argc, char *argv[], char *env[])
    {
        std::cout << "Hello, World!" << std::endl;
        return 0;
    }

Скомпилируем и слинкуем его:

.. code-block:: text

    g++ $(rpm -E %{optflags}) -fPIC helloworld.cpp -o helloworld $(rpm -E %{build_ldflags}) -lstdc++

Здесь **g++** -- запускающий файл файл компилятора, **helloworld.cpp** -- файл с исходным кодом (если их несколько, то разделяются пробелом), **helloworld** -- имя результирующего бинарника, **-lstdc++** -- указание компоновщику на необходимость линковки со стандартной библиотекой C++.

Корректные флаги компиляции и компоновки вставляются автоматически из соответствующих макросов RPM.

Запустим результат сборки:

.. code-block:: text

    ./helloworld

Если всё сделано верно, то увидим сообщение *Hello, World!* в консоли.

.. index:: gdb, debugging, segfault, segmentation fault
.. _debug-application:

Приложение падает. Как мне его отладить?
===========================================

Для начала рекомендуется (хотя и не обязательно) установить отладочную информацию для данного пакета:

.. code-block:: text

    sudo dnf debuginfo-install foo-bar

После завершения процесса отладки символы можно снова удалить.

Чтобы получить бэктрейс падения, нужно выполнить в терминале:

.. code-block:: text

    gdb /usr/bin/foo-bar 2>&1 | tee ~/backtrace.log

Далее в интерактивной консоли отладчика ввести: ``handle SIGPIPE nostop noprint`` и затем ``run``, дождаться сегфолта и выполнить ``bt full`` для получения бэктрейса. Теперь можно прописать ``quit`` для выхода из режима отладки.

Далее получившийся файл ``~/backtrace.log`` следует загрузить на любой сервис размещения текстовых файлов.

Также рекомендуется ещё сделать трассировку приложения до момента падения:

.. code-block:: text

    strace -o ~/trace.log /usr/bin/foo-bar

Полученный файл ``~/trace.log`` также следует загрузить на сервис.

.. index:: library, shared library, so, ld preload, security, gcc, c, ld
.. _ldpreload-safety:

Безопасно ли использовать LD_PRELOAD для загрузки сторонних библиотек?
=========================================================================

Нет, это не безопасно, т.к. существует возможность создания внутри библиотек `суперглобальных конструкторов <https://gcc.gnu.org/onlinedocs/gcc-8.2.0/gcc/Common-Function-Attributes.html>`__, которые будут выполняться в момент присоединения библиотеки *до запуска приложения*.

Создадим и скомпилируем простой пример ``example.c``:

.. code-block:: c

    #include <stdio.h>

    static __attribute__((constructor (200))) void bar()
    {
        printf("%s", "Method bar() was called.\n");
    }

    static __attribute__((constructor (150))) void foo()
    {
        printf("%s", "Method foo() was called.\n");
    }

Данный метод содержит сразу два суперглобальных конструктора с указанием приоритетов. Чем ниже приоритет, тем скорее данный метод будет исполнен.

Скомпилируем и слинкуем наш пример:

.. code-block:: text

    gcc -shared $(rpm -E %{optflags}) -fPIC example.c -o example.so $(rpm -E %{build_ldflags}) -lc

Внедрим нашу библиотеку в известный доверенный процесс, например **whoami**:

.. code-block:: text

    LD_PRELOAD=./example.so whoami

Оба суперглобальных метода будут немедленно исполнены *с правами запускаемого приложения* и изменят его вывод:

.. code-block:: text

    Method foo() was called.
    Method bar() was called.
    user1

Разумеется, вместо безобидных вызовов функции printf() может находиться абсолютно любой код, в т.ч. вредоносный.

.. index:: lto, optimization, linker, compilation, gcc
.. _enable-lto:

Как активировать LTO-оптимизации при сборке пакета?
=======================================================

Актуальные релизы Fedora автоматически включают `LTO оптимизации <https://gcc.gnu.org/wiki/LinkTimeOptimization>`__ для всех собираемых пакетов.

Если в проекте применяются статические библиотеки (в т.ч. для внутренних целей), то экспортируем ряд :ref:`переменных окружения <env-set>` внутри секции ``%build``:

.. code-block:: text

    export AR=%{_bindir}/gcc-ar
    export RANLIB=%{_bindir}/gcc-ranlib
    export NM=%{_bindir}/gcc-nm

В случае использования системы сборки cmake, воспользуемся штатной функцией переопределения встроенных параметров:

.. code-block:: text

    %cmake -G Ninja \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_AR=%{_bindir}/gcc-ar \
        -DCMAKE_RANLIB=%{_bindir}/gcc-ranlib \
        -DCMAKE_NM=%{_bindir}/gcc-nm \
        ..

В противном случае появится ошибка *plugin needed to handle lto object*.

.. index:: lto, optimization, linker, compilation
.. _disable-lto:

Как запретить LTO-оптимизации при сборке пакета?
===================================================

При необходимости :ref:`LTO-оптимизации <enable-lto>` допускается отключить.

Определим переменную **_lto_cflags** и установим ей пустое значение:

.. code-block:: text

    %global _lto_cflags %{nil}

.. index:: gcc, c, rpm, dependencies, package
.. _rpm-unneeded:

Как вывести список установленных пакетов, от которых никто не зависит?
=========================================================================

В настоящее время данная функциональность отсутствует в dnf "из коробки", поэтому напишем и скомпилируем небольшую программу на языке C, реализующую это средствами библиотеки **libsolv**.

Установим компилятор и необходимые для сборки библиотеки:

.. code-block:: text

    sudo dnf install gcc libsolv-devel

Создадим файл ``rpm-unneeded.c`` с исходным текстом программы:

.. code-block:: c

    #include <solv/pool.h>
    #include <solv/poolarch.h>
    #include <solv/repo_rpmdb.h>
    #include <solv/solver.h>

    int main(void)
    {
        Pool *pool;
        Repo *rpmdb;
        Solver *solver;
        Queue q;

        pool = pool_create();
        pool_setarch(pool, NULL);
        pool_set_flag(pool, POOL_FLAG_IMPLICITOBSOLETEUSESCOLORS, 1);

        rpmdb = repo_create(pool, "@system");
        repo_add_rpmdb(rpmdb, NULL, 0);
        pool->installed = rpmdb;

        solver = solver_create(pool);
        solver_set_flag(solver, SOLVER_FLAG_KEEP_EXPLICIT_OBSOLETES, 1);
        solver_set_flag(solver, SOLVER_FLAG_BEST_OBEY_POLICY, 1);
        solver_set_flag(solver, SOLVER_FLAG_YUM_OBSOLETES, 1);

        queue_init(&q);
        solver_solve(solver, &q);
        solver_get_unneeded(solver, &q, 1);

        for (int i = 0; i < q.count; i++)
        {
            printf("%s\n", pool_solvid2str(pool, q.elements[i]));
        }

        queue_free(&q);
        pool_free(pool);

        return 0;
    }

Скомпилируем и слинкуем приложение:

.. code-block:: text

    gcc $(rpm -E %{optflags}) -fPIC rpm-unneeded.c -o rpm-unneeded $(rpm -E %{build_ldflags}) -lsolv -lsolvext

Запустим приложение ``./rpm-unneeded`` и получим список установленных пакетов, от которых никто не зависит.

.. index:: cpack, cmake, rpm, deb, package
.. _using-cpack:

Можно ли использовать cpack для сборки пакетов для GNU/Linux?
================================================================

Нет, использовать cpack категорически не рекомендуется по следующим причинам:

  * создаёт RPM и DEB пакеты в виде архивов;
  * не добавляет метаданные в создаваемые пакеты;
  * не прописывает зависимости от библиотек и других пакетов;
  * не экспортирует provides;
  * не обрабатывает :ref:`mime-типы <file-types>`;
  * не добавляет обязательные скриптлеты;
  * не соблюдает гайдлайны дистрибутивов.

Вместо cpack следует собирать :ref:`нативные пакеты <create-package>`.

.. index:: library, shared library, so, ld
.. _library-path:

Приложение собрано со старой версией библиотеки. Как заставить его работать?
===============================================================================

Если приложение было собрано со старой версией библиотеки **foo-bar**, которой уже нет в репозиториях и его требуется запустить, существует два способа:

  1. :ref:`LD_PRELOAD <ldpreload-safety>` -- небезопасный -- библиотека (или библиотеки) напрямую инъектируется в процесс средствами интерпретатора динамических библиотек LD до его непосредственного запуска;
  2. LD_LIBRARY_PATH -- более безопасный -- список каталогов, в которых интерпретатор динамических библиотек LD ищет соответствующие so, расширяется на указанные пользователем значения.

Рассмотрим второй способ с переопределением :ref:`переменной окружения <env-set>` ``LD_LIBRARY_PATH``.

Скачаем RPM пакет **foo-bar** необходимой версии из любого источника (лучшим вариантом будет конечно же репозитории старых версий Fedora), распакуем его например в ``~/lib/foo-bar`` и извлечём необходимые динамические библиотеки (.so файлы).

Создадим shell-скрипт ``run-foo.sh`` для запуска бинарника:

.. code-block:: text

    #!/usr/bin/sh
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/lib/foo-bar
    /path/to/binary/foo

Здесь **foo** -- имя бинарника, который требуется запустить, а **/path/to/binary** -- каталог, в котором он находится. В качестве разделителя путей **LD_LIBRARY_PATH** применяется двоеточие. Закрывающий слэш не ставится.

Установим скрипту разрешение не запуск и запустим его:

.. code-block:: text

    chmod +x run-foo.sh
    ./run-foo.sh

Если всё сделано верно, приложение успешно стартует.

.. index:: fedora, license, guidelines, legal
.. _fedora-licenses:

Проекты под какими лицензиями допускается распространять в репозиториях?
===========================================================================

См. `здесь <https://fedoraproject.org/wiki/Licensing:Main>`__.

.. index:: process, bash, console, pipe
.. _pipe-order:

В каком порядке запускаются процессы через канал (пайп)?
===========================================================

Если запускается несколько процессов с передачей данных через канал (пайп; pipe), то все они стартуют одновременно, затем начинает выполняться первый, а остальные уходят в состояние ожидания ввода.

.. index:: gcc, compiler, build, flags
.. _build-flags:

Можно ли использовать собственные флаги компиляции при сборке пакета?
========================================================================

Для любых официальных сборок следует использовать исключительно стандартные для дистрибутива флаги, предоставляемые макросами ``%{optflags}`` (флаги компилятора) и ``%{build_ldflags}`` (флаги компоновки).

.. index:: gcc, c++, ide, qt creator, qt
.. _cxx-ide:

Какую IDE использовать для разработки на C++ в Fedora?
=========================================================

Мы рекомендуем Qt Creator, которая одинаково хорошо подходит как для разработки на C++ (с Qt и без него), так и чистого C.

Установим данную IDE, а также компилятор C++ и ряд необходимых библиотек и средств для сборки проектов:

.. code-block:: text

    sudo dnf install gcc gcc-c++ qt-creator qt5-qtbase-devel cmake

При необходимости установим также документацию Qt и готовые примеры стандартных приложений:

.. code-block:: text

    sudo dnf install qt5-qtbase-doc qt5-qtbase-examples qt-creator-doc

.. index:: c++, ide, qt creator, qt, docs
.. _qtcreator-docs:

В Qt Creator отсутствует документация. Как исправить?
========================================================

Если Qt Creator при попытке загрузить документацию выдаёт ошибку *Error loading: qthelp://org.qt-project.qtcreator.472/doc/index.html*, выберем пункт меню **Tools** -- **Options** -- **Help** -- **Documentation** -- **Add**, затем вручную добавим следующие файлы:

.. code-block:: text

    /usr/share/doc/qt5/qmake.qch
    /usr/share/doc/qt5/qtconcurrent.qch
    /usr/share/doc/qt5/qtcore.qch
    /usr/share/doc/qt5/qtdbus.qch
    /usr/share/doc/qt5/qtgui.qch
    /usr/share/doc/qt5/qtnetwork.qch
    /usr/share/doc/qt5/qtnetworkauth.qch
    /usr/share/doc/qt5/qtopengl.qch
    /usr/share/doc/qt5/qtplatformheaders.qch
    /usr/share/doc/qt5/qtprintsupport.qch
    /usr/share/doc/qt5/qtsql.qch
    /usr/share/doc/qt5/qttestlib.qch
    /usr/share/doc/qt5/qtwidgets.qch
    /usr/share/doc/qt5/qtxml.qch
    /usr/share/doc/qt5/qtxmlpatterns.qch
    /usr/share/doc/qtcreator/qtcreator.qch
    /usr/share/doc/qtcreator/qtcreator-dev.qch

Изменения вступят в силу после перезапуска IDE.

.. index:: gcc, c++, ide, qt creator, qt
.. _qtcreator-kits:

В Qt Creator отсутствуют компиляторы. Как исправить?
=======================================================

Если Qt Creator не смог самостоятельно обнаружить установленный в системе фреймворк Qt, а также компилятор, то необходимо добавить их самостоятельно.

Для этого войдём в настройки IDE, затем сначала добавим компилятор GCC ``/usr/bin/gcc``, а затем тулчейн Qt -- ``/usr/bin/qmake-qt5``. После этого на вкладке **Kits** создадим новый набор из данных компонентов.

Сохраним изменения в настройках и добавим созданный Kit к своему проекту.

.. index:: python, ide, pycharm
.. _python-ide:

Какую IDE использовать для разработки на Python в Fedora?
============================================================

Мы рекомендуем PyCharm Community Edition.

Подключим COPR репозиторий:

.. code-block:: text

    sudo dnf copr enable phracek/PyCharm

Установим IDE:

.. code-block:: text

    sudo dnf install pycharm-community

При необходимости установим также набор популярных плагинов:

.. code-block:: text

    sudo dnf install pycharm-community-plugins

.. index:: firmware, binwalk
.. _fw-image:

Как получить информацию о содержимом образа бинарной прошивки?
=================================================================

Для работы с образами прошивок можно использовать утилиту **binwalk**. Установим её:

.. code-block:: text

    sudo dnf install binwalk

Произведём анализ файла и получим результат:

.. code-block:: text

    binwalk foo-bar.bin

.. index:: rpmbuild, spec, sources
.. _spectool:

Как автоматически скачать исходники, прописанные в SPEC-файле?
=================================================================

Установим необходимые утилиты:

.. code-block:: text

    sudo dnf install rpm-build rpmdevtools

Создадим базовую иерархию каталогов для rpmbuild:

.. code-block:: text

    rpmdev-setuptree

Скачаем исходники, прописанные в SPEC-файле **foo-bar.spec**:

.. code-block:: text

    spectool -g -R foo-bar.spec

.. index:: spec, version, tag
.. _spec-auto:

Как автоматически инкрементировать релиз в SPEC-файле?
==========================================================

Установим необходимый для работы пакет:

.. code-block:: text

    sudo dnf install rpmdevtools

Инкрементируем релиз SPEC-файла (директива *Release*) с автоматическим созданием новой строки в *%changelog*:

.. code-block:: text

    rpmdev-bumpspec -c "Updated to latest snapshot."

.. index:: git, pull, bash, find
.. _git-multi:

Как загрузить изменения во всех вложенных репозиториях из данного каталога?
==============================================================================

Если Git репозитории были клонированы в общий каталог ``~/foo-bar``, то загрузим изменения в каждом из вложенных проектов при помощи **find** и **bash**:

.. code-block:: text

    find ~/foo-bar -maxdepth 1 ! -path . -type d -exec bash -c "pushd '{}' ; git pull ; popd" \;

.. index:: git, checkout, branch
.. _git-empty:

Как создать пустую ветку в Git без общей истории?
====================================================

Создадим новую пустую ветку **foo-bar** от текущего HEAD:

.. code-block:: text

    git checkout --orphan foo-bar

Создадим удалим всё проиндексированное содержимое данной ветки:

.. code-block:: text

    git reset --hard

.. index:: mock, transfer, build, move
.. _mock-move:

Можно ли перенести каталоги сборки и кэшей mock на другой диск?
==================================================================

Система автоматической :ref:`сборки пакетов mock <build-package>` занимает огромное количество места в корневом разделе, поэтому многие мейнтейнеры хотели бы перенести её на другой диск. Штатно это сделать не представляется возможным ибо значения каталогов по умолчанию ``/var/cache/mock`` и ``/var/lib/mock`` жёстко прописаны внутри приложения и не подлежат изменению со стороны пользователя, поэтому воспользуемся символическими ссылками.

Создадим на другом накопителе (его файловая система должна поддерживать права доступа Unix) базовый каталог для mock:

.. code-block:: text

    cd /media/foo-bar
    sudo mkdir mock
    sudo chown root:mock mock
    sudo chmod 4775 mock

Переместим содержимое текущих рабочих каталогов mock:

.. code-block:: text

    sudo mv /var/cache/mock /media/foo-bar/mock/cache
    sudo mv /var/lib/mock /media/foo-bar/mock/lib

Создадим символические ссылки на старом месте:

.. code-block:: text

    sudo ln -s /media/foo-bar/mock/cache /var/cache/mock
    sudo ln -s /media/foo-bar/mock/lib /var/lib/mock

Зададим контекст :ref:`SELinux <selinux>` по умолчанию для нового хранилища:

.. code-block:: text

    sudo semanage fcontext -a -t mock_cache_t "/media/foo-bar/mock/cache(/.*)?"
    sudo semanage fcontext -a -t mock_var_lib_t "/media/foo-bar/mock/lib(/.*)?"

Сбросим контекст SELinux для всех рабочих каталогов:

.. code-block:: text

    sudo restorecon -Rv /var/cache/mock
    sudo restorecon -Rv /var/lib/mock
    sudo restorecon -Rv /media/foo-bar/mock/cache
    sudo restorecon -Rv /media/foo-bar/mock/lib

Здесь **/media/foo-bar** -- точка монтирования нового накопителя, на котором будут располагаться кэши mock.

Внимание! Раздел назначения должен использовать флаги монтирования по умолчанию ``defaults``. В противном случае не будут выполнены скриптлеты и сборка не завершится успешно.

.. index:: git, bash, branch
.. _bash-git-branch:

Как включить отображение текущей ветки Git в Bash?
=====================================================

Модуль интеграции с Bash входит в состав пакета Git. Добавим в :ref:`приветствие Bash <bash-shell>` следующую строку:

.. code-block:: text

    export PS1='[\u@\h \W$(declare -F __git_ps1 &>/dev/null && __git_ps1 " (%s)")]\$ '

В качестве опциональных параметров поддерживаются ``GIT_PS1_SHOWDIRTYSTATE`` (показывать наличие незакреплённых изменений внутри каталога) и ``GIT_PS1_SHOWUNTRACKEDFILES`` (учитывать, либо нет не отслеживаемые системой контроля версий файлы):

.. code-block:: text

    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWUNTRACKEDFILES=true

Изменения вступят в силу при следующем запуске оболочки.

.. index:: patch, diff, unified, file
.. _patch-file:

Как создать унифицированный патч изменений между двумя файлами?
==================================================================

Для создания патча нам необходимо две версии файла: оригинальная и текущая.

Создадим унифицрованный патч с разностью между файлами **foo-bar.txt.orig** (оригинальный) и **foo-bar.txt** (текущий):

.. code-block:: text

    diff -Naur foo-bar.txt.orig foo-bar.txt > result.patch

Результат будет сохранён в файле **result.patch**.

.. index:: patch, diff, unified, file, directory
.. _patch-directory:

Как создать унифицированный патч изменений между двумя каталогами?
=====================================================================

Создадим унифицрованный патч с разностью между каталогами **foo-bar_orig** (оригинальный) и **foo-bar** (текущий):

.. code-block:: text

    diff -Naur foo-bar_orig foo-bar > result.patch

Результат будет сохранён в файле **result.patch**.

.. index:: patch, diff, unified, apply
.. _patch-apply:

Как применить унифицированный патч?
======================================

Проверим возможность применения патча **foo-bar.patch** без внесения каких-либо изменений:

.. code-block:: text

    patch -p0 --dry-run -i foo-bar.patch

Применим патч:

.. code-block:: text

    patch -p0 -i foo-bar.patch

Параметром ``-p`` задаётся количество каталогов, которые будут отброшены при поиске файлов, указанных внутри унифицированного патча.

.. index:: patch, diff, unified, revert
.. _patch-revert:

Как откатить наложенный унифицированный патч?
================================================

Проверим возможность отката патча **foo-bar.patch** без внесения каких-либо изменений:

.. code-block:: text

    patch -p0 -R --dry-run -i foo-bar.patch

Откатитим внесённые изменения:

.. code-block:: text

    patch -p0 -R -i foo-bar.patch

Параметром ``-p`` задаётся количество каталогов, которые будут отброшены при поиске файлов, указанных внутри унифицированного патча.

.. index:: patch, diff, unified, git, commit
.. _patch-git-create:

Как создать унифицированный патч между двумя коммитами?
==========================================================

Создадим патч между двумя коммитами **AAA** и **BBB**:

.. code-block:: text

    git diff AAA BBB > result.patch

Создадим патч коммитом **CCC** и текущим рабочей рабочей версией:

.. code-block:: text

    git diff CCC > result.patch

Здесь **AAA**, **BBB** и **CCC** -- хеши коммитов в Git репозитории.

.. index:: patch, diff, unified, git, commit, export
.. _patch-git-export:

Как экспортировать Git коммит для отправки по электронной почте?
====================================================================

В Git имеется встроенное средство экспорта коммитов для их дальнейшей отправки по электронной почте.

Экспортируем один коммит:

.. code-block:: text

    git format-patch -1

Экспортируем сразу 3 коммита:

.. code-block:: text

    git format-patch -3

.. index:: fedora, infrastructure, authentication, kerberos, kinit
.. _fedora-login:

Как авторизоваться в инфраструктуре Fedora?
==============================================

Для авторизации мы должны использовать вход в домен :ref:`посредством Kerberos <kerberos-auth>`:

.. code-block:: text

    kinit foo-bar@FEDORAPROJECT.ORG

Здесь **foo-bar** -- логин в FAS. Имя домена должно быть указано строго в верхнем регистре.

Также для некоторых операций необходимо загрузить :ref:`публичный ключ <ssh-keygen>` SSH в `FAS аккаунт <https://admin.fedoraproject.org/accounts>`__.

.. index:: fedora, infrastructure, authentication, kerberos, kinit, 2fa, otp
.. _fedora-login-2fa:

Как авторизоваться в инфраструктуре Fedora с поддержкой 2FA?
================================================================

Для авторизации в инфраструктуре Fedora с поддержкой двухфакторной аутентификации :ref:`стандартный вход <fedora-login>` :ref:`посредством Kerberos <kerberos-auth>` работать не будет из-за возникновения ошибки *kinit: Pre-authentication failed: Invalid argument while getting initial credentials*, поэтому мы должны использовать альтернативный способ.

Сгенерируем актуальный файл Kerberos Credentials Cache:

.. code-block:: text

    kinit -n @FEDORAPROJECT.ORG -c FILE:$HOME/.cache/fedora-armor.ccache

Авторизуемся в домене с указанием KCC-файла:

.. code-block:: text

    kinit -T FILE:$HOME/.cache/fedora-armor.ccache foo-bar@FEDORAPROJECT.ORG

Когда сервер запросит ввод *Enter OTP Token Value:*, укажем свой пароль и текущий код из OTP-аутентификатора по схеме **парольКОД** без пробелов и прочих знаков.

Здесь **foo-bar** -- логин в FAS. Имя домена должно быть указано строго в верхнем регистре.

.. index:: fedora, package, request, fedpkg
.. _package-request:

Как запросить создание пакета в репозитории?
===============================================

Сразу после завершения :ref:`процедуры package review <becoming-maintainer>`, мейнтейнер должен запросить создание пакета в репозиториях Fedora.

Установим утилиту **fedpkg**

.. code-block:: text

    sudo dnf install fedpkg

Получим `новый токен <https://pagure.io/settings>`__ в Pagure, который будет использоваться утилитой fedpkg для создания заявки. Для этого перейдём в раздел **Settings** -- **API Keys** -- **Create new key**, затем в списке доступных разрешений (**ACLs**) установим флажок только около опции **Create a new ticket** и нажмём кнопку **Add**.

Создадим файл конфигурации fedpkg:

.. code-block:: text

    mkdir -p ~/.config/rpkg
    touch ~/.config/rpkg/fedpkg.conf

Загрузим созданный файл ``~/.config/rpkg/fedpkg.conf`` в любом текстовом редакторе и добавим:

.. code-block:: ini

    [fedpkg.pagure]
    token = XXXXXXXXXX

Здесь **XXXXXXXXXX** -- полученный от Pagure токен.

Запросим создание нового пакета в репозитории, а также веток для всех поддерживаемых релизов Fedora:

.. code-block:: text

    fedpkg request-repo --namespace rpms --monitor monitoring foo-bar YYYYYY
    fedpkg request-branch --namespace rpms --repo foo-bar --all-releases

Здесь **foo-bar** -- имя пакета, а **YYYYYY** -- номер заявки в Red Hat BugZilla с успешно завершённым package review.

.. index:: fedora, package, upload, fedpkg
.. _fedpkg-upload:

Как загрузить файлы с исходными кодами пакета в систему сборки?
==================================================================

После :ref:`создания пакета <package-request>` осуществим :ref:`вход в инфраструктуру <fedora-login>` Fedora, затем скачаем репозиторий пакета из Fedora SCM, содержащий SPEC файл и набор патчей (при необходимости), а также прочие службные файлы:

.. code-block:: text

    fedpkg clone foo-bar
    cd foo-bar

Самым простым способом загрузки является импорт готового SRPM файла, поэтому выполним именно эту процедуру:

.. code-block:: text

    fedpkg switch-branch master
    fedpkg import /путь/к/foo-bar-1.0-1.fc36.src.rpm

Проверим внесённые изменения и если всё верно, жмём **Q** для выхода. Зафиксируем наши изменения:

.. code-block:: text

    git commit -m "Initial import."

При необходимости внесём изменения и в ветки поддерживаемых релизов Fedora:

.. code-block:: text

    fedpkg switch-branch f36
    git merge master

Отправим изменения на сервер:

.. code-block:: text

    git push

.. index:: fedora, package, build, fedpkg
.. _fedpkg-build:

Как осуществить сборку пакета для публикации в репозиториях?
===============================================================

После :ref:`загрузки файлов с исходными кодами <fedpkg-upload>` пакета, осуществим :ref:`вход в инфраструктуру <fedora-login>` Fedora, а затем приступим к непосредственно сборке в :ref:`Fedora Koji <koji-about>`:

.. code-block:: text

    cd foo-bar
    fedpkg switch-branch master
    fedpkg build

При необходимости соберём и для других поддерживаемых релизов Fedora:

.. code-block:: text

    fedpkg switch-branch f36
    fedpkg build

.. index:: fedora, package, build, fedpkg, scratch
.. _fedpkg-scratch:

Как осуществить тестовую сборку пакета для определённой архитектуры?
=======================================================================

Осуществим :ref:`вход в инфраструктуру <fedora-login>` Fedora.

Выполним стандартную scratch-сборку для всех поддерживаемых данным выпуском архитектур:

.. code-block:: text

    cd foo-bar
    fedpkg switch-branch master
    fedpkg build --scratch

Выполним scratch-сборку только для указанных архитектур:

.. code-block:: text

    cd foo-bar
    fedpkg switch-branch master
    fedpkg scratch-build --arches x86_64 aarch64

.. index:: fedora, package, release, publish
.. _fedpkg-publish:

Как выложить собранный пакет в репозитории?
==============================================

По окончании :ref:`сборки <fedpkg-build>` мы можем воспользоваться `Fedora Bodhi <https://bodhi.fedoraproject.org/>`__ и `выложить обновление <https://bodhi.fedoraproject.org/updates/new>`__ в репозитории.

Сначала все обновления попадают в тестовые репозитории Fedora (*updates-testing*) и лишь после получения положительной кармы от других участников сообщества (уровень задаётся мейнтейнером, но не может быть меньше 1), либо по истечении 7 дней, оно может попасть в стабильные (*updates*) и будет доставлено конечным пользователям.

Заполним стандартную, хорошо документированную форму, затем нажмём кнопку **Submit**.

.. index:: repository, copr, overlay
.. _copr-legal:

Что разрешается хранить в COPR репозиториях?
================================================

В :ref:`COPR <copr>` разрешается распространять всё то же, что и в :ref:`основных репозиториях <fedora-licenses>` Fedora. Сборка и публикация запатентованного и проприетарного программного обеспечения в пользовательских оверлеях не допускается.

.. index:: shared library, vdso, so, ldd
.. _linux-vdso:

Что такое linux-vdso.so.1 и почему она загружена в каждый процесс?
=====================================================================

Библиотека **linux-vdso.so.1** не является обычной динамической библиотекой. Это виртуальный динамически разделяемый объект (VDSO), который отображается на адресное пространство каждого запущенного процесса ядром Linux и представляет собой интерфейс для осуществления быстрых системных вызовов.

Данный объект можно обнаружить в :ref:`выводе ldd <linux-ldd>` для любого бинарного ELF-файла, но без прямого пути, т.к. он не является реальным файлом.

.. index:: shared library, elf, so, binary, ldd, ld
.. _linux-ldd:

Как определить зависимости конкретного бинарника?
====================================================

Для определения зависимостей любых ELF-файлов, воспользуемся утилитой **ldd**.

Определим зависимости динамически разделяемой библиотеки:

.. code-block:: text

    ldd /path/to/shared/library.so.1

Определим зависимости исполняемого файла:

.. code-block:: text

    ldd /path/to/application

Если библиотека была найдена в системе, наряду с именем будет указан абсолютный путь к её файлу на диске, а также адрес предполагаемой загрузки.

Исключение составляют :ref:`виртуальные объекты <linux-vdso>`, для которых будет указан лишь адрес, без пути.

.. index:: git, upstream, remote, origin
.. _git-switch-remote:

Как изменить адрес Git репозитория после его переезда?
========================================================

Получим список подключённых удалённых ресурсов текущего Git репозитория:

.. code-block:: text

    git remote -v

Изменим апстрим для ``origin``:

.. code-block:: text

    git remote set-url origin https://github.com/foo-bar/new_repo.git

После этого команды Git, отвечающие за работу с удалёнными ресурсами, ``git pull``, ``git fetch``, ``git push``, начнут использовать новый апстрим.

.. index:: rpmbuild, move
.. _rpmbuild-move:

Можно ли перенести стандартный каталог сборки rpmbuild?
==========================================================

Да, это возможно. Откроем файл ``~/.rpmmacros`` в любом текстовом редаторе, найдём строку:

.. code-block:: text

    %_topdir %(echo $HOME)/rpmbuild

Заменим её на следующую:

.. code-block:: text

    %_topdir /media/foo-bar/rpmbuild

Здесь **/media/foo-bar** -- новый каталог размещения базовой иерархии rpmbuild.

Сохраним изменения, которые вступят в силу немеденно.

.. index:: license, checker, copyright
.. _license-check:

Как определить какие лицензии используются в проекте?
=========================================================

Установим утилиту **licensecheck**:

.. code-block:: text

    sudo dnf install licensecheck

Запустим проверку проекта:

.. code-block:: text

    licensecheck --recursive --merge-licenses --no-verbose /path/to/foo-bar > ~/results.txt

Здесь **/path/to/foo-bar** -- путь к распакованным исходникам проекта, а **~/results.txt** -- имя файла, в котором будут сохранены результаты проверки.

.. index:: gdb, debugging, backtrace, coredump
.. _gdb-coredump:

Как загрузить в gdb отладчик coredump падения?
=================================================

GDB позволяет не только отлаживать приложения напрямую, но и загружать :ref:`coredump падений <codedump-info>`.

Установим утилиту **lz4** для распаковки сжатых файлов с дампами:

.. code-block:: text

    sudo dnf install lz4

Распакуем coredump:

.. code-block:: text

    unlz4 /path/to/coredump.lz4

Воспользуемся :ref:`описанным выше <debug-application>` способом получения backtrace падения, но слегка модифицируем команду запуска отладчика:

.. code-block:: text

    gdb /usr/bin/foo-bar /path/to/coredump 2>&1 | tee ~/backtrace.log

Здесь **/usr/bin/foo-bar** -- путь к отлаживаемому приложению, **/path/to/coredump** -- coredump падения (версия приложения и дампа, снятого с него, должны обязательно совпадать), а **~/backtrace.log** -- файл, в котором будет сохранён трейс падения.

.. index:: rpmbuild, cmake, clang, cpp, compilation
.. _clang-fedora:

Как собрать пакет с использованием компилятора Clang в Fedora?
===================================================================

Определим переменную **toolchain** и установим ей значение **clang**:

.. code-block:: text

    %global toolchain clang

Если в проекте применяются статические библиотеки (в т.ч. для внутренних целей), то экспортируем ряд :ref:`переменных окружения <env-set>` внутри секции ``%build``:

.. code-block:: text

    export AR=%{_bindir}/llvm-ar
    export RANLIB=%{_bindir}/llvm-ranlib
    export LINKER=%{_bindir}/llvm-ld
    export OBJDUMP=%{_bindir}/llvm-objdump
    export NM=%{_bindir}/llvm-nm

В случае использования системы сборки cmake, воспользуемся штатной функцией переопределения встроенных параметров:

.. code-block:: text

    %cmake -G Ninja \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_C_COMPILER=%{_bindir}/clang \
        -DCMAKE_CXX_COMPILER=%{_bindir}/clang++ \
        -DCMAKE_AR=%{_bindir}/llvm-ar \
        -DCMAKE_RANLIB=%{_bindir}/llvm-ranlib \
        -DCMAKE_LINKER=%{_bindir}/llvm-ld \
        -DCMAKE_OBJDUMP=%{_bindir}/llvm-objdump \
        -DCMAKE_NM=%{_bindir}/llvm-nm \
        ..

Следует :ref:`быть осторожным <qt-clang-lto>` при сборке Qt-приложений данным компилятором при использовании :ref:`LTO-оптимизаций <enable-lto>`.

.. index:: clang, lto, optimization, linker, cpp
.. _qt-clang-lto:

Qt-приложение, собранное Clang с LTO не запускается. Что делать?
=====================================================================

Невозможность запуска Qt-приложений, собранных компилятором Clang с включёнными :ref:`LTO-оптимизациями <enable-lto>` -- это `известная проблема <https://bugreports.qt.io/browse/QTBUG-61710>`__, которая в настоящее время не решена.

Для её решения необходимо либо отказаться от использования компилятора Clang и вернуться на GCC, либо отключить LTO-оптимизации.

.. index:: linker, dependencies, ldd, library
.. _using-ldd:

Безопасно ли использовать LDD для проверки зависимостей бинарника?
=====================================================================

Нет, т.к. утилита :ref:`ldd <linux-ldd>` лишь изменяет ряд :ref:`переменных окружения <env-set>`, а затем запускает бинарник, чтобы определить все динамически загружаемые библиотеки, от которых он зависит.

Внедоносный код сможет легко перехватить управление и начать выполнять свои задачи в пределах имеющихся полномочий.

.. index:: git, remove, remote, tag
.. _git-remove-tag:

Как удалить тег во внешнем Git репозитории?
================================================

Удалим локальный тег **1.0.0**:

.. code-block:: text

    git tag -d v1.0.0

Удалим удалённый тег **1.0.0** из удалённого Git репозитория:

.. code-block:: text

    git push --delete origin v1.0.0

.. index:: git, remove, remote, branch
.. _git-remove-branch:

Как удалить ветку во внешнем Git репозитории?
=================================================

Удалим удалённую ветку **foo-bar** из удалённого Git репозитория:

.. code-block:: text

    git push --delete origin foo-bar

.. index:: git, remove, tag, remote
.. _git-remove-all-tags:

Как удалить все теги (локальные и удалённые) в Git репозитории?
===================================================================

Удалим все теги из внешнего Git репозитория:

.. code-block:: text

    git push origin --delete $(git tag -l)

Удалим все оставшиеся локальные теги:

.. code-block:: text

    git tag -d $(git tag -l)

.. index:: gcc, regression, bug report, report, bug, koji, uue, uuencode, uudecode
.. _koji-extract-data:

Как извлечь из Koji какие-либо данные для отправки баг-репорта?
===================================================================

Т.к. :ref:`Koji <koji-about>` автоматически очищает каталог сборки по её завершении с любым статусом, единственная возможность извлечь полезные данные -- это закодировать их в формате `Uuencode <https://ru.wikipedia.org/wiki/UUE>`__ и вывести в общий журнал сборки.

Добавим в :ref:`SPEC-файл пакета <create-package>` зависимость от **sharutils**:

.. code-block:: text

    BuildRequires: sharutils

Немного доработаем команду сборки (например ``%make_build``), включив в неё упаковку всех необработанных preprocessed sources в архив с кодированием в UUE, при возникновении ошибки:

.. code-block:: text

    %make_build || (tar cf - /tmp/cc*.out | bzip2 -9 | uuencode cc.tar.bz2)

Найдём в журнале ``build.log`` блок вида:

.. code-block:: text

    begin 644 cc.tar.bz2
    ...
    ...
    end

Извлечём и сохраним его в файл ``foo-bar.uue``.

Установим утилиту **uudecode**:

.. code-block:: text

    sudo dnf install sharutils

Декодируем полезную нагрузку:

.. code-block:: text

    uudecode foo-bar.uue

Загрузим полученный архив в :ref:`баг-репорт <bug-report>`.

.. index:: rpm, rpmbuild, version, package, compare
.. _compare-versions:

Как определить, какая из двух версий больше?
================================================

Для проверки версий воспользуемся утилитой **rpmdev-vercmp**, входящей в состав пакета **rpmdevtools**.

Установим его:

.. code-block:: text

    sudo dnf install rpmdevtools

Произведём проверку между **X** и **Y**:

.. code-block:: text

    rpmdev-vercmp X Y

Данную утилиту также можно использовать в различных скриптах, исходя из возвращаемых ею кодов завершения:

  * **0** -- версии равны;
  * **11** -- версия **X** больше, чем **Y**;
  * **12** -- версия **X** меньше, чем **Y**.

.. index:: mock, cleanup, cache
.. _mock-cleanup:

Как очистить все кэши mock?
================================

Выполним очистку сборочного каталога :ref:`mock <build-package>` для цели по умолчанию:

.. code-block:: text

    mock --scrub=all

Выполним очистку сборочного каталога, а также кэша загруженных пакетов mock для **fedora-rawhide-x86_64**:

.. code-block:: text

    mock -r fedora-rawhide-x86_64 --scrub=all

.. index:: root, permissions, library, shared library, so, ld preload, ld
.. _root-check-bypass:

Как обойти проверку приложением наличия прав суперпользователя?
===================================================================

См. `здесь <https://www.easycoding.org/2021/08/31/obxodim-proverku-na-nalichie-prav-superpolzovatelya.html>`__.

.. index:: rpm, architecture, rpmbuild, excludearch, package
.. _rpmbuild-exclude-arch:

Как исключить определённую архитектуру из сборки пакета?
============================================================

Для исключения указанных архитектур из сборки, добавим в SPEC-файл директиву ``ExcludeArch``.

В качестве примера исключим 32-битные ARM и x86:

.. code-block:: text

    ExcludeArch: %{arm} %{ix86}

.. index:: rpm, architecture, rpmbuild, exclusivearch, package
.. _rpmbuild-exclusive-arch:

Как собрать пакет только для определённой архитектуры?
=========================================================

Для выбора конкретных архитектур сборки, добавим в SPEC-файл директиву ``ExclusiveArch``.

В качестве примера включим только 64-битные ARM и x86:

.. code-block:: text

    ExcludeArch: aarch64 x86_64

.. index:: rpm, rpmbuild, exclude, package, library, provides, filter
.. _rpmbuild-filter-provides:

Как исключить библиотеку из списка предоставляемых пакетом?
===============================================================

Исключим все файлы, расположенные в каталоге **%{_libdir}/%{name}**, из автоматически генерируемого списка предоставляемых пакетом:

.. code-block:: text

    %global __provides_exclude_from %{_libdir}/%{name}/.*

При необходимости указать несколько каталогов, разделим их стандартным для `регулярного выражения PCRE <https://ru.wikipedia.org/wiki/PCRE>`__ способом:

.. code-block:: text

    %global __provides_exclude_from %{_libdir}/%{name}/foo/.*|%{_libdir}/%{name}/bar/.*

.. index:: rpm, rpmbuild, exclude, package, library, requires, filter
.. _rpmbuild-filter-requires:

Как исключить библиотеку из списка зависимостей пакета?
===========================================================

Отключим автоматическое построение списка зависимостей пакета для ELF-объектов, расположенных в каталоге **%{_libdir}/%{name}**:

.. code-block:: text

    %global __requires_exclude_from %{_libdir}/%{name}/.*

При необходимости указать несколько каталогов, разделим их стандартным для `регулярного выражения PCRE <https://ru.wikipedia.org/wiki/PCRE>`__ способом:

.. code-block:: text

    %global __requires_exclude_from %{_libdir}/%{name}/foo/.*|%{_libdir}/%{name}/bar/.*

.. index:: rpm, rpmbuild, side-tag, koji, fedpkg, build, bodhi
.. _koji-side-tags:

Как собрать несколько зависящих друг от друга пакетов?
==========================================================

Если раньше приходилось использовать механизм "build overrides", позволяющий вручную переопределять пакеты в сборочном репозитории, то сейчас рекомендуется для сборки двух и более пакетов применять side-теги, т.к. это более простой и безопасный способ, не создающий конфликтов и проблем с зависимостями.

Мейнтейнер может запросить создание произвольного количества side-тегов и производить сборку в них по своему усмотрению.

Запросим новый side-tag для F35:

.. code-block:: text

    fedpkg request-side-tag --base-tag f36-build

В выводе **fedpkg** сообщит нам уникальный идентификатор созданного репозитория, например *f36-build-side-12345*.

Ждём его создания и готовности к работе:

.. code-block:: text

    koji wait-repo f36-build-side-XXXXX

Произведём сборку первого пакета **foo**:

.. code-block:: text

    fedpkg build --target=f36-build-side-XXXXX

Ожидаем его появления в теге:

.. code-block:: text

    koji wait-repo --build=foo-1.0.0-1.fc36 f36-build-side-XXXXX

Собираем все остальные пакеты тем же способом.

По окончании перейдём в `Bodhi <https://bodhi.fedoraproject.org/>`__ и выберем **Create New Update** -- **Use Side Tag** для выгрузки его в основной репозиторий.

.. index:: rpm, rpmbuild, koji, fedpkg, build, chain, rawhide
.. _koji-chain-build:

Как собрать несколько зависящих друг от друга пакетов по цепочке?
====================================================================

В :ref:`Fedora Rawhide <using-rawhide>` наряду с :ref:`использованием side-тегов <koji-side-tags>`, существует и более удобный способ -- сборки по цепочке (chain builds).

Мейнтейнер может указать произвольное количество пакетов в пределах одного задания. Koji выполнит задачу строго в указанном порядке.

Внимание! Каталоги с исходниками всех участников группы должны находиться на одном уровне файловой иерархии.

Перейдём в каталог последнего пакета в цепочке (в данном примере это **bar**) и запустим процесс:

.. code-block:: text

    cd bar
    fedpkg switch-branch rawhide
    fedpkg chain-build libfoo1 libfoo2

Данное действие создаст следующую цепочку *libfoo1* -> *libfoo2* -> *bar*.

В случае если некоторые пакеты допустимо собирать параллельно, поделим задание на подгруппы (разделителем является двоеточие):

.. code-block:: text

    cd bar
    fedpkg switch-branch rawhide
    fedpkg chain-build libfoo1 : libfoo2 libfoo3 :

В результате появится цепочка *libfoo1* -> *libfoo2* + *libfoo3* -> *bar*.
