.. Fedora-Faq-Ru (c) 2018 - 2019, EasyCoding Team and contributors
.. 
.. Fedora-Faq-Ru is licensed under a
.. Creative Commons Attribution-ShareAlike 4.0 International License.
.. 
.. You should have received a copy of the license along with this
.. work. If not, see <https://creativecommons.org/licenses/by-sa/4.0/>.
.. _development:

*****************************************************
Вопросы, связанные с разработкой и сборкой пакетов
*****************************************************

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

`Fedora Koji <https://koji.fedoraproject.org/koji/>`__ - это автоматизированная среда для сборки пакетов для Fedora.

.. index:: fedpkg, package, rebuild, mock, rpm
.. _fedpkg-rebuild:

Хочу внести свои правки в пакет и пересобрать его для личных нужд. Как проще это сделать?
===============================================================================================

Установим утилиты fedpkg и mock:

.. code-block:: bash

    sudo dnf install fedpkg mock

Скачаем исходники необходимого пакета **foo-bar**:

.. code-block:: bash

    fedpkg clone -a foo-bar

Перейдём в каталог с загруженными исходниками и переключимся на ветку для конкретной версии Fedora (если нужна версия из Rawhide - следует использовать **master**):

.. code-block:: bash

    cd foo-bar
    fedpkg switch-branch f29

Внесём свои правки, сделаем коммит в репозиторий:

.. code-block:: bash

    git add -A
    git commit -m "Description of our changes."

Запустим автоматическую :ref:`сборку в mock <build-package>`:

.. code-block:: bash

    fedpkg mockbuild

.. index:: git, tarball
.. _git-tarball:

Как создать tarball с исходниками из Git репозитория?
=========================================================

Если проект по какой-либо причине не поставляет готовые тарболы и отсутствует возможность их скачать напрямую с хостинга VCS, можно создать их из Git.

Клонируем репозиторий источника:

.. code-block:: bash

    git clone https://example.org/foo-bar.git

Создадим архив с исходниками:

.. code-block:: bash

    git archive --format=tar --prefix=foo-bar-1.0.0/ HEAD | gzip > ~/rpmbuild/SOURCES/foo-bar-1.0.0.tar.gz

Здесь **HEAD** - указатель на актуальный коммит (вместо этого можно использовать SHA1 хеш любого коммита, а также имя тега или ветки), **foo-bar** - название проекта, а **1.0.0** - его версия.

.. index:: fedpkg, koji
.. _rpmfusion-override:

Как переопределить пакет в Koji репозитория RPM Fusion?
===========================================================

Создание build override для репозитория f29-free:

.. code-block:: bash

    koji-rpmfusion tag f29-free-override foo-bar-1.0-1.fc29

Удаление build override для репозитория f29-free:

.. code-block:: bash

    koji-rpmfusion untag f29-free-override foo-bar-1.0-1.fc29

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

.. code-block:: bash

    env

.. index:: environment, options, env, application
.. _env-get-app:

Как получить полный список установленных переменных для запущенного процесса?
================================================================================

Получение списка установленных :ref:`переменных окружения <env-set>` для запущенных процессов:

.. code-block:: bash

    cat /proc/$PID/environ

Здесь **$PID** - :ref:`PID <get-pid>` процесса, информацию о котором необходимо получить.

.. index:: environment, options, env
.. _env-set:

Как задать переменную окружения?
====================================

Вариант 1. Запуск процесса с заданной переменной окружения:

.. code-block:: bash

    FOO=BAR /usr/bin/foo-bar

Вариант 2. Экспорт переменной окружения в запущенном терминале и дальнейший запуск приложения:

.. code-block:: bash

    export FOO=BAR
    /usr/bin/foo-bar

Вариант 3. Модификация директивы **Exec=** в ярлыке запуска приложения:

.. code-block:: bash

    env FOO=BAR /usr/bin/foo-bar

.. index:: git, vcs, configuration
.. _git-configuration:

Как правильно настроить Git для работы?
===========================================

Сначала укажем своё имя и адрес электронной почты:

.. code-block:: bash

    git config --global user.name "Your Name"
    git config --global user.email email@example.org

