@echo off
setlocal EnableExtensions

if not {%CODETITANS_SETUP%} == {} goto ALREADY_SETUP
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86
set CodeTitans_Setup=VS10_x86
:ALREADY_SETUP

set WorkingDir=%CD%
echo Working directory: %WorkingDir%

echo Preparing environment...

rem Remove old compilation temporary files...
set TempFolder=%CD%\temp_bin
set PackageFolder=%CD%\packages

rd /S /Q %PackageFolder% 2> NUL:
rd /S /Q %TempFolder% 2> NUL:
del /S *.nupkg > NUL: 2> NUL:

mkdir %PackageFolder%

set builder=msbuild /nologo /noconlog /maxcpucount /p:Configuration=Release;DebugSymbols=false;DebugType=None /t:Rebuild
set nuget=nuget

echo Preparing source-code distributions...

rem #######################################################################################
rem # JSON-SRC
rem #
echo JSon@CodeTitans as source-code
set PackageSourcesDestPath=%TempFolder%\JSon-src\content\CodeTitans\JSon
if exist "%PackageSourcesDestPath%" (
  rd /Q "%PackageSourcesDestPath%" /S > NUL:
)
mkdir "%PackageSourcesDestPath%/Diagnostics"
mkdir "%PackageSourcesDestPath%/Objects/Mutable"
mkdir "%PackageSourcesDestPath%/ReaderHelpers/Factories"
mkdir "%PackageSourcesDestPath%/WriterHelpers"
echo Copying sources to: %PackageSourcesDestPath%

copy codetitans-json-src.nuspec %TempFolder% > NUL:

cd "%WorkingDir%/../JSon@CodeTitans"
copy "*.cs" /b "%PackageSourcesDestPath%\" > NUL:
rm "%PackageSourcesDestPath%\BSonReader.cs" > NUL:
rm "%PackageSourcesDestPath%\BSonWriter.cs" > NUL:
cd Objects
copy "*.cs" /b "%PackageSourcesDestPath%\Objects\" > NUL:
cd Mutable
copy "*.cs" /b "%PackageSourcesDestPath%\Objects\Mutable\" > NUL:
cd ../../ReaderHelpers
copy "*.cs" /b "%PackageSourcesDestPath%\ReaderHelpers\" > NUL:
cd Factories
copy "*.cs" /b "%PackageSourcesDestPath%\ReaderHelpers\Factories\" > NUL:
cd ../../WriterHelpers
copy "*.cs" /b "%PackageSourcesDestPath%\WriterHelpers\" > NUL:
cd "%WorkingDir%/../Core@CodeTitans"
copy "IStringReader.cs" /b "%PackageSourcesDestPath%\" > NUL:
copy "NumericHelper.cs" /b "%PackageSourcesDestPath%\" > NUL:
copy "ReflectionHelper.cs" /b "%PackageSourcesDestPath%\" > NUL:
copy "SerializationHelper.cs" /b "%PackageSourcesDestPath%\" > NUL:
copy "StringHelper.cs" /b "%PackageSourcesDestPath%\" > NUL:
cd Diagnostics
copy "DebugEntry.cs" /b "%PackageSourcesDestPath%\Diagnostics\" > NUL:
copy "DebugLog.cs" /b "%PackageSourcesDestPath%\Diagnostics\" > NUL:
copy "IDebugTraceListener.cs" /b "%PackageSourcesDestPath%\Diagnostics\" > NUL:
copy "StandardDebugListener.cs" /b "%PackageSourcesDestPath%\Diagnostics\" > NUL:
cd %WorkingDir%

pushd %PackageFolder%
%nuget% pack %TempFolder%\codetitans-json-src.nuspec -BasePath "%TempFolder%\JSon-src"
popd

rem #######################################################################################
rem # IoC-SRC
rem #
echo IoC@CodeTitans as source-code
set PackageSourcesDestPath=%TempFolder%\IoC-src\content\CodeTitans\Services
if exist "%PackageSourcesDestPath%" (
  rd /Q "%PackageSourcesDestPath%" /S > NUL:
)
mkdir "%PackageSourcesDestPath%/Internals"
echo Copying sources to: %PackageSourcesDestPath%

