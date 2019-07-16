#!/usr/bin/env python3

from vunit import VUnit

# Create VUnit instance by parsing command line arguments
prj = VUnit.from_argv()

pwm_lib = prj.add_library('pwm_lib')
pwm_lib.add_source_files('./src/pwm.vhdl')

lib = prj.add_library('lib')
lib.add_source_files('./test/tb_pwm.vhdl')

# Run VUnit
prj.main()