Установим :ref:`предпочитаемый текстовый редактор <editor-git>` для работы с коммитами:

.. code-block:: bash

    git config --global core.editor vim

.. index:: git, vcs, pull request, push, commit
.. _git-pull-request:

Я хочу внести правки в проект. Как правильно отправить их в апстрим?
=======================================================================

Если проект хостится на одном из популярных сервисов (GitHub, BitBucket или GitLab), сначала войдём в свой аккаунт (при осутствии создадим) и сделаем форк репозитория.

Осуществим :ref:`базовую настройку Git <git-configuration>` клиента если это ещё не было сделано ранее.

Клонируем наш форк:

.. code-block:: bash

    git clone git@github.com:YOURNAME/foo-bar.git

Создадим ветку **new_feature** для наших изменений (для каждого крупного изменения следует создавать отдельную ветку и *ни в коем случае не коммитить в master*):

.. code-block:: bash

    git checkout -b new_feature

Внесём свои правки в проект, затем осуществим их фиксацию:

.. code-block:: bash

    git add -A
    git commit -s

В появившемся :ref:`текстовом редакторе <editor-git>` укажем подробное описание всех наших изменений на английском языке. Несмотря на то, что параметр ``-s`` является опциональным, большинство проектов требуют его использования для автоматического создания подписи вида:

.. code-block:: text

    Signed-off-by: Your Name <email@example.org>

Многие проекты обновляются слишком быстро, поэтому потребуется осуществить синхронизацию наших изменений с актуальной веткой апстрима. Для этого подключим к нашем форку оригинальный репозиторий:

.. code-block:: bash

    git remote add upstream https://github.com/foo/foo-bar.git

Скачаем актуальные изменения и выполним rebase основной ветки нашего форка с апстримом:

.. code-block:: bash

    git fetch upstream
    git checkout master
    git merge upstream/master

Осуществим rebase ветки с нашими изменениями с основной:

.. code-block:: bash

    git checkout new_feature
    git rebase master

Отправим наши изменения на сервер:

.. code-block:: bash

    git push -u origin new_feature

Создадим новый Pull Request.

.. index:: c++, cxx, application, console
.. _cxx-console:

Как скомпилировать простую программу на языке C++ из консоли?
================================================================

Установим компилятор GCC-C++ (G++) и ряд вспомогательных компонентов:

.. code-block:: bash

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

.. code-block:: bash

    g++ $(rpm -E %{optflags}) -fPIC helloworld.cpp -o helloworld $(rpm -E %{build_ldflags}) -lstdc++

Здесь **g++** - запускающий файл файл компилятора, **helloworld.cpp** - файл с исходным кодом (если их несколько, то разделяются пробелом), **helloworld** - имя результирующего бинарника, **-lstdc++** - указание компоновщику на необходимость линковки со стандартной библиотекой C++.

Корректные флаги компиляции и компоновки вставляются автоматически из соответствующих макросов RPM.

Запустим результат сборки:

.. code-block:: bash

    ./helloworld

Если всё сделано верно, то увидим сообщение *Hello, World!* в консоли.

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

.. code-block:: bash

    gcc -shared $(rpm -E %{optflags}) -fPIC example.c -o example.so $(rpm -E %{build_ldflags}) -lc

Внедрим нашу библиотеку в известный доверенный процесс, например **whoami**:

.. code-block:: bash

    LD_PRELOAD=./example.so whoami

Оба суперглобальных метода будут немедленно исполнены *с правами запускаемого приложения* и изменят его вывод:

.. code-block:: text

    Method foo() was called.
    Method bar() was called.
    user1

Разумеется, вместо безобидных вызовов функции printf() может находиться абсолютно любой код, в т.ч. вредоносный.

.. index:: lto, optimization, linker, compilation, gcc
.. _enable-lto:

Как можно активировать LTO оптимизации при сборке пакета?
============================================================

Для активации `LTO оптимизаций <https://gcc.gnu.org/wiki/LinkTimeOptimization>`__ необходимо и достаточно передать параметр ``-flto`` как для компилятора (**CFLAGS** и/или **CXXFLAGS**), так и для компоновщика.