copy codetitans-ioc-src.nuspec %TempFolder% > NUL:
cd "%WorkingDir%/../IoC@CodeTitans"
copy "*.cs" /b "%PackageSourcesDestPath%\" > NUL:
cd Internals
copy "*.cs" /b "%PackageSourcesDestPath%\Internals\" > NUL:
cd %WorkingDir%

pushd %PackageFolder%
%nuget% pack %TempFolder%\codetitans-ioc-src.nuspec -BasePath "%TempFolder%\IoC-src"
popd

echo Building libraries...

rem #######################################################################################
rem # JSON
rem #
echo JSon@CodeTitans for all platforms
set OutputPath=%TempFolder%\JSON@CodeTitans\lib
%builder% ../JSON@CodeTitans/CodeTitans.Silverlight.JSon.VS2010.csproj /p:TargetFrameworkVersion=v3.0 /property:OutDir=%OutputPath%\sl30
%builder% ../JSON@CodeTitans/CodeTitans.Silverlight.JSon.VS2010.csproj /p:TargetFrameworkVersion=v4.0 /property:OutDir=%OutputPath%\sl40
%builder% ../JSON@CodeTitans/CodeTitans.Silverlight.JSon.VS2010.csproj /p:TargetFrameworkVersion=v5.0 /property:OutDir=%OutputPath%\sl50

%builder% ../JSON@CodeTitans/CodeTitans.JSon.VS2010.csproj /p:TargetFrameworkVersion=v2.0 /property:OutDir=%OutputPath%\net20
%builder% ../JSON@CodeTitans/CodeTitans.JSon.VS2010.csproj /p:TargetFrameworkVersion=v3.0 /property:OutDir=%OutputPath%\net30
%builder% ../JSON@CodeTitans/CodeTitans.JSon.VS2010.csproj /p:TargetFrameworkVersion=v3.5 /property:OutDir=%OutputPath%\net35
%builder% ../JSON@CodeTitans/CodeTitans.JSon.VS2010.csproj /p:TargetFrameworkVersion=v4.0 /property:OutDir=%OutputPath%\net40
%builder% ../JSON@CodeTitans/CodeTitans.JSon.VS2010.csproj /p:TargetFrameworkVersion=v4.5 /property:OutDir=%OutputPath%\net45

%builder% ../JSON@CodeTitans/CodeTitans.Phone.JSon.csproj /property:OutDir=%OutputPath%\wp7
%builder% ../JSON@CodeTitans/CodeTitans.Phone.JSon.csproj /p:TargetFrameworkProfile=WindowsPhone71 /property:OutDir=%OutputPath%\wp71
%builder% ../JSON@CodeTitans/CodeTitans.Phone.JSon.VS2012.csproj /property:OutDir=%OutputPath%\wp8

%builder% ../JSON@CodeTitans/CodeTitans.WinStore.JSon.VS2012.csproj /property:OutputPath=%OutputPath%\windows8\

copy codetitans-json.nuspec %OutputPath%\.. > NUL:
pushd %PackageFolder%
%nuget% pack %OutputPath%\..\codetitans-json.nuspec
popd

:skip_json

rem #######################################################################################
rem # Bayeux
rem #
echo Bayeux@CodeTitans for all platforms
set OutputPath=%TempFolder%\Bayeux@CodeTitans\lib

%builder% ../Bayeux@CodeTitans/CodeTitans.Silverlight.Bayeux.VS2010.csproj /p:TargetFrameworkVersion=v3.0;AdditionalDefines=SILVERLIGHT_3_COMPATIBLE /property:OutDir=%OutputPath%\sl30
%builder% ../Bayeux@CodeTitans/CodeTitans.Silverlight.Bayeux.VS2010.csproj /p:TargetFrameworkVersion=v4.0 /property:OutDir=%OutputPath%\sl40
%builder% ../Bayeux@CodeTitans/CodeTitans.Silverlight.Bayeux.VS2010.csproj /p:TargetFrameworkVersion=v5.0 /property:OutDir=%OutputPath%\sl50

