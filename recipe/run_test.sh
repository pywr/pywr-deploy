PYWR_SOLVER=glpk pytest -v ${SRC_DIR}/tests
PYWR_SOLVER=glpk-edge pytest -v ${SRC_DIR}/tests
PYWR_SOLVER=lpsolve pytest -v ${SRC_DIR}/tests
