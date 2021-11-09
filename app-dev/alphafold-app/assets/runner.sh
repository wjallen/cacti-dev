# Allow over-ride
if [ -z "${CONTAINER_IMAGE}" ]
then
    version=$(cat ./_util/VERSION)
    CONTAINER_IMAGE="index.docker.io/library/ubuntu:bionic"
fi
. lib/container_exec.sh


touch sample.fasta
echo "> seq from portal" > sample.fasta
echo ${sequence} >> sample.fasta


COMMAND="/app/run_alphafold.sh"
OPTS="--flagfile=$AF2_HOME/test/flags/${PRECISION}_dbs.ff  --fasta_paths=./sample.fasta  --output_dir=./af2_${PRECISION}  --model_preset=${MODEL}"


echo "container_exec ${CONTAINER_IMAGE} ${COMMAND} ${OPTS}"
container_exec ${CONTAINER_IMAGE} ${COMMAND} ${OPTS}
