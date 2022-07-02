@import Darwin;
extern char** environ;

#define POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE 1
int posix_spawnattr_set_persona_np(const posix_spawnattr_t* __restrict, uid_t, uint32_t);
int posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t* __restrict, uid_t);
int posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t* __restrict, uid_t);

int main(int argc, char** argv) {
  if (argc < 2) {
    fprintf(stderr, "usage: spawn_root <command> <to> <run>\n");
    return 1;
  }
  posix_spawnattr_t attr;
  posix_spawnattr_init(&attr);
  posix_spawnattr_set_persona_np(&attr, /*persona_id=*/99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
  posix_spawnattr_set_persona_uid_np(&attr, 0);
  posix_spawnattr_set_persona_gid_np(&attr, 0);

  int pid = 0;
  int ret = posix_spawnp(&pid, argv[1], NULL, &attr, &argv[1], environ);
  if (ret) {
    fprintf(stderr, "failed to exec %s: %s\n", argv[1], strerror(errno));
    return 1;
  }
  waitpid(pid, nil, 0);
  return 0;
}
