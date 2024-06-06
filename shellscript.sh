#!/bin/bash

AMI=
SG_ID=

INSTANCES=("Mongodb" "mySql" "rabitmq" "redis" "user" "cart" "shipping" "payments" "dispatch" "catalogue" "web")
ZONE_ID=
DOMAIN_NAME=

for i in "${INSTANCE[@]}"
do
 if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
 then
 INSTANCE_TYPE="t3.small"
 else
 INSTANCE_TYPE="t2.micro"
 fi
 IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids --tag-specifications "ResourceType=instance,Tags=[{key=name,value=$i}]" --query 'instances[0].privateIpadress' --output text)
 echo "$i: $IP_ADRESS"

      #creating R53 record, make sure you delete existing records
      aws route53 change-resource-record-sets\

       --hosted-zone-id $ZONE_ID\
       --change-batch
     {

       "comments": "creating a record set for cognito endpoint",
       "changes": [{ 
        "Action" : "UPSERT",
        "ResourceRecordSet" : {
            "Name" : "'$i.'$DOMAIN_NAME",
            "Type" : "A",
            "TTL"  :  1 ,
            "ResourceRecords"  : [{
                "value"  : "'$IP_ADRESS'"
          }]

        }
        }]
     
     }

done 
