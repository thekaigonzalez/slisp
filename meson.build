project('salmon', 'd')

add_global_arguments(['-L-static', '-lreadline'], language : 'd')

libreadline = dependency('readline')

executable(
  'salmon-' + build_machine.system().to_lower() + '-' + build_machine.cpu(),
  [
    './salmon.d',
    './salinterp.d',
    './sal_type.d',
    './sal_shared_api.d',
    './sal_auxlib.d',
    './sal_builtins.d'
  ],
  install: true,
  dependencies: [libreadline]
)

executable('sal-test', 'sal_test.d', install : true)

install_subdir('salmon', install_dir: 'lib')
install_subdir('salmon/libs', install_dir: 'lib/salmon')
