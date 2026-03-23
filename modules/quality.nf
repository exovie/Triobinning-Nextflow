nextflow.enable.dsl=2

process bbtools {
    label "bbtools"
    tag "${bbtools_name}"

    publishDir "$params.outdir/results/$params.assembly_name/bbtools/$bbtools_name", mode: 'copy', pattern: '*.txt'

    input:
        val(bbtools_name)
        path(scaffolded_hap)
    
    output:
        path "${bbtools_name}.txt", emit: bbtools_file
    
    script:
        """
        /opt/bbmap/stats.sh in=$scaffolded_hap -Xmx50g out=$bbtools_name".txt"
        """
}

process busco {
    label "busco"
    tag "${busco_name}"

    publishDir "$params.outdir/results/$params.assembly_name/busco/$busco_name", mode: 'copy'

    input:
        val(busco_name)
        path(scaffolded_hap)
    
    output:
        path "*"
    
    script:
        """
        ${params.option_busco_java}
        busco $params.option_busco \
        -i $scaffolded_hap \
        -o $busco_name
        """
}
