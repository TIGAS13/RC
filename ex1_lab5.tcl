# -----------------------------------------------------------------------------
# Exemplo de script TCL para NS-2
# Parametrizado por largura de banda, atraso e tempo de simulação
# -----------------------------------------------------------------------------

if {$argc != 3} {
    puts "Uso: ns exemploCenarios.tcl <bandwidth> <delay> <simTime>"
    puts "Ex.: ns exemploCenarios.tcl 1Gb 10ms 1.0"
    exit 1
}

# Ler parâmetros da linha de comando
set bandwidth [lindex $argv 0]
set delay     [lindex $argv 1]
set simTime   [lindex $argv 2]

# Criação do objeto Simulator
set ns [new Simulator]

# Arquivo para saída NAM (visualização)
set nf [open out.nam w]
$ns namtrace-all $nf

# Procedimento finish
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exit 0
}

# Cores para o NAM
$ns color 1 Red
$ns color 2 Blue

# Definição dos nós
set n0 [$ns node]
set n1 [$ns node]

# Criação do link duplex
#   <origem> <destino> <largura-de-banda> <atraso> <tipo-de-fila>
$ns duplex-link $n0 $n1 $bandwidth $delay DropTail
$ns duplex-link-op $n0 $n1 orient right-left

# Criar agente TCP em n0 e um TCPSink em n1
set tcpAgent [$ns create-connection TCP $n0 TCPSink $n1 0]
$tcpAgent set packetSize_ 1000  ;# Tamanho de pacotes (exemplo)
set tcpApp [new Application/FTP]
$tcpApp attach-agent $tcpAgent

# Início da transmissão
$ns at 0.0 "$tcpApp start"

# Término da simulação
$ns at $simTime "finish"

# Execução
$ns run



