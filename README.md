# Vinnny gift

Vinnny happy birthday gift

Влад, с днем рождения!

## Необходимые инструменты

* [git](https://git-scm.com/)
* [sjasmplus](https://github.com/z00m128/sjasmplus)
* `mktap`, `bintap` (ask your ZX Spectrum guru for links)
* `make` and some Linux stuffs (for Windows you can use [cygwin](https://www.cygwin.com/))

## Сборка 

Сборка производится основным сценарием `Makefile`. При этом:
* Компилируется файл `src/main.asm`
* Создается снэпшот, для удобства содержащий в имени хэш коммита
* Создаются полностью готовые к работе *trd* и *tap* файлы. Имя файла задается переменной **PROJECT_NAME** файла `Makefile`
