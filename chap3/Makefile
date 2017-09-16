# chap3の自動テストのためのMakefile
#
# 使用法:
# $ make
#     演習1.3-1～1.3-4に対するテストを順に実行する。
#     不合格のテストがあればその時点で終了する。
#     各問題について"[ 演習1.3-x: OK ]"というメッセージが表示されればok。
# $ make test-1
#     演習1.3-1に対するテストを実行する (test-2, test-3, test-4も同様)。
# $ make clean
#     テストの際に生成した一時ファイルを削除する。

# 変数
AS = nasm -felf
LD = ld
LDFLAGS = -m elf_i386

TMP_PREFIX = 00tmp-
TESTS = test-1 test-2 test-3 test-4

.PHONY: test $(TESTS) clean

# 型ルール
%.o: %.s
	$(AS) -o $@ $<
%: %.o
	$(LD) $(LDFLAGS) -o $@ $<
%: %.s  # Remove an implicit rule

# ルール
test : $(TESTS)

test-1: fib13
	test `./fib13 ; echo $$?` = 233
	@echo '[ 演習1.3-1: OK ]'
	$(RM) fib13

test-2: isprime $(TMP_PREFIX)isprime0 $(TMP_PREFIX)isprime1
	test `./isprime ; echo $$?` = 0
	test `./$(TMP_PREFIX)isprime0 ; echo $$?` = 1
	test `./$(TMP_PREFIX)isprime1 ; echo $$?` = 0
	@echo '[ 演習1.3-2: OK ]'
	$(RM) isprime $(TMP_PREFIX)isprime0 $(TMP_PREFIX)isprime0.s \
	              $(TMP_PREFIX)isprime1 $(TMP_PREFIX)isprime1.s

test-3: nprime255 $(TMP_PREFIX)nprime0 $(TMP_PREFIX)nprime1
	test `./nprime255 ; echo $$?` = 54
	test `./$(TMP_PREFIX)nprime0 ; echo $$?` = 239
	test `./$(TMP_PREFIX)nprime1 ; echo $$?` = 2
	@echo '[ 演習1.3-3: OK ]'
	$(RM) nprime255 $(TMP_PREFIX)nprime0 $(TMP_PREFIX)nprime0.s \
	                $(TMP_PREFIX)nprime1 $(TMP_PREFIX)nprime1.s

test-4: 10thprime $(TMP_PREFIX)10thprime0 $(TMP_PREFIX)10thprime1
	test `./10thprime ; echo $$?` = 197
	test `./$(TMP_PREFIX)10thprime0 ; echo $$?` = 157
	test `./$(TMP_PREFIX)10thprime1 ; echo $$?` = 3
	@echo '[ 演習1.3-4: OK ]'
	$(RM) 10thprime $(TMP_PREFIX)10thprime0 $(TMP_PREFIX)10thprime0.s \
	                $(TMP_PREFIX)10thprime1 $(TMP_PREFIX)10thprime1.s

$(TMP_PREFIX)isprime0.s: isprime.s
	test `perl -pe 's/;.*//' $< | grep -P '\b12379\b' | wc -l` = 1
	perl -pe 's/\b12379\b/12389/g' $< > $@
$(TMP_PREFIX)isprime1.s: isprime.s
	perl -pe 's/\b12379\b/3/g' $< > $@

$(TMP_PREFIX)nprime0.s: nprime255.s
	test `perl -pe 's/;.*//' $< | grep -P '\b255\b' | wc -l` = 1
	perl -pe 's/\b255\b/1500/g' $< > $@
$(TMP_PREFIX)nprime1.s: nprime255.s
	perl -pe 's/\b255\b/3/g' $< > $@

$(TMP_PREFIX)10thprime0.s: 10thprime.s
	test `perl -pe 's/;.*//' $< | grep -P '\b255\b' | wc -l` = 1
	perl -pe 's/\b255\b/200/g' $< > $@
$(TMP_PREFIX)10thprime1.s: 10thprime.s
	perl -pe 's/\b255\b/31/g' $< > $@

clean:
	$(RM) $(TMP_PREFIX)*
