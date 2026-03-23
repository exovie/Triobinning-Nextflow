nextflow.enable.dsl=2

process gfa_to_fa {
    label "gfa_to_fa"
    tag "${gfa_name}"

    publishDir "$params.outdir/results/$params.assembly_name/gfa_to_fa/$gfa_name", mode: 'copy', pattern: '*.fa'

    input:
        val(gfa_name)
        path(gfa_file)
    
    output:
        path "${gfa_name}.fa", emit: fasta_haplotype
    
    script:
        """
        gfatools gfa2fa $gfa_file > $gfa_name".fa"
        """
}

process scaffolding {
    label "scaffolding"
    tag "${scaffolding_name}"

    publishDir "$params.outdir/results/$params.assembly_name/scaffolding/$scaffolding_name", mode: 'copy'

    input:
        val(scaffolding_name)
        path(haplotype_1)
        path(haplotype_2)

    output:
        path "*"
        path "${scaffolding_name}/ragtag.scaffold.fasta", emit: scaffolded_haplotype
    
    script:
        """
        ragtag.py scaffold $haplotype_2 $haplotype_1 -o $scaffolding_name --aligner /usr/local/bin/minimap2/minimap2
        """
}
