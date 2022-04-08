### Allegro 

MG-1:
`snakemake --use-conda -s Snakefile --cluster 'sbatch -t 100 --nodelist={resources.nodelist}  --mem=40g --cpus-per-task={threads} -p big' -j 5 --latency-wait 80`

MG-3: 
`snakemake --use-conda -s Snakefile --cluster 'sbatch -t 1440 --nodelist={resources.nodelist}  --mem=40g --cpus-per-task={threads} -p big' -j 20 --latency-wait 80`
