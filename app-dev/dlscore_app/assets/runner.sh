# Allow over-ride
if [ -z "${CONTAINER_IMAGE}" ]
then
    version=$(cat ./_util/VERSION)
    CONTAINER_IMAGE="index.docker.io/wallen/dlscore:1.0"
fi
. lib/container_exec.sh

# Write an excution command below that will run a script or binary inside the
# requested container, assuming that the current working directory is
# mounted in the container as its WORKDIR. In place of 'docker run'
# use 'container_exec' which will handle setup of the container on
# a variety of host environments.
#
# Here is a template:
#
# container_exec ${CONTAINER_IMAGE} COMMAND OPTS INPUTS

COMMAND=" python3 /DLSCORE/dlscore.py "
PARAMS=" --ligand ${ligand} --receptor ${protein} --vina_executable /DLSCORE/autodock_vina_1_1_2_linux_x86/bin/vina "


if [ -z "${num_networks}" ];
then
        PARAMS=" ${PARAMS} --num_networks 10 "
else
        PARAMS=" ${PARAMS} --num_networks ${num_networks} "
fi

if [ -z "${network_type}" ];
then
        PARAMS=" ${PARAMS} --network_type refined "
else
        PARAMS=" ${PARAMS} --network_type ${network_type} "
fi

if [ -z "${verbose}" ];
then
        PARAMS=" ${PARAMS} --verbose 0 "
else
        PARAMS=" ${PARAMS} --verbose ${verbose} "
fi

PARAMS=" ${PARAMS} --output ${output} "


container_exec ${CONTAINER_IMAGE} ${COMMAND} ${PARAMS}
