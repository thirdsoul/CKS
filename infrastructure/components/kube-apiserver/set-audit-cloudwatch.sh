#Attach role CloudWatchAgentServerRole to instance, Policy CloudWatchAgentServerPolicy


sudo wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb -O $HOME/amazon-cloudwatch-agent.deb
cd $HOME;
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
cd /opt/aws/amazon-cloudwatch-agent/etc;


#create audit-policy.yaml




sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

#create the config I added logging for cpu, memory and audit log
#config file /opt/aws/amazon-cloudwatch-agent/bin/config.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
cat /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
#user cwagent, make sure it has rights to send our logs

#And voila, cloudwatch activated
