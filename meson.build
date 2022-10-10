project('salmon', 'd')

add_global_arguments(['-L-static'], language : 'd')

libreadline = dependency('readline')

srcs = [
    # './salmon.d',
    './salinterp.d',
    './sal_type.d',
    './sal_shared_api.d',
    './sal_auxlib.d',
    './sal_builtins.d',
    './sal_std.d',
    './mathstd.d',
    './extraops.d',
    './operators.d',
    './sarithmetic.d'
]

slib = shared_library('salmon',
              srcs,
              install : true)

executable('sal-test', 'sal_test.d', install : true)

# ['./salmon.d']
executable('salmon-' + build_machine.system().to_lower() + '-' + build_machine.cpu(),
          './salmon.d',
          link_with : slib,
          dependencies: [libreadline],
          install : true)

install_subdir('salmon', install_dir: 'lib')
install_subdir('salmon/libs', install_dir: 'lib/salmon')

# meson.add_install_script('./copy-success.sh')
