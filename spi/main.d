module spi.main;

import std.stdio;
import std.getopt;
import std.net.curl;
import salinterp;
import sal_auxlib;
import sal_shared_api;
import std.process;

void runProject(string d) {
  chdir(d);
  SalmonEnvironment pkgEnv = new SalmonEnvironment();
  // string PKG_DISPNAME = "";

  quickRun(readText("package.spi"), pkgEnv, false);

  string pkgName = pkgEnv.env_vars["package"].getValue();

  writeln("Package name: \033[1m" ~ pkgName ~ "\033[0m");

  auto pkgList = pkgEnv.env_vars["sources"];
  foreach (SalmonValue file; pkgList.list_members()) {
    quickRun(readText(file.getValue()), new SalmonEnvironment(), false);
  }
}

int main(string[] args) {
  GetoptResult opt;
  bool nomod = false;
  string path = "libs";
  opt = getopt(args,
    "no-modify", "Don't modify the PATH", &nomod,
    "save", "The directory to save the files to (default " ~ path ~ ")", &path);

  if (args.length == 1) {
    writeln("\033[31;1myou need to specify an action.\033[0m");
    return 0;
  }

  if (args[1] == "install") {
    writeln("Downloading SPI `" ~ args[2] ~ "`");

    import std.path;
    import std.file;

    mkdirRecurse(path);

    auto spi_download = executeShell(
      "git clone https://github.com/" ~ args[2] ~ " libs/" ~ baseName(args[2]));

    if (spi_download.status != 0) {
      writeln("Error cloning repository: `" ~ args[2] ~ "`");
      writeln("Output:");
      writeln(spi_download.output);
      return spi_download.status;
    }
    else {
      writeln("\033[33;1mcloned!\033[0m");
      runProject("libs/" ~ baseName(args[2]));
    }
  }
  return 0;
}
