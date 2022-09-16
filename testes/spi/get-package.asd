(require "spi")

(spi:ensurestd)

(spi:get "https://github.com/thekaigonzalez/testLib")

(require "testlib1")

(test_func_from_lib)