require:
	@docker --version >/dev/null 2>&1 || (echo "ERROR: docker is required."; exit 1)
	@pip --version >/dev/null 2>&1 || (echo "ERROR: pip is required."; exit 1)

init: require
	@pre-commit --version >/dev/null 2>&1 || (pip install pre-commit)
	@pre-commit install >/dev/null 2>&1
