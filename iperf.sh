#bandwidth policy
netctl netprofile create -b 1000kbps -dscp 1 dev-net-profile-2
#create profile to use the profile
netctl group create default-net dev-web-group2 -networkprofile=dev-net-profile-2

#create iperf3 pods, the yaml file is using dev-net-profile-2
kubectl create -f https://raw.githubusercontent.com/iceworld/yaml/master/iperf3.yaml
kubectl create -f https://raw.githubusercontent.com/iceworld/yaml/master/iperf3-svc.yaml

#bandwidth testing!!!
kubectl exec iperf-5s4sx  -- iperf3 -c $(kubectl describe pod  iperf-8788x | grep IP | awk '{print $2}') -t 10 -i 1