%builder% ../Bayeux@CodeTitans/CodeTitans.Bayeux.VS2010.csproj /p:TargetFrameworkVersion=v2.0;AdditionalDefines=NET_2_COMPATIBLE /property:OutDir=%OutputPath%\net20
%builder% ../Bayeux@CodeTitans/CodeTitans.Bayeux.VS2010.csproj /p:TargetFrameworkVersion=v3.0;AdditionalDefines=NET_2_COMPATIBLE /property:OutDir=%OutputPath%\net30
%builder% ../Bayeux@CodeTitans/CodeTitans.Bayeux.VS2010.csproj /p:TargetFrameworkVersion=v3.5;AdditionalDefines=NET_2_COMPATIBLE /property:OutDir=%OutputPath%\net35
%builder% ../Bayeux@CodeTitans/CodeTitans.Bayeux.VS2010.csproj /p:TargetFrameworkVersion=v4.0 /property:OutDir=%OutputPath%\net40
%builder% ../Bayeux@CodeTitans/CodeTitans.Bayeux.VS2010.csproj /p:TargetFrameworkVersion=v4.5 /property:OutDir=%OutputPath%\net45

%builder% ../Bayeux@CodeTitans/CodeTitans.Phone.Bayeux.csproj /property:OutDir=%OutputPath%\wp7
%builder% ../Bayeux@CodeTitans/CodeTitans.Phone.Bayeux.csproj /p:TargetFrameworkProfile=WindowsPhone71 /property:OutDir=%OutputPath%\wp71
%builder% ../Bayeux@CodeTitans/CodeTitans.Phone.Bayeux.VS2012.csproj /property:OutDir=%OutputPath%\wp8

%builder% ../Bayeux@CodeTitans/CodeTitans.WinStore.Bayeux.VS2012.csproj /property:OutputPath=%OutputPath%\windows8\

echo Removing JSON@CodeTitans, as it shouldn't be distributed together
del /S /Q %OutputPath%\*JSon.* > NUL:

copy codetitans-bayeux.nuspec %OutputPath%\.. > NUL:
pushd %PackageFolder%
%nuget% pack %OutputPath%\..\codetitans-bayeux.nuspec
popd

:skip_bayeux

rem #######################################################################################
rem # Core
rem #
echo Core@CodeTitans for all platforms
set OutputPath=%TempFolder%\Core@CodeTitans\lib

%builder% ../Core@CodeTitans/CodeTitans.Silverlight.Core.VS2010.csproj /p:TargetFrameworkVersion=v3.0;AdditionalDefines=SILVERLIGHT_3_COMPATIBLE /property:OutDir=%OutputPath%\sl30
%builder% ../Core@CodeTitans/CodeTitans.Silverlight.Core.VS2010.csproj /p:TargetFrameworkVersion=v4.0 /property:OutDir=%OutputPath%\sl40
%builder% ../Core@CodeTitans/CodeTitans.Silverlight.Core.VS2010.csproj /p:TargetFrameworkVersion=v5.0 /property:OutDir=%OutputPath%\sl50

%builder% ../Core@CodeTitans/CodeTitans.Core.VS2010.csproj /p:TargetFrameworkVersion=v2.0;AdditionalDefines=NET_2_COMPATIBLE /property:OutDir=%OutputPath%\net20
%builder% ../Core@CodeTitans/CodeTitans.Core.VS2010.csproj /p:TargetFrameworkVersion=v3.0;AdditionalDefines=NET_2_COMPATIBLE /property:OutDir=%OutputPath%\net30
%builder% ../Core@CodeTitans/CodeTitans.Core.VS2010.csproj /p:TargetFrameworkVersion=v3.5;AdditionalDefines=NET_2_COMPATIBLE /property:OutDir=%OutputPath%\net35
%builder% ../Core@CodeTitans/CodeTitans.Core.VS2010.csproj /p:TargetFrameworkVersion=v4.0 /property:OutDir=%OutputPath%\net40
%builder% ../Core@CodeTitans/CodeTitans.Core.VS2010.csproj /p:TargetFrameworkVersion=v4.5 /property:OutDir=%OutputPath%\net45

