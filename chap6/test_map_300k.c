#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_KEY_LEN  30
#define MAX_N_ENTRY  300000

extern void c_map_init();
extern void c_map_add(const char *key, int val);
extern int *c_map_get(const char *key);

#define rand_nextInt(range)  ((int)(rand() / (RAND_MAX + 1.0) * (range)))

const char *newKey() {
  int offset = 10;
  int nshuffle, ntruncate, i;
  char *key = malloc(MAX_KEY_LEN + 1);
  strcpy(key, "Abcdefghijklmnopqrstuvwxyzabcd");
  nshuffle  = 1 + rand_nextInt(4);
  for (i = 0; i < nshuffle; i++) {
    int pos = offset + rand_nextInt(MAX_KEY_LEN - offset);
    char c = 'a' + rand_nextInt(26);
    key[pos] = c;
  }
  ntruncate = rand_nextInt(3) * 3;
  key[MAX_KEY_LEN - ntruncate] = '\0';
  return key;
}

int main()
{
  int c, val;
  const char *key;
  int *vp;

  srand(123457);

  c_map_init();

  for (c = 0; c < MAX_N_ENTRY; c++) {
    key = newKey();
    val = rand_nextInt(0x10000);
    c_map_add(key, val);

    key = newKey();
    vp = c_map_get(key);
    if (vp == 0) {
      printf("not_found\n");
    } else {
      printf("%d\n", *vp);
    }
  }

  return 0;
}