Самый простой способ сделать это - переопределение значений стандартных макросов внутри SPEC файла:

.. code-block:: text

    %global optflags %{optflags} -flto
    %global build_ldflags %{build_ldflags} -flto

Если в проекте применяются статические библиотеки (в т.ч. для внутренних целей), то также необходимо переопределить ряд :ref:`переменных окружения <env-set>` внутри секции ``%build``:

.. code-block:: bash

    export AR=%{_bindir}/gcc-ar
    export RANLIB=%{_bindir}/gcc-ranlib
    export NM=%{_bindir}/gcc-nm

Если используется система сборки cmake, то помимо этого придётся патчить манифест **CMakeLists.txt**, т.к. он в настоящее время не поддерживает загрузку переопределённых значений:

.. code-block:: bash

    set(CMAKE_AR "/usr/bin/gcc-ar")
    set(CMAKE_RANLIB "/usr/bin/gcc-ranlib")
    set(CMAKE_NM "/usr/bin/gcc-nm")

В противном случае появится ошибка *plugin needed to handle lto object*.

.. index:: gcc, c, rpm, dependencies, package
.. _rpm-unneeded:

Как вывести список установленных пакетов, от которых никто не зависит?
=========================================================================

В настоящее время данная функциональность отсутствует в dnf "из коробки", поэтому напишем и скомпилируем небольшую программу на языке C, реализующую это средствами библиотеки **libsolv**.

Установим компилятор и необходимые для сборки библиотеки:

.. code-block:: bash

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

.. code-block:: bash

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

 1. :ref:`LD_PRELOAD <ldpreload-safety>` - небезопасный - библиотека (или библиотеки) напрямую инъектируется в процесс средствами интерпретатора динамических библиотек LD до его непосредственного запуска;
 2. LD_LIBRARY_PATH - более безопасный - список каталогов, в которых интерпретатор динамических библиотек LD ищет соответствующие so, расширяется на указанные пользователем значения.

Рассмотрим второй способ с переопределением :ref:`переменной окружения <env-set>` ``LD_LIBRARY_PATH``.

Скачаем RPM пакет **foo-bar** необходимой версии из любого источника (лучшим вариантом будет конечно же репозитории старых версий Fedora), распакуем его например в ``~/lib/foo-bar`` и извлечём необходимые динамические библиотеки (.so файлы).

Создадим shell-скрипт ``run-foo.sh`` для запуска бинарника:

.. code-block:: bash

    #!/usr/bin/sh
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/lib/foo-bar
    /path/to/binary/foo

Здесь **foo** - имя бинарника, который требуется запустить, а **/path/to/binary** - каталог, в котором он находится. В качестве разделителя путей **LD_LIBRARY_PATH** применяется двоеточие. Закрывающий слэш не ставится.

Установим скрипту разрешение не запуск и запустим его:

.. code-block:: bash

    chmod +x run-foo.sh
    ./run-foo.sh

Если всё сделано верно, приложение успешно стартует.

.. index:: fedora, license, guidelines, legal
.. _fedora-licenses:

Проекты под какими лицензиями допускается распространять в репозиториях?
===========================================================================

См. `здесь <https://fedoraproject.org/wiki/Licensing:Main>`__.

.. index:: tlp, laptop, notebook, battery
.. _tlp-battery:

Нужно ли использовать TLP для оптимизации работы батареи?
============================================================

На современных поколениях ноутбуков использовать TLP не следует, т.к. контроллеры аккумуляторных батарей способны самостоятельно контролировать уровень заряда и балансировать износ ячеек.

Если всё же требуется установить предел заряда например от 70% до 90%, вместо TLP лучше один раз воспользоваться фирменной утилитой производителя устройства, задать необходимые настройки и сохранить изменения в NVRAM материнской платы. В таком случае они будут работать в любой ОС.

.. index:: process, bash, console, pipe
.. _pipe-order:

В каком порядке запускаются процессы через канал (пайп)?
===========================================================

Если запускается несколько процессов с передачей данных через канал (пайп; pipe), то все они стартуют одновременно, затем начинает выполняться первый, а остальные уходят в состояние ожидания ввода.
