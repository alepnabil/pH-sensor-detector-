# pH Sensor detector for water quality 

This group project is a simulation of pH detector to check water quality by integrating Intel Galileo Gen 1 board 8086, comparator digital circuit, and comparator simulation.
In this proposed project, the pH of the water is observed by manipulating the outputs. The outputs are light-emitting diodes (LEDs). Three LEDs are used to indicate acidic(red LEDs), neutral(green LEDs) and basic/alkali(blue LEDs). This project can help people to determine pH of a water whether to drink or to be used. To make an example, horticulturists can use this technology to choose good water for their plants.Each value of voltage drop indicates a different pH value. Then one of the three LEDs will light up according to the input we have set. 


# Board
![intel board](https://github.com/alepnabil/Sematstik/assets/65908522/ed158ad1-fc93-42ca-a536-1949dd4fb9c2)



# State digram
![FSM](https://github.com/alepnabil/Sematstik/assets/65908522/0750608e-cedb-41d0-b215-ca291213bd66)


# Truth table
![Truth table](https://github.com/alepnabil/Sematstik/assets/65908522/34c08556-0ea8-4d11-8ef0-f1d9420ebec3)



# Circuit simulation

![Digital circuit simulation 1](https://github.com/alepnabil/Sematstik/assets/65908522/dcece48d-35c4-48bb-ba17-3851ebf226d0)

![Digital circuit simulation 2](https://github.com/alepnabil/Sematstik/assets/65908522/680cec9c-4aec-493e-8701-88bd4cd7bb3b)

![Digital circuit simulation 3](https://github.com/alepnabil/Sematstik/assets/65908522/6fb61f1f-a7a5-4518-b472-f6ff451f38a6)


# Circuit 
![Hardware](https://github.com/alepnabil/Sematstik/assets/65908522/6e30b7dc-cd1d-4dd4-9df0-25915bd5abbc)

# Circuit demo
![demo](https://github.com/alepnabil/Sematstik/assets/65908522/19dec566-5d69-4f32-a4de-5e6d681633cc)


# Output

![Output](https://github.com/alepnabil/Sematstik/assets/65908522/e134f440-7183-4876-9858-9fb30efcb9e1)



# Compiling automation

> Automate compiling assembly files. Put this command in a file in the same directory.

```bash
    nasm -f win32 led.asm -l led.lst

    ld --disable-reloc-section -m i386pe -o led.pe -T link.x led.obj

    objcopy -O elf32-i386 led.pe led.elf

    openocd -f /ucrt64/share/openocd/scripts/interface/ftdi/olimex-arm-usb-ocd-h.cfg -f /ucrt64/share/openocd/scripts/board/quark_x10xx_board.cfg

    --gdb--

    target remote localhost:3333

    monitor halt

    file led2.elf
    load
    #to monitor specific register
    monitor reg eip 0xe3ac0f0

```
    

# Contributors
- 212973@pelajar.upm.edu.my
- 210167@pelajar.upm.edu.my
- 210277@pelajar.upm.edu.my
