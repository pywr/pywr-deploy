py.test %SRC_DIR%\tests --solver=glpk
if errorlevel 1 exit 1

py.test %SRC_DIR%\tests --solver=lpsolve
if errorlevel 1 exit 1
