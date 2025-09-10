#!/bin/bash
# Проверка возможности вызвать userfaultfd из текущего пользователя

cat > check-userfaultfd.c <<'EOF'
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <errno.h>

#ifndef SYS_userfaultfd
  #if defined(__x86_64__)
    #define SYS_userfaultfd 323
  #elif defined(__i386__)
    #define SYS_userfaultfd 374
  #elif defined(__aarch64__)
    #define SYS_userfaultfd 282
  #else
    #error "Неизвестная архитектура — добавьте номер userfaultfd syscal для своей платформы"
  #endif
#endif

int main() {
    long fd = syscall(SYS_userfaultfd, 0);
    if (fd == -1) {
        perror("userfaultfd вызов не удался");
        return errno;
    }
    printf("userfaultfd системный вызов ДОСТУПЕН, fd=%ld\n", fd);
    close(fd);
    return 0;
}
EOF

gcc check-userfaultfd.c -o check-userfaultfd 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Ошибка: не удалось скомпилировать тестовую программу (нужен gcc)."
    exit 1
fi

./check-userfaultfd
rc=$?
rm -f check-userfaultfd.c check-userfaultfd
exit $rc

