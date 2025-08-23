KCONF := /boot/config-$(shell uname -r)
SYSCTL := vm.unprivileged_userfaultfd

.PHONY: check
check:
	@echo "Проверка настроек ядра и sysctl:"
	@if [ -r "$(KCONF)" ]; then \
		if grep -q '^CONFIG_SECCOMP=y' "$(KCONF)"; then \
			echo "\033[32mCONFIG_SECCOMP включен (seccomp работает, как и в CI)\033[0m"; \
		else \
			echo "\033[33mПредупреждение:\033[0m"; \
			echo "CONFIG_SECCOMP выключен! Seccomp не будет работать, тесты могут отличаться от CI."; \
		fi; \
	else \
		echo "\033[33mПредупреждение:\033[0m"; \
		echo "\033[33mНе удалось прочитать $(KCONF), проверка CONFIG_SECCOMP пропущена.\033[0m"; \
	fi
		
	@val=$$(sysctl -n $(SYSCTL) 2>/dev/null || echo "нет"); \
	if [ "$$val" = "1" ]; then \
		echo "\033[32m$(SYSCTL)=1 — непривилегированные процессы могут вызывать userfaultfd \
(тесты будут работать и от не-root).\033[0m"; \
	elif [ "$$val" = "0" ]; then \
		echo "\033[31mПредупреждение:\033[0m"; \
		echo "\033[31m$(SYSCTL)=0 — непривилегированные процессы НЕ могут вызывать \
userfaultfd (тесты могут падать).\033[0m"; \
	else \
		echo "\033[31mПредупреждение:\033[0m"; \
		echo "\033[31mСистемный вызов $(SYSCTL) не найден! Процессы НЕ могут вызывать \
userfaultfd (тесты могут падать).\033[0m"; \
	fi

.PHONY: enable-dev
enable-dev:
	@echo "Включаем $(SYSCTL)=1 (требуются права sudo)..."
	@sudo sysctl -w $(SYSCTL)=1
	@echo ""
	@$(MAKE) check

.PHONY: disable-dev
disable-dev:
	@echo "Отключаем $(SYSCTL)=0 (требуются права sudo)..."
	@sudo sysctl -w $(SYSCTL)=0
	@echo ""
	@$(MAKE) check

