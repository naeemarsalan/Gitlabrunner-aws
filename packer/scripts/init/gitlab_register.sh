#!/bin/bash

echo "Registering gitlab runner"
sed -i 's/concurrent = 1/concurrent = 10/g' /etc/gitlab-runner/config.toml
gitlab-runner register  --non-interactive -u "${GitlabURL}" \
                        --run-untagged=false --executor "docker+machine" --locked=false --docker-privileged=true \
                        --machine-machine-driver "amazonec2" \
                        --machine-machine-name "gitlab-docker-machine-%s" \
			--tag-list "${RUNNER_TAG_LIST}" \
                        --machine-idle-nodes "1" \
                        --machine-idle-time "1800" \
                        --machine-max-builds "3" \
                        --docker-image "alpine" \
			--machine-machine-options "amazonec2-private-address-only=true" \
                        --machine-machine-options "amazonec2-access-key=${AWS_KEY_ID}" \
                        --machine-machine-options "amazonec2-secret-key=${AWS_SECRET_KEY}" \
                        --machine-machine-options "amazonec2-region=eu-west-1" \
                        --machine-machine-options "amazonec2-vpc-id=${vpc_id}" \
                        --machine-machine-options "amazonec2-subnet-id=${subnet_id}" \
                        --machine-machine-options "amazonec2-zone=a" \
                        --machine-machine-options "amazonec2-security-group=${sec_group}" \
                        --machine-machine-options "amazonec2-instance-type=m4.xlarge" \
                        --machine-machine-options "amazonec2-use-private-address=true" \
                        --machine-machine-options "amazonec2-tags=runner-manager-name,gitlab-aws-autoscaler,gitlab,true"

[ $? -ne 0 ] && die "Failed to register gitlab runner";