%builder% ../Core@CodeTitans/CodeTitans.Phone.Core.csproj /property:OutDir=%OutputPath%\wp7
%builder% ../Core@CodeTitans/CodeTitans.Phone.Core.csproj /p:TargetFrameworkProfile=WindowsPhone71 /property:OutDir=%OutputPath%\wp71
%builder% ../Core@CodeTitans/CodeTitans.Phone.Core.VS2012.csproj /property:OutDir=%OutputPath%\wp8

%builder% ../Core@CodeTitans/CodeTitans.WinStore.Core.VS2012.csproj /property:OutputPath=%OutputPath%\windows8\

copy codetitans-core.nuspec %OutputPath%\.. > NUL:
pushd %PackageFolder%
%nuget% pack %OutputPath%\..\codetitans-core.nuspec
popd

:skip_core

rem #######################################################################################
rem # IoC
rem #
echo IoC@CodeTitans for all platforms
set OutputPath=%TempFolder%\IoC@CodeTitans\lib

%builder% ../IoC@CodeTitans/CodeTitans.Silverlight.IoC.VS2010.csproj /p:TargetFrameworkVersion=v3.0 /property:OutDir=%OutputPath%\sl30
%builder% ../IoC@CodeTitans/CodeTitans.Silverlight.IoC.VS2010.csproj /p:TargetFrameworkVersion=v4.0 /property:OutDir=%OutputPath%\sl40
%builder% ../IoC@CodeTitans/CodeTitans.Silverlight.IoC.VS2010.csproj /p:TargetFrameworkVersion=v5.0 /property:OutDir=%OutputPath%\sl50

%builder% ../IoC@CodeTitans/CodeTitans.IoC.VS2010.csproj /p:TargetFrameworkVersion=v2.0 /property:OutDir=%OutputPath%\net20
%builder% ../IoC@CodeTitans/CodeTitans.IoC.VS2010.csproj /p:TargetFrameworkVersion=v3.0 /property:OutDir=%OutputPath%\net30
%builder% ../IoC@CodeTitans/CodeTitans.IoC.VS2010.csproj /p:TargetFrameworkVersion=v3.5 /property:OutDir=%OutputPath%\net35
%builder% ../IoC@CodeTitans/CodeTitans.IoC.VS2010.csproj /p:TargetFrameworkVersion=v4.0 /property:OutDir=%OutputPath%\net40
%builder% ../IoC@CodeTitans/CodeTitans.IoC.VS2010.csproj /p:TargetFrameworkVersion=v4.5 /property:OutDir=%OutputPath%\net45

%builder% ../IoC@CodeTitans/CodeTitans.Phone.IoC.csproj /property:OutDir=%OutputPath%\wp7
%builder% ../IoC@CodeTitans/CodeTitans.Phone.IoC.csproj /p:TargetFrameworkProfile=WindowsPhone71 /property:OutDir=%OutputPath%\wp71
%builder% ../IoC@CodeTitans/CodeTitans.Phone.IoC.VS2012.csproj /property:OutDir=%OutputPath%\wp8

%builder% ../IoC@CodeTitans/CodeTitans.WinStore.IoC.VS2012.csproj /property:OutputPath=%OutputPath%\windows8\

copy codetitans-ioc.nuspec %OutputPath%\.. > NUL:
pushd %PackageFolder%
%nuget% pack %OutputPath%\..\codetitans-ioc.nuspec
popd

:skip_ioc

:EOF

echo Removing temporary files
rd /S /Q %TempFolder%

echo ########
echo # DONE #
echo ########
echo.
echo Release prepared, find packages at '%PackageFolder%'
endlocal
