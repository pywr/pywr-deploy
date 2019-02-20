set PYWR_SOLVER=glpk
py.test -v %SRC_DIR%\tests
if errorlevel 1 exit 1

set PYWR_SOLVER=glpk-edge
py.test -v %SRC_DIR%\tests
if errorlevel 1 exit 1

set PYWR_SOLVER=lpsolve
py.test -v %SRC_DIR%\tests
if errorlevel 1 exit 1
