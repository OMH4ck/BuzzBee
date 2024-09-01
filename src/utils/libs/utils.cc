#include "utils.h"

#include <fcntl.h>
#include <pty.h>
#include <sys/select.h>
#include <termios.h>
#include <unistd.h>

#include <csignal>
#include <fstream>
#include <iostream>
#include <thread>

#include "absl/strings/str_format.h"
#include "filesystem_wrapper.h"

namespace utils {

#define READ 0
#define WRITE 1
// Return <0 upon error
pid_t POpen2(const char *command, int *infp, int *outfp) {
  int p_stdin[2], p_stdout[2];
  pid_t pid;

  if (pipe(p_stdin) != 0 || pipe(p_stdout) != 0) return -1;

  pid = fork();

  if (pid < 0)
    return pid;
  else if (pid == 0) {
    close(p_stdin[WRITE]);
    dup2(p_stdin[READ], READ);
    close(p_stdout[READ]);
    dup2(p_stdout[WRITE], WRITE);

    execl("/bin/sh", "sh", "-c", command, NULL);
    perror("execl");
    exit(1);
  }

  if (infp == NULL)
    close(p_stdin[WRITE]);
  else {
    *infp = p_stdin[WRITE];
    fcntl(*infp, F_SETFL, fcntl(*infp, F_GETFL) | O_NONBLOCK);
  }

  if (outfp == NULL)
    close(p_stdout[READ]);
  else {
    *outfp = p_stdout[READ];
    fcntl(*outfp, F_SETFL, fcntl(*outfp, F_GETFL) | O_NONBLOCK);
  }

  return pid;
}

void Kill(pid_t pid) { kill(pid, 9); }

int OpenWithTTY(const char *command) {
  int master;
  pid_t pid = forkpty(&master, NULL, NULL, NULL);  // opentty + login_tty + fork

  if (pid < 0) {
    return 1;  // fork with pseudo terminal failed
  }

  else if (pid == 0) {  // child
    execl("/bin/sh", "sh", "-c", command, NULL);
  }

  else {  // parent
    struct termios tios;
    tcgetattr(master, &tios);
    tios.c_lflag &= ~(ECHO | ECHONL);
    tcsetattr(master, TCSAFLUSH, &tios);
    fcntl(master, F_SETFL, fcntl(master, F_GETFL) | O_NONBLOCK);
  }
  return master;
}

std::string GetPrintableRepr(std::string str) {
  std::string repr;
  for (auto &each : str) {
    if (each >= 30 && each < 127) {
      repr += each;
    } else {
      switch (each) {
        case '\t':
          repr += "\\t";
          break;
        case '\n':
          repr += "\\n";
          break;
        default:
          char tmp[10];
          sprintf(tmp, "\\x%02x", each);
          repr += tmp;
      }
    }
  }
  return repr;
}

std::string SendCommandToOpenedTTYAndGetResponse(int master, const char *cmd,
                                                 const char *until_str,
                                                 bool &failed) {
  std::string result;
  bool command_sent = false;
  bool cmd_response_received = false;

  while (1) {
    fd_set read_fd, write_fd, err_fd;

    FD_ZERO(&read_fd);
    FD_ZERO(&write_fd);
    FD_ZERO(&err_fd);
    FD_SET(master, &read_fd);
    // FD_SET(STDIN_FILENO, &read_fd);

    struct timeval long_timeout = {1, 0};
    struct timeval short_timeout = {0, 1000};

    int ret = 0;
    if (cmd_response_received || !command_sent)
      ret = select(master + 1, &read_fd, &write_fd, &err_fd, &short_timeout);
    else
      ret = select(master + 1, &read_fd, &write_fd, &err_fd, &long_timeout);

    if (command_sent) {
      if (!cmd_response_received) cmd_response_received = true;
    }

    if (ret == 0) {
      if (!command_sent) {
        // current buffer cleared, send our command
        size_t sz = write(master, cmd, strlen(cmd));
        assert(sz == strlen(cmd));

        command_sent = true;
        continue;
      } else {
        if (until_str) {
          if (!strcmp(result.c_str() + result.size() - strlen(until_str),
                      until_str)) {
            return result;
          }
        } else {
          return result;
        }
      }
    }

    if (FD_ISSET(master, &read_fd)) {
      char ch;
      if (read(master, &ch, 1) != -1)  // read from program
      {
        if (command_sent) {
          result += ch;
        }

      } else {
        failed = true;
        return "";
      }
    }
  }
}

const std::string WHITESPACE = " \n\r\t\f\v";

std::string LTrim(const std::string &s) {
  size_t start = s.find_first_not_of(WHITESPACE);
  return (start == std::string::npos) ? "" : s.substr(start);
}

std::string RTrim(const std::string &s) {
  size_t end = s.find_last_not_of(WHITESPACE);
  return (end == std::string::npos) ? "" : s.substr(0, end + 1);
}

std::string Trim(const std::string &s) {
  std::string tmp = s;
  while (true) {
    // recursive trim
    std::string after_trim = RTrim(LTrim(tmp));
    if (after_trim == tmp) {
      break;
    } else {
      tmp = after_trim;
    }
  }
  return tmp;
}

std::streampos FileSize(const char *filename) {
  std::streampos fsize = 0;
  std::ifstream file(filename, std::ios::binary);

  fsize = file.tellg();
  file.seekg(0, std::ios::end);
  fsize = file.tellg() - fsize;
  file.close();

  return fsize;
}
uint32_t GetRandomNumber(uint32_t start_inclusive, uint32_t end_inclusive) {
  static std::random_device rd;
  static std::mt19937 gen(rd());
  std::uniform_int_distribution<int> uid(start_inclusive, end_inclusive);
  return uid(gen);
}

std::string ExecCmdAndGetOutput(const char *cmd) {
  char tmp_random[] = "/tmp/obftmp.XXXXXX";
  mkstemp(tmp_random);
  unlink(tmp_random);

  std::string fmt_cmd =
      absl::StrFormat("timeout 1 %s > %s 2>/dev/null", cmd, tmp_random);

  system(fmt_cmd.c_str());

  std::ifstream ifs;

  // wait for 1500ms
  for (int i = 0; i < 3; ++i) {
    ifs.open(tmp_random);
    if (ifs.is_open()) break;
    std::this_thread::sleep_for(std::chrono::milliseconds(500));
  }
  if (!ifs.is_open()) return "";

  std::stringstream result_ss;
  result_ss << ifs.rdbuf();
  ifs.close();

  unlink(tmp_random);
  return result_ss.str();
}

std::string ReadUntil(int fd, std::string until_str, int timeout,
                      bool *reached_until_str) {
  std::string result;
  uint8_t tmp_buf;
  for (int time = 0; time < timeout;) {
    size_t bytes_read = read(fd, &tmp_buf, 1);
    if (bytes_read == 1) {
      std::cout << (char)tmp_buf;
      result += (char)tmp_buf;
      if (result.size() >= until_str.size() &&
          result.substr(result.size() - until_str.size(), until_str.size()) ==
              until_str) {
        *reached_until_str = true;
        return result;
      }
    } else {
      std::this_thread::sleep_for(std::chrono::milliseconds(100));
      time += 100;
    }
  }
  *reached_until_str = false;
  return result;
}

};  // namespace utils
