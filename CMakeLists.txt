cmake_minimum_required(VERSION 3.13)

include(pico_sdk_import.cmake)

project (hw_control C CXX ASM)

pico_sdk_init()

add_executable(hw_control
    hw_control.S
)

pico_enable_stdio_uart(hw_control 0)
pico_enable_stdio_usb(hw_control 1)

pico_add_extra_outputs(hw_control)

target_link_libraries(hw_control pico_stdlib)

