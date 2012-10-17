#---------------------------------------
#   Define a PHYsical layer parameters
#---------------------------------------
set val(chan)   Channel/WirelessChannel
set val(prop)   Propagation/TwoRayGround
set val(netif)  Phy/WirelessPhy
set val(mac)    Mac/802_11
set val(ifq)    CMUPriQueue
set val(ll)     LL
set val(ant)    Antenna/OmniAntenna
#----------------------------------------
# Scenario parameters
#----------------------------------------
set val(x)      500
set val(y)      300
set val(ifqlen) 64
set val(seed)   0.0
set val(routingProt)     DSR
set val(nn)             51
set val(tr)     output80211_500max20d_p0.tr;# trace file
set val(nam)    output80211_500max20d_p0.nam;# nam trace file
set val(move)   trafCBR_rate4.traff   ;# movement scenario
set val(cp)     scen_500max20_p0.scen;# connection traffic
set val(starttime) 5;
set val(stop)     900.0   ;#simulation duration
set val(energymod)  EnergyModel
set val(initialenergy)  30;    #value in [J]
#-----------------------------------------------
# Define antenna at node centre 
#-----------------------------------------------
#Antenna/OmniAntenna set X_ 0
#Antenna/OmniAntenna set Y_ 0
#Antenna/OmniAntenna set Z_ 0.7
Antenna/OmniAntenna set Gt_ 1.0
Antenna/OmniAntenna set Gr_ 1.0
#------------------------------------------------
# For 'TwoRayGround'
#------------------------------------------------
#Phy/WirelessPhy set CSThresh_ 1.559e−14; #carrier sensing threshold
Phy/WirelessPhy set RXThresh_ 3.652e-13; #receiver threshold
Phy/WirelessPhy set CPThresh_ 10;        #capture threshold
Phy/WirelessPhy set freq_ 9.15e+08;        #Operating Freq
Phy/WirelessPhy set L_ 1.0;              #System loss factor
Phy/WirelessPhy set Pt_ 0.001;           #transmitter power

#-----------------------------------------
#Set up simulator objects
#-----------------------------------------
#
# check for random seed
#
if {$val(seed) > 0} {
    puts "Seeding Random number generator with $opt(seed)\n"
    ns-random $val(seed)
}

#create simulator instance
set ns_  [new Simulator]
$ns_ color 1 Blue
$ns_ color 2 Red

#setup topography object
set topo    [new Topography]
$topo load_flatgrid $val(x) $val(y)

#create trace object NS and NAM
set tracefd [open ./$val(tr) w]
$ns_ trace-all $tracefd
# Statement indicating to simulator about NAM.
set namtrace [open ./$val(nam) w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)




#create GOD
set god_ [create-god $val(nn)]
set chan_1_ [new $val(chan)]

#--------------------------------------------
# Define node properties
#--------------------------------------------
$ns_ node-config -adhocRouting $val(routingProt) \
                 -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen  $val(ifqlen) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -phyType  $val(netif) \
                 -topoInstance $topo \
                 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace ON \
                 -movementTrace OFF\
                 -channel $chan_1_\
       #-----------------------------------------
       # Parameter req. only when energy logging
       #----------------------------------------
         #       -energyModel $val(energymod) \
         #       -initialEnergy $val(initialenergy) \
         #       -rxPower 0.0648 \
         #       -txPower 0.0744 \
         #      -idlePower 0.00000552 \
         #       -sleepPower 144e-9 \

#-----------------------------------------------
# Creates val(nn) node and attached to val(chan)
#----------------------------------------------
for {set i 0} {$i < $val(nn) } {incr i} {
set node_($i) [$ns_ node]
$node_($i) random-motion 0		;# disable random motion
}

#-------------------------------------------
# Load val(move)  and val(cp) patterns
#-------------------------------------------

puts "Loading scenario pattern ..."
source $val(cp); #load traffick pattern

puts "Loading movement pattern ..."
source $val(move); #load movement pattern

#Define node initial position for NAM
for  {set i 0} {$i < $val(nn)} {incr i} {
    puts "Processng node $i for NAM ..."
    $ns_ initial_node_pos $node_($i) 20
 }

#-----------------------------------------------
# Tell nodes when the simulation ends
#-----------------------------------------------
for {set i 0} {$i < $val(nn) } {incr i} {
$ns_ at $val(stop) "$node_($i) reset;"
}
$ns_ at $val(stop) "$ns_ nam-end-wireless $val(stop)"
#$ns_ at $val(stop) "stop"
$ns_ at $val(stop).0002 "puts \"end simulation \" ; $ns_ halt"

proc stop {} {
       global ns_ tracefd namtrace
        $ns_ flush-trace
        close $tracefd
        close $namtrace
}

#running the simulation
puts "\nStarting Simulation..."
$ns_ run
