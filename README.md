# Projeto Elevador PI2

Projeto Integrador 2 - Engenharia da Computação (IESB)

## Descrição

Sistema de controle de elevador de 4 andares implementado em VHDL utilizando a FPGA Nexys A7-100T.

O projeto possui:

- Memória de pedidos dos andares
- Controle de movimentação do elevador
- Controle de abertura e fechamento da porta
- Acionamento de motor de passo
- Controle de servo motor da porta
- Sensores de posição para os 4 andares

## Estrutura do Projeto

### Módulos principais

- top_elevador.vhd
- controle_elevador.vhd
- memoria_pedidos.vhd
- door_controller.vhd
- motor_controller.vhd
- pwm_servo.vhd

### Testbenches

- tb_top_elevador.vhd
- tb_controle_elevador.vhd
- tb_memoria_pedidos.vhd
- tb_door_controller.vhd
- tb_motor_controller.vhd
- tb_pwm_servo.vhd

## Plataforma

- FPGA Digilent Nexys A7-100T
- Vivado 2017.2

## Autores

- João Victor Bueno 
- Miguel Kohmann
- Sthefany Alves
