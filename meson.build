project('salmon', 'd')

executable(
  'salmon-' + build_machine.system().to_lower() + '-' + build_machine.cpu(),
  [
    './salmon-impl.d',
    './sal_shared_api.d',
    './sal_builtins.d'
  ],
  install: true
)