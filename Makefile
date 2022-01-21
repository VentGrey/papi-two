#
# Don't edit, this file is generated by FPCMake Version 2.0.0
#
default: all
MAKEFILETARGETS=x86_64-linux
BSDs = freebsd netbsd openbsd darwin dragonfly
UNIXs = linux $(BSDs) solaris qnx haiku aix
LIMIT83fs = go32v2 os2 emx watcom msdos win16 atari
OSNeedsComspecToRunBatch = go32v2 watcom
FORCE:
.PHONY: FORCE
override PATH:=$(patsubst %/,%,$(subst \,/,$(PATH)))
ifneq ($(findstring darwin,$(OSTYPE)),)
inUnix=1 #darwin
SEARCHPATH:=$(filter-out .,$(subst :, ,$(PATH)))
else
ifeq ($(findstring ;,$(PATH)),)
inUnix=1
SEARCHPATH:=$(filter-out .,$(subst :, ,$(PATH)))
else
SEARCHPATH:=$(subst ;, ,$(PATH))
endif
endif
SEARCHPATH+=$(patsubst %/,%,$(subst \,/,$(dir $(MAKE))))
PWD:=$(strip $(wildcard $(addsuffix /pwd.exe,$(SEARCHPATH))))
ifeq ($(PWD),)
PWD:=$(strip $(wildcard $(addsuffix /pwd,$(SEARCHPATH))))
ifeq ($(PWD),)
$(error You need the GNU utils package to use this Makefile)
else
PWD:=$(firstword $(PWD))
SRCEXEEXT=
endif
else
PWD:=$(firstword $(PWD))
SRCEXEEXT=.exe
endif
ifndef inUnix
ifeq ($(OS),Windows_NT)
inWinNT=1
else
ifdef OS2_SHELL
inOS2=1
endif
endif
else
ifneq ($(findstring cygdrive,$(PATH)),)
inCygWin=1
endif
endif
ifdef inUnix
SRCBATCHEXT=.sh
else
ifdef inOS2
SRCBATCHEXT=.cmd
else
SRCBATCHEXT=.bat
endif
endif
ifdef COMSPEC
ifneq ($(findstring $(OS_SOURCE),$(OSNeedsComspecToRunBatch)),)
ifndef RUNBATCH
RUNBATCH=$(COMSPEC) /C
endif
endif
endif
ifdef inUnix
PATHSEP=/
else
PATHSEP:=$(subst /,\,/)
ifdef inCygWin
PATHSEP=/
endif
endif
ifdef PWD
BASEDIR:=$(subst \,/,$(shell $(PWD)))
ifdef inCygWin
ifneq ($(findstring /cygdrive/,$(BASEDIR)),)
BASENODIR:=$(patsubst /cygdrive%,%,$(BASEDIR))
BASEDRIVE:=$(firstword $(subst /, ,$(BASENODIR)))
BASEDIR:=$(subst /cygdrive/$(BASEDRIVE)/,$(BASEDRIVE):/,$(BASEDIR))
endif
endif
else
BASEDIR=.
endif
ifdef inOS2
ifndef ECHO
ECHO:=$(strip $(wildcard $(addsuffix /gecho$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ECHO),)
ECHO:=$(strip $(wildcard $(addsuffix /echo$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ECHO),)
ECHO=echo
else
ECHO:=$(firstword $(ECHO))
endif
else
ECHO:=$(firstword $(ECHO))
endif
endif
export ECHO
endif
ifndef FPC
ifdef PP
FPC=$(PP)
endif
endif
ifndef FPC
FPCPROG:=$(strip $(wildcard $(addsuffix /fpc$(SRCEXEEXT),$(SEARCHPATH))))
ifneq ($(FPCPROG),)
FPCPROG:=$(firstword $(FPCPROG))
ifneq ($(CPU_TARGET),)
FPC:=$(shell $(FPCPROG) -P$(CPU_TARGET) -PB)
else
FPC:=$(shell $(FPCPROG) -PB)
endif
ifneq ($(findstring Error,$(FPC)),)
override FPC=$(firstword $(strip $(wildcard $(addsuffix /ppc386$(SRCEXEEXT),$(SEARCHPATH)))))
else
ifeq ($(strip $(wildcard $(FPC))),)
FPC:=$(firstword $(FPCPROG))
endif
endif
else
override FPC=$(firstword $(strip $(wildcard $(addsuffix /ppc386$(SRCEXEEXT),$(SEARCHPATH)))))
endif
endif
override FPC:=$(subst $(SRCEXEEXT),,$(FPC))
override FPC:=$(subst \,/,$(FPC))$(SRCEXEEXT)
FOUNDFPC:=$(strip $(wildcard $(FPC)))
ifeq ($(FOUNDFPC),)
FOUNDFPC=$(strip $(wildcard $(addsuffix /$(FPC),$(SEARCHPATH))))
ifeq ($(FOUNDFPC),)
$(error Compiler $(FPC) not found)
endif
endif
ifndef FPC_COMPILERINFO
FPC_COMPILERINFO:=$(shell $(FPC) -iVSPTPSOTO)
endif
ifndef FPC_VERSION
FPC_VERSION:=$(word 1,$(FPC_COMPILERINFO))
endif
export FPC FPC_VERSION FPC_COMPILERINFO
unexport CHECKDEPEND ALLDEPENDENCIES
ifndef CPU_TARGET
ifdef CPU_TARGET_DEFAULT
CPU_TARGET=$(CPU_TARGET_DEFAULT)
endif
endif
ifndef OS_TARGET
ifdef OS_TARGET_DEFAULT
OS_TARGET=$(OS_TARGET_DEFAULT)
endif
endif
ifndef CPU_SOURCE
CPU_SOURCE:=$(word 2,$(FPC_COMPILERINFO))
endif
ifndef CPU_TARGET
CPU_TARGET:=$(word 3,$(FPC_COMPILERINFO))
endif
ifndef OS_SOURCE
OS_SOURCE:=$(word 4,$(FPC_COMPILERINFO))
endif
ifndef OS_TARGET
OS_TARGET:=$(word 5,$(FPC_COMPILERINFO))
endif
FULL_TARGET=$(CPU_TARGET)-$(OS_TARGET)
FULL_SOURCE=$(CPU_SOURCE)-$(OS_SOURCE)
ifeq ($(CPU_TARGET),armeb)
ARCH=arm
override FPCOPT+=-Cb
else
ifeq ($(CPU_TARGET),armel)
ARCH=arm
override FPCOPT+=-CaEABI
else
ARCH=$(CPU_TARGET)
endif
endif
ifeq ($(FULL_TARGET),arm-embedded)
ifeq ($(SUBARCH),)
$(error When compiling for arm-embedded, a sub-architecture (e.g. SUBARCH=armv4t or SUBARCH=armv7m) must be defined)
endif
override FPCOPT+=-Cp$(SUBARCH)
endif
ifeq ($(FULL_TARGET),avr-embedded)
ifeq ($(SUBARCH),)
$(error When compiling for avr-embedded, a sub-architecture (e.g. SUBARCH=avr25 or SUBARCH=avr35) must be defined)
endif
override FPCOPT+=-Cp$(SUBARCH)
endif
ifeq ($(FULL_TARGET),mipsel-embedded)
ifeq ($(SUBARCH),)
$(error When compiling for mipsel-embedded, a sub-architecture (e.g. SUBARCH=pic32mx) must be defined)
endif
override FPCOPT+=-Cp$(SUBARCH)
endif
ifneq ($(findstring $(OS_SOURCE),$(LIMIT83fs)),)
TARGETSUFFIX=$(OS_TARGET)
SOURCESUFFIX=$(OS_SOURCE)
else
ifneq ($(findstring $(OS_TARGET),$(LIMIT83fs)),)
TARGETSUFFIX=$(OS_TARGET)
else
TARGETSUFFIX=$(FULL_TARGET)
endif
SOURCESUFFIX=$(FULL_SOURCE)
endif
ifneq ($(FULL_TARGET),$(FULL_SOURCE))
CROSSCOMPILE=1
endif
ifeq ($(findstring makefile,$(MAKECMDGOALS)),)
ifeq ($(findstring $(FULL_TARGET),$(MAKEFILETARGETS)),)
$(error The Makefile doesn't support target $(FULL_TARGET), please run fpcmake first)
endif
endif
ifneq ($(findstring $(OS_TARGET),$(BSDs)),)
BSDhier=1
endif
ifeq ($(OS_TARGET),linux)
linuxHier=1
endif
ifndef CROSSCOMPILE
BUILDFULLNATIVE=1
export BUILDFULLNATIVE
endif
ifdef BUILDFULLNATIVE
BUILDNATIVE=1
export BUILDNATIVE
endif
export OS_TARGET OS_SOURCE ARCH CPU_TARGET CPU_SOURCE FULL_TARGET FULL_SOURCE TARGETSUFFIX SOURCESUFFIX CROSSCOMPILE
ifndef DEB_HOST_MULTIARCH
DEB_HOST_MULTIARCH=$(shell dpkg-architecture -qDEB_HOST_MULTIARCH)
endif
export DEB_HOST_MULTIARCH
ifdef FPCDIR
override FPCDIR:=$(subst \,/,$(FPCDIR))
ifeq ($(wildcard $(addprefix $(FPCDIR)/,rtl)),)
override FPCDIR=wrong
endif
else
override FPCDIR=wrong
endif
ifdef DEFAULT_FPCDIR
ifeq ($(FPCDIR),wrong)
override FPCDIR:=$(subst \,/,$(DEFAULT_FPCDIR))
ifeq ($(wildcard $(addprefix $(FPCDIR)/,rtl)),)
override FPCDIR=wrong
endif
endif
endif
ifeq ($(FPCDIR),wrong)
ifdef inUnix
override FPCDIR=/usr/local/lib/fpc/$(FPC_VERSION)
ifeq ($(wildcard $(FPCDIR)/units),)
override FPCDIR=/usr/lib/${DEB_HOST_MULTIARCH}/fpc/$(FPC_VERSION)
endif
else
override FPCDIR:=$(subst /$(FPC),,$(firstword $(strip $(wildcard $(addsuffix /$(FPC),$(SEARCHPATH))))))
override FPCDIR:=$(FPCDIR)/..
ifeq ($(wildcard $(addprefix $(FPCDIR)/,rtl)),)
override FPCDIR:=$(FPCDIR)/..
ifeq ($(wildcard $(addprefix $(FPCDIR)/,rtl)),)
override FPCDIR:=$(BASEDIR)
ifeq ($(wildcard $(addprefix $(FPCDIR)/,rtl)),)
override FPCDIR=c:/pp
endif
endif
endif
endif
endif
ifndef CROSSBINDIR
CROSSBINDIR:=$(wildcard $(FPCDIR)/bin/$(TARGETSUFFIX))
endif
ifneq ($(findstring $(OS_TARGET),darwin iphonesim ios),)
ifneq ($(findstring $(OS_SOURCE),darwin ios),)
DARWIN2DARWIN=1
endif
endif
ifndef BINUTILSPREFIX
ifndef CROSSBINDIR
ifdef CROSSCOMPILE
ifneq ($(OS_TARGET),msdos)
ifndef DARWIN2DARWIN
ifneq ($(CPU_TARGET),jvm)
BINUTILSPREFIX=$(CPU_TARGET)-$(OS_TARGET)-
ifeq ($(OS_TARGET),android)
ifeq ($(CPU_TARGET),arm)
BINUTILSPREFIX=arm-linux-androideabi-
else
ifeq ($(CPU_TARGET),i386)
BINUTILSPREFIX=i686-linux-android-
else
BINUTILSPREFIX=$(CPU_TARGET)-linux-android-
endif
endif
endif
endif
endif
else
BINUTILSPREFIX=$(OS_TARGET)-
endif
endif
endif
endif
UNITSDIR:=$(wildcard $(FPCDIR)/units/$(TARGETSUFFIX))
ifeq ($(UNITSDIR),)
UNITSDIR:=$(wildcard $(FPCDIR)/units/$(OS_TARGET))
endif
PACKAGESDIR:=$(wildcard $(FPCDIR) $(FPCDIR)/packages)
ifndef FPCFPMAKE
ifdef CROSSCOMPILE
ifeq ($(strip $(wildcard $(addsuffix /compiler/ppc$(SRCEXEEXT),$(FPCDIR)))),)
FPCPROG:=$(strip $(wildcard $(addsuffix /fpc$(SRCEXEEXT),$(SEARCHPATH))))
ifneq ($(FPCPROG),)
FPCPROG:=$(firstword $(FPCPROG))
FPCFPMAKE:=$(shell $(FPCPROG) -PB)
ifeq ($(strip $(wildcard $(FPCFPMAKE))),)
FPCFPMAKE:=$(firstword $(FPCPROG))
endif
else
override FPCFPMAKE=$(firstword $(strip $(wildcard $(addsuffix /ppc386$(SRCEXEEXT),$(SEARCHPATH)))))
endif
else
FPCFPMAKE=$(strip $(wildcard $(addsuffix /compiler/ppc$(SRCEXEEXT),$(FPCDIR))))
FPMAKE_SKIP_CONFIG=-n
export FPCFPMAKE
export FPMAKE_SKIP_CONFIG
endif
else
FPMAKE_SKIP_CONFIG=-n
FPCFPMAKE=$(FPC)
endif
endif
override PACKAGE_NAME=papi-two
override PACKAGE_VERSION=0.0.1
ifdef REQUIRE_UNITSDIR
override UNITSDIR+=$(REQUIRE_UNITSDIR)
endif
ifdef REQUIRE_PACKAGESDIR
override PACKAGESDIR+=$(REQUIRE_PACKAGESDIR)
endif
ifdef ZIPINSTALL
ifneq ($(findstring $(OS_TARGET),$(UNIXs)),)
UNIXHier=1
endif
else
ifneq ($(findstring $(OS_SOURCE),$(UNIXs)),)
UNIXHier=1
endif
endif
ifndef INSTALL_PREFIX
ifdef PREFIX
INSTALL_PREFIX=$(PREFIX)
endif
endif
ifndef INSTALL_PREFIX
ifdef UNIXHier
INSTALL_PREFIX=/usr/local
else
ifdef INSTALL_FPCPACKAGE
INSTALL_BASEDIR:=/pp
else
INSTALL_BASEDIR:=/$(PACKAGE_NAME)
endif
endif
endif
export INSTALL_PREFIX
ifdef INSTALL_FPCSUBDIR
export INSTALL_FPCSUBDIR
endif
ifndef DIST_DESTDIR
DIST_DESTDIR:=$(BASEDIR)
endif
export DIST_DESTDIR
ifndef COMPILER_UNITTARGETDIR
ifdef PACKAGEDIR_MAIN
COMPILER_UNITTARGETDIR=$(PACKAGEDIR_MAIN)/units/$(TARGETSUFFIX)
else
COMPILER_UNITTARGETDIR=units/$(TARGETSUFFIX)
endif
endif
ifndef COMPILER_TARGETDIR
COMPILER_TARGETDIR=.
endif
ifndef INSTALL_BASEDIR
ifdef UNIXHier
ifdef INSTALL_FPCPACKAGE
INSTALL_BASEDIR:=$(INSTALL_PREFIX)/lib/${DEB_HOST_MULTIARCH}/fpc/$(FPC_VERSION)
else
INSTALL_BASEDIR:=$(INSTALL_PREFIX)/lib/$(PACKAGE_NAME)
endif
else
INSTALL_BASEDIR:=$(INSTALL_PREFIX)
endif
endif
ifndef INSTALL_BINDIR
ifdef UNIXHier
INSTALL_BINDIR:=$(INSTALL_PREFIX)/bin
else
INSTALL_BINDIR:=$(INSTALL_BASEDIR)/bin
ifdef INSTALL_FPCPACKAGE
ifdef CROSSCOMPILE
ifdef CROSSINSTALL
INSTALL_BINDIR:=$(INSTALL_BINDIR)/$(SOURCESUFFIX)
else
INSTALL_BINDIR:=$(INSTALL_BINDIR)/$(TARGETSUFFIX)
endif
else
INSTALL_BINDIR:=$(INSTALL_BINDIR)/$(TARGETSUFFIX)
endif
endif
endif
endif
ifndef INSTALL_UNITDIR
INSTALL_UNITDIR:=$(INSTALL_BASEDIR)/units/$(TARGETSUFFIX)
ifdef INSTALL_FPCPACKAGE
ifdef PACKAGE_NAME
INSTALL_UNITDIR:=$(INSTALL_UNITDIR)/$(PACKAGE_NAME)
endif
endif
endif
ifndef INSTALL_LIBDIR
ifdef UNIXHier
INSTALL_LIBDIR:=$(INSTALL_PREFIX)/lib/${DEB_HOST_MULTIARCH}
else
INSTALL_LIBDIR:=$(INSTALL_UNITDIR)
endif
endif
ifndef INSTALL_SOURCEDIR
ifdef UNIXHier
ifdef BSDhier
SRCPREFIXDIR=share/src
else
ifdef linuxHier
SRCPREFIXDIR=share/src
else
SRCPREFIXDIR=src
endif
endif
ifdef INSTALL_FPCPACKAGE
ifdef INSTALL_FPCSUBDIR
INSTALL_SOURCEDIR:=$(INSTALL_PREFIX)/$(SRCPREFIXDIR)/fpc-$(FPC_VERSION)/$(INSTALL_FPCSUBDIR)/$(PACKAGE_NAME)
else
INSTALL_SOURCEDIR:=$(INSTALL_PREFIX)/$(SRCPREFIXDIR)/fpc-$(FPC_VERSION)/$(PACKAGE_NAME)
endif
else
INSTALL_SOURCEDIR:=$(INSTALL_PREFIX)/$(SRCPREFIXDIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
endif
else
ifdef INSTALL_FPCPACKAGE
ifdef INSTALL_FPCSUBDIR
INSTALL_SOURCEDIR:=$(INSTALL_BASEDIR)/source/$(INSTALL_FPCSUBDIR)/$(PACKAGE_NAME)
else
INSTALL_SOURCEDIR:=$(INSTALL_BASEDIR)/source/$(PACKAGE_NAME)
endif
else
INSTALL_SOURCEDIR:=$(INSTALL_BASEDIR)/source
endif
endif
endif
ifndef INSTALL_DOCDIR
ifdef UNIXHier
ifdef BSDhier
DOCPREFIXDIR=share/doc
else
ifdef linuxHier
DOCPREFIXDIR=share/doc
else
DOCPREFIXDIR=doc
endif
endif
ifdef INSTALL_FPCPACKAGE
INSTALL_DOCDIR:=$(INSTALL_PREFIX)/$(DOCPREFIXDIR)/fpc-$(FPC_VERSION)/$(PACKAGE_NAME)
else
INSTALL_DOCDIR:=$(INSTALL_PREFIX)/$(DOCPREFIXDIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
endif
else
ifdef INSTALL_FPCPACKAGE
INSTALL_DOCDIR:=$(INSTALL_BASEDIR)/doc/$(PACKAGE_NAME)
else
INSTALL_DOCDIR:=$(INSTALL_BASEDIR)/doc
endif
endif
endif
ifndef INSTALL_EXAMPLEDIR
ifdef UNIXHier
ifdef INSTALL_FPCPACKAGE
ifdef BSDhier
INSTALL_EXAMPLEDIR:=$(INSTALL_PREFIX)/share/examples/fpc-$(FPC_VERSION)/$(PACKAGE_NAME)
else
ifdef linuxHier
INSTALL_EXAMPLEDIR:=$(INSTALL_DOCDIR)/examples
else
INSTALL_EXAMPLEDIR:=$(INSTALL_PREFIX)/doc/fpc-$(FPC_VERSION)/examples/$(PACKAGE_NAME)
endif
endif
else
ifdef BSDhier
INSTALL_EXAMPLEDIR:=$(INSTALL_PREFIX)/share/examples/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
else
ifdef linuxHier
INSTALL_EXAMPLEDIR:=$(INSTALL_DOCDIR)/examples/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
else
INSTALL_EXAMPLEDIR:=$(INSTALL_PREFIX)/doc/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
endif
endif
endif
else
ifdef INSTALL_FPCPACKAGE
INSTALL_EXAMPLEDIR:=$(INSTALL_BASEDIR)/examples/$(PACKAGE_NAME)
else
INSTALL_EXAMPLEDIR:=$(INSTALL_BASEDIR)/examples
endif
endif
endif
ifndef INSTALL_DATADIR
INSTALL_DATADIR=$(INSTALL_BASEDIR)
endif
ifndef INSTALL_SHAREDDIR
INSTALL_SHAREDDIR=$(INSTALL_PREFIX)/lib/${DEB_HOST_MULTIARCH}
endif
ifdef CROSSCOMPILE
ifndef CROSSBINDIR
CROSSBINDIR:=$(wildcard $(CROSSTARGETDIR)/bin/$(SOURCESUFFIX))
ifeq ($(CROSSBINDIR),)
CROSSBINDIR:=$(wildcard $(INSTALL_BASEDIR)/cross/$(TARGETSUFFIX)/bin/$(FULL_SOURCE))
endif
endif
else
CROSSBINDIR=
endif
BATCHEXT=.bat
LOADEREXT=.as
EXEEXT=.exe
PPLEXT=.ppl
PPUEXT=.ppu
OEXT=.o
ASMEXT=.s
SMARTEXT=.sl
STATICLIBEXT=.a
SHAREDLIBEXT=.so
SHAREDLIBPREFIX=libfp
STATICLIBPREFIX=libp
IMPORTLIBPREFIX=libimp
RSTEXT=.rst
EXEDBGEXT=.dbg
ifeq ($(OS_TARGET),go32v1)
STATICLIBPREFIX=
SHORTSUFFIX=v1
endif
ifeq ($(OS_TARGET),go32v2)
STATICLIBPREFIX=
SHORTSUFFIX=dos
IMPORTLIBPREFIX=
endif
ifeq ($(OS_TARGET),watcom)
STATICLIBPREFIX=
OEXT=.obj
ASMEXT=.asm
SHAREDLIBEXT=.dll
SHORTSUFFIX=wat
IMPORTLIBPREFIX=
endif
ifneq ($(CPU_TARGET),jvm)
ifeq ($(OS_TARGET),android)
BATCHEXT=.sh
EXEEXT=
HASSHAREDLIB=1
SHORTSUFFIX=lnx
endif
endif
ifeq ($(OS_TARGET),linux)
BATCHEXT=.sh
EXEEXT=
HASSHAREDLIB=1
SHORTSUFFIX=lnx
endif
ifeq ($(OS_TARGET),dragonfly)
BATCHEXT=.sh
EXEEXT=
HASSHAREDLIB=1
SHORTSUFFIX=df
endif
ifeq ($(OS_TARGET),freebsd)
BATCHEXT=.sh
EXEEXT=
HASSHAREDLIB=1
SHORTSUFFIX=fbs
endif
ifeq ($(OS_TARGET),netbsd)
BATCHEXT=.sh
EXEEXT=
HASSHAREDLIB=1
SHORTSUFFIX=nbs
endif
ifeq ($(OS_TARGET),openbsd)
BATCHEXT=.sh
EXEEXT=
HASSHAREDLIB=1
SHORTSUFFIX=obs
endif
ifeq ($(OS_TARGET),win32)
SHAREDLIBEXT=.dll
SHORTSUFFIX=w32
endif
ifeq ($(OS_TARGET),os2)
BATCHEXT=.cmd
AOUTEXT=.out
STATICLIBPREFIX=
SHAREDLIBEXT=.dll
SHORTSUFFIX=os2
ECHO=echo
IMPORTLIBPREFIX=
endif
ifeq ($(OS_TARGET),emx)
BATCHEXT=.cmd
AOUTEXT=.out
STATICLIBPREFIX=
SHAREDLIBEXT=.dll
SHORTSUFFIX=emx
ECHO=echo
IMPORTLIBPREFIX=
endif
ifeq ($(OS_TARGET),amiga)
EXEEXT=
SHAREDLIBEXT=.library
SHORTSUFFIX=amg
endif
ifeq ($(OS_TARGET),aros)
EXEEXT=
SHAREDLIBEXT=.library
SHORTSUFFIX=aros
endif
ifeq ($(OS_TARGET),morphos)
EXEEXT=
SHAREDLIBEXT=.library
SHORTSUFFIX=mos
endif
ifeq ($(OS_TARGET),atari)
EXEEXT=.ttp
SHORTSUFFIX=ata
endif
ifeq ($(OS_TARGET),beos)
BATCHEXT=.sh
EXEEXT=
SHORTSUFFIX=be
endif
ifeq ($(OS_TARGET),haiku)
BATCHEXT=.sh
EXEEXT=
SHORTSUFFIX=hai
endif
ifeq ($(OS_TARGET),solaris)
BATCHEXT=.sh
EXEEXT=
SHORTSUFFIX=sun
endif
ifeq ($(OS_TARGET),qnx)
BATCHEXT=.sh
EXEEXT=
SHORTSUFFIX=qnx
endif
ifeq ($(OS_TARGET),netware)
EXEEXT=.nlm
STATICLIBPREFIX=
SHORTSUFFIX=nw
IMPORTLIBPREFIX=imp
endif
ifeq ($(OS_TARGET),netwlibc)
EXEEXT=.nlm
STATICLIBPREFIX=
SHORTSUFFIX=nwl
IMPORTLIBPREFIX=imp
endif
ifeq ($(OS_TARGET),macosclassic)
BATCHEXT=
EXEEXT=
DEBUGSYMEXT=.xcoff
SHORTSUFFIX=mac
IMPORTLIBPREFIX=imp
endif
ifneq ($(findstring $(OS_TARGET),darwin iphonesim ios),)
BATCHEXT=.sh
EXEEXT=
HASSHAREDLIB=1
SHORTSUFFIX=dwn
EXEDBGEXT=.dSYM
endif
ifeq ($(OS_TARGET),gba)
EXEEXT=.gba
SHAREDLIBEXT=.so
SHORTSUFFIX=gba
endif
ifeq ($(OS_TARGET),symbian)
SHAREDLIBEXT=.dll
SHORTSUFFIX=symbian
endif
ifeq ($(OS_TARGET),NativeNT)
SHAREDLIBEXT=.dll
SHORTSUFFIX=nativent
endif
ifeq ($(OS_TARGET),wii)
EXEEXT=.dol
SHAREDLIBEXT=.so
SHORTSUFFIX=wii
endif
ifeq ($(OS_TARGET),aix)
BATCHEXT=.sh
EXEEXT=
SHAREDLIBEXT=.a
SHORTSUFFIX=aix
endif
ifeq ($(OS_TARGET),java)
OEXT=.class
ASMEXT=.j
SHAREDLIBEXT=.jar
SHORTSUFFIX=java
endif
ifeq ($(CPU_TARGET),jvm)
ifeq ($(OS_TARGET),android)
OEXT=.class
ASMEXT=.j
SHAREDLIBEXT=.jar
SHORTSUFFIX=android
endif
endif
ifeq ($(OS_TARGET),msdos)
STATICLIBPREFIX=
STATICLIBEXT=.a
SHORTSUFFIX=d16
endif
ifeq ($(OS_TARGET),embedded)
ifeq ($(CPU_TARGET),i8086)
STATICLIBPREFIX=
STATICLIBEXT=.a
else
EXEEXT=.bin
endif
SHORTSUFFIX=emb
endif
ifeq ($(OS_TARGET),win16)
STATICLIBPREFIX=
STATICLIBEXT=.a
SHAREDLIBEXT=.dll
SHORTSUFFIX=w16
endif
ifneq ($(findstring $(OS_SOURCE),$(LIMIT83fs)),)
FPCMADE=fpcmade.$(SHORTSUFFIX)
ZIPSUFFIX=$(SHORTSUFFIX)
ZIPCROSSPREFIX=
ZIPSOURCESUFFIX=src
ZIPEXAMPLESUFFIX=exm
else
FPCMADE=fpcmade.$(TARGETSUFFIX)
ZIPSOURCESUFFIX=.source
ZIPEXAMPLESUFFIX=.examples
ifdef CROSSCOMPILE
ZIPSUFFIX=.$(SOURCESUFFIX)
ZIPCROSSPREFIX=$(TARGETSUFFIX)-
else
ZIPSUFFIX=.$(TARGETSUFFIX)
ZIPCROSSPREFIX=
endif
endif
ifndef ECHO
ECHO:=$(strip $(wildcard $(addsuffix /gecho$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ECHO),)
ECHO:=$(strip $(wildcard $(addsuffix /echo$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ECHO),)
ECHO= __missing_command_ECHO
else
ECHO:=$(firstword $(ECHO))
endif
else
ECHO:=$(firstword $(ECHO))
endif
endif
export ECHO
ifndef DATE
DATE:=$(strip $(wildcard $(addsuffix /gdate$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(DATE),)
DATE:=$(strip $(wildcard $(addsuffix /date$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(DATE),)
DATE= __missing_command_DATE
else
DATE:=$(firstword $(DATE))
endif
else
DATE:=$(firstword $(DATE))
endif
endif
export DATE
ifndef GINSTALL
GINSTALL:=$(strip $(wildcard $(addsuffix /ginstall$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(GINSTALL),)
GINSTALL:=$(strip $(wildcard $(addsuffix /install$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(GINSTALL),)
GINSTALL= __missing_command_GINSTALL
else
GINSTALL:=$(firstword $(GINSTALL))
endif
else
GINSTALL:=$(firstword $(GINSTALL))
endif
endif
export GINSTALL
ifndef CPPROG
CPPROG:=$(strip $(wildcard $(addsuffix /cp$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(CPPROG),)
CPPROG= __missing_command_CPPROG
else
CPPROG:=$(firstword $(CPPROG))
endif
endif
export CPPROG
ifndef RMPROG
RMPROG:=$(strip $(wildcard $(addsuffix /rm$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(RMPROG),)
RMPROG= __missing_command_RMPROG
else
RMPROG:=$(firstword $(RMPROG))
endif
endif
export RMPROG
ifndef MVPROG
MVPROG:=$(strip $(wildcard $(addsuffix /mv$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(MVPROG),)
MVPROG= __missing_command_MVPROG
else
MVPROG:=$(firstword $(MVPROG))
endif
endif
export MVPROG
ifndef MKDIRPROG
MKDIRPROG:=$(strip $(wildcard $(addsuffix /gmkdir$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(MKDIRPROG),)
MKDIRPROG:=$(strip $(wildcard $(addsuffix /mkdir$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(MKDIRPROG),)
MKDIRPROG= __missing_command_MKDIRPROG
else
MKDIRPROG:=$(firstword $(MKDIRPROG))
endif
else
MKDIRPROG:=$(firstword $(MKDIRPROG))
endif
endif
export MKDIRPROG
ifndef ECHOREDIR
ifndef inUnix
ECHOREDIR=echo
else
ECHOREDIR=$(ECHO)
endif
endif
ifndef COPY
COPY:=$(CPPROG) -fp
endif
ifndef COPYTREE
COPYTREE:=$(CPPROG) -Rfp
endif
ifndef MKDIRTREE
MKDIRTREE:=$(MKDIRPROG) -p
endif
ifndef MOVE
MOVE:=$(MVPROG) -f
endif
ifndef DEL
DEL:=$(RMPROG) -f
endif
ifndef DELTREE
DELTREE:=$(RMPROG) -rf
endif
ifndef INSTALL
ifdef inUnix
INSTALL:=$(GINSTALL) -c -m 644
else
INSTALL:=$(COPY)
endif
endif
ifndef INSTALLEXE
ifdef inUnix
INSTALLEXE:=$(GINSTALL) -c -m 755
else
INSTALLEXE:=$(COPY)
endif
endif
ifndef MKDIR
MKDIR:=$(GINSTALL) -m 755 -d
endif
export ECHOREDIR COPY COPYTREE MOVE DEL DELTREE INSTALL INSTALLEXE MKDIR
ifndef PPUMOVE
PPUMOVE:=$(strip $(wildcard $(addsuffix /ppumove$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(PPUMOVE),)
PPUMOVE= __missing_command_PPUMOVE
else
PPUMOVE:=$(firstword $(PPUMOVE))
endif
endif
export PPUMOVE
ifndef FPCMAKE
FPCMAKE:=$(strip $(wildcard $(addsuffix /fpcmake$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(FPCMAKE),)
FPCMAKE= __missing_command_FPCMAKE
else
FPCMAKE:=$(firstword $(FPCMAKE))
endif
endif
export FPCMAKE
ifndef ZIPPROG
ZIPPROG:=$(strip $(wildcard $(addsuffix /zip$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ZIPPROG),)
ZIPPROG= __missing_command_ZIPPROG
else
ZIPPROG:=$(firstword $(ZIPPROG))
endif
endif
export ZIPPROG
ifndef TARPROG
TARPROG:=$(strip $(wildcard $(addsuffix /gtar$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(TARPROG),)
TARPROG:=$(strip $(wildcard $(addsuffix /tar$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(TARPROG),)
TARPROG= __missing_command_TARPROG
else
TARPROG:=$(firstword $(TARPROG))
endif
else
TARPROG:=$(firstword $(TARPROG))
endif
endif
export TARPROG
ASNAME=$(BINUTILSPREFIX)as
LDNAME=$(BINUTILSPREFIX)ld
ARNAME=$(BINUTILSPREFIX)ar
RCNAME=$(BINUTILSPREFIX)rc
NASMNAME=$(BINUTILSPREFIX)nasm
ifndef ASPROG
ifdef CROSSBINDIR
ASPROG=$(CROSSBINDIR)/$(ASNAME)$(SRCEXEEXT)
else
ASPROG=$(ASNAME)
endif
endif
ifndef LDPROG
ifdef CROSSBINDIR
LDPROG=$(CROSSBINDIR)/$(LDNAME)$(SRCEXEEXT)
else
LDPROG=$(LDNAME)
endif
endif
ifndef RCPROG
ifdef CROSSBINDIR
RCPROG=$(CROSSBINDIR)/$(RCNAME)$(SRCEXEEXT)
else
RCPROG=$(RCNAME)
endif
endif
ifndef ARPROG
ifdef CROSSBINDIR
ARPROG=$(CROSSBINDIR)/$(ARNAME)$(SRCEXEEXT)
else
ARPROG=$(ARNAME)
endif
endif
ifndef NASMPROG
ifdef CROSSBINDIR
NASMPROG=$(CROSSBINDIR)/$(NASMNAME)$(SRCEXEEXT)
else
NASMPROG=$(NASMNAME)
endif
endif
AS=$(ASPROG)
LD=$(LDPROG)
RC=$(RCPROG)
AR=$(ARPROG)
NASM=$(NASMPROG)
ifdef inUnix
PPAS=./ppas$(SRCBATCHEXT)
else
PPAS=ppas$(SRCBATCHEXT)
endif
ifdef inUnix
LDCONFIG=ldconfig
else
LDCONFIG=
endif
ifdef DATE
DATESTR:=$(shell $(DATE) +%Y%m%d)
else
DATESTR=
endif
ZIPOPT=-9
ZIPEXT=.zip
ifeq ($(USETAR),bz2)
TAROPT=vj
TAREXT=.tar.bz2
else
TAROPT=vz
TAREXT=.tar.gz
endif
ifndef NOCPUDEF
override FPCOPTDEF=$(ARCH)
endif
ifneq ($(OS_TARGET),$(OS_SOURCE))
override FPCOPT+=-T$(OS_TARGET)
endif
ifneq ($(CPU_TARGET),$(CPU_SOURCE))
override FPCOPT+=-P$(ARCH)
endif
ifeq ($(OS_SOURCE),openbsd)
override FPCOPT+=-FD$(NEW_BINUTILS_PATH)
override FPCMAKEOPT+=-FD$(NEW_BINUTILS_PATH)
override FPMAKE_BUILD_OPT+=-FD$(NEW_BINUTILS_PATH)
endif
ifndef CROSSBOOTSTRAP
ifneq ($(BINUTILSPREFIX),)
override FPCOPT+=-XP$(BINUTILSPREFIX)
endif
ifneq ($(BINUTILSPREFIX),)
override FPCOPT+=-Xr$(RLINKPATH)
endif
endif
ifndef CROSSCOMPILE
ifneq ($(BINUTILSPREFIX),)
override FPCMAKEOPT+=-XP$(BINUTILSPREFIX)
override FPMAKE_BUILD_OPT+=-XP$(BINUTILSPREFIX)
endif
endif
ifdef UNITDIR
override FPCOPT+=$(addprefix -Fu,$(UNITDIR))
endif
ifdef LIBDIR
override FPCOPT+=$(addprefix -Fl,$(LIBDIR))
endif
ifdef OBJDIR
override FPCOPT+=$(addprefix -Fo,$(OBJDIR))
endif
ifdef INCDIR
override FPCOPT+=$(addprefix -Fi,$(INCDIR))
endif
ifdef LINKSMART
override FPCOPT+=-XX
endif
ifdef CREATESMART
override FPCOPT+=-CX
endif
ifdef DEBUG
override FPCOPT+=-gl
override FPCOPTDEF+=DEBUG
endif
ifdef RELEASE
FPCCPUOPT:=-O2
override FPCOPT+=-Ur -Xs $(FPCCPUOPT) -n
override FPCOPTDEF+=RELEASE
endif
ifdef STRIP
override FPCOPT+=-Xs
endif
ifdef OPTIMIZE
override FPCOPT+=-O2
endif
ifdef VERBOSE
override FPCOPT+=-vwni
endif
ifdef COMPILER_OPTIONS
override FPCOPT+=$(COMPILER_OPTIONS)
endif
ifdef COMPILER_UNITDIR
override FPCOPT+=$(addprefix -Fu,$(COMPILER_UNITDIR))
endif
ifdef COMPILER_LIBRARYDIR
override FPCOPT+=$(addprefix -Fl,$(COMPILER_LIBRARYDIR))
endif
ifdef COMPILER_OBJECTDIR
override FPCOPT+=$(addprefix -Fo,$(COMPILER_OBJECTDIR))
endif
ifdef COMPILER_INCLUDEDIR
override FPCOPT+=$(addprefix -Fi,$(COMPILER_INCLUDEDIR))
endif
ifdef CROSSBINDIR
override FPCOPT+=-FD$(CROSSBINDIR)
endif
ifdef COMPILER_TARGETDIR
override FPCOPT+=-FE$(COMPILER_TARGETDIR)
ifeq ($(COMPILER_TARGETDIR),.)
override TARGETDIRPREFIX=
else
override TARGETDIRPREFIX=$(COMPILER_TARGETDIR)/
endif
endif
ifdef COMPILER_UNITTARGETDIR
override FPCOPT+=-FU$(COMPILER_UNITTARGETDIR)
ifeq ($(COMPILER_UNITTARGETDIR),.)
override UNITTARGETDIRPREFIX=
else
override UNITTARGETDIRPREFIX=$(COMPILER_UNITTARGETDIR)/
endif
else
ifdef COMPILER_TARGETDIR
override COMPILER_UNITTARGETDIR=$(COMPILER_TARGETDIR)
override UNITTARGETDIRPREFIX=$(TARGETDIRPREFIX)
endif
endif
ifdef CREATESHARED
override FPCOPT+=-Cg
endif
ifneq ($(findstring $(OS_TARGET),dragonfly freebsd openbsd netbsd linux solaris),)
ifneq ($(findstring $(CPU_TARGET),x86_64 mips mipsel),)
override FPCOPT+=-Cg
endif
endif
ifdef LINKSHARED
endif
ifdef OPT
override FPCOPT+=$(OPT)
endif
ifdef FPMAKEBUILDOPT
override FPMAKE_BUILD_OPT+=$(FPMAKEBUILDOPT)
endif
ifdef FPCOPTDEF
override FPCOPT+=$(addprefix -d,$(FPCOPTDEF))
endif
ifdef CFGFILE
override FPCOPT+=@$(CFGFILE)
endif
ifdef USEENV
override FPCEXTCMD:=$(FPCOPT)
override FPCOPT:=!FPCEXTCMD
export FPCEXTCMD
endif
override AFULL_TARGET=$(CPU_TARGET)-$(OS_TARGET)
override AFULL_SOURCE=$(CPU_SOURCE)-$(OS_SOURCE)
ifneq ($(AFULL_TARGET),$(AFULL_SOURCE))
override ACROSSCOMPILE=1
endif
ifdef ACROSSCOMPILE
override FPCOPT+=$(CROSSOPT)
endif
override COMPILER:=$(strip $(FPC) $(FPCOPT))
ifneq (,$(findstring -sh ,$(COMPILER)))
UseEXECPPAS=1
endif
ifneq (,$(findstring -s ,$(COMPILER)))
ifeq ($(FULL_SOURCE),$(FULL_TARGET))
UseEXECPPAS=1
endif
endif
ifneq ($(UseEXECPPAS),1)
EXECPPAS=
else
ifdef RUNBATCH
EXECPPAS:=@$(RUNBATCH) $(PPAS)
else
EXECPPAS:=@$(PPAS)
endif
endif
ifdef TARGET_RSTS
override RSTFILES=$(addsuffix $(RSTEXT),$(TARGET_RSTS))
override CLEANRSTFILES+=$(RSTFILES)
endif
.PHONY: fpc_install fpc_sourceinstall fpc_exampleinstall
ifdef INSTALL_UNITS
override INSTALLPPUFILES+=$(addsuffix $(PPUEXT),$(INSTALL_UNITS))
endif
ifdef INSTALL_BUILDUNIT
override INSTALLPPUFILES:=$(filter-out $(INSTALL_BUILDUNIT)$(PPUEXT),$(INSTALLPPUFILES))
endif
ifdef INSTALLPPUFILES
ifneq ($(IMPORTLIBPREFIX)-$(STATICLIBEXT),$(STATICLIBPREFIX)-$(STATICLIBEXT))
override INSTALLPPULINKFILES:=$(subst $(PPUEXT),$(OEXT),$(INSTALLPPUFILES)) $(addprefix $(STATICLIBPREFIX),$(subst $(PPUEXT),$(STATICLIBEXT),$(INSTALLPPUFILES))) $(addprefix $(IMPORTLIBPREFIX),$(subst $(PPUEXT),$(STATICLIBEXT),$(INSTALLPPUFILES)))
else
override INSTALLPPULINKFILES:=$(subst $(PPUEXT),$(OEXT),$(INSTALLPPUFILES)) $(addprefix $(STATICLIBPREFIX),$(subst $(PPUEXT),$(STATICLIBEXT),$(INSTALLPPUFILES)))
endif
ifneq ($(UNITTARGETDIRPREFIX),)
override INSTALLPPUFILES:=$(addprefix $(UNITTARGETDIRPREFIX),$(notdir $(INSTALLPPUFILES)))
override INSTALLPPULINKFILES:=$(wildcard $(addprefix $(UNITTARGETDIRPREFIX),$(notdir $(INSTALLPPULINKFILES))))
endif
override INSTALL_CREATEPACKAGEFPC=1
endif
ifdef INSTALLEXEFILES
ifneq ($(TARGETDIRPREFIX),)
override INSTALLEXEFILES:=$(addprefix $(TARGETDIRPREFIX),$(notdir $(INSTALLEXEFILES)))
endif
endif
fpc_install: all $(INSTALLTARGET)
ifdef INSTALLEXEFILES
	$(MKDIR) $(INSTALL_BINDIR)
	$(INSTALLEXE) $(INSTALLEXEFILES) $(INSTALL_BINDIR)
endif
ifdef INSTALL_CREATEPACKAGEFPC
ifdef FPCMAKE
ifdef PACKAGE_VERSION
ifneq ($(wildcard Makefile.fpc),)
	$(FPCMAKE) -p -T$(CPU_TARGET)-$(OS_TARGET) Makefile.fpc
	$(MKDIR) $(INSTALL_UNITDIR)
	$(INSTALL) Package.fpc $(INSTALL_UNITDIR)
endif
endif
endif
endif
ifdef INSTALLPPUFILES
	$(MKDIR) $(INSTALL_UNITDIR)
	$(INSTALL) $(INSTALLPPUFILES) $(INSTALL_UNITDIR)
ifneq ($(INSTALLPPULINKFILES),)
	$(INSTALL) $(INSTALLPPULINKFILES) $(INSTALL_UNITDIR)
endif
ifneq ($(wildcard $(LIB_FULLNAME)),)
	$(MKDIR) $(INSTALL_LIBDIR)
	$(INSTALL) $(LIB_FULLNAME) $(INSTALL_LIBDIR)
ifdef inUnix
	ln -sf $(LIB_FULLNAME) $(INSTALL_LIBDIR)/$(LIB_NAME)
endif
endif
endif
ifdef INSTALL_FILES
	$(MKDIR) $(INSTALL_DATADIR)
	$(INSTALL) $(INSTALL_FILES) $(INSTALL_DATADIR)
endif
fpc_sourceinstall: distclean
	$(MKDIR) $(INSTALL_SOURCEDIR)
	$(COPYTREE) $(BASEDIR)/* $(INSTALL_SOURCEDIR)
fpc_exampleinstall: $(EXAMPLEINSTALLTARGET) $(addsuffix _distclean,$(TARGET_EXAMPLEDIRS))
ifdef HASEXAMPLES
	$(MKDIR) $(INSTALL_EXAMPLEDIR)
endif
ifdef EXAMPLESOURCEFILES
	$(COPY) $(EXAMPLESOURCEFILES) $(INSTALL_EXAMPLEDIR)
endif
ifdef TARGET_EXAMPLEDIRS
	$(COPYTREE) $(addsuffix /*,$(TARGET_EXAMPLEDIRS)) $(INSTALL_EXAMPLEDIR)
endif
.PHONY: fpc_distinstall
fpc_distinstall: install exampleinstall
.PHONY: fpc_zipinstall fpc_zipsourceinstall fpc_zipexampleinstall
ifndef PACKDIR
ifndef inUnix
PACKDIR=$(BASEDIR)/../fpc-pack
else
PACKDIR=/tmp/fpc-pack
endif
endif
ifndef ZIPNAME
ifdef DIST_ZIPNAME
ZIPNAME=$(DIST_ZIPNAME)
else
ZIPNAME=$(PACKAGE_NAME)
endif
endif
ifndef FULLZIPNAME
FULLZIPNAME=$(ZIPCROSSPREFIX)$(ZIPPREFIX)$(ZIPNAME)$(ZIPSUFFIX)
endif
ifndef ZIPTARGET
ifdef DIST_ZIPTARGET
ZIPTARGET=DIST_ZIPTARGET
else
ZIPTARGET=install
endif
endif
ifndef USEZIP
ifdef inUnix
USETAR=1
endif
endif
ifndef inUnix
USEZIPWRAPPER=1
endif
ifdef USEZIPWRAPPER
ZIPPATHSEP=$(PATHSEP)
ZIPWRAPPER=$(subst /,$(PATHSEP),$(DIST_DESTDIR)/fpczip$(SRCBATCHEXT))
else
ZIPPATHSEP=/
endif
ZIPCMD_CDPACK:=cd $(subst /,$(ZIPPATHSEP),$(PACKDIR))
ZIPCMD_CDBASE:=cd $(subst /,$(ZIPPATHSEP),$(BASEDIR))
ifdef USETAR
ZIPDESTFILE:=$(DIST_DESTDIR)/$(FULLZIPNAME)$(TAREXT)
ZIPCMD_ZIP:=$(TARPROG) c$(TAROPT)f $(ZIPDESTFILE) *
else
ZIPDESTFILE:=$(DIST_DESTDIR)/$(FULLZIPNAME)$(ZIPEXT)
ZIPCMD_ZIP:=$(subst /,$(ZIPPATHSEP),$(ZIPPROG)) -Dr $(ZIPOPT) $(ZIPDESTFILE) *
endif
fpc_zipinstall:
	$(MAKE) $(ZIPTARGET) INSTALL_PREFIX=$(PACKDIR) ZIPINSTALL=1
	$(MKDIR) $(DIST_DESTDIR)
	$(DEL) $(ZIPDESTFILE)
ifdef USEZIPWRAPPER
ifneq ($(ECHOREDIR),echo)
	$(ECHOREDIR) -e "$(subst \,\\,$(ZIPCMD_CDPACK))" > $(ZIPWRAPPER)
	$(ECHOREDIR) -e "$(subst \,\\,$(ZIPCMD_ZIP))" >> $(ZIPWRAPPER)
	$(ECHOREDIR) -e "$(subst \,\\,$(ZIPCMD_CDBASE))" >> $(ZIPWRAPPER)
else
	echo $(ZIPCMD_CDPACK) > $(ZIPWRAPPER)
	echo $(ZIPCMD_ZIP) >> $(ZIPWRAPPER)
	echo $(ZIPCMD_CDBASE) >> $(ZIPWRAPPER)
endif
ifdef inUnix
	/bin/sh $(ZIPWRAPPER)
else
ifdef RUNBATCH
	$(RUNBATCH) $(ZIPWRAPPER)
else
	$(ZIPWRAPPER)
endif
endif
	$(DEL) $(ZIPWRAPPER)
else
	$(ZIPCMD_CDPACK) ; $(ZIPCMD_ZIP) ; $(ZIPCMD_CDBASE)
endif
	$(DELTREE) $(PACKDIR)
fpc_zipsourceinstall:
	$(MAKE) fpc_zipinstall ZIPTARGET=sourceinstall ZIPSUFFIX=$(ZIPSOURCESUFFIX)
fpc_zipexampleinstall:
ifdef HASEXAMPLES
	$(MAKE) fpc_zipinstall ZIPTARGET=exampleinstall ZIPSUFFIX=$(ZIPEXAMPLESUFFIX)
endif
fpc_zipdistinstall:
	$(MAKE) fpc_zipinstall ZIPTARGET=distinstall
.PHONY: fpc_clean fpc_cleanall fpc_distclean
ifdef EXEFILES
override CLEANEXEFILES:=$(addprefix $(TARGETDIRPREFIX),$(CLEANEXEFILES))
override CLEANEXEDBGFILES:=$(addprefix $(TARGETDIRPREFIX),$(CLEANEXEDBGFILES))
endif
ifdef CLEAN_PROGRAMS
override CLEANEXEFILES+=$(addprefix $(TARGETDIRPREFIX),$(addsuffix $(EXEEXT), $(CLEAN_PROGRAMS)))
override CLEANEXEDBGFILES+=$(addprefix $(TARGETDIRPREFIX),$(addsuffix $(EXEDBGEXT), $(CLEAN_PROGRAMS)))
endif
ifdef CLEAN_UNITS
override CLEANPPUFILES+=$(addsuffix $(PPUEXT),$(CLEAN_UNITS))
endif
ifdef CLEANPPUFILES
override CLEANPPULINKFILES:=$(subst $(PPUEXT),$(OEXT),$(CLEANPPUFILES)) $(addprefix $(STATICLIBPREFIX),$(subst $(PPUEXT),$(STATICLIBEXT),$(CLEANPPUFILES))) $(addprefix $(IMPORTLIBPREFIX),$(subst $(PPUEXT),$(STATICLIBEXT),$(CLEANPPUFILES)))
ifdef DEBUGSYMEXT
override CLEANPPULINKFILES+=$(subst $(PPUEXT),$(DEBUGSYMEXT),$(CLEANPPUFILES))
endif
override CLEANPPUFILES:=$(addprefix $(UNITTARGETDIRPREFIX),$(CLEANPPUFILES))
override CLEANPPULINKFILES:=$(wildcard $(addprefix $(UNITTARGETDIRPREFIX),$(CLEANPPULINKFILES)))
endif
fpc_clean: $(CLEANTARGET)
ifdef CLEANEXEFILES
	-$(DEL) $(CLEANEXEFILES)
endif
ifdef CLEANEXEDBGFILES
	-$(DELTREE) $(CLEANEXEDBGFILES)
endif
ifdef CLEANPPUFILES
	-$(DEL) $(CLEANPPUFILES)
endif
ifneq ($(CLEANPPULINKFILES),)
	-$(DEL) $(CLEANPPULINKFILES)
endif
ifdef CLEANRSTFILES
	-$(DEL) $(addprefix $(UNITTARGETDIRPREFIX),$(CLEANRSTFILES))
endif
ifdef CLEAN_FILES
	-$(DEL) $(CLEAN_FILES)
endif
ifdef LIB_NAME
	-$(DEL) $(LIB_NAME) $(LIB_FULLNAME)
endif
	-$(DEL) $(FPCMADE) Package.fpc $(PPAS) script.res link.res $(FPCEXTFILE) $(REDIRFILE)
	-$(DEL) *$(ASMEXT) *_ppas$(BATCHEXT) ppas$(BATCHEXT) ppaslink$(BATCHEXT)
fpc_cleanall: $(CLEANTARGET)
ifdef CLEANEXEFILES
	-$(DEL) $(CLEANEXEFILES)
endif
ifdef COMPILER_UNITTARGETDIR
ifdef CLEANPPUFILES
	-$(DEL) $(CLEANPPUFILES)
endif
ifneq ($(CLEANPPULINKFILES),)
	-$(DEL) $(CLEANPPULINKFILES)
endif
ifdef CLEANRSTFILES
	-$(DEL) $(addprefix $(UNITTARGETDIRPREFIX),$(CLEANRSTFILES))
endif
endif
ifdef CLEAN_FILES
	-$(DEL) $(CLEAN_FILES)
endif
	-$(DELTREE) units
	-$(DELTREE) bin
	-$(DEL) *$(OEXT) *$(PPUEXT) *$(RSTEXT) *$(ASMEXT) *$(STATICLIBEXT) *$(SHAREDLIBEXT) *$(PPLEXT)
ifneq ($(PPUEXT),.ppu)
	-$(DEL) *.o *.ppu *.a
endif
	-$(DELTREE) *$(SMARTEXT)
	-$(DEL) fpcmade.* Package.fpc $(PPAS) script.res link.res $(FPCEXTFILE) $(REDIRFILE)
	-$(DEL) *_ppas$(BATCHEXT) ppas$(BATCHEXT) ppaslink$(BATCHEXT)
ifdef AOUTEXT
	-$(DEL) *$(AOUTEXT)
endif
ifdef DEBUGSYMEXT
	-$(DEL) *$(DEBUGSYMEXT)
endif
ifdef LOCALFPMAKEBIN
	-$(DEL) $(LOCALFPMAKEBIN)
	-$(DEL) $(FPMAKEBINOBJ)
endif
fpc_distclean: cleanall
.PHONY: fpc_baseinfo
override INFORULES+=fpc_baseinfo
fpc_baseinfo:
	@$(ECHO)
	@$(ECHO)  == Package info ==
	@$(ECHO)  Package Name..... $(PACKAGE_NAME)
	@$(ECHO)  Package Version.. $(PACKAGE_VERSION)
	@$(ECHO)
	@$(ECHO)  == Configuration info ==
	@$(ECHO)
	@$(ECHO)  FPC.......... $(FPC)
	@$(ECHO)  FPC Version.. $(FPC_VERSION)
	@$(ECHO)  Source CPU... $(CPU_SOURCE)
	@$(ECHO)  Target CPU... $(CPU_TARGET)
	@$(ECHO)  Source OS.... $(OS_SOURCE)
	@$(ECHO)  Target OS.... $(OS_TARGET)
	@$(ECHO)  Full Source.. $(FULL_SOURCE)
	@$(ECHO)  Full Target.. $(FULL_TARGET)
	@$(ECHO)  SourceSuffix. $(SOURCESUFFIX)
	@$(ECHO)  TargetSuffix. $(TARGETSUFFIX)
	@$(ECHO)  FPC fpmake... $(FPCFPMAKE)
	@$(ECHO)
	@$(ECHO)  == Directory info ==
	@$(ECHO)
	@$(ECHO)  Required pkgs... $(REQUIRE_PACKAGES)
	@$(ECHO)
	@$(ECHO)  Basedir......... $(BASEDIR)
	@$(ECHO)  FPCDir.......... $(FPCDIR)
	@$(ECHO)  CrossBinDir..... $(CROSSBINDIR)
	@$(ECHO)  UnitsDir........ $(UNITSDIR)
	@$(ECHO)  PackagesDir..... $(PACKAGESDIR)
	@$(ECHO)
	@$(ECHO)  GCC library..... $(GCCLIBDIR)
	@$(ECHO)  Other library... $(OTHERLIBDIR)
	@$(ECHO)
	@$(ECHO)  == Tools info ==
	@$(ECHO)
	@$(ECHO)  As........ $(AS)
	@$(ECHO)  Ld........ $(LD)
	@$(ECHO)  Ar........ $(AR)
	@$(ECHO)  Rc........ $(RC)
	@$(ECHO)
	@$(ECHO)  Mv........ $(MVPROG)
	@$(ECHO)  Cp........ $(CPPROG)
	@$(ECHO)  Rm........ $(RMPROG)
	@$(ECHO)  GInstall.. $(GINSTALL)
	@$(ECHO)  Echo...... $(ECHO)
	@$(ECHO)  Shell..... $(SHELL)
	@$(ECHO)  Date...... $(DATE)
	@$(ECHO)  FPCMake... $(FPCMAKE)
	@$(ECHO)  PPUMove... $(PPUMOVE)
	@$(ECHO)  Zip....... $(ZIPPROG)
	@$(ECHO)
	@$(ECHO)  == Object info ==
	@$(ECHO)
	@$(ECHO)  Target Loaders........ $(TARGET_LOADERS)
	@$(ECHO)  Target Units.......... $(TARGET_UNITS)
	@$(ECHO)  Target Implicit Units. $(TARGET_IMPLICITUNITS)
	@$(ECHO)  Target Programs....... $(TARGET_PROGRAMS)
	@$(ECHO)  Target Dirs........... $(TARGET_DIRS)
	@$(ECHO)  Target Examples....... $(TARGET_EXAMPLES)
	@$(ECHO)  Target ExampleDirs.... $(TARGET_EXAMPLEDIRS)
	@$(ECHO)
	@$(ECHO)  Clean Units......... $(CLEAN_UNITS)
	@$(ECHO)  Clean Files......... $(CLEAN_FILES)
	@$(ECHO)
	@$(ECHO)  Install Units....... $(INSTALL_UNITS)
	@$(ECHO)  Install Files....... $(INSTALL_FILES)
	@$(ECHO)
	@$(ECHO)  == Install info ==
	@$(ECHO)
	@$(ECHO)  DateStr.............. $(DATESTR)
	@$(ECHO)  ZipName.............. $(ZIPNAME)
	@$(ECHO)  ZipPrefix............ $(ZIPPREFIX)
	@$(ECHO)  ZipCrossPrefix....... $(ZIPCROSSPREFIX)
	@$(ECHO)  ZipSuffix............ $(ZIPSUFFIX)
	@$(ECHO)  FullZipName.......... $(FULLZIPNAME)
	@$(ECHO)  Install FPC Package.. $(INSTALL_FPCPACKAGE)
	@$(ECHO)
	@$(ECHO)  Install base dir..... $(INSTALL_BASEDIR)
	@$(ECHO)  Install binary dir... $(INSTALL_BINDIR)
	@$(ECHO)  Install library dir.. $(INSTALL_LIBDIR)
	@$(ECHO)  Install units dir.... $(INSTALL_UNITDIR)
	@$(ECHO)  Install source dir... $(INSTALL_SOURCEDIR)
	@$(ECHO)  Install doc dir...... $(INSTALL_DOCDIR)
	@$(ECHO)  Install example dir.. $(INSTALL_EXAMPLEDIR)
	@$(ECHO)  Install data dir..... $(INSTALL_DATADIR)
	@$(ECHO)
	@$(ECHO)  Dist destination dir. $(DIST_DESTDIR)
	@$(ECHO)  Dist zip name........ $(DIST_ZIPNAME)
	@$(ECHO)
.PHONY: fpc_info
fpc_info: $(INFORULES)
.PHONY: fpc_makefile fpc_makefiles fpc_makefile_sub1 fpc_makefile_sub2 \
	fpc_makefile_dirs
fpc_makefile:
	$(FPCMAKE) -w -T$(OS_TARGET) Makefile.fpc
fpc_makefile_sub1:
ifdef TARGET_DIRS
	$(FPCMAKE) -w -T$(OS_TARGET) $(addsuffix /Makefile.fpc,$(TARGET_DIRS))
endif
ifdef TARGET_EXAMPLEDIRS
	$(FPCMAKE) -w -T$(OS_TARGET) $(addsuffix /Makefile.fpc,$(TARGET_EXAMPLEDIRS))
endif
fpc_makefile_sub2: $(addsuffix _makefile_dirs,$(TARGET_DIRS) $(TARGET_EXAMPLEDIRS))
fpc_makefile_dirs: fpc_makefile_sub1 fpc_makefile_sub2
fpc_makefiles: fpc_makefile fpc_makefile_dirs
all:
debug:
smart:
release:
units:
examples:
shared:
install: fpc_install
sourceinstall: fpc_sourceinstall
exampleinstall: fpc_exampleinstall
distinstall: fpc_distinstall
zipinstall: fpc_zipinstall
zipsourceinstall: fpc_zipsourceinstall
zipexampleinstall: fpc_zipexampleinstall
zipdistinstall: fpc_zipdistinstall
clean:
distclean:
cleanall:
info: fpc_info
makefiles: fpc_makefiles
.PHONY: all debug smart release units examples shared install sourceinstall exampleinstall distinstall zipinstall zipsourceinstall zipexampleinstall zipdistinstall clean distclean cleanall info makefiles
ifneq ($(wildcard fpcmake.loc),)
include fpcmake.loc
endif
