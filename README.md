### Allegro 

Choose the cluster nodes and set them in the snakemake rule files e.g `nodelist = "cmp[241]"`. You can check which nodes are idle with `sinfo -p small`.

MG-1:

`snakemake --use-conda -s Snakefile --cluster 'sbatch -t 100 --nodelist={resources.nodelist}  --mem=40g --cpus-per-task={threads} -p big' -j 5 --latency-wait 80`

MG-3: 

`snakemake --use-conda -s Snakefile --cluster 'sbatch -t 1440 --nodelist={resources.nodelist}  --mem=40g --cpus-per-task={threads} -p big' -j 20 --latency-wait 80`


Snakemake cluster options:
- `–time 120`                killsig after time is up                 
- `--nodelist={resources.nodelist}`     nodelist specified in Snakefile
- `–mem=10g`                 max memory per cluster node
- `–cpus-per-task={params.t}'`         number of threads per job/node
- `–jobs 2`                     use at most 2 cluster jobs in parallel
- `--latency-wait 80`           in case of file system latency
