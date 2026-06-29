#!/bin/bash
# Runs on the HPC login node (via ci-hpc-generic with a `direct` site).
# Writes the two SLURM batch scripts, submits them concurrently via
# `sbatch --wait`, collects output, and propagates any failure.
echo "Running on the login node: $(hostname)"

# --- Write the two SLURM batch scripts -----------------------------------

cat > slurm_job_1.sh <<'SLURM1'
#!/bin/bash
#SBATCH --job-name=downstream-direct-1
#SBATCH --qos=nf
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --output=slurm_job_1.%j.out
set -ex
echo "Hello from SLURM job 1 on $(hostname)"
srun hostname
SLURM1

cat > slurm_job_2.sh <<'SLURM2'
#!/bin/bash
#SBATCH --job-name=downstream-direct-2
#SBATCH --qos=nf
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --output=slurm_job_2.%j.out
set -ex
echo "Hello from SLURM job 2 on $(hostname)"
srun hostname
SLURM2

# --- Submit both via SLURM and block until they finish -------------------
# `sbatch --wait` returns the job's exit code, so the CI step fails
# if either SLURM job fails.  Run them concurrently.
echo "Submitting slurm_job_1.sh and slurm_job_2.sh via sbatch --wait"
sbatch --wait slurm_job_1.sh &
PID1=$!
sbatch --wait slurm_job_2.sh &
PID2=$!

RC=0
wait $PID1 || RC=1
wait $PID2 || RC=1

echo "==== slurm_job_1 output ===="
cat slurm_job_1.*.out || true
echo "==== slurm_job_2 output ===="
cat slurm_job_2.*.out || true

if [ "$RC" -ne 0 ]; then
  echo "One or more SLURM jobs failed"
  exit 1
fi
echo "Both SLURM jobs completed successfully"
