#- create bandwidth policy
netctl net create contiv-net --subnet=20.1.1.0/24 -g 20.1.1.1
netctl netprofile create -b 1000kbps -dscp 1 dev-net-profile-2

#isolation policy, should not impact bandwidth policy here
netctl policy create allow-diags
#deny https outbound traffic using port 443
netctl policy rule-add allow-diags 1 -direction=out -protocol=tcp -port=443 -action=deny -priority 1
#enable vnc, icmp 
netctl policy rule-add allow-diags 2 -direction=in -protocol=icmp -action=allow
netctl policy rule-add allow-diags 3 -direction=in -protocol=tcp -port=5201 -action=allow -priority 10
netctl policy rule-add allow-diags 4 -direction=out -protocol=tcp -port=5201 -action=allow -priority 9
netctl policy rule-add allow-diags 5 -direction=in -protocol=tcp -action=allow -priority 1
netctl policy rule-add allow-diags 6 -direction=out -protocol=tcp -action=allow -priority 1
netctl policy rule-add allow-diags 7 -direction=in -protocol=tcp -port=5900 -action=allow -priority 1

#our chrome pod will use contiv-network and dev-net-profile-2 profile
netctl group create contiv-net dev-web-group4 -policy=allow-diags -networkprofile=dev-net-profile-2

# set socks proxy using puuty to 10.10.20.1:
#127.0.0.1:9999, socks 5

#start chrome pod
kubectl create -f ./selenium-node-chrome-rc.yaml

#enable https traffic
netctl policy rule-add allow-diags 1 -direction=out -protocol=tcp -port = 443 -action=allow -priority 1

#change bandwidht to 10mbps to check video quality again
#using contiv UI should be easier here



