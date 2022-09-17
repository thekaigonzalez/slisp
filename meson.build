project('salmon', 'd')

add_global_arguments('-L-static', language : 'd')

executable(
  'salmon-' + build_machine.system().to_lower() + '-' + build_machine.cpu(),
  [
    './salmon-impl.d',
    './sal_shared_api.d',
    './sal_builtins.d'
  ],
  install: true
)

install_subdir('salmon', install_dir: 'lib')
install_subdir('salmon/libs', install_dir: 'lib/salmon')