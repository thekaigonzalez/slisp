project('salmon', 'd')

add_global_arguments(['-L-static'], language : 'd')

libreadline = dependency('readline')

srcs = [
    # './salmon.d',
    './salinterp.d',
    './sal_type.d',
    './sal_shared_api.d',
    './sal_auxlib.d',
    './sal_builtins.d'
]

executable(
  'salmon-' + build_machine.system().to_lower() + '-' + build_machine.cpu(),
  srcs + ['./salmon.d'],
  install: true,
  dependencies: [libreadline]
)

shared_library('salmon',
              srcs,
              install : true)

executable('sal-test', 'sal_test.d', install : true)

install_subdir('salmon', install_dir: 'lib')
install_subdir('salmon/libs', install_dir: 'lib/salmon')
